
user/_usertests:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <copyinstr1>:
}

// what if you pass ridiculous string pointers to system calls?
void
copyinstr1(char *s)
{
       0:	1141                	add	sp,sp,-16
       2:	e406                	sd	ra,8(sp)
       4:	e022                	sd	s0,0(sp)
       6:	0800                	add	s0,sp,16
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };

  for(int ai = 0; ai < 2; ai++){
    uint64 addr = addrs[ai];

    int fd = open((char *)addr, O_CREATE|O_WRONLY);
       8:	20100593          	li	a1,513
       c:	4505                	li	a0,1
       e:	057e                	sll	a0,a0,0x1f
      10:	00006097          	auipc	ra,0x6
      14:	bbe080e7          	jalr	-1090(ra) # 5bce <open>
    if(fd >= 0){
      18:	02055063          	bgez	a0,38 <copyinstr1+0x38>
    int fd = open((char *)addr, O_CREATE|O_WRONLY);
      1c:	20100593          	li	a1,513
      20:	557d                	li	a0,-1
      22:	00006097          	auipc	ra,0x6
      26:	bac080e7          	jalr	-1108(ra) # 5bce <open>
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
      34:	0141                	add	sp,sp,16
      36:	8082                	ret
    uint64 addr = addrs[ai];
      38:	4585                	li	a1,1
      3a:	05fe                	sll	a1,a1,0x1f
      printf("open(%p) returned %d, not -1\n", addr, fd);
      3c:	862a                	mv	a2,a0
      3e:	00006517          	auipc	a0,0x6
      42:	08250513          	add	a0,a0,130 # 60c0 <malloc+0xea>
      46:	00006097          	auipc	ra,0x6
      4a:	ed8080e7          	jalr	-296(ra) # 5f1e <printf>
      exit(1);
      4e:	4505                	li	a0,1
      50:	00006097          	auipc	ra,0x6
      54:	b3e080e7          	jalr	-1218(ra) # 5b8e <exit>

0000000000000058 <bsstest>:
void
bsstest(char *s)
{
  int i;

  for(i = 0; i < sizeof(uninit); i++){
      58:	0000a797          	auipc	a5,0xa
      5c:	50078793          	add	a5,a5,1280 # a558 <uninit>
      60:	0000d697          	auipc	a3,0xd
      64:	c0868693          	add	a3,a3,-1016 # cc68 <buf>
    if(uninit[i] != '\0'){
      68:	0007c703          	lbu	a4,0(a5)
      6c:	e709                	bnez	a4,76 <bsstest+0x1e>
  for(i = 0; i < sizeof(uninit); i++){
      6e:	0785                	add	a5,a5,1
      70:	fed79ce3          	bne	a5,a3,68 <bsstest+0x10>
      74:	8082                	ret
{
      76:	1141                	add	sp,sp,-16
      78:	e406                	sd	ra,8(sp)
      7a:	e022                	sd	s0,0(sp)
      7c:	0800                	add	s0,sp,16
      printf("%s: bss test failed\n", s);
      7e:	85aa                	mv	a1,a0
      80:	00006517          	auipc	a0,0x6
      84:	06050513          	add	a0,a0,96 # 60e0 <malloc+0x10a>
      88:	00006097          	auipc	ra,0x6
      8c:	e96080e7          	jalr	-362(ra) # 5f1e <printf>
      exit(1);
      90:	4505                	li	a0,1
      92:	00006097          	auipc	ra,0x6
      96:	afc080e7          	jalr	-1284(ra) # 5b8e <exit>

000000000000009a <opentest>:
{
      9a:	1101                	add	sp,sp,-32
      9c:	ec06                	sd	ra,24(sp)
      9e:	e822                	sd	s0,16(sp)
      a0:	e426                	sd	s1,8(sp)
      a2:	1000                	add	s0,sp,32
      a4:	84aa                	mv	s1,a0
  fd = open("echo", 0);
      a6:	4581                	li	a1,0
      a8:	00006517          	auipc	a0,0x6
      ac:	05050513          	add	a0,a0,80 # 60f8 <malloc+0x122>
      b0:	00006097          	auipc	ra,0x6
      b4:	b1e080e7          	jalr	-1250(ra) # 5bce <open>
  if(fd < 0){
      b8:	02054663          	bltz	a0,e4 <opentest+0x4a>
  close(fd);
      bc:	00006097          	auipc	ra,0x6
      c0:	afa080e7          	jalr	-1286(ra) # 5bb6 <close>
  fd = open("doesnotexist", 0);
      c4:	4581                	li	a1,0
      c6:	00006517          	auipc	a0,0x6
      ca:	05250513          	add	a0,a0,82 # 6118 <malloc+0x142>
      ce:	00006097          	auipc	ra,0x6
      d2:	b00080e7          	jalr	-1280(ra) # 5bce <open>
  if(fd >= 0){
      d6:	02055563          	bgez	a0,100 <opentest+0x66>
}
      da:	60e2                	ld	ra,24(sp)
      dc:	6442                	ld	s0,16(sp)
      de:	64a2                	ld	s1,8(sp)
      e0:	6105                	add	sp,sp,32
      e2:	8082                	ret
    printf("%s: open echo failed!\n", s);
      e4:	85a6                	mv	a1,s1
      e6:	00006517          	auipc	a0,0x6
      ea:	01a50513          	add	a0,a0,26 # 6100 <malloc+0x12a>
      ee:	00006097          	auipc	ra,0x6
      f2:	e30080e7          	jalr	-464(ra) # 5f1e <printf>
    exit(1);
      f6:	4505                	li	a0,1
      f8:	00006097          	auipc	ra,0x6
      fc:	a96080e7          	jalr	-1386(ra) # 5b8e <exit>
    printf("%s: open doesnotexist succeeded!\n", s);
     100:	85a6                	mv	a1,s1
     102:	00006517          	auipc	a0,0x6
     106:	02650513          	add	a0,a0,38 # 6128 <malloc+0x152>
     10a:	00006097          	auipc	ra,0x6
     10e:	e14080e7          	jalr	-492(ra) # 5f1e <printf>
    exit(1);
     112:	4505                	li	a0,1
     114:	00006097          	auipc	ra,0x6
     118:	a7a080e7          	jalr	-1414(ra) # 5b8e <exit>

000000000000011c <truncate2>:
{
     11c:	7179                	add	sp,sp,-48
     11e:	f406                	sd	ra,40(sp)
     120:	f022                	sd	s0,32(sp)
     122:	ec26                	sd	s1,24(sp)
     124:	e84a                	sd	s2,16(sp)
     126:	e44e                	sd	s3,8(sp)
     128:	1800                	add	s0,sp,48
     12a:	89aa                	mv	s3,a0
  unlink("truncfile");
     12c:	00006517          	auipc	a0,0x6
     130:	02450513          	add	a0,a0,36 # 6150 <malloc+0x17a>
     134:	00006097          	auipc	ra,0x6
     138:	aaa080e7          	jalr	-1366(ra) # 5bde <unlink>
  int fd1 = open("truncfile", O_CREATE|O_TRUNC|O_WRONLY);
     13c:	60100593          	li	a1,1537
     140:	00006517          	auipc	a0,0x6
     144:	01050513          	add	a0,a0,16 # 6150 <malloc+0x17a>
     148:	00006097          	auipc	ra,0x6
     14c:	a86080e7          	jalr	-1402(ra) # 5bce <open>
     150:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     152:	4611                	li	a2,4
     154:	00006597          	auipc	a1,0x6
     158:	00c58593          	add	a1,a1,12 # 6160 <malloc+0x18a>
     15c:	00006097          	auipc	ra,0x6
     160:	a52080e7          	jalr	-1454(ra) # 5bae <write>
  int fd2 = open("truncfile", O_TRUNC|O_WRONLY);
     164:	40100593          	li	a1,1025
     168:	00006517          	auipc	a0,0x6
     16c:	fe850513          	add	a0,a0,-24 # 6150 <malloc+0x17a>
     170:	00006097          	auipc	ra,0x6
     174:	a5e080e7          	jalr	-1442(ra) # 5bce <open>
     178:	892a                	mv	s2,a0
  int n = write(fd1, "x", 1);
     17a:	4605                	li	a2,1
     17c:	00006597          	auipc	a1,0x6
     180:	fec58593          	add	a1,a1,-20 # 6168 <malloc+0x192>
     184:	8526                	mv	a0,s1
     186:	00006097          	auipc	ra,0x6
     18a:	a28080e7          	jalr	-1496(ra) # 5bae <write>
  if(n != -1){
     18e:	57fd                	li	a5,-1
     190:	02f51b63          	bne	a0,a5,1c6 <truncate2+0xaa>
  unlink("truncfile");
     194:	00006517          	auipc	a0,0x6
     198:	fbc50513          	add	a0,a0,-68 # 6150 <malloc+0x17a>
     19c:	00006097          	auipc	ra,0x6
     1a0:	a42080e7          	jalr	-1470(ra) # 5bde <unlink>
  close(fd1);
     1a4:	8526                	mv	a0,s1
     1a6:	00006097          	auipc	ra,0x6
     1aa:	a10080e7          	jalr	-1520(ra) # 5bb6 <close>
  close(fd2);
     1ae:	854a                	mv	a0,s2
     1b0:	00006097          	auipc	ra,0x6
     1b4:	a06080e7          	jalr	-1530(ra) # 5bb6 <close>
}
     1b8:	70a2                	ld	ra,40(sp)
     1ba:	7402                	ld	s0,32(sp)
     1bc:	64e2                	ld	s1,24(sp)
     1be:	6942                	ld	s2,16(sp)
     1c0:	69a2                	ld	s3,8(sp)
     1c2:	6145                	add	sp,sp,48
     1c4:	8082                	ret
    printf("%s: write returned %d, expected -1\n", s, n);
     1c6:	862a                	mv	a2,a0
     1c8:	85ce                	mv	a1,s3
     1ca:	00006517          	auipc	a0,0x6
     1ce:	fa650513          	add	a0,a0,-90 # 6170 <malloc+0x19a>
     1d2:	00006097          	auipc	ra,0x6
     1d6:	d4c080e7          	jalr	-692(ra) # 5f1e <printf>
    exit(1);
     1da:	4505                	li	a0,1
     1dc:	00006097          	auipc	ra,0x6
     1e0:	9b2080e7          	jalr	-1614(ra) # 5b8e <exit>

00000000000001e4 <createtest>:
{
     1e4:	7179                	add	sp,sp,-48
     1e6:	f406                	sd	ra,40(sp)
     1e8:	f022                	sd	s0,32(sp)
     1ea:	ec26                	sd	s1,24(sp)
     1ec:	e84a                	sd	s2,16(sp)
     1ee:	1800                	add	s0,sp,48
  name[0] = 'a';
     1f0:	06100793          	li	a5,97
     1f4:	fcf40c23          	sb	a5,-40(s0)
  name[2] = '\0';
     1f8:	fc040d23          	sb	zero,-38(s0)
     1fc:	03000493          	li	s1,48
  for(i = 0; i < N; i++){
     200:	06400913          	li	s2,100
    name[1] = '0' + i;
     204:	fc940ca3          	sb	s1,-39(s0)
    fd = open(name, O_CREATE|O_RDWR);
     208:	20200593          	li	a1,514
     20c:	fd840513          	add	a0,s0,-40
     210:	00006097          	auipc	ra,0x6
     214:	9be080e7          	jalr	-1602(ra) # 5bce <open>
    close(fd);
     218:	00006097          	auipc	ra,0x6
     21c:	99e080e7          	jalr	-1634(ra) # 5bb6 <close>
  for(i = 0; i < N; i++){
     220:	2485                	addw	s1,s1,1
     222:	0ff4f493          	zext.b	s1,s1
     226:	fd249fe3          	bne	s1,s2,204 <createtest+0x20>
  name[0] = 'a';
     22a:	06100793          	li	a5,97
     22e:	fcf40c23          	sb	a5,-40(s0)
  name[2] = '\0';
     232:	fc040d23          	sb	zero,-38(s0)
     236:	03000493          	li	s1,48
  for(i = 0; i < N; i++){
     23a:	06400913          	li	s2,100
    name[1] = '0' + i;
     23e:	fc940ca3          	sb	s1,-39(s0)
    unlink(name);
     242:	fd840513          	add	a0,s0,-40
     246:	00006097          	auipc	ra,0x6
     24a:	998080e7          	jalr	-1640(ra) # 5bde <unlink>
  for(i = 0; i < N; i++){
     24e:	2485                	addw	s1,s1,1
     250:	0ff4f493          	zext.b	s1,s1
     254:	ff2495e3          	bne	s1,s2,23e <createtest+0x5a>
}
     258:	70a2                	ld	ra,40(sp)
     25a:	7402                	ld	s0,32(sp)
     25c:	64e2                	ld	s1,24(sp)
     25e:	6942                	ld	s2,16(sp)
     260:	6145                	add	sp,sp,48
     262:	8082                	ret

0000000000000264 <bigwrite>:
{
     264:	715d                	add	sp,sp,-80
     266:	e486                	sd	ra,72(sp)
     268:	e0a2                	sd	s0,64(sp)
     26a:	fc26                	sd	s1,56(sp)
     26c:	f84a                	sd	s2,48(sp)
     26e:	f44e                	sd	s3,40(sp)
     270:	f052                	sd	s4,32(sp)
     272:	ec56                	sd	s5,24(sp)
     274:	e85a                	sd	s6,16(sp)
     276:	e45e                	sd	s7,8(sp)
     278:	0880                	add	s0,sp,80
     27a:	8baa                	mv	s7,a0
  unlink("bigwrite");
     27c:	00006517          	auipc	a0,0x6
     280:	f1c50513          	add	a0,a0,-228 # 6198 <malloc+0x1c2>
     284:	00006097          	auipc	ra,0x6
     288:	95a080e7          	jalr	-1702(ra) # 5bde <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     28c:	1f300493          	li	s1,499
    fd = open("bigwrite", O_CREATE | O_RDWR);
     290:	00006a97          	auipc	s5,0x6
     294:	f08a8a93          	add	s5,s5,-248 # 6198 <malloc+0x1c2>
      int cc = write(fd, buf, sz);
     298:	0000da17          	auipc	s4,0xd
     29c:	9d0a0a13          	add	s4,s4,-1584 # cc68 <buf>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     2a0:	6b0d                	lui	s6,0x3
     2a2:	1c9b0b13          	add	s6,s6,457 # 31c9 <diskfull+0x15f>
    fd = open("bigwrite", O_CREATE | O_RDWR);
     2a6:	20200593          	li	a1,514
     2aa:	8556                	mv	a0,s5
     2ac:	00006097          	auipc	ra,0x6
     2b0:	922080e7          	jalr	-1758(ra) # 5bce <open>
     2b4:	892a                	mv	s2,a0
    if(fd < 0){
     2b6:	04054d63          	bltz	a0,310 <bigwrite+0xac>
      int cc = write(fd, buf, sz);
     2ba:	8626                	mv	a2,s1
     2bc:	85d2                	mv	a1,s4
     2be:	00006097          	auipc	ra,0x6
     2c2:	8f0080e7          	jalr	-1808(ra) # 5bae <write>
     2c6:	89aa                	mv	s3,a0
      if(cc != sz){
     2c8:	06a49263          	bne	s1,a0,32c <bigwrite+0xc8>
      int cc = write(fd, buf, sz);
     2cc:	8626                	mv	a2,s1
     2ce:	85d2                	mv	a1,s4
     2d0:	854a                	mv	a0,s2
     2d2:	00006097          	auipc	ra,0x6
     2d6:	8dc080e7          	jalr	-1828(ra) # 5bae <write>
      if(cc != sz){
     2da:	04951a63          	bne	a0,s1,32e <bigwrite+0xca>
    close(fd);
     2de:	854a                	mv	a0,s2
     2e0:	00006097          	auipc	ra,0x6
     2e4:	8d6080e7          	jalr	-1834(ra) # 5bb6 <close>
    unlink("bigwrite");
     2e8:	8556                	mv	a0,s5
     2ea:	00006097          	auipc	ra,0x6
     2ee:	8f4080e7          	jalr	-1804(ra) # 5bde <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     2f2:	1d74849b          	addw	s1,s1,471
     2f6:	fb6498e3          	bne	s1,s6,2a6 <bigwrite+0x42>
}
     2fa:	60a6                	ld	ra,72(sp)
     2fc:	6406                	ld	s0,64(sp)
     2fe:	74e2                	ld	s1,56(sp)
     300:	7942                	ld	s2,48(sp)
     302:	79a2                	ld	s3,40(sp)
     304:	7a02                	ld	s4,32(sp)
     306:	6ae2                	ld	s5,24(sp)
     308:	6b42                	ld	s6,16(sp)
     30a:	6ba2                	ld	s7,8(sp)
     30c:	6161                	add	sp,sp,80
     30e:	8082                	ret
      printf("%s: cannot create bigwrite\n", s);
     310:	85de                	mv	a1,s7
     312:	00006517          	auipc	a0,0x6
     316:	e9650513          	add	a0,a0,-362 # 61a8 <malloc+0x1d2>
     31a:	00006097          	auipc	ra,0x6
     31e:	c04080e7          	jalr	-1020(ra) # 5f1e <printf>
      exit(1);
     322:	4505                	li	a0,1
     324:	00006097          	auipc	ra,0x6
     328:	86a080e7          	jalr	-1942(ra) # 5b8e <exit>
      if(cc != sz){
     32c:	89a6                	mv	s3,s1
        printf("%s: write(%d) ret %d\n", s, sz, cc);
     32e:	86aa                	mv	a3,a0
     330:	864e                	mv	a2,s3
     332:	85de                	mv	a1,s7
     334:	00006517          	auipc	a0,0x6
     338:	e9450513          	add	a0,a0,-364 # 61c8 <malloc+0x1f2>
     33c:	00006097          	auipc	ra,0x6
     340:	be2080e7          	jalr	-1054(ra) # 5f1e <printf>
        exit(1);
     344:	4505                	li	a0,1
     346:	00006097          	auipc	ra,0x6
     34a:	848080e7          	jalr	-1976(ra) # 5b8e <exit>

000000000000034e <badwrite>:
// file is deleted? if the kernel has this bug, it will panic: balloc:
// out of blocks. assumed_free may need to be raised to be more than
// the number of free blocks. this test takes a long time.
void
badwrite(char *s)
{
     34e:	7179                	add	sp,sp,-48
     350:	f406                	sd	ra,40(sp)
     352:	f022                	sd	s0,32(sp)
     354:	ec26                	sd	s1,24(sp)
     356:	e84a                	sd	s2,16(sp)
     358:	e44e                	sd	s3,8(sp)
     35a:	e052                	sd	s4,0(sp)
     35c:	1800                	add	s0,sp,48
  int assumed_free = 600;
  
  unlink("junk");
     35e:	00006517          	auipc	a0,0x6
     362:	e8250513          	add	a0,a0,-382 # 61e0 <malloc+0x20a>
     366:	00006097          	auipc	ra,0x6
     36a:	878080e7          	jalr	-1928(ra) # 5bde <unlink>
     36e:	25800913          	li	s2,600
  for(int i = 0; i < assumed_free; i++){
    int fd = open("junk", O_CREATE|O_WRONLY);
     372:	00006997          	auipc	s3,0x6
     376:	e6e98993          	add	s3,s3,-402 # 61e0 <malloc+0x20a>
    if(fd < 0){
      printf("open junk failed\n");
      exit(1);
    }
    write(fd, (char*)0xffffffffffL, 1);
     37a:	5a7d                	li	s4,-1
     37c:	018a5a13          	srl	s4,s4,0x18
    int fd = open("junk", O_CREATE|O_WRONLY);
     380:	20100593          	li	a1,513
     384:	854e                	mv	a0,s3
     386:	00006097          	auipc	ra,0x6
     38a:	848080e7          	jalr	-1976(ra) # 5bce <open>
     38e:	84aa                	mv	s1,a0
    if(fd < 0){
     390:	06054b63          	bltz	a0,406 <badwrite+0xb8>
    write(fd, (char*)0xffffffffffL, 1);
     394:	4605                	li	a2,1
     396:	85d2                	mv	a1,s4
     398:	00006097          	auipc	ra,0x6
     39c:	816080e7          	jalr	-2026(ra) # 5bae <write>
    close(fd);
     3a0:	8526                	mv	a0,s1
     3a2:	00006097          	auipc	ra,0x6
     3a6:	814080e7          	jalr	-2028(ra) # 5bb6 <close>
    unlink("junk");
     3aa:	854e                	mv	a0,s3
     3ac:	00006097          	auipc	ra,0x6
     3b0:	832080e7          	jalr	-1998(ra) # 5bde <unlink>
  for(int i = 0; i < assumed_free; i++){
     3b4:	397d                	addw	s2,s2,-1
     3b6:	fc0915e3          	bnez	s2,380 <badwrite+0x32>
  }

  int fd = open("junk", O_CREATE|O_WRONLY);
     3ba:	20100593          	li	a1,513
     3be:	00006517          	auipc	a0,0x6
     3c2:	e2250513          	add	a0,a0,-478 # 61e0 <malloc+0x20a>
     3c6:	00006097          	auipc	ra,0x6
     3ca:	808080e7          	jalr	-2040(ra) # 5bce <open>
     3ce:	84aa                	mv	s1,a0
  if(fd < 0){
     3d0:	04054863          	bltz	a0,420 <badwrite+0xd2>
    printf("open junk failed\n");
    exit(1);
  }
  if(write(fd, "x", 1) != 1){
     3d4:	4605                	li	a2,1
     3d6:	00006597          	auipc	a1,0x6
     3da:	d9258593          	add	a1,a1,-622 # 6168 <malloc+0x192>
     3de:	00005097          	auipc	ra,0x5
     3e2:	7d0080e7          	jalr	2000(ra) # 5bae <write>
     3e6:	4785                	li	a5,1
     3e8:	04f50963          	beq	a0,a5,43a <badwrite+0xec>
    printf("write failed\n");
     3ec:	00006517          	auipc	a0,0x6
     3f0:	e1450513          	add	a0,a0,-492 # 6200 <malloc+0x22a>
     3f4:	00006097          	auipc	ra,0x6
     3f8:	b2a080e7          	jalr	-1238(ra) # 5f1e <printf>
    exit(1);
     3fc:	4505                	li	a0,1
     3fe:	00005097          	auipc	ra,0x5
     402:	790080e7          	jalr	1936(ra) # 5b8e <exit>
      printf("open junk failed\n");
     406:	00006517          	auipc	a0,0x6
     40a:	de250513          	add	a0,a0,-542 # 61e8 <malloc+0x212>
     40e:	00006097          	auipc	ra,0x6
     412:	b10080e7          	jalr	-1264(ra) # 5f1e <printf>
      exit(1);
     416:	4505                	li	a0,1
     418:	00005097          	auipc	ra,0x5
     41c:	776080e7          	jalr	1910(ra) # 5b8e <exit>
    printf("open junk failed\n");
     420:	00006517          	auipc	a0,0x6
     424:	dc850513          	add	a0,a0,-568 # 61e8 <malloc+0x212>
     428:	00006097          	auipc	ra,0x6
     42c:	af6080e7          	jalr	-1290(ra) # 5f1e <printf>
    exit(1);
     430:	4505                	li	a0,1
     432:	00005097          	auipc	ra,0x5
     436:	75c080e7          	jalr	1884(ra) # 5b8e <exit>
  }
  close(fd);
     43a:	8526                	mv	a0,s1
     43c:	00005097          	auipc	ra,0x5
     440:	77a080e7          	jalr	1914(ra) # 5bb6 <close>
  unlink("junk");
     444:	00006517          	auipc	a0,0x6
     448:	d9c50513          	add	a0,a0,-612 # 61e0 <malloc+0x20a>
     44c:	00005097          	auipc	ra,0x5
     450:	792080e7          	jalr	1938(ra) # 5bde <unlink>

  exit(0);
     454:	4501                	li	a0,0
     456:	00005097          	auipc	ra,0x5
     45a:	738080e7          	jalr	1848(ra) # 5b8e <exit>

000000000000045e <outofinodes>:
  }
}

void
outofinodes(char *s)
{
     45e:	715d                	add	sp,sp,-80
     460:	e486                	sd	ra,72(sp)
     462:	e0a2                	sd	s0,64(sp)
     464:	fc26                	sd	s1,56(sp)
     466:	f84a                	sd	s2,48(sp)
     468:	f44e                	sd	s3,40(sp)
     46a:	0880                	add	s0,sp,80
  int nzz = 32*32;
  for(int i = 0; i < nzz; i++){
     46c:	4481                	li	s1,0
    char name[32];
    name[0] = 'z';
     46e:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
     472:	40000993          	li	s3,1024
    name[0] = 'z';
     476:	fb240823          	sb	s2,-80(s0)
    name[1] = 'z';
     47a:	fb2408a3          	sb	s2,-79(s0)
    name[2] = '0' + (i / 32);
     47e:	41f4d71b          	sraw	a4,s1,0x1f
     482:	01b7571b          	srlw	a4,a4,0x1b
     486:	009707bb          	addw	a5,a4,s1
     48a:	4057d69b          	sraw	a3,a5,0x5
     48e:	0306869b          	addw	a3,a3,48
     492:	fad40923          	sb	a3,-78(s0)
    name[3] = '0' + (i % 32);
     496:	8bfd                	and	a5,a5,31
     498:	9f99                	subw	a5,a5,a4
     49a:	0307879b          	addw	a5,a5,48
     49e:	faf409a3          	sb	a5,-77(s0)
    name[4] = '\0';
     4a2:	fa040a23          	sb	zero,-76(s0)
    unlink(name);
     4a6:	fb040513          	add	a0,s0,-80
     4aa:	00005097          	auipc	ra,0x5
     4ae:	734080e7          	jalr	1844(ra) # 5bde <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
     4b2:	60200593          	li	a1,1538
     4b6:	fb040513          	add	a0,s0,-80
     4ba:	00005097          	auipc	ra,0x5
     4be:	714080e7          	jalr	1812(ra) # 5bce <open>
    if(fd < 0){
     4c2:	00054963          	bltz	a0,4d4 <outofinodes+0x76>
      // failure is eventually expected.
      break;
    }
    close(fd);
     4c6:	00005097          	auipc	ra,0x5
     4ca:	6f0080e7          	jalr	1776(ra) # 5bb6 <close>
  for(int i = 0; i < nzz; i++){
     4ce:	2485                	addw	s1,s1,1
     4d0:	fb3493e3          	bne	s1,s3,476 <outofinodes+0x18>
     4d4:	4481                	li	s1,0
  }

  for(int i = 0; i < nzz; i++){
    char name[32];
    name[0] = 'z';
     4d6:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
     4da:	40000993          	li	s3,1024
    name[0] = 'z';
     4de:	fb240823          	sb	s2,-80(s0)
    name[1] = 'z';
     4e2:	fb2408a3          	sb	s2,-79(s0)
    name[2] = '0' + (i / 32);
     4e6:	41f4d71b          	sraw	a4,s1,0x1f
     4ea:	01b7571b          	srlw	a4,a4,0x1b
     4ee:	009707bb          	addw	a5,a4,s1
     4f2:	4057d69b          	sraw	a3,a5,0x5
     4f6:	0306869b          	addw	a3,a3,48
     4fa:	fad40923          	sb	a3,-78(s0)
    name[3] = '0' + (i % 32);
     4fe:	8bfd                	and	a5,a5,31
     500:	9f99                	subw	a5,a5,a4
     502:	0307879b          	addw	a5,a5,48
     506:	faf409a3          	sb	a5,-77(s0)
    name[4] = '\0';
     50a:	fa040a23          	sb	zero,-76(s0)
    unlink(name);
     50e:	fb040513          	add	a0,s0,-80
     512:	00005097          	auipc	ra,0x5
     516:	6cc080e7          	jalr	1740(ra) # 5bde <unlink>
  for(int i = 0; i < nzz; i++){
     51a:	2485                	addw	s1,s1,1
     51c:	fd3491e3          	bne	s1,s3,4de <outofinodes+0x80>
  }
}
     520:	60a6                	ld	ra,72(sp)
     522:	6406                	ld	s0,64(sp)
     524:	74e2                	ld	s1,56(sp)
     526:	7942                	ld	s2,48(sp)
     528:	79a2                	ld	s3,40(sp)
     52a:	6161                	add	sp,sp,80
     52c:	8082                	ret

000000000000052e <copyin>:
{
     52e:	715d                	add	sp,sp,-80
     530:	e486                	sd	ra,72(sp)
     532:	e0a2                	sd	s0,64(sp)
     534:	fc26                	sd	s1,56(sp)
     536:	f84a                	sd	s2,48(sp)
     538:	f44e                	sd	s3,40(sp)
     53a:	f052                	sd	s4,32(sp)
     53c:	0880                	add	s0,sp,80
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };
     53e:	4785                	li	a5,1
     540:	07fe                	sll	a5,a5,0x1f
     542:	fcf43023          	sd	a5,-64(s0)
     546:	57fd                	li	a5,-1
     548:	fcf43423          	sd	a5,-56(s0)
  for(int ai = 0; ai < 2; ai++){
     54c:	fc040913          	add	s2,s0,-64
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     550:	00006a17          	auipc	s4,0x6
     554:	cc0a0a13          	add	s4,s4,-832 # 6210 <malloc+0x23a>
    uint64 addr = addrs[ai];
     558:	00093983          	ld	s3,0(s2)
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     55c:	20100593          	li	a1,513
     560:	8552                	mv	a0,s4
     562:	00005097          	auipc	ra,0x5
     566:	66c080e7          	jalr	1644(ra) # 5bce <open>
     56a:	84aa                	mv	s1,a0
    if(fd < 0){
     56c:	08054863          	bltz	a0,5fc <copyin+0xce>
    int n = write(fd, (void*)addr, 8192);
     570:	6609                	lui	a2,0x2
     572:	85ce                	mv	a1,s3
     574:	00005097          	auipc	ra,0x5
     578:	63a080e7          	jalr	1594(ra) # 5bae <write>
    if(n >= 0){
     57c:	08055d63          	bgez	a0,616 <copyin+0xe8>
    close(fd);
     580:	8526                	mv	a0,s1
     582:	00005097          	auipc	ra,0x5
     586:	634080e7          	jalr	1588(ra) # 5bb6 <close>
    unlink("copyin1");
     58a:	8552                	mv	a0,s4
     58c:	00005097          	auipc	ra,0x5
     590:	652080e7          	jalr	1618(ra) # 5bde <unlink>
    n = write(1, (char*)addr, 8192);
     594:	6609                	lui	a2,0x2
     596:	85ce                	mv	a1,s3
     598:	4505                	li	a0,1
     59a:	00005097          	auipc	ra,0x5
     59e:	614080e7          	jalr	1556(ra) # 5bae <write>
    if(n > 0){
     5a2:	08a04963          	bgtz	a0,634 <copyin+0x106>
    if(pipe(fds) < 0){
     5a6:	fb840513          	add	a0,s0,-72
     5aa:	00005097          	auipc	ra,0x5
     5ae:	5f4080e7          	jalr	1524(ra) # 5b9e <pipe>
     5b2:	0a054063          	bltz	a0,652 <copyin+0x124>
    n = write(fds[1], (char*)addr, 8192);
     5b6:	6609                	lui	a2,0x2
     5b8:	85ce                	mv	a1,s3
     5ba:	fbc42503          	lw	a0,-68(s0)
     5be:	00005097          	auipc	ra,0x5
     5c2:	5f0080e7          	jalr	1520(ra) # 5bae <write>
    if(n > 0){
     5c6:	0aa04363          	bgtz	a0,66c <copyin+0x13e>
    close(fds[0]);
     5ca:	fb842503          	lw	a0,-72(s0)
     5ce:	00005097          	auipc	ra,0x5
     5d2:	5e8080e7          	jalr	1512(ra) # 5bb6 <close>
    close(fds[1]);
     5d6:	fbc42503          	lw	a0,-68(s0)
     5da:	00005097          	auipc	ra,0x5
     5de:	5dc080e7          	jalr	1500(ra) # 5bb6 <close>
  for(int ai = 0; ai < 2; ai++){
     5e2:	0921                	add	s2,s2,8
     5e4:	fd040793          	add	a5,s0,-48
     5e8:	f6f918e3          	bne	s2,a5,558 <copyin+0x2a>
}
     5ec:	60a6                	ld	ra,72(sp)
     5ee:	6406                	ld	s0,64(sp)
     5f0:	74e2                	ld	s1,56(sp)
     5f2:	7942                	ld	s2,48(sp)
     5f4:	79a2                	ld	s3,40(sp)
     5f6:	7a02                	ld	s4,32(sp)
     5f8:	6161                	add	sp,sp,80
     5fa:	8082                	ret
      printf("open(copyin1) failed\n");
     5fc:	00006517          	auipc	a0,0x6
     600:	c1c50513          	add	a0,a0,-996 # 6218 <malloc+0x242>
     604:	00006097          	auipc	ra,0x6
     608:	91a080e7          	jalr	-1766(ra) # 5f1e <printf>
      exit(1);
     60c:	4505                	li	a0,1
     60e:	00005097          	auipc	ra,0x5
     612:	580080e7          	jalr	1408(ra) # 5b8e <exit>
      printf("write(fd, %p, 8192) returned %d, not -1\n", addr, n);
     616:	862a                	mv	a2,a0
     618:	85ce                	mv	a1,s3
     61a:	00006517          	auipc	a0,0x6
     61e:	c1650513          	add	a0,a0,-1002 # 6230 <malloc+0x25a>
     622:	00006097          	auipc	ra,0x6
     626:	8fc080e7          	jalr	-1796(ra) # 5f1e <printf>
      exit(1);
     62a:	4505                	li	a0,1
     62c:	00005097          	auipc	ra,0x5
     630:	562080e7          	jalr	1378(ra) # 5b8e <exit>
      printf("write(1, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     634:	862a                	mv	a2,a0
     636:	85ce                	mv	a1,s3
     638:	00006517          	auipc	a0,0x6
     63c:	c2850513          	add	a0,a0,-984 # 6260 <malloc+0x28a>
     640:	00006097          	auipc	ra,0x6
     644:	8de080e7          	jalr	-1826(ra) # 5f1e <printf>
      exit(1);
     648:	4505                	li	a0,1
     64a:	00005097          	auipc	ra,0x5
     64e:	544080e7          	jalr	1348(ra) # 5b8e <exit>
      printf("pipe() failed\n");
     652:	00006517          	auipc	a0,0x6
     656:	c3e50513          	add	a0,a0,-962 # 6290 <malloc+0x2ba>
     65a:	00006097          	auipc	ra,0x6
     65e:	8c4080e7          	jalr	-1852(ra) # 5f1e <printf>
      exit(1);
     662:	4505                	li	a0,1
     664:	00005097          	auipc	ra,0x5
     668:	52a080e7          	jalr	1322(ra) # 5b8e <exit>
      printf("write(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     66c:	862a                	mv	a2,a0
     66e:	85ce                	mv	a1,s3
     670:	00006517          	auipc	a0,0x6
     674:	c3050513          	add	a0,a0,-976 # 62a0 <malloc+0x2ca>
     678:	00006097          	auipc	ra,0x6
     67c:	8a6080e7          	jalr	-1882(ra) # 5f1e <printf>
      exit(1);
     680:	4505                	li	a0,1
     682:	00005097          	auipc	ra,0x5
     686:	50c080e7          	jalr	1292(ra) # 5b8e <exit>

000000000000068a <copyout>:
{
     68a:	711d                	add	sp,sp,-96
     68c:	ec86                	sd	ra,88(sp)
     68e:	e8a2                	sd	s0,80(sp)
     690:	e4a6                	sd	s1,72(sp)
     692:	e0ca                	sd	s2,64(sp)
     694:	fc4e                	sd	s3,56(sp)
     696:	f852                	sd	s4,48(sp)
     698:	f456                	sd	s5,40(sp)
     69a:	1080                	add	s0,sp,96
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };
     69c:	4785                	li	a5,1
     69e:	07fe                	sll	a5,a5,0x1f
     6a0:	faf43823          	sd	a5,-80(s0)
     6a4:	57fd                	li	a5,-1
     6a6:	faf43c23          	sd	a5,-72(s0)
  for(int ai = 0; ai < 2; ai++){
     6aa:	fb040913          	add	s2,s0,-80
    int fd = open("README", 0);
     6ae:	00006a17          	auipc	s4,0x6
     6b2:	c22a0a13          	add	s4,s4,-990 # 62d0 <malloc+0x2fa>
    n = write(fds[1], "x", 1);
     6b6:	00006a97          	auipc	s5,0x6
     6ba:	ab2a8a93          	add	s5,s5,-1358 # 6168 <malloc+0x192>
    uint64 addr = addrs[ai];
     6be:	00093983          	ld	s3,0(s2)
    int fd = open("README", 0);
     6c2:	4581                	li	a1,0
     6c4:	8552                	mv	a0,s4
     6c6:	00005097          	auipc	ra,0x5
     6ca:	508080e7          	jalr	1288(ra) # 5bce <open>
     6ce:	84aa                	mv	s1,a0
    if(fd < 0){
     6d0:	08054663          	bltz	a0,75c <copyout+0xd2>
    int n = read(fd, (void*)addr, 8192);
     6d4:	6609                	lui	a2,0x2
     6d6:	85ce                	mv	a1,s3
     6d8:	00005097          	auipc	ra,0x5
     6dc:	4ce080e7          	jalr	1230(ra) # 5ba6 <read>
    if(n > 0){
     6e0:	08a04b63          	bgtz	a0,776 <copyout+0xec>
    close(fd);
     6e4:	8526                	mv	a0,s1
     6e6:	00005097          	auipc	ra,0x5
     6ea:	4d0080e7          	jalr	1232(ra) # 5bb6 <close>
    if(pipe(fds) < 0){
     6ee:	fa840513          	add	a0,s0,-88
     6f2:	00005097          	auipc	ra,0x5
     6f6:	4ac080e7          	jalr	1196(ra) # 5b9e <pipe>
     6fa:	08054d63          	bltz	a0,794 <copyout+0x10a>
    n = write(fds[1], "x", 1);
     6fe:	4605                	li	a2,1
     700:	85d6                	mv	a1,s5
     702:	fac42503          	lw	a0,-84(s0)
     706:	00005097          	auipc	ra,0x5
     70a:	4a8080e7          	jalr	1192(ra) # 5bae <write>
    if(n != 1){
     70e:	4785                	li	a5,1
     710:	08f51f63          	bne	a0,a5,7ae <copyout+0x124>
    n = read(fds[0], (void*)addr, 8192);
     714:	6609                	lui	a2,0x2
     716:	85ce                	mv	a1,s3
     718:	fa842503          	lw	a0,-88(s0)
     71c:	00005097          	auipc	ra,0x5
     720:	48a080e7          	jalr	1162(ra) # 5ba6 <read>
    if(n > 0){
     724:	0aa04263          	bgtz	a0,7c8 <copyout+0x13e>
    close(fds[0]);
     728:	fa842503          	lw	a0,-88(s0)
     72c:	00005097          	auipc	ra,0x5
     730:	48a080e7          	jalr	1162(ra) # 5bb6 <close>
    close(fds[1]);
     734:	fac42503          	lw	a0,-84(s0)
     738:	00005097          	auipc	ra,0x5
     73c:	47e080e7          	jalr	1150(ra) # 5bb6 <close>
  for(int ai = 0; ai < 2; ai++){
     740:	0921                	add	s2,s2,8
     742:	fc040793          	add	a5,s0,-64
     746:	f6f91ce3          	bne	s2,a5,6be <copyout+0x34>
}
     74a:	60e6                	ld	ra,88(sp)
     74c:	6446                	ld	s0,80(sp)
     74e:	64a6                	ld	s1,72(sp)
     750:	6906                	ld	s2,64(sp)
     752:	79e2                	ld	s3,56(sp)
     754:	7a42                	ld	s4,48(sp)
     756:	7aa2                	ld	s5,40(sp)
     758:	6125                	add	sp,sp,96
     75a:	8082                	ret
      printf("open(README) failed\n");
     75c:	00006517          	auipc	a0,0x6
     760:	b7c50513          	add	a0,a0,-1156 # 62d8 <malloc+0x302>
     764:	00005097          	auipc	ra,0x5
     768:	7ba080e7          	jalr	1978(ra) # 5f1e <printf>
      exit(1);
     76c:	4505                	li	a0,1
     76e:	00005097          	auipc	ra,0x5
     772:	420080e7          	jalr	1056(ra) # 5b8e <exit>
      printf("read(fd, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     776:	862a                	mv	a2,a0
     778:	85ce                	mv	a1,s3
     77a:	00006517          	auipc	a0,0x6
     77e:	b7650513          	add	a0,a0,-1162 # 62f0 <malloc+0x31a>
     782:	00005097          	auipc	ra,0x5
     786:	79c080e7          	jalr	1948(ra) # 5f1e <printf>
      exit(1);
     78a:	4505                	li	a0,1
     78c:	00005097          	auipc	ra,0x5
     790:	402080e7          	jalr	1026(ra) # 5b8e <exit>
      printf("pipe() failed\n");
     794:	00006517          	auipc	a0,0x6
     798:	afc50513          	add	a0,a0,-1284 # 6290 <malloc+0x2ba>
     79c:	00005097          	auipc	ra,0x5
     7a0:	782080e7          	jalr	1922(ra) # 5f1e <printf>
      exit(1);
     7a4:	4505                	li	a0,1
     7a6:	00005097          	auipc	ra,0x5
     7aa:	3e8080e7          	jalr	1000(ra) # 5b8e <exit>
      printf("pipe write failed\n");
     7ae:	00006517          	auipc	a0,0x6
     7b2:	b7250513          	add	a0,a0,-1166 # 6320 <malloc+0x34a>
     7b6:	00005097          	auipc	ra,0x5
     7ba:	768080e7          	jalr	1896(ra) # 5f1e <printf>
      exit(1);
     7be:	4505                	li	a0,1
     7c0:	00005097          	auipc	ra,0x5
     7c4:	3ce080e7          	jalr	974(ra) # 5b8e <exit>
      printf("read(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     7c8:	862a                	mv	a2,a0
     7ca:	85ce                	mv	a1,s3
     7cc:	00006517          	auipc	a0,0x6
     7d0:	b6c50513          	add	a0,a0,-1172 # 6338 <malloc+0x362>
     7d4:	00005097          	auipc	ra,0x5
     7d8:	74a080e7          	jalr	1866(ra) # 5f1e <printf>
      exit(1);
     7dc:	4505                	li	a0,1
     7de:	00005097          	auipc	ra,0x5
     7e2:	3b0080e7          	jalr	944(ra) # 5b8e <exit>

00000000000007e6 <truncate1>:
{
     7e6:	711d                	add	sp,sp,-96
     7e8:	ec86                	sd	ra,88(sp)
     7ea:	e8a2                	sd	s0,80(sp)
     7ec:	e4a6                	sd	s1,72(sp)
     7ee:	e0ca                	sd	s2,64(sp)
     7f0:	fc4e                	sd	s3,56(sp)
     7f2:	f852                	sd	s4,48(sp)
     7f4:	f456                	sd	s5,40(sp)
     7f6:	1080                	add	s0,sp,96
     7f8:	8aaa                	mv	s5,a0
  unlink("truncfile");
     7fa:	00006517          	auipc	a0,0x6
     7fe:	95650513          	add	a0,a0,-1706 # 6150 <malloc+0x17a>
     802:	00005097          	auipc	ra,0x5
     806:	3dc080e7          	jalr	988(ra) # 5bde <unlink>
  int fd1 = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
     80a:	60100593          	li	a1,1537
     80e:	00006517          	auipc	a0,0x6
     812:	94250513          	add	a0,a0,-1726 # 6150 <malloc+0x17a>
     816:	00005097          	auipc	ra,0x5
     81a:	3b8080e7          	jalr	952(ra) # 5bce <open>
     81e:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     820:	4611                	li	a2,4
     822:	00006597          	auipc	a1,0x6
     826:	93e58593          	add	a1,a1,-1730 # 6160 <malloc+0x18a>
     82a:	00005097          	auipc	ra,0x5
     82e:	384080e7          	jalr	900(ra) # 5bae <write>
  close(fd1);
     832:	8526                	mv	a0,s1
     834:	00005097          	auipc	ra,0x5
     838:	382080e7          	jalr	898(ra) # 5bb6 <close>
  int fd2 = open("truncfile", O_RDONLY);
     83c:	4581                	li	a1,0
     83e:	00006517          	auipc	a0,0x6
     842:	91250513          	add	a0,a0,-1774 # 6150 <malloc+0x17a>
     846:	00005097          	auipc	ra,0x5
     84a:	388080e7          	jalr	904(ra) # 5bce <open>
     84e:	84aa                	mv	s1,a0
  int n = read(fd2, buf, sizeof(buf));
     850:	02000613          	li	a2,32
     854:	fa040593          	add	a1,s0,-96
     858:	00005097          	auipc	ra,0x5
     85c:	34e080e7          	jalr	846(ra) # 5ba6 <read>
  if(n != 4){
     860:	4791                	li	a5,4
     862:	0cf51e63          	bne	a0,a5,93e <truncate1+0x158>
  fd1 = open("truncfile", O_WRONLY|O_TRUNC);
     866:	40100593          	li	a1,1025
     86a:	00006517          	auipc	a0,0x6
     86e:	8e650513          	add	a0,a0,-1818 # 6150 <malloc+0x17a>
     872:	00005097          	auipc	ra,0x5
     876:	35c080e7          	jalr	860(ra) # 5bce <open>
     87a:	89aa                	mv	s3,a0
  int fd3 = open("truncfile", O_RDONLY);
     87c:	4581                	li	a1,0
     87e:	00006517          	auipc	a0,0x6
     882:	8d250513          	add	a0,a0,-1838 # 6150 <malloc+0x17a>
     886:	00005097          	auipc	ra,0x5
     88a:	348080e7          	jalr	840(ra) # 5bce <open>
     88e:	892a                	mv	s2,a0
  n = read(fd3, buf, sizeof(buf));
     890:	02000613          	li	a2,32
     894:	fa040593          	add	a1,s0,-96
     898:	00005097          	auipc	ra,0x5
     89c:	30e080e7          	jalr	782(ra) # 5ba6 <read>
     8a0:	8a2a                	mv	s4,a0
  if(n != 0){
     8a2:	ed4d                	bnez	a0,95c <truncate1+0x176>
  n = read(fd2, buf, sizeof(buf));
     8a4:	02000613          	li	a2,32
     8a8:	fa040593          	add	a1,s0,-96
     8ac:	8526                	mv	a0,s1
     8ae:	00005097          	auipc	ra,0x5
     8b2:	2f8080e7          	jalr	760(ra) # 5ba6 <read>
     8b6:	8a2a                	mv	s4,a0
  if(n != 0){
     8b8:	e971                	bnez	a0,98c <truncate1+0x1a6>
  write(fd1, "abcdef", 6);
     8ba:	4619                	li	a2,6
     8bc:	00006597          	auipc	a1,0x6
     8c0:	b0c58593          	add	a1,a1,-1268 # 63c8 <malloc+0x3f2>
     8c4:	854e                	mv	a0,s3
     8c6:	00005097          	auipc	ra,0x5
     8ca:	2e8080e7          	jalr	744(ra) # 5bae <write>
  n = read(fd3, buf, sizeof(buf));
     8ce:	02000613          	li	a2,32
     8d2:	fa040593          	add	a1,s0,-96
     8d6:	854a                	mv	a0,s2
     8d8:	00005097          	auipc	ra,0x5
     8dc:	2ce080e7          	jalr	718(ra) # 5ba6 <read>
  if(n != 6){
     8e0:	4799                	li	a5,6
     8e2:	0cf51d63          	bne	a0,a5,9bc <truncate1+0x1d6>
  n = read(fd2, buf, sizeof(buf));
     8e6:	02000613          	li	a2,32
     8ea:	fa040593          	add	a1,s0,-96
     8ee:	8526                	mv	a0,s1
     8f0:	00005097          	auipc	ra,0x5
     8f4:	2b6080e7          	jalr	694(ra) # 5ba6 <read>
  if(n != 2){
     8f8:	4789                	li	a5,2
     8fa:	0ef51063          	bne	a0,a5,9da <truncate1+0x1f4>
  unlink("truncfile");
     8fe:	00006517          	auipc	a0,0x6
     902:	85250513          	add	a0,a0,-1966 # 6150 <malloc+0x17a>
     906:	00005097          	auipc	ra,0x5
     90a:	2d8080e7          	jalr	728(ra) # 5bde <unlink>
  close(fd1);
     90e:	854e                	mv	a0,s3
     910:	00005097          	auipc	ra,0x5
     914:	2a6080e7          	jalr	678(ra) # 5bb6 <close>
  close(fd2);
     918:	8526                	mv	a0,s1
     91a:	00005097          	auipc	ra,0x5
     91e:	29c080e7          	jalr	668(ra) # 5bb6 <close>
  close(fd3);
     922:	854a                	mv	a0,s2
     924:	00005097          	auipc	ra,0x5
     928:	292080e7          	jalr	658(ra) # 5bb6 <close>
}
     92c:	60e6                	ld	ra,88(sp)
     92e:	6446                	ld	s0,80(sp)
     930:	64a6                	ld	s1,72(sp)
     932:	6906                	ld	s2,64(sp)
     934:	79e2                	ld	s3,56(sp)
     936:	7a42                	ld	s4,48(sp)
     938:	7aa2                	ld	s5,40(sp)
     93a:	6125                	add	sp,sp,96
     93c:	8082                	ret
    printf("%s: read %d bytes, wanted 4\n", s, n);
     93e:	862a                	mv	a2,a0
     940:	85d6                	mv	a1,s5
     942:	00006517          	auipc	a0,0x6
     946:	a2650513          	add	a0,a0,-1498 # 6368 <malloc+0x392>
     94a:	00005097          	auipc	ra,0x5
     94e:	5d4080e7          	jalr	1492(ra) # 5f1e <printf>
    exit(1);
     952:	4505                	li	a0,1
     954:	00005097          	auipc	ra,0x5
     958:	23a080e7          	jalr	570(ra) # 5b8e <exit>
    printf("aaa fd3=%d\n", fd3);
     95c:	85ca                	mv	a1,s2
     95e:	00006517          	auipc	a0,0x6
     962:	a2a50513          	add	a0,a0,-1494 # 6388 <malloc+0x3b2>
     966:	00005097          	auipc	ra,0x5
     96a:	5b8080e7          	jalr	1464(ra) # 5f1e <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     96e:	8652                	mv	a2,s4
     970:	85d6                	mv	a1,s5
     972:	00006517          	auipc	a0,0x6
     976:	a2650513          	add	a0,a0,-1498 # 6398 <malloc+0x3c2>
     97a:	00005097          	auipc	ra,0x5
     97e:	5a4080e7          	jalr	1444(ra) # 5f1e <printf>
    exit(1);
     982:	4505                	li	a0,1
     984:	00005097          	auipc	ra,0x5
     988:	20a080e7          	jalr	522(ra) # 5b8e <exit>
    printf("bbb fd2=%d\n", fd2);
     98c:	85a6                	mv	a1,s1
     98e:	00006517          	auipc	a0,0x6
     992:	a2a50513          	add	a0,a0,-1494 # 63b8 <malloc+0x3e2>
     996:	00005097          	auipc	ra,0x5
     99a:	588080e7          	jalr	1416(ra) # 5f1e <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     99e:	8652                	mv	a2,s4
     9a0:	85d6                	mv	a1,s5
     9a2:	00006517          	auipc	a0,0x6
     9a6:	9f650513          	add	a0,a0,-1546 # 6398 <malloc+0x3c2>
     9aa:	00005097          	auipc	ra,0x5
     9ae:	574080e7          	jalr	1396(ra) # 5f1e <printf>
    exit(1);
     9b2:	4505                	li	a0,1
     9b4:	00005097          	auipc	ra,0x5
     9b8:	1da080e7          	jalr	474(ra) # 5b8e <exit>
    printf("%s: read %d bytes, wanted 6\n", s, n);
     9bc:	862a                	mv	a2,a0
     9be:	85d6                	mv	a1,s5
     9c0:	00006517          	auipc	a0,0x6
     9c4:	a1050513          	add	a0,a0,-1520 # 63d0 <malloc+0x3fa>
     9c8:	00005097          	auipc	ra,0x5
     9cc:	556080e7          	jalr	1366(ra) # 5f1e <printf>
    exit(1);
     9d0:	4505                	li	a0,1
     9d2:	00005097          	auipc	ra,0x5
     9d6:	1bc080e7          	jalr	444(ra) # 5b8e <exit>
    printf("%s: read %d bytes, wanted 2\n", s, n);
     9da:	862a                	mv	a2,a0
     9dc:	85d6                	mv	a1,s5
     9de:	00006517          	auipc	a0,0x6
     9e2:	a1250513          	add	a0,a0,-1518 # 63f0 <malloc+0x41a>
     9e6:	00005097          	auipc	ra,0x5
     9ea:	538080e7          	jalr	1336(ra) # 5f1e <printf>
    exit(1);
     9ee:	4505                	li	a0,1
     9f0:	00005097          	auipc	ra,0x5
     9f4:	19e080e7          	jalr	414(ra) # 5b8e <exit>

00000000000009f8 <writetest>:
{
     9f8:	7139                	add	sp,sp,-64
     9fa:	fc06                	sd	ra,56(sp)
     9fc:	f822                	sd	s0,48(sp)
     9fe:	f426                	sd	s1,40(sp)
     a00:	f04a                	sd	s2,32(sp)
     a02:	ec4e                	sd	s3,24(sp)
     a04:	e852                	sd	s4,16(sp)
     a06:	e456                	sd	s5,8(sp)
     a08:	e05a                	sd	s6,0(sp)
     a0a:	0080                	add	s0,sp,64
     a0c:	8b2a                	mv	s6,a0
  fd = open("small", O_CREATE|O_RDWR);
     a0e:	20200593          	li	a1,514
     a12:	00006517          	auipc	a0,0x6
     a16:	9fe50513          	add	a0,a0,-1538 # 6410 <malloc+0x43a>
     a1a:	00005097          	auipc	ra,0x5
     a1e:	1b4080e7          	jalr	436(ra) # 5bce <open>
  if(fd < 0){
     a22:	0a054d63          	bltz	a0,adc <writetest+0xe4>
     a26:	892a                	mv	s2,a0
     a28:	4481                	li	s1,0
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     a2a:	00006997          	auipc	s3,0x6
     a2e:	a0e98993          	add	s3,s3,-1522 # 6438 <malloc+0x462>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     a32:	00006a97          	auipc	s5,0x6
     a36:	a3ea8a93          	add	s5,s5,-1474 # 6470 <malloc+0x49a>
  for(i = 0; i < N; i++){
     a3a:	06400a13          	li	s4,100
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     a3e:	4629                	li	a2,10
     a40:	85ce                	mv	a1,s3
     a42:	854a                	mv	a0,s2
     a44:	00005097          	auipc	ra,0x5
     a48:	16a080e7          	jalr	362(ra) # 5bae <write>
     a4c:	47a9                	li	a5,10
     a4e:	0af51563          	bne	a0,a5,af8 <writetest+0x100>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     a52:	4629                	li	a2,10
     a54:	85d6                	mv	a1,s5
     a56:	854a                	mv	a0,s2
     a58:	00005097          	auipc	ra,0x5
     a5c:	156080e7          	jalr	342(ra) # 5bae <write>
     a60:	47a9                	li	a5,10
     a62:	0af51a63          	bne	a0,a5,b16 <writetest+0x11e>
  for(i = 0; i < N; i++){
     a66:	2485                	addw	s1,s1,1
     a68:	fd449be3          	bne	s1,s4,a3e <writetest+0x46>
  close(fd);
     a6c:	854a                	mv	a0,s2
     a6e:	00005097          	auipc	ra,0x5
     a72:	148080e7          	jalr	328(ra) # 5bb6 <close>
  fd = open("small", O_RDONLY);
     a76:	4581                	li	a1,0
     a78:	00006517          	auipc	a0,0x6
     a7c:	99850513          	add	a0,a0,-1640 # 6410 <malloc+0x43a>
     a80:	00005097          	auipc	ra,0x5
     a84:	14e080e7          	jalr	334(ra) # 5bce <open>
     a88:	84aa                	mv	s1,a0
  if(fd < 0){
     a8a:	0a054563          	bltz	a0,b34 <writetest+0x13c>
  i = read(fd, buf, N*SZ*2);
     a8e:	7d000613          	li	a2,2000
     a92:	0000c597          	auipc	a1,0xc
     a96:	1d658593          	add	a1,a1,470 # cc68 <buf>
     a9a:	00005097          	auipc	ra,0x5
     a9e:	10c080e7          	jalr	268(ra) # 5ba6 <read>
  if(i != N*SZ*2){
     aa2:	7d000793          	li	a5,2000
     aa6:	0af51563          	bne	a0,a5,b50 <writetest+0x158>
  close(fd);
     aaa:	8526                	mv	a0,s1
     aac:	00005097          	auipc	ra,0x5
     ab0:	10a080e7          	jalr	266(ra) # 5bb6 <close>
  if(unlink("small") < 0){
     ab4:	00006517          	auipc	a0,0x6
     ab8:	95c50513          	add	a0,a0,-1700 # 6410 <malloc+0x43a>
     abc:	00005097          	auipc	ra,0x5
     ac0:	122080e7          	jalr	290(ra) # 5bde <unlink>
     ac4:	0a054463          	bltz	a0,b6c <writetest+0x174>
}
     ac8:	70e2                	ld	ra,56(sp)
     aca:	7442                	ld	s0,48(sp)
     acc:	74a2                	ld	s1,40(sp)
     ace:	7902                	ld	s2,32(sp)
     ad0:	69e2                	ld	s3,24(sp)
     ad2:	6a42                	ld	s4,16(sp)
     ad4:	6aa2                	ld	s5,8(sp)
     ad6:	6b02                	ld	s6,0(sp)
     ad8:	6121                	add	sp,sp,64
     ada:	8082                	ret
    printf("%s: error: creat small failed!\n", s);
     adc:	85da                	mv	a1,s6
     ade:	00006517          	auipc	a0,0x6
     ae2:	93a50513          	add	a0,a0,-1734 # 6418 <malloc+0x442>
     ae6:	00005097          	auipc	ra,0x5
     aea:	438080e7          	jalr	1080(ra) # 5f1e <printf>
    exit(1);
     aee:	4505                	li	a0,1
     af0:	00005097          	auipc	ra,0x5
     af4:	09e080e7          	jalr	158(ra) # 5b8e <exit>
      printf("%s: error: write aa %d new file failed\n", s, i);
     af8:	8626                	mv	a2,s1
     afa:	85da                	mv	a1,s6
     afc:	00006517          	auipc	a0,0x6
     b00:	94c50513          	add	a0,a0,-1716 # 6448 <malloc+0x472>
     b04:	00005097          	auipc	ra,0x5
     b08:	41a080e7          	jalr	1050(ra) # 5f1e <printf>
      exit(1);
     b0c:	4505                	li	a0,1
     b0e:	00005097          	auipc	ra,0x5
     b12:	080080e7          	jalr	128(ra) # 5b8e <exit>
      printf("%s: error: write bb %d new file failed\n", s, i);
     b16:	8626                	mv	a2,s1
     b18:	85da                	mv	a1,s6
     b1a:	00006517          	auipc	a0,0x6
     b1e:	96650513          	add	a0,a0,-1690 # 6480 <malloc+0x4aa>
     b22:	00005097          	auipc	ra,0x5
     b26:	3fc080e7          	jalr	1020(ra) # 5f1e <printf>
      exit(1);
     b2a:	4505                	li	a0,1
     b2c:	00005097          	auipc	ra,0x5
     b30:	062080e7          	jalr	98(ra) # 5b8e <exit>
    printf("%s: error: open small failed!\n", s);
     b34:	85da                	mv	a1,s6
     b36:	00006517          	auipc	a0,0x6
     b3a:	97250513          	add	a0,a0,-1678 # 64a8 <malloc+0x4d2>
     b3e:	00005097          	auipc	ra,0x5
     b42:	3e0080e7          	jalr	992(ra) # 5f1e <printf>
    exit(1);
     b46:	4505                	li	a0,1
     b48:	00005097          	auipc	ra,0x5
     b4c:	046080e7          	jalr	70(ra) # 5b8e <exit>
    printf("%s: read failed\n", s);
     b50:	85da                	mv	a1,s6
     b52:	00006517          	auipc	a0,0x6
     b56:	97650513          	add	a0,a0,-1674 # 64c8 <malloc+0x4f2>
     b5a:	00005097          	auipc	ra,0x5
     b5e:	3c4080e7          	jalr	964(ra) # 5f1e <printf>
    exit(1);
     b62:	4505                	li	a0,1
     b64:	00005097          	auipc	ra,0x5
     b68:	02a080e7          	jalr	42(ra) # 5b8e <exit>
    printf("%s: unlink small failed\n", s);
     b6c:	85da                	mv	a1,s6
     b6e:	00006517          	auipc	a0,0x6
     b72:	97250513          	add	a0,a0,-1678 # 64e0 <malloc+0x50a>
     b76:	00005097          	auipc	ra,0x5
     b7a:	3a8080e7          	jalr	936(ra) # 5f1e <printf>
    exit(1);
     b7e:	4505                	li	a0,1
     b80:	00005097          	auipc	ra,0x5
     b84:	00e080e7          	jalr	14(ra) # 5b8e <exit>

0000000000000b88 <writebig>:
{
     b88:	7139                	add	sp,sp,-64
     b8a:	fc06                	sd	ra,56(sp)
     b8c:	f822                	sd	s0,48(sp)
     b8e:	f426                	sd	s1,40(sp)
     b90:	f04a                	sd	s2,32(sp)
     b92:	ec4e                	sd	s3,24(sp)
     b94:	e852                	sd	s4,16(sp)
     b96:	e456                	sd	s5,8(sp)
     b98:	0080                	add	s0,sp,64
     b9a:	8aaa                	mv	s5,a0
  fd = open("big", O_CREATE|O_RDWR);
     b9c:	20200593          	li	a1,514
     ba0:	00006517          	auipc	a0,0x6
     ba4:	96050513          	add	a0,a0,-1696 # 6500 <malloc+0x52a>
     ba8:	00005097          	auipc	ra,0x5
     bac:	026080e7          	jalr	38(ra) # 5bce <open>
     bb0:	89aa                	mv	s3,a0
  for(i = 0; i < MAXFILE; i++){
     bb2:	4481                	li	s1,0
    ((int*)buf)[0] = i;
     bb4:	0000c917          	auipc	s2,0xc
     bb8:	0b490913          	add	s2,s2,180 # cc68 <buf>
  for(i = 0; i < MAXFILE; i++){
     bbc:	10c00a13          	li	s4,268
  if(fd < 0){
     bc0:	06054c63          	bltz	a0,c38 <writebig+0xb0>
    ((int*)buf)[0] = i;
     bc4:	00992023          	sw	s1,0(s2)
    if(write(fd, buf, BSIZE) != BSIZE){
     bc8:	40000613          	li	a2,1024
     bcc:	85ca                	mv	a1,s2
     bce:	854e                	mv	a0,s3
     bd0:	00005097          	auipc	ra,0x5
     bd4:	fde080e7          	jalr	-34(ra) # 5bae <write>
     bd8:	40000793          	li	a5,1024
     bdc:	06f51c63          	bne	a0,a5,c54 <writebig+0xcc>
  for(i = 0; i < MAXFILE; i++){
     be0:	2485                	addw	s1,s1,1
     be2:	ff4491e3          	bne	s1,s4,bc4 <writebig+0x3c>
  close(fd);
     be6:	854e                	mv	a0,s3
     be8:	00005097          	auipc	ra,0x5
     bec:	fce080e7          	jalr	-50(ra) # 5bb6 <close>
  fd = open("big", O_RDONLY);
     bf0:	4581                	li	a1,0
     bf2:	00006517          	auipc	a0,0x6
     bf6:	90e50513          	add	a0,a0,-1778 # 6500 <malloc+0x52a>
     bfa:	00005097          	auipc	ra,0x5
     bfe:	fd4080e7          	jalr	-44(ra) # 5bce <open>
     c02:	89aa                	mv	s3,a0
  n = 0;
     c04:	4481                	li	s1,0
    i = read(fd, buf, BSIZE);
     c06:	0000c917          	auipc	s2,0xc
     c0a:	06290913          	add	s2,s2,98 # cc68 <buf>
  if(fd < 0){
     c0e:	06054263          	bltz	a0,c72 <writebig+0xea>
    i = read(fd, buf, BSIZE);
     c12:	40000613          	li	a2,1024
     c16:	85ca                	mv	a1,s2
     c18:	854e                	mv	a0,s3
     c1a:	00005097          	auipc	ra,0x5
     c1e:	f8c080e7          	jalr	-116(ra) # 5ba6 <read>
    if(i == 0){
     c22:	c535                	beqz	a0,c8e <writebig+0x106>
    } else if(i != BSIZE){
     c24:	40000793          	li	a5,1024
     c28:	0af51f63          	bne	a0,a5,ce6 <writebig+0x15e>
    if(((int*)buf)[0] != n){
     c2c:	00092683          	lw	a3,0(s2)
     c30:	0c969a63          	bne	a3,s1,d04 <writebig+0x17c>
    n++;
     c34:	2485                	addw	s1,s1,1
    i = read(fd, buf, BSIZE);
     c36:	bff1                	j	c12 <writebig+0x8a>
    printf("%s: error: creat big failed!\n", s);
     c38:	85d6                	mv	a1,s5
     c3a:	00006517          	auipc	a0,0x6
     c3e:	8ce50513          	add	a0,a0,-1842 # 6508 <malloc+0x532>
     c42:	00005097          	auipc	ra,0x5
     c46:	2dc080e7          	jalr	732(ra) # 5f1e <printf>
    exit(1);
     c4a:	4505                	li	a0,1
     c4c:	00005097          	auipc	ra,0x5
     c50:	f42080e7          	jalr	-190(ra) # 5b8e <exit>
      printf("%s: error: write big file failed\n", s, i);
     c54:	8626                	mv	a2,s1
     c56:	85d6                	mv	a1,s5
     c58:	00006517          	auipc	a0,0x6
     c5c:	8d050513          	add	a0,a0,-1840 # 6528 <malloc+0x552>
     c60:	00005097          	auipc	ra,0x5
     c64:	2be080e7          	jalr	702(ra) # 5f1e <printf>
      exit(1);
     c68:	4505                	li	a0,1
     c6a:	00005097          	auipc	ra,0x5
     c6e:	f24080e7          	jalr	-220(ra) # 5b8e <exit>
    printf("%s: error: open big failed!\n", s);
     c72:	85d6                	mv	a1,s5
     c74:	00006517          	auipc	a0,0x6
     c78:	8dc50513          	add	a0,a0,-1828 # 6550 <malloc+0x57a>
     c7c:	00005097          	auipc	ra,0x5
     c80:	2a2080e7          	jalr	674(ra) # 5f1e <printf>
    exit(1);
     c84:	4505                	li	a0,1
     c86:	00005097          	auipc	ra,0x5
     c8a:	f08080e7          	jalr	-248(ra) # 5b8e <exit>
      if(n == MAXFILE - 1){
     c8e:	10b00793          	li	a5,267
     c92:	02f48a63          	beq	s1,a5,cc6 <writebig+0x13e>
  close(fd);
     c96:	854e                	mv	a0,s3
     c98:	00005097          	auipc	ra,0x5
     c9c:	f1e080e7          	jalr	-226(ra) # 5bb6 <close>
  if(unlink("big") < 0){
     ca0:	00006517          	auipc	a0,0x6
     ca4:	86050513          	add	a0,a0,-1952 # 6500 <malloc+0x52a>
     ca8:	00005097          	auipc	ra,0x5
     cac:	f36080e7          	jalr	-202(ra) # 5bde <unlink>
     cb0:	06054963          	bltz	a0,d22 <writebig+0x19a>
}
     cb4:	70e2                	ld	ra,56(sp)
     cb6:	7442                	ld	s0,48(sp)
     cb8:	74a2                	ld	s1,40(sp)
     cba:	7902                	ld	s2,32(sp)
     cbc:	69e2                	ld	s3,24(sp)
     cbe:	6a42                	ld	s4,16(sp)
     cc0:	6aa2                	ld	s5,8(sp)
     cc2:	6121                	add	sp,sp,64
     cc4:	8082                	ret
        printf("%s: read only %d blocks from big", s, n);
     cc6:	10b00613          	li	a2,267
     cca:	85d6                	mv	a1,s5
     ccc:	00006517          	auipc	a0,0x6
     cd0:	8a450513          	add	a0,a0,-1884 # 6570 <malloc+0x59a>
     cd4:	00005097          	auipc	ra,0x5
     cd8:	24a080e7          	jalr	586(ra) # 5f1e <printf>
        exit(1);
     cdc:	4505                	li	a0,1
     cde:	00005097          	auipc	ra,0x5
     ce2:	eb0080e7          	jalr	-336(ra) # 5b8e <exit>
      printf("%s: read failed %d\n", s, i);
     ce6:	862a                	mv	a2,a0
     ce8:	85d6                	mv	a1,s5
     cea:	00006517          	auipc	a0,0x6
     cee:	8ae50513          	add	a0,a0,-1874 # 6598 <malloc+0x5c2>
     cf2:	00005097          	auipc	ra,0x5
     cf6:	22c080e7          	jalr	556(ra) # 5f1e <printf>
      exit(1);
     cfa:	4505                	li	a0,1
     cfc:	00005097          	auipc	ra,0x5
     d00:	e92080e7          	jalr	-366(ra) # 5b8e <exit>
      printf("%s: read content of block %d is %d\n", s,
     d04:	8626                	mv	a2,s1
     d06:	85d6                	mv	a1,s5
     d08:	00006517          	auipc	a0,0x6
     d0c:	8a850513          	add	a0,a0,-1880 # 65b0 <malloc+0x5da>
     d10:	00005097          	auipc	ra,0x5
     d14:	20e080e7          	jalr	526(ra) # 5f1e <printf>
      exit(1);
     d18:	4505                	li	a0,1
     d1a:	00005097          	auipc	ra,0x5
     d1e:	e74080e7          	jalr	-396(ra) # 5b8e <exit>
    printf("%s: unlink big failed\n", s);
     d22:	85d6                	mv	a1,s5
     d24:	00006517          	auipc	a0,0x6
     d28:	8b450513          	add	a0,a0,-1868 # 65d8 <malloc+0x602>
     d2c:	00005097          	auipc	ra,0x5
     d30:	1f2080e7          	jalr	498(ra) # 5f1e <printf>
    exit(1);
     d34:	4505                	li	a0,1
     d36:	00005097          	auipc	ra,0x5
     d3a:	e58080e7          	jalr	-424(ra) # 5b8e <exit>

0000000000000d3e <unlinkread>:
{
     d3e:	7179                	add	sp,sp,-48
     d40:	f406                	sd	ra,40(sp)
     d42:	f022                	sd	s0,32(sp)
     d44:	ec26                	sd	s1,24(sp)
     d46:	e84a                	sd	s2,16(sp)
     d48:	e44e                	sd	s3,8(sp)
     d4a:	1800                	add	s0,sp,48
     d4c:	89aa                	mv	s3,a0
  fd = open("unlinkread", O_CREATE | O_RDWR);
     d4e:	20200593          	li	a1,514
     d52:	00006517          	auipc	a0,0x6
     d56:	89e50513          	add	a0,a0,-1890 # 65f0 <malloc+0x61a>
     d5a:	00005097          	auipc	ra,0x5
     d5e:	e74080e7          	jalr	-396(ra) # 5bce <open>
  if(fd < 0){
     d62:	0e054563          	bltz	a0,e4c <unlinkread+0x10e>
     d66:	84aa                	mv	s1,a0
  write(fd, "hello", SZ);
     d68:	4615                	li	a2,5
     d6a:	00006597          	auipc	a1,0x6
     d6e:	8b658593          	add	a1,a1,-1866 # 6620 <malloc+0x64a>
     d72:	00005097          	auipc	ra,0x5
     d76:	e3c080e7          	jalr	-452(ra) # 5bae <write>
  close(fd);
     d7a:	8526                	mv	a0,s1
     d7c:	00005097          	auipc	ra,0x5
     d80:	e3a080e7          	jalr	-454(ra) # 5bb6 <close>
  fd = open("unlinkread", O_RDWR);
     d84:	4589                	li	a1,2
     d86:	00006517          	auipc	a0,0x6
     d8a:	86a50513          	add	a0,a0,-1942 # 65f0 <malloc+0x61a>
     d8e:	00005097          	auipc	ra,0x5
     d92:	e40080e7          	jalr	-448(ra) # 5bce <open>
     d96:	84aa                	mv	s1,a0
  if(fd < 0){
     d98:	0c054863          	bltz	a0,e68 <unlinkread+0x12a>
  if(unlink("unlinkread") != 0){
     d9c:	00006517          	auipc	a0,0x6
     da0:	85450513          	add	a0,a0,-1964 # 65f0 <malloc+0x61a>
     da4:	00005097          	auipc	ra,0x5
     da8:	e3a080e7          	jalr	-454(ra) # 5bde <unlink>
     dac:	ed61                	bnez	a0,e84 <unlinkread+0x146>
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
     dae:	20200593          	li	a1,514
     db2:	00006517          	auipc	a0,0x6
     db6:	83e50513          	add	a0,a0,-1986 # 65f0 <malloc+0x61a>
     dba:	00005097          	auipc	ra,0x5
     dbe:	e14080e7          	jalr	-492(ra) # 5bce <open>
     dc2:	892a                	mv	s2,a0
  write(fd1, "yyy", 3);
     dc4:	460d                	li	a2,3
     dc6:	00006597          	auipc	a1,0x6
     dca:	8a258593          	add	a1,a1,-1886 # 6668 <malloc+0x692>
     dce:	00005097          	auipc	ra,0x5
     dd2:	de0080e7          	jalr	-544(ra) # 5bae <write>
  close(fd1);
     dd6:	854a                	mv	a0,s2
     dd8:	00005097          	auipc	ra,0x5
     ddc:	dde080e7          	jalr	-546(ra) # 5bb6 <close>
  if(read(fd, buf, sizeof(buf)) != SZ){
     de0:	660d                	lui	a2,0x3
     de2:	0000c597          	auipc	a1,0xc
     de6:	e8658593          	add	a1,a1,-378 # cc68 <buf>
     dea:	8526                	mv	a0,s1
     dec:	00005097          	auipc	ra,0x5
     df0:	dba080e7          	jalr	-582(ra) # 5ba6 <read>
     df4:	4795                	li	a5,5
     df6:	0af51563          	bne	a0,a5,ea0 <unlinkread+0x162>
  if(buf[0] != 'h'){
     dfa:	0000c717          	auipc	a4,0xc
     dfe:	e6e74703          	lbu	a4,-402(a4) # cc68 <buf>
     e02:	06800793          	li	a5,104
     e06:	0af71b63          	bne	a4,a5,ebc <unlinkread+0x17e>
  if(write(fd, buf, 10) != 10){
     e0a:	4629                	li	a2,10
     e0c:	0000c597          	auipc	a1,0xc
     e10:	e5c58593          	add	a1,a1,-420 # cc68 <buf>
     e14:	8526                	mv	a0,s1
     e16:	00005097          	auipc	ra,0x5
     e1a:	d98080e7          	jalr	-616(ra) # 5bae <write>
     e1e:	47a9                	li	a5,10
     e20:	0af51c63          	bne	a0,a5,ed8 <unlinkread+0x19a>
  close(fd);
     e24:	8526                	mv	a0,s1
     e26:	00005097          	auipc	ra,0x5
     e2a:	d90080e7          	jalr	-624(ra) # 5bb6 <close>
  unlink("unlinkread");
     e2e:	00005517          	auipc	a0,0x5
     e32:	7c250513          	add	a0,a0,1986 # 65f0 <malloc+0x61a>
     e36:	00005097          	auipc	ra,0x5
     e3a:	da8080e7          	jalr	-600(ra) # 5bde <unlink>
}
     e3e:	70a2                	ld	ra,40(sp)
     e40:	7402                	ld	s0,32(sp)
     e42:	64e2                	ld	s1,24(sp)
     e44:	6942                	ld	s2,16(sp)
     e46:	69a2                	ld	s3,8(sp)
     e48:	6145                	add	sp,sp,48
     e4a:	8082                	ret
    printf("%s: create unlinkread failed\n", s);
     e4c:	85ce                	mv	a1,s3
     e4e:	00005517          	auipc	a0,0x5
     e52:	7b250513          	add	a0,a0,1970 # 6600 <malloc+0x62a>
     e56:	00005097          	auipc	ra,0x5
     e5a:	0c8080e7          	jalr	200(ra) # 5f1e <printf>
    exit(1);
     e5e:	4505                	li	a0,1
     e60:	00005097          	auipc	ra,0x5
     e64:	d2e080e7          	jalr	-722(ra) # 5b8e <exit>
    printf("%s: open unlinkread failed\n", s);
     e68:	85ce                	mv	a1,s3
     e6a:	00005517          	auipc	a0,0x5
     e6e:	7be50513          	add	a0,a0,1982 # 6628 <malloc+0x652>
     e72:	00005097          	auipc	ra,0x5
     e76:	0ac080e7          	jalr	172(ra) # 5f1e <printf>
    exit(1);
     e7a:	4505                	li	a0,1
     e7c:	00005097          	auipc	ra,0x5
     e80:	d12080e7          	jalr	-750(ra) # 5b8e <exit>
    printf("%s: unlink unlinkread failed\n", s);
     e84:	85ce                	mv	a1,s3
     e86:	00005517          	auipc	a0,0x5
     e8a:	7c250513          	add	a0,a0,1986 # 6648 <malloc+0x672>
     e8e:	00005097          	auipc	ra,0x5
     e92:	090080e7          	jalr	144(ra) # 5f1e <printf>
    exit(1);
     e96:	4505                	li	a0,1
     e98:	00005097          	auipc	ra,0x5
     e9c:	cf6080e7          	jalr	-778(ra) # 5b8e <exit>
    printf("%s: unlinkread read failed", s);
     ea0:	85ce                	mv	a1,s3
     ea2:	00005517          	auipc	a0,0x5
     ea6:	7ce50513          	add	a0,a0,1998 # 6670 <malloc+0x69a>
     eaa:	00005097          	auipc	ra,0x5
     eae:	074080e7          	jalr	116(ra) # 5f1e <printf>
    exit(1);
     eb2:	4505                	li	a0,1
     eb4:	00005097          	auipc	ra,0x5
     eb8:	cda080e7          	jalr	-806(ra) # 5b8e <exit>
    printf("%s: unlinkread wrong data\n", s);
     ebc:	85ce                	mv	a1,s3
     ebe:	00005517          	auipc	a0,0x5
     ec2:	7d250513          	add	a0,a0,2002 # 6690 <malloc+0x6ba>
     ec6:	00005097          	auipc	ra,0x5
     eca:	058080e7          	jalr	88(ra) # 5f1e <printf>
    exit(1);
     ece:	4505                	li	a0,1
     ed0:	00005097          	auipc	ra,0x5
     ed4:	cbe080e7          	jalr	-834(ra) # 5b8e <exit>
    printf("%s: unlinkread write failed\n", s);
     ed8:	85ce                	mv	a1,s3
     eda:	00005517          	auipc	a0,0x5
     ede:	7d650513          	add	a0,a0,2006 # 66b0 <malloc+0x6da>
     ee2:	00005097          	auipc	ra,0x5
     ee6:	03c080e7          	jalr	60(ra) # 5f1e <printf>
    exit(1);
     eea:	4505                	li	a0,1
     eec:	00005097          	auipc	ra,0x5
     ef0:	ca2080e7          	jalr	-862(ra) # 5b8e <exit>

0000000000000ef4 <linktest>:
{
     ef4:	1101                	add	sp,sp,-32
     ef6:	ec06                	sd	ra,24(sp)
     ef8:	e822                	sd	s0,16(sp)
     efa:	e426                	sd	s1,8(sp)
     efc:	e04a                	sd	s2,0(sp)
     efe:	1000                	add	s0,sp,32
     f00:	892a                	mv	s2,a0
  unlink("lf1");
     f02:	00005517          	auipc	a0,0x5
     f06:	7ce50513          	add	a0,a0,1998 # 66d0 <malloc+0x6fa>
     f0a:	00005097          	auipc	ra,0x5
     f0e:	cd4080e7          	jalr	-812(ra) # 5bde <unlink>
  unlink("lf2");
     f12:	00005517          	auipc	a0,0x5
     f16:	7c650513          	add	a0,a0,1990 # 66d8 <malloc+0x702>
     f1a:	00005097          	auipc	ra,0x5
     f1e:	cc4080e7          	jalr	-828(ra) # 5bde <unlink>
  fd = open("lf1", O_CREATE|O_RDWR);
     f22:	20200593          	li	a1,514
     f26:	00005517          	auipc	a0,0x5
     f2a:	7aa50513          	add	a0,a0,1962 # 66d0 <malloc+0x6fa>
     f2e:	00005097          	auipc	ra,0x5
     f32:	ca0080e7          	jalr	-864(ra) # 5bce <open>
  if(fd < 0){
     f36:	10054763          	bltz	a0,1044 <linktest+0x150>
     f3a:	84aa                	mv	s1,a0
  if(write(fd, "hello", SZ) != SZ){
     f3c:	4615                	li	a2,5
     f3e:	00005597          	auipc	a1,0x5
     f42:	6e258593          	add	a1,a1,1762 # 6620 <malloc+0x64a>
     f46:	00005097          	auipc	ra,0x5
     f4a:	c68080e7          	jalr	-920(ra) # 5bae <write>
     f4e:	4795                	li	a5,5
     f50:	10f51863          	bne	a0,a5,1060 <linktest+0x16c>
  close(fd);
     f54:	8526                	mv	a0,s1
     f56:	00005097          	auipc	ra,0x5
     f5a:	c60080e7          	jalr	-928(ra) # 5bb6 <close>
  if(link("lf1", "lf2") < 0){
     f5e:	00005597          	auipc	a1,0x5
     f62:	77a58593          	add	a1,a1,1914 # 66d8 <malloc+0x702>
     f66:	00005517          	auipc	a0,0x5
     f6a:	76a50513          	add	a0,a0,1898 # 66d0 <malloc+0x6fa>
     f6e:	00005097          	auipc	ra,0x5
     f72:	c80080e7          	jalr	-896(ra) # 5bee <link>
     f76:	10054363          	bltz	a0,107c <linktest+0x188>
  unlink("lf1");
     f7a:	00005517          	auipc	a0,0x5
     f7e:	75650513          	add	a0,a0,1878 # 66d0 <malloc+0x6fa>
     f82:	00005097          	auipc	ra,0x5
     f86:	c5c080e7          	jalr	-932(ra) # 5bde <unlink>
  if(open("lf1", 0) >= 0){
     f8a:	4581                	li	a1,0
     f8c:	00005517          	auipc	a0,0x5
     f90:	74450513          	add	a0,a0,1860 # 66d0 <malloc+0x6fa>
     f94:	00005097          	auipc	ra,0x5
     f98:	c3a080e7          	jalr	-966(ra) # 5bce <open>
     f9c:	0e055e63          	bgez	a0,1098 <linktest+0x1a4>
  fd = open("lf2", 0);
     fa0:	4581                	li	a1,0
     fa2:	00005517          	auipc	a0,0x5
     fa6:	73650513          	add	a0,a0,1846 # 66d8 <malloc+0x702>
     faa:	00005097          	auipc	ra,0x5
     fae:	c24080e7          	jalr	-988(ra) # 5bce <open>
     fb2:	84aa                	mv	s1,a0
  if(fd < 0){
     fb4:	10054063          	bltz	a0,10b4 <linktest+0x1c0>
  if(read(fd, buf, sizeof(buf)) != SZ){
     fb8:	660d                	lui	a2,0x3
     fba:	0000c597          	auipc	a1,0xc
     fbe:	cae58593          	add	a1,a1,-850 # cc68 <buf>
     fc2:	00005097          	auipc	ra,0x5
     fc6:	be4080e7          	jalr	-1052(ra) # 5ba6 <read>
     fca:	4795                	li	a5,5
     fcc:	10f51263          	bne	a0,a5,10d0 <linktest+0x1dc>
  close(fd);
     fd0:	8526                	mv	a0,s1
     fd2:	00005097          	auipc	ra,0x5
     fd6:	be4080e7          	jalr	-1052(ra) # 5bb6 <close>
  if(link("lf2", "lf2") >= 0){
     fda:	00005597          	auipc	a1,0x5
     fde:	6fe58593          	add	a1,a1,1790 # 66d8 <malloc+0x702>
     fe2:	852e                	mv	a0,a1
     fe4:	00005097          	auipc	ra,0x5
     fe8:	c0a080e7          	jalr	-1014(ra) # 5bee <link>
     fec:	10055063          	bgez	a0,10ec <linktest+0x1f8>
  unlink("lf2");
     ff0:	00005517          	auipc	a0,0x5
     ff4:	6e850513          	add	a0,a0,1768 # 66d8 <malloc+0x702>
     ff8:	00005097          	auipc	ra,0x5
     ffc:	be6080e7          	jalr	-1050(ra) # 5bde <unlink>
  if(link("lf2", "lf1") >= 0){
    1000:	00005597          	auipc	a1,0x5
    1004:	6d058593          	add	a1,a1,1744 # 66d0 <malloc+0x6fa>
    1008:	00005517          	auipc	a0,0x5
    100c:	6d050513          	add	a0,a0,1744 # 66d8 <malloc+0x702>
    1010:	00005097          	auipc	ra,0x5
    1014:	bde080e7          	jalr	-1058(ra) # 5bee <link>
    1018:	0e055863          	bgez	a0,1108 <linktest+0x214>
  if(link(".", "lf1") >= 0){
    101c:	00005597          	auipc	a1,0x5
    1020:	6b458593          	add	a1,a1,1716 # 66d0 <malloc+0x6fa>
    1024:	00005517          	auipc	a0,0x5
    1028:	7bc50513          	add	a0,a0,1980 # 67e0 <malloc+0x80a>
    102c:	00005097          	auipc	ra,0x5
    1030:	bc2080e7          	jalr	-1086(ra) # 5bee <link>
    1034:	0e055863          	bgez	a0,1124 <linktest+0x230>
}
    1038:	60e2                	ld	ra,24(sp)
    103a:	6442                	ld	s0,16(sp)
    103c:	64a2                	ld	s1,8(sp)
    103e:	6902                	ld	s2,0(sp)
    1040:	6105                	add	sp,sp,32
    1042:	8082                	ret
    printf("%s: create lf1 failed\n", s);
    1044:	85ca                	mv	a1,s2
    1046:	00005517          	auipc	a0,0x5
    104a:	69a50513          	add	a0,a0,1690 # 66e0 <malloc+0x70a>
    104e:	00005097          	auipc	ra,0x5
    1052:	ed0080e7          	jalr	-304(ra) # 5f1e <printf>
    exit(1);
    1056:	4505                	li	a0,1
    1058:	00005097          	auipc	ra,0x5
    105c:	b36080e7          	jalr	-1226(ra) # 5b8e <exit>
    printf("%s: write lf1 failed\n", s);
    1060:	85ca                	mv	a1,s2
    1062:	00005517          	auipc	a0,0x5
    1066:	69650513          	add	a0,a0,1686 # 66f8 <malloc+0x722>
    106a:	00005097          	auipc	ra,0x5
    106e:	eb4080e7          	jalr	-332(ra) # 5f1e <printf>
    exit(1);
    1072:	4505                	li	a0,1
    1074:	00005097          	auipc	ra,0x5
    1078:	b1a080e7          	jalr	-1254(ra) # 5b8e <exit>
    printf("%s: link lf1 lf2 failed\n", s);
    107c:	85ca                	mv	a1,s2
    107e:	00005517          	auipc	a0,0x5
    1082:	69250513          	add	a0,a0,1682 # 6710 <malloc+0x73a>
    1086:	00005097          	auipc	ra,0x5
    108a:	e98080e7          	jalr	-360(ra) # 5f1e <printf>
    exit(1);
    108e:	4505                	li	a0,1
    1090:	00005097          	auipc	ra,0x5
    1094:	afe080e7          	jalr	-1282(ra) # 5b8e <exit>
    printf("%s: unlinked lf1 but it is still there!\n", s);
    1098:	85ca                	mv	a1,s2
    109a:	00005517          	auipc	a0,0x5
    109e:	69650513          	add	a0,a0,1686 # 6730 <malloc+0x75a>
    10a2:	00005097          	auipc	ra,0x5
    10a6:	e7c080e7          	jalr	-388(ra) # 5f1e <printf>
    exit(1);
    10aa:	4505                	li	a0,1
    10ac:	00005097          	auipc	ra,0x5
    10b0:	ae2080e7          	jalr	-1310(ra) # 5b8e <exit>
    printf("%s: open lf2 failed\n", s);
    10b4:	85ca                	mv	a1,s2
    10b6:	00005517          	auipc	a0,0x5
    10ba:	6aa50513          	add	a0,a0,1706 # 6760 <malloc+0x78a>
    10be:	00005097          	auipc	ra,0x5
    10c2:	e60080e7          	jalr	-416(ra) # 5f1e <printf>
    exit(1);
    10c6:	4505                	li	a0,1
    10c8:	00005097          	auipc	ra,0x5
    10cc:	ac6080e7          	jalr	-1338(ra) # 5b8e <exit>
    printf("%s: read lf2 failed\n", s);
    10d0:	85ca                	mv	a1,s2
    10d2:	00005517          	auipc	a0,0x5
    10d6:	6a650513          	add	a0,a0,1702 # 6778 <malloc+0x7a2>
    10da:	00005097          	auipc	ra,0x5
    10de:	e44080e7          	jalr	-444(ra) # 5f1e <printf>
    exit(1);
    10e2:	4505                	li	a0,1
    10e4:	00005097          	auipc	ra,0x5
    10e8:	aaa080e7          	jalr	-1366(ra) # 5b8e <exit>
    printf("%s: link lf2 lf2 succeeded! oops\n", s);
    10ec:	85ca                	mv	a1,s2
    10ee:	00005517          	auipc	a0,0x5
    10f2:	6a250513          	add	a0,a0,1698 # 6790 <malloc+0x7ba>
    10f6:	00005097          	auipc	ra,0x5
    10fa:	e28080e7          	jalr	-472(ra) # 5f1e <printf>
    exit(1);
    10fe:	4505                	li	a0,1
    1100:	00005097          	auipc	ra,0x5
    1104:	a8e080e7          	jalr	-1394(ra) # 5b8e <exit>
    printf("%s: link non-existent succeeded! oops\n", s);
    1108:	85ca                	mv	a1,s2
    110a:	00005517          	auipc	a0,0x5
    110e:	6ae50513          	add	a0,a0,1710 # 67b8 <malloc+0x7e2>
    1112:	00005097          	auipc	ra,0x5
    1116:	e0c080e7          	jalr	-500(ra) # 5f1e <printf>
    exit(1);
    111a:	4505                	li	a0,1
    111c:	00005097          	auipc	ra,0x5
    1120:	a72080e7          	jalr	-1422(ra) # 5b8e <exit>
    printf("%s: link . lf1 succeeded! oops\n", s);
    1124:	85ca                	mv	a1,s2
    1126:	00005517          	auipc	a0,0x5
    112a:	6c250513          	add	a0,a0,1730 # 67e8 <malloc+0x812>
    112e:	00005097          	auipc	ra,0x5
    1132:	df0080e7          	jalr	-528(ra) # 5f1e <printf>
    exit(1);
    1136:	4505                	li	a0,1
    1138:	00005097          	auipc	ra,0x5
    113c:	a56080e7          	jalr	-1450(ra) # 5b8e <exit>

0000000000001140 <validatetest>:
{
    1140:	7139                	add	sp,sp,-64
    1142:	fc06                	sd	ra,56(sp)
    1144:	f822                	sd	s0,48(sp)
    1146:	f426                	sd	s1,40(sp)
    1148:	f04a                	sd	s2,32(sp)
    114a:	ec4e                	sd	s3,24(sp)
    114c:	e852                	sd	s4,16(sp)
    114e:	e456                	sd	s5,8(sp)
    1150:	e05a                	sd	s6,0(sp)
    1152:	0080                	add	s0,sp,64
    1154:	8b2a                	mv	s6,a0
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    1156:	4481                	li	s1,0
    if(link("nosuchfile", (char*)p) != -1){
    1158:	00005997          	auipc	s3,0x5
    115c:	6b098993          	add	s3,s3,1712 # 6808 <malloc+0x832>
    1160:	597d                	li	s2,-1
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    1162:	6a85                	lui	s5,0x1
    1164:	00114a37          	lui	s4,0x114
    if(link("nosuchfile", (char*)p) != -1){
    1168:	85a6                	mv	a1,s1
    116a:	854e                	mv	a0,s3
    116c:	00005097          	auipc	ra,0x5
    1170:	a82080e7          	jalr	-1406(ra) # 5bee <link>
    1174:	01251f63          	bne	a0,s2,1192 <validatetest+0x52>
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    1178:	94d6                	add	s1,s1,s5
    117a:	ff4497e3          	bne	s1,s4,1168 <validatetest+0x28>
}
    117e:	70e2                	ld	ra,56(sp)
    1180:	7442                	ld	s0,48(sp)
    1182:	74a2                	ld	s1,40(sp)
    1184:	7902                	ld	s2,32(sp)
    1186:	69e2                	ld	s3,24(sp)
    1188:	6a42                	ld	s4,16(sp)
    118a:	6aa2                	ld	s5,8(sp)
    118c:	6b02                	ld	s6,0(sp)
    118e:	6121                	add	sp,sp,64
    1190:	8082                	ret
      printf("%s: link should not succeed\n", s);
    1192:	85da                	mv	a1,s6
    1194:	00005517          	auipc	a0,0x5
    1198:	68450513          	add	a0,a0,1668 # 6818 <malloc+0x842>
    119c:	00005097          	auipc	ra,0x5
    11a0:	d82080e7          	jalr	-638(ra) # 5f1e <printf>
      exit(1);
    11a4:	4505                	li	a0,1
    11a6:	00005097          	auipc	ra,0x5
    11aa:	9e8080e7          	jalr	-1560(ra) # 5b8e <exit>

00000000000011ae <bigdir>:
{
    11ae:	715d                	add	sp,sp,-80
    11b0:	e486                	sd	ra,72(sp)
    11b2:	e0a2                	sd	s0,64(sp)
    11b4:	fc26                	sd	s1,56(sp)
    11b6:	f84a                	sd	s2,48(sp)
    11b8:	f44e                	sd	s3,40(sp)
    11ba:	f052                	sd	s4,32(sp)
    11bc:	ec56                	sd	s5,24(sp)
    11be:	e85a                	sd	s6,16(sp)
    11c0:	0880                	add	s0,sp,80
    11c2:	89aa                	mv	s3,a0
  unlink("bd");
    11c4:	00005517          	auipc	a0,0x5
    11c8:	67450513          	add	a0,a0,1652 # 6838 <malloc+0x862>
    11cc:	00005097          	auipc	ra,0x5
    11d0:	a12080e7          	jalr	-1518(ra) # 5bde <unlink>
  fd = open("bd", O_CREATE);
    11d4:	20000593          	li	a1,512
    11d8:	00005517          	auipc	a0,0x5
    11dc:	66050513          	add	a0,a0,1632 # 6838 <malloc+0x862>
    11e0:	00005097          	auipc	ra,0x5
    11e4:	9ee080e7          	jalr	-1554(ra) # 5bce <open>
  if(fd < 0){
    11e8:	0c054963          	bltz	a0,12ba <bigdir+0x10c>
  close(fd);
    11ec:	00005097          	auipc	ra,0x5
    11f0:	9ca080e7          	jalr	-1590(ra) # 5bb6 <close>
  for(i = 0; i < N; i++){
    11f4:	4901                	li	s2,0
    name[0] = 'x';
    11f6:	07800a93          	li	s5,120
    if(link("bd", name) != 0){
    11fa:	00005a17          	auipc	s4,0x5
    11fe:	63ea0a13          	add	s4,s4,1598 # 6838 <malloc+0x862>
  for(i = 0; i < N; i++){
    1202:	1f400b13          	li	s6,500
    name[0] = 'x';
    1206:	fb540823          	sb	s5,-80(s0)
    name[1] = '0' + (i / 64);
    120a:	41f9571b          	sraw	a4,s2,0x1f
    120e:	01a7571b          	srlw	a4,a4,0x1a
    1212:	012707bb          	addw	a5,a4,s2
    1216:	4067d69b          	sraw	a3,a5,0x6
    121a:	0306869b          	addw	a3,a3,48
    121e:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
    1222:	03f7f793          	and	a5,a5,63
    1226:	9f99                	subw	a5,a5,a4
    1228:	0307879b          	addw	a5,a5,48
    122c:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
    1230:	fa0409a3          	sb	zero,-77(s0)
    if(link("bd", name) != 0){
    1234:	fb040593          	add	a1,s0,-80
    1238:	8552                	mv	a0,s4
    123a:	00005097          	auipc	ra,0x5
    123e:	9b4080e7          	jalr	-1612(ra) # 5bee <link>
    1242:	84aa                	mv	s1,a0
    1244:	e949                	bnez	a0,12d6 <bigdir+0x128>
  for(i = 0; i < N; i++){
    1246:	2905                	addw	s2,s2,1
    1248:	fb691fe3          	bne	s2,s6,1206 <bigdir+0x58>
  unlink("bd");
    124c:	00005517          	auipc	a0,0x5
    1250:	5ec50513          	add	a0,a0,1516 # 6838 <malloc+0x862>
    1254:	00005097          	auipc	ra,0x5
    1258:	98a080e7          	jalr	-1654(ra) # 5bde <unlink>
    name[0] = 'x';
    125c:	07800913          	li	s2,120
  for(i = 0; i < N; i++){
    1260:	1f400a13          	li	s4,500
    name[0] = 'x';
    1264:	fb240823          	sb	s2,-80(s0)
    name[1] = '0' + (i / 64);
    1268:	41f4d71b          	sraw	a4,s1,0x1f
    126c:	01a7571b          	srlw	a4,a4,0x1a
    1270:	009707bb          	addw	a5,a4,s1
    1274:	4067d69b          	sraw	a3,a5,0x6
    1278:	0306869b          	addw	a3,a3,48
    127c:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
    1280:	03f7f793          	and	a5,a5,63
    1284:	9f99                	subw	a5,a5,a4
    1286:	0307879b          	addw	a5,a5,48
    128a:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
    128e:	fa0409a3          	sb	zero,-77(s0)
    if(unlink(name) != 0){
    1292:	fb040513          	add	a0,s0,-80
    1296:	00005097          	auipc	ra,0x5
    129a:	948080e7          	jalr	-1720(ra) # 5bde <unlink>
    129e:	ed21                	bnez	a0,12f6 <bigdir+0x148>
  for(i = 0; i < N; i++){
    12a0:	2485                	addw	s1,s1,1
    12a2:	fd4491e3          	bne	s1,s4,1264 <bigdir+0xb6>
}
    12a6:	60a6                	ld	ra,72(sp)
    12a8:	6406                	ld	s0,64(sp)
    12aa:	74e2                	ld	s1,56(sp)
    12ac:	7942                	ld	s2,48(sp)
    12ae:	79a2                	ld	s3,40(sp)
    12b0:	7a02                	ld	s4,32(sp)
    12b2:	6ae2                	ld	s5,24(sp)
    12b4:	6b42                	ld	s6,16(sp)
    12b6:	6161                	add	sp,sp,80
    12b8:	8082                	ret
    printf("%s: bigdir create failed\n", s);
    12ba:	85ce                	mv	a1,s3
    12bc:	00005517          	auipc	a0,0x5
    12c0:	58450513          	add	a0,a0,1412 # 6840 <malloc+0x86a>
    12c4:	00005097          	auipc	ra,0x5
    12c8:	c5a080e7          	jalr	-934(ra) # 5f1e <printf>
    exit(1);
    12cc:	4505                	li	a0,1
    12ce:	00005097          	auipc	ra,0x5
    12d2:	8c0080e7          	jalr	-1856(ra) # 5b8e <exit>
      printf("%s: bigdir link(bd, %s) failed\n", s, name);
    12d6:	fb040613          	add	a2,s0,-80
    12da:	85ce                	mv	a1,s3
    12dc:	00005517          	auipc	a0,0x5
    12e0:	58450513          	add	a0,a0,1412 # 6860 <malloc+0x88a>
    12e4:	00005097          	auipc	ra,0x5
    12e8:	c3a080e7          	jalr	-966(ra) # 5f1e <printf>
      exit(1);
    12ec:	4505                	li	a0,1
    12ee:	00005097          	auipc	ra,0x5
    12f2:	8a0080e7          	jalr	-1888(ra) # 5b8e <exit>
      printf("%s: bigdir unlink failed", s);
    12f6:	85ce                	mv	a1,s3
    12f8:	00005517          	auipc	a0,0x5
    12fc:	58850513          	add	a0,a0,1416 # 6880 <malloc+0x8aa>
    1300:	00005097          	auipc	ra,0x5
    1304:	c1e080e7          	jalr	-994(ra) # 5f1e <printf>
      exit(1);
    1308:	4505                	li	a0,1
    130a:	00005097          	auipc	ra,0x5
    130e:	884080e7          	jalr	-1916(ra) # 5b8e <exit>

0000000000001312 <pgbug>:
{
    1312:	7179                	add	sp,sp,-48
    1314:	f406                	sd	ra,40(sp)
    1316:	f022                	sd	s0,32(sp)
    1318:	ec26                	sd	s1,24(sp)
    131a:	1800                	add	s0,sp,48
  argv[0] = 0;
    131c:	fc043c23          	sd	zero,-40(s0)
  exec(big, argv);
    1320:	00008497          	auipc	s1,0x8
    1324:	ce048493          	add	s1,s1,-800 # 9000 <big>
    1328:	fd840593          	add	a1,s0,-40
    132c:	6088                	ld	a0,0(s1)
    132e:	00005097          	auipc	ra,0x5
    1332:	898080e7          	jalr	-1896(ra) # 5bc6 <exec>
  pipe(big);
    1336:	6088                	ld	a0,0(s1)
    1338:	00005097          	auipc	ra,0x5
    133c:	866080e7          	jalr	-1946(ra) # 5b9e <pipe>
  exit(0);
    1340:	4501                	li	a0,0
    1342:	00005097          	auipc	ra,0x5
    1346:	84c080e7          	jalr	-1972(ra) # 5b8e <exit>

000000000000134a <badarg>:
{
    134a:	7139                	add	sp,sp,-64
    134c:	fc06                	sd	ra,56(sp)
    134e:	f822                	sd	s0,48(sp)
    1350:	f426                	sd	s1,40(sp)
    1352:	f04a                	sd	s2,32(sp)
    1354:	ec4e                	sd	s3,24(sp)
    1356:	0080                	add	s0,sp,64
    1358:	64b1                	lui	s1,0xc
    135a:	35048493          	add	s1,s1,848 # c350 <uninit+0x1df8>
    argv[0] = (char*)0xffffffff;
    135e:	597d                	li	s2,-1
    1360:	02095913          	srl	s2,s2,0x20
    exec("echo", argv);
    1364:	00005997          	auipc	s3,0x5
    1368:	d9498993          	add	s3,s3,-620 # 60f8 <malloc+0x122>
    argv[0] = (char*)0xffffffff;
    136c:	fd243023          	sd	s2,-64(s0)
    argv[1] = 0;
    1370:	fc043423          	sd	zero,-56(s0)
    exec("echo", argv);
    1374:	fc040593          	add	a1,s0,-64
    1378:	854e                	mv	a0,s3
    137a:	00005097          	auipc	ra,0x5
    137e:	84c080e7          	jalr	-1972(ra) # 5bc6 <exec>
  for(int i = 0; i < 50000; i++){
    1382:	34fd                	addw	s1,s1,-1
    1384:	f4e5                	bnez	s1,136c <badarg+0x22>
  exit(0);
    1386:	4501                	li	a0,0
    1388:	00005097          	auipc	ra,0x5
    138c:	806080e7          	jalr	-2042(ra) # 5b8e <exit>

0000000000001390 <copyinstr2>:
{
    1390:	7155                	add	sp,sp,-208
    1392:	e586                	sd	ra,200(sp)
    1394:	e1a2                	sd	s0,192(sp)
    1396:	0980                	add	s0,sp,208
  for(int i = 0; i < MAXPATH; i++)
    1398:	f6840793          	add	a5,s0,-152
    139c:	fe840693          	add	a3,s0,-24
    b[i] = 'x';
    13a0:	07800713          	li	a4,120
    13a4:	00e78023          	sb	a4,0(a5)
  for(int i = 0; i < MAXPATH; i++)
    13a8:	0785                	add	a5,a5,1
    13aa:	fed79de3          	bne	a5,a3,13a4 <copyinstr2+0x14>
  b[MAXPATH] = '\0';
    13ae:	fe040423          	sb	zero,-24(s0)
  int ret = unlink(b);
    13b2:	f6840513          	add	a0,s0,-152
    13b6:	00005097          	auipc	ra,0x5
    13ba:	828080e7          	jalr	-2008(ra) # 5bde <unlink>
  if(ret != -1){
    13be:	57fd                	li	a5,-1
    13c0:	0ef51063          	bne	a0,a5,14a0 <copyinstr2+0x110>
  int fd = open(b, O_CREATE | O_WRONLY);
    13c4:	20100593          	li	a1,513
    13c8:	f6840513          	add	a0,s0,-152
    13cc:	00005097          	auipc	ra,0x5
    13d0:	802080e7          	jalr	-2046(ra) # 5bce <open>
  if(fd != -1){
    13d4:	57fd                	li	a5,-1
    13d6:	0ef51563          	bne	a0,a5,14c0 <copyinstr2+0x130>
  ret = link(b, b);
    13da:	f6840593          	add	a1,s0,-152
    13de:	852e                	mv	a0,a1
    13e0:	00005097          	auipc	ra,0x5
    13e4:	80e080e7          	jalr	-2034(ra) # 5bee <link>
  if(ret != -1){
    13e8:	57fd                	li	a5,-1
    13ea:	0ef51b63          	bne	a0,a5,14e0 <copyinstr2+0x150>
  char *args[] = { "xx", 0 };
    13ee:	00006797          	auipc	a5,0x6
    13f2:	63a78793          	add	a5,a5,1594 # 7a28 <malloc+0x1a52>
    13f6:	f4f43c23          	sd	a5,-168(s0)
    13fa:	f6043023          	sd	zero,-160(s0)
  ret = exec(b, args);
    13fe:	f5840593          	add	a1,s0,-168
    1402:	f6840513          	add	a0,s0,-152
    1406:	00004097          	auipc	ra,0x4
    140a:	7c0080e7          	jalr	1984(ra) # 5bc6 <exec>
  if(ret != -1){
    140e:	57fd                	li	a5,-1
    1410:	0ef51963          	bne	a0,a5,1502 <copyinstr2+0x172>
  int pid = fork();
    1414:	00004097          	auipc	ra,0x4
    1418:	772080e7          	jalr	1906(ra) # 5b86 <fork>
  if(pid < 0){
    141c:	10054363          	bltz	a0,1522 <copyinstr2+0x192>
  if(pid == 0){
    1420:	12051463          	bnez	a0,1548 <copyinstr2+0x1b8>
    1424:	00008797          	auipc	a5,0x8
    1428:	12c78793          	add	a5,a5,300 # 9550 <big.0>
    142c:	00009697          	auipc	a3,0x9
    1430:	12468693          	add	a3,a3,292 # a550 <big.0+0x1000>
      big[i] = 'x';
    1434:	07800713          	li	a4,120
    1438:	00e78023          	sb	a4,0(a5)
    for(int i = 0; i < PGSIZE; i++)
    143c:	0785                	add	a5,a5,1
    143e:	fed79de3          	bne	a5,a3,1438 <copyinstr2+0xa8>
    big[PGSIZE] = '\0';
    1442:	00009797          	auipc	a5,0x9
    1446:	10078723          	sb	zero,270(a5) # a550 <big.0+0x1000>
    char *args2[] = { big, big, big, 0 };
    144a:	00007797          	auipc	a5,0x7
    144e:	0d678793          	add	a5,a5,214 # 8520 <malloc+0x254a>
    1452:	6390                	ld	a2,0(a5)
    1454:	6794                	ld	a3,8(a5)
    1456:	6b98                	ld	a4,16(a5)
    1458:	6f9c                	ld	a5,24(a5)
    145a:	f2c43823          	sd	a2,-208(s0)
    145e:	f2d43c23          	sd	a3,-200(s0)
    1462:	f4e43023          	sd	a4,-192(s0)
    1466:	f4f43423          	sd	a5,-184(s0)
    ret = exec("echo", args2);
    146a:	f3040593          	add	a1,s0,-208
    146e:	00005517          	auipc	a0,0x5
    1472:	c8a50513          	add	a0,a0,-886 # 60f8 <malloc+0x122>
    1476:	00004097          	auipc	ra,0x4
    147a:	750080e7          	jalr	1872(ra) # 5bc6 <exec>
    if(ret != -1){
    147e:	57fd                	li	a5,-1
    1480:	0af50e63          	beq	a0,a5,153c <copyinstr2+0x1ac>
      printf("exec(echo, BIG) returned %d, not -1\n", fd);
    1484:	55fd                	li	a1,-1
    1486:	00005517          	auipc	a0,0x5
    148a:	4a250513          	add	a0,a0,1186 # 6928 <malloc+0x952>
    148e:	00005097          	auipc	ra,0x5
    1492:	a90080e7          	jalr	-1392(ra) # 5f1e <printf>
      exit(1);
    1496:	4505                	li	a0,1
    1498:	00004097          	auipc	ra,0x4
    149c:	6f6080e7          	jalr	1782(ra) # 5b8e <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    14a0:	862a                	mv	a2,a0
    14a2:	f6840593          	add	a1,s0,-152
    14a6:	00005517          	auipc	a0,0x5
    14aa:	3fa50513          	add	a0,a0,1018 # 68a0 <malloc+0x8ca>
    14ae:	00005097          	auipc	ra,0x5
    14b2:	a70080e7          	jalr	-1424(ra) # 5f1e <printf>
    exit(1);
    14b6:	4505                	li	a0,1
    14b8:	00004097          	auipc	ra,0x4
    14bc:	6d6080e7          	jalr	1750(ra) # 5b8e <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    14c0:	862a                	mv	a2,a0
    14c2:	f6840593          	add	a1,s0,-152
    14c6:	00005517          	auipc	a0,0x5
    14ca:	3fa50513          	add	a0,a0,1018 # 68c0 <malloc+0x8ea>
    14ce:	00005097          	auipc	ra,0x5
    14d2:	a50080e7          	jalr	-1456(ra) # 5f1e <printf>
    exit(1);
    14d6:	4505                	li	a0,1
    14d8:	00004097          	auipc	ra,0x4
    14dc:	6b6080e7          	jalr	1718(ra) # 5b8e <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    14e0:	86aa                	mv	a3,a0
    14e2:	f6840613          	add	a2,s0,-152
    14e6:	85b2                	mv	a1,a2
    14e8:	00005517          	auipc	a0,0x5
    14ec:	3f850513          	add	a0,a0,1016 # 68e0 <malloc+0x90a>
    14f0:	00005097          	auipc	ra,0x5
    14f4:	a2e080e7          	jalr	-1490(ra) # 5f1e <printf>
    exit(1);
    14f8:	4505                	li	a0,1
    14fa:	00004097          	auipc	ra,0x4
    14fe:	694080e7          	jalr	1684(ra) # 5b8e <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    1502:	567d                	li	a2,-1
    1504:	f6840593          	add	a1,s0,-152
    1508:	00005517          	auipc	a0,0x5
    150c:	40050513          	add	a0,a0,1024 # 6908 <malloc+0x932>
    1510:	00005097          	auipc	ra,0x5
    1514:	a0e080e7          	jalr	-1522(ra) # 5f1e <printf>
    exit(1);
    1518:	4505                	li	a0,1
    151a:	00004097          	auipc	ra,0x4
    151e:	674080e7          	jalr	1652(ra) # 5b8e <exit>
    printf("fork failed\n");
    1522:	00006517          	auipc	a0,0x6
    1526:	86650513          	add	a0,a0,-1946 # 6d88 <malloc+0xdb2>
    152a:	00005097          	auipc	ra,0x5
    152e:	9f4080e7          	jalr	-1548(ra) # 5f1e <printf>
    exit(1);
    1532:	4505                	li	a0,1
    1534:	00004097          	auipc	ra,0x4
    1538:	65a080e7          	jalr	1626(ra) # 5b8e <exit>
    exit(747); // OK
    153c:	2eb00513          	li	a0,747
    1540:	00004097          	auipc	ra,0x4
    1544:	64e080e7          	jalr	1614(ra) # 5b8e <exit>
  int st = 0;
    1548:	f4042a23          	sw	zero,-172(s0)
  wait(&st);
    154c:	f5440513          	add	a0,s0,-172
    1550:	00004097          	auipc	ra,0x4
    1554:	646080e7          	jalr	1606(ra) # 5b96 <wait>
  if(st != 747){
    1558:	f5442703          	lw	a4,-172(s0)
    155c:	2eb00793          	li	a5,747
    1560:	00f71663          	bne	a4,a5,156c <copyinstr2+0x1dc>
}
    1564:	60ae                	ld	ra,200(sp)
    1566:	640e                	ld	s0,192(sp)
    1568:	6169                	add	sp,sp,208
    156a:	8082                	ret
    printf("exec(echo, BIG) succeeded, should have failed\n");
    156c:	00005517          	auipc	a0,0x5
    1570:	3e450513          	add	a0,a0,996 # 6950 <malloc+0x97a>
    1574:	00005097          	auipc	ra,0x5
    1578:	9aa080e7          	jalr	-1622(ra) # 5f1e <printf>
    exit(1);
    157c:	4505                	li	a0,1
    157e:	00004097          	auipc	ra,0x4
    1582:	610080e7          	jalr	1552(ra) # 5b8e <exit>

0000000000001586 <truncate3>:
{
    1586:	7159                	add	sp,sp,-112
    1588:	f486                	sd	ra,104(sp)
    158a:	f0a2                	sd	s0,96(sp)
    158c:	eca6                	sd	s1,88(sp)
    158e:	e8ca                	sd	s2,80(sp)
    1590:	e4ce                	sd	s3,72(sp)
    1592:	e0d2                	sd	s4,64(sp)
    1594:	fc56                	sd	s5,56(sp)
    1596:	1880                	add	s0,sp,112
    1598:	892a                	mv	s2,a0
  close(open("truncfile", O_CREATE|O_TRUNC|O_WRONLY));
    159a:	60100593          	li	a1,1537
    159e:	00005517          	auipc	a0,0x5
    15a2:	bb250513          	add	a0,a0,-1102 # 6150 <malloc+0x17a>
    15a6:	00004097          	auipc	ra,0x4
    15aa:	628080e7          	jalr	1576(ra) # 5bce <open>
    15ae:	00004097          	auipc	ra,0x4
    15b2:	608080e7          	jalr	1544(ra) # 5bb6 <close>
  pid = fork();
    15b6:	00004097          	auipc	ra,0x4
    15ba:	5d0080e7          	jalr	1488(ra) # 5b86 <fork>
  if(pid < 0){
    15be:	08054063          	bltz	a0,163e <truncate3+0xb8>
  if(pid == 0){
    15c2:	e969                	bnez	a0,1694 <truncate3+0x10e>
    15c4:	06400993          	li	s3,100
      int fd = open("truncfile", O_WRONLY);
    15c8:	00005a17          	auipc	s4,0x5
    15cc:	b88a0a13          	add	s4,s4,-1144 # 6150 <malloc+0x17a>
      int n = write(fd, "1234567890", 10);
    15d0:	00005a97          	auipc	s5,0x5
    15d4:	3e0a8a93          	add	s5,s5,992 # 69b0 <malloc+0x9da>
      int fd = open("truncfile", O_WRONLY);
    15d8:	4585                	li	a1,1
    15da:	8552                	mv	a0,s4
    15dc:	00004097          	auipc	ra,0x4
    15e0:	5f2080e7          	jalr	1522(ra) # 5bce <open>
    15e4:	84aa                	mv	s1,a0
      if(fd < 0){
    15e6:	06054a63          	bltz	a0,165a <truncate3+0xd4>
      int n = write(fd, "1234567890", 10);
    15ea:	4629                	li	a2,10
    15ec:	85d6                	mv	a1,s5
    15ee:	00004097          	auipc	ra,0x4
    15f2:	5c0080e7          	jalr	1472(ra) # 5bae <write>
      if(n != 10){
    15f6:	47a9                	li	a5,10
    15f8:	06f51f63          	bne	a0,a5,1676 <truncate3+0xf0>
      close(fd);
    15fc:	8526                	mv	a0,s1
    15fe:	00004097          	auipc	ra,0x4
    1602:	5b8080e7          	jalr	1464(ra) # 5bb6 <close>
      fd = open("truncfile", O_RDONLY);
    1606:	4581                	li	a1,0
    1608:	8552                	mv	a0,s4
    160a:	00004097          	auipc	ra,0x4
    160e:	5c4080e7          	jalr	1476(ra) # 5bce <open>
    1612:	84aa                	mv	s1,a0
      read(fd, buf, sizeof(buf));
    1614:	02000613          	li	a2,32
    1618:	f9840593          	add	a1,s0,-104
    161c:	00004097          	auipc	ra,0x4
    1620:	58a080e7          	jalr	1418(ra) # 5ba6 <read>
      close(fd);
    1624:	8526                	mv	a0,s1
    1626:	00004097          	auipc	ra,0x4
    162a:	590080e7          	jalr	1424(ra) # 5bb6 <close>
    for(int i = 0; i < 100; i++){
    162e:	39fd                	addw	s3,s3,-1
    1630:	fa0994e3          	bnez	s3,15d8 <truncate3+0x52>
    exit(0);
    1634:	4501                	li	a0,0
    1636:	00004097          	auipc	ra,0x4
    163a:	558080e7          	jalr	1368(ra) # 5b8e <exit>
    printf("%s: fork failed\n", s);
    163e:	85ca                	mv	a1,s2
    1640:	00005517          	auipc	a0,0x5
    1644:	34050513          	add	a0,a0,832 # 6980 <malloc+0x9aa>
    1648:	00005097          	auipc	ra,0x5
    164c:	8d6080e7          	jalr	-1834(ra) # 5f1e <printf>
    exit(1);
    1650:	4505                	li	a0,1
    1652:	00004097          	auipc	ra,0x4
    1656:	53c080e7          	jalr	1340(ra) # 5b8e <exit>
        printf("%s: open failed\n", s);
    165a:	85ca                	mv	a1,s2
    165c:	00005517          	auipc	a0,0x5
    1660:	33c50513          	add	a0,a0,828 # 6998 <malloc+0x9c2>
    1664:	00005097          	auipc	ra,0x5
    1668:	8ba080e7          	jalr	-1862(ra) # 5f1e <printf>
        exit(1);
    166c:	4505                	li	a0,1
    166e:	00004097          	auipc	ra,0x4
    1672:	520080e7          	jalr	1312(ra) # 5b8e <exit>
        printf("%s: write got %d, expected 10\n", s, n);
    1676:	862a                	mv	a2,a0
    1678:	85ca                	mv	a1,s2
    167a:	00005517          	auipc	a0,0x5
    167e:	34650513          	add	a0,a0,838 # 69c0 <malloc+0x9ea>
    1682:	00005097          	auipc	ra,0x5
    1686:	89c080e7          	jalr	-1892(ra) # 5f1e <printf>
        exit(1);
    168a:	4505                	li	a0,1
    168c:	00004097          	auipc	ra,0x4
    1690:	502080e7          	jalr	1282(ra) # 5b8e <exit>
    1694:	09600993          	li	s3,150
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    1698:	00005a17          	auipc	s4,0x5
    169c:	ab8a0a13          	add	s4,s4,-1352 # 6150 <malloc+0x17a>
    int n = write(fd, "xxx", 3);
    16a0:	00005a97          	auipc	s5,0x5
    16a4:	340a8a93          	add	s5,s5,832 # 69e0 <malloc+0xa0a>
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    16a8:	60100593          	li	a1,1537
    16ac:	8552                	mv	a0,s4
    16ae:	00004097          	auipc	ra,0x4
    16b2:	520080e7          	jalr	1312(ra) # 5bce <open>
    16b6:	84aa                	mv	s1,a0
    if(fd < 0){
    16b8:	04054763          	bltz	a0,1706 <truncate3+0x180>
    int n = write(fd, "xxx", 3);
    16bc:	460d                	li	a2,3
    16be:	85d6                	mv	a1,s5
    16c0:	00004097          	auipc	ra,0x4
    16c4:	4ee080e7          	jalr	1262(ra) # 5bae <write>
    if(n != 3){
    16c8:	478d                	li	a5,3
    16ca:	04f51c63          	bne	a0,a5,1722 <truncate3+0x19c>
    close(fd);
    16ce:	8526                	mv	a0,s1
    16d0:	00004097          	auipc	ra,0x4
    16d4:	4e6080e7          	jalr	1254(ra) # 5bb6 <close>
  for(int i = 0; i < 150; i++){
    16d8:	39fd                	addw	s3,s3,-1
    16da:	fc0997e3          	bnez	s3,16a8 <truncate3+0x122>
  wait(&xstatus);
    16de:	fbc40513          	add	a0,s0,-68
    16e2:	00004097          	auipc	ra,0x4
    16e6:	4b4080e7          	jalr	1204(ra) # 5b96 <wait>
  unlink("truncfile");
    16ea:	00005517          	auipc	a0,0x5
    16ee:	a6650513          	add	a0,a0,-1434 # 6150 <malloc+0x17a>
    16f2:	00004097          	auipc	ra,0x4
    16f6:	4ec080e7          	jalr	1260(ra) # 5bde <unlink>
  exit(xstatus);
    16fa:	fbc42503          	lw	a0,-68(s0)
    16fe:	00004097          	auipc	ra,0x4
    1702:	490080e7          	jalr	1168(ra) # 5b8e <exit>
      printf("%s: open failed\n", s);
    1706:	85ca                	mv	a1,s2
    1708:	00005517          	auipc	a0,0x5
    170c:	29050513          	add	a0,a0,656 # 6998 <malloc+0x9c2>
    1710:	00005097          	auipc	ra,0x5
    1714:	80e080e7          	jalr	-2034(ra) # 5f1e <printf>
      exit(1);
    1718:	4505                	li	a0,1
    171a:	00004097          	auipc	ra,0x4
    171e:	474080e7          	jalr	1140(ra) # 5b8e <exit>
      printf("%s: write got %d, expected 3\n", s, n);
    1722:	862a                	mv	a2,a0
    1724:	85ca                	mv	a1,s2
    1726:	00005517          	auipc	a0,0x5
    172a:	2c250513          	add	a0,a0,706 # 69e8 <malloc+0xa12>
    172e:	00004097          	auipc	ra,0x4
    1732:	7f0080e7          	jalr	2032(ra) # 5f1e <printf>
      exit(1);
    1736:	4505                	li	a0,1
    1738:	00004097          	auipc	ra,0x4
    173c:	456080e7          	jalr	1110(ra) # 5b8e <exit>

0000000000001740 <exectest>:
{
    1740:	715d                	add	sp,sp,-80
    1742:	e486                	sd	ra,72(sp)
    1744:	e0a2                	sd	s0,64(sp)
    1746:	fc26                	sd	s1,56(sp)
    1748:	f84a                	sd	s2,48(sp)
    174a:	0880                	add	s0,sp,80
    174c:	892a                	mv	s2,a0
  char *echoargv[] = { "echo", "OK", 0 };
    174e:	00005797          	auipc	a5,0x5
    1752:	9aa78793          	add	a5,a5,-1622 # 60f8 <malloc+0x122>
    1756:	fcf43023          	sd	a5,-64(s0)
    175a:	00005797          	auipc	a5,0x5
    175e:	2ae78793          	add	a5,a5,686 # 6a08 <malloc+0xa32>
    1762:	fcf43423          	sd	a5,-56(s0)
    1766:	fc043823          	sd	zero,-48(s0)
  unlink("echo-ok");
    176a:	00005517          	auipc	a0,0x5
    176e:	2a650513          	add	a0,a0,678 # 6a10 <malloc+0xa3a>
    1772:	00004097          	auipc	ra,0x4
    1776:	46c080e7          	jalr	1132(ra) # 5bde <unlink>
  pid = fork();
    177a:	00004097          	auipc	ra,0x4
    177e:	40c080e7          	jalr	1036(ra) # 5b86 <fork>
  if(pid < 0) {
    1782:	04054663          	bltz	a0,17ce <exectest+0x8e>
    1786:	84aa                	mv	s1,a0
  if(pid == 0) {
    1788:	e959                	bnez	a0,181e <exectest+0xde>
    close(1);
    178a:	4505                	li	a0,1
    178c:	00004097          	auipc	ra,0x4
    1790:	42a080e7          	jalr	1066(ra) # 5bb6 <close>
    fd = open("echo-ok", O_CREATE|O_WRONLY);
    1794:	20100593          	li	a1,513
    1798:	00005517          	auipc	a0,0x5
    179c:	27850513          	add	a0,a0,632 # 6a10 <malloc+0xa3a>
    17a0:	00004097          	auipc	ra,0x4
    17a4:	42e080e7          	jalr	1070(ra) # 5bce <open>
    if(fd < 0) {
    17a8:	04054163          	bltz	a0,17ea <exectest+0xaa>
    if(fd != 1) {
    17ac:	4785                	li	a5,1
    17ae:	04f50c63          	beq	a0,a5,1806 <exectest+0xc6>
      printf("%s: wrong fd\n", s);
    17b2:	85ca                	mv	a1,s2
    17b4:	00005517          	auipc	a0,0x5
    17b8:	27c50513          	add	a0,a0,636 # 6a30 <malloc+0xa5a>
    17bc:	00004097          	auipc	ra,0x4
    17c0:	762080e7          	jalr	1890(ra) # 5f1e <printf>
      exit(1);
    17c4:	4505                	li	a0,1
    17c6:	00004097          	auipc	ra,0x4
    17ca:	3c8080e7          	jalr	968(ra) # 5b8e <exit>
     printf("%s: fork failed\n", s);
    17ce:	85ca                	mv	a1,s2
    17d0:	00005517          	auipc	a0,0x5
    17d4:	1b050513          	add	a0,a0,432 # 6980 <malloc+0x9aa>
    17d8:	00004097          	auipc	ra,0x4
    17dc:	746080e7          	jalr	1862(ra) # 5f1e <printf>
     exit(1);
    17e0:	4505                	li	a0,1
    17e2:	00004097          	auipc	ra,0x4
    17e6:	3ac080e7          	jalr	940(ra) # 5b8e <exit>
      printf("%s: create failed\n", s);
    17ea:	85ca                	mv	a1,s2
    17ec:	00005517          	auipc	a0,0x5
    17f0:	22c50513          	add	a0,a0,556 # 6a18 <malloc+0xa42>
    17f4:	00004097          	auipc	ra,0x4
    17f8:	72a080e7          	jalr	1834(ra) # 5f1e <printf>
      exit(1);
    17fc:	4505                	li	a0,1
    17fe:	00004097          	auipc	ra,0x4
    1802:	390080e7          	jalr	912(ra) # 5b8e <exit>
    if(exec("echo", echoargv) < 0){
    1806:	fc040593          	add	a1,s0,-64
    180a:	00005517          	auipc	a0,0x5
    180e:	8ee50513          	add	a0,a0,-1810 # 60f8 <malloc+0x122>
    1812:	00004097          	auipc	ra,0x4
    1816:	3b4080e7          	jalr	948(ra) # 5bc6 <exec>
    181a:	02054163          	bltz	a0,183c <exectest+0xfc>
  if (wait(&xstatus) != pid) {
    181e:	fdc40513          	add	a0,s0,-36
    1822:	00004097          	auipc	ra,0x4
    1826:	374080e7          	jalr	884(ra) # 5b96 <wait>
    182a:	02951763          	bne	a0,s1,1858 <exectest+0x118>
  if(xstatus != 0)
    182e:	fdc42503          	lw	a0,-36(s0)
    1832:	cd0d                	beqz	a0,186c <exectest+0x12c>
    exit(xstatus);
    1834:	00004097          	auipc	ra,0x4
    1838:	35a080e7          	jalr	858(ra) # 5b8e <exit>
      printf("%s: exec echo failed\n", s);
    183c:	85ca                	mv	a1,s2
    183e:	00005517          	auipc	a0,0x5
    1842:	20250513          	add	a0,a0,514 # 6a40 <malloc+0xa6a>
    1846:	00004097          	auipc	ra,0x4
    184a:	6d8080e7          	jalr	1752(ra) # 5f1e <printf>
      exit(1);
    184e:	4505                	li	a0,1
    1850:	00004097          	auipc	ra,0x4
    1854:	33e080e7          	jalr	830(ra) # 5b8e <exit>
    printf("%s: wait failed!\n", s);
    1858:	85ca                	mv	a1,s2
    185a:	00005517          	auipc	a0,0x5
    185e:	1fe50513          	add	a0,a0,510 # 6a58 <malloc+0xa82>
    1862:	00004097          	auipc	ra,0x4
    1866:	6bc080e7          	jalr	1724(ra) # 5f1e <printf>
    186a:	b7d1                	j	182e <exectest+0xee>
  fd = open("echo-ok", O_RDONLY);
    186c:	4581                	li	a1,0
    186e:	00005517          	auipc	a0,0x5
    1872:	1a250513          	add	a0,a0,418 # 6a10 <malloc+0xa3a>
    1876:	00004097          	auipc	ra,0x4
    187a:	358080e7          	jalr	856(ra) # 5bce <open>
  if(fd < 0) {
    187e:	02054a63          	bltz	a0,18b2 <exectest+0x172>
  if (read(fd, buf, 2) != 2) {
    1882:	4609                	li	a2,2
    1884:	fb840593          	add	a1,s0,-72
    1888:	00004097          	auipc	ra,0x4
    188c:	31e080e7          	jalr	798(ra) # 5ba6 <read>
    1890:	4789                	li	a5,2
    1892:	02f50e63          	beq	a0,a5,18ce <exectest+0x18e>
    printf("%s: read failed\n", s);
    1896:	85ca                	mv	a1,s2
    1898:	00005517          	auipc	a0,0x5
    189c:	c3050513          	add	a0,a0,-976 # 64c8 <malloc+0x4f2>
    18a0:	00004097          	auipc	ra,0x4
    18a4:	67e080e7          	jalr	1662(ra) # 5f1e <printf>
    exit(1);
    18a8:	4505                	li	a0,1
    18aa:	00004097          	auipc	ra,0x4
    18ae:	2e4080e7          	jalr	740(ra) # 5b8e <exit>
    printf("%s: open failed\n", s);
    18b2:	85ca                	mv	a1,s2
    18b4:	00005517          	auipc	a0,0x5
    18b8:	0e450513          	add	a0,a0,228 # 6998 <malloc+0x9c2>
    18bc:	00004097          	auipc	ra,0x4
    18c0:	662080e7          	jalr	1634(ra) # 5f1e <printf>
    exit(1);
    18c4:	4505                	li	a0,1
    18c6:	00004097          	auipc	ra,0x4
    18ca:	2c8080e7          	jalr	712(ra) # 5b8e <exit>
  unlink("echo-ok");
    18ce:	00005517          	auipc	a0,0x5
    18d2:	14250513          	add	a0,a0,322 # 6a10 <malloc+0xa3a>
    18d6:	00004097          	auipc	ra,0x4
    18da:	308080e7          	jalr	776(ra) # 5bde <unlink>
  if(buf[0] == 'O' && buf[1] == 'K')
    18de:	fb844703          	lbu	a4,-72(s0)
    18e2:	04f00793          	li	a5,79
    18e6:	00f71863          	bne	a4,a5,18f6 <exectest+0x1b6>
    18ea:	fb944703          	lbu	a4,-71(s0)
    18ee:	04b00793          	li	a5,75
    18f2:	02f70063          	beq	a4,a5,1912 <exectest+0x1d2>
    printf("%s: wrong output\n", s);
    18f6:	85ca                	mv	a1,s2
    18f8:	00005517          	auipc	a0,0x5
    18fc:	17850513          	add	a0,a0,376 # 6a70 <malloc+0xa9a>
    1900:	00004097          	auipc	ra,0x4
    1904:	61e080e7          	jalr	1566(ra) # 5f1e <printf>
    exit(1);
    1908:	4505                	li	a0,1
    190a:	00004097          	auipc	ra,0x4
    190e:	284080e7          	jalr	644(ra) # 5b8e <exit>
    exit(0);
    1912:	4501                	li	a0,0
    1914:	00004097          	auipc	ra,0x4
    1918:	27a080e7          	jalr	634(ra) # 5b8e <exit>

000000000000191c <pipe1>:
{
    191c:	711d                	add	sp,sp,-96
    191e:	ec86                	sd	ra,88(sp)
    1920:	e8a2                	sd	s0,80(sp)
    1922:	e4a6                	sd	s1,72(sp)
    1924:	e0ca                	sd	s2,64(sp)
    1926:	fc4e                	sd	s3,56(sp)
    1928:	f852                	sd	s4,48(sp)
    192a:	f456                	sd	s5,40(sp)
    192c:	f05a                	sd	s6,32(sp)
    192e:	ec5e                	sd	s7,24(sp)
    1930:	1080                	add	s0,sp,96
    1932:	892a                	mv	s2,a0
  if(pipe(fds) != 0){
    1934:	fa840513          	add	a0,s0,-88
    1938:	00004097          	auipc	ra,0x4
    193c:	266080e7          	jalr	614(ra) # 5b9e <pipe>
    1940:	e93d                	bnez	a0,19b6 <pipe1+0x9a>
    1942:	84aa                	mv	s1,a0
  pid = fork();
    1944:	00004097          	auipc	ra,0x4
    1948:	242080e7          	jalr	578(ra) # 5b86 <fork>
    194c:	8a2a                	mv	s4,a0
  if(pid == 0){
    194e:	c151                	beqz	a0,19d2 <pipe1+0xb6>
  } else if(pid > 0){
    1950:	16a05d63          	blez	a0,1aca <pipe1+0x1ae>
    close(fds[1]);
    1954:	fac42503          	lw	a0,-84(s0)
    1958:	00004097          	auipc	ra,0x4
    195c:	25e080e7          	jalr	606(ra) # 5bb6 <close>
    total = 0;
    1960:	8a26                	mv	s4,s1
    cc = 1;
    1962:	4985                	li	s3,1
    while((n = read(fds[0], buf, cc)) > 0){
    1964:	0000ba97          	auipc	s5,0xb
    1968:	304a8a93          	add	s5,s5,772 # cc68 <buf>
    196c:	864e                	mv	a2,s3
    196e:	85d6                	mv	a1,s5
    1970:	fa842503          	lw	a0,-88(s0)
    1974:	00004097          	auipc	ra,0x4
    1978:	232080e7          	jalr	562(ra) # 5ba6 <read>
    197c:	10a05263          	blez	a0,1a80 <pipe1+0x164>
      for(i = 0; i < n; i++){
    1980:	0000b717          	auipc	a4,0xb
    1984:	2e870713          	add	a4,a4,744 # cc68 <buf>
    1988:	00a4863b          	addw	a2,s1,a0
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    198c:	00074683          	lbu	a3,0(a4)
    1990:	0ff4f793          	zext.b	a5,s1
    1994:	2485                	addw	s1,s1,1
    1996:	0cf69163          	bne	a3,a5,1a58 <pipe1+0x13c>
      for(i = 0; i < n; i++){
    199a:	0705                	add	a4,a4,1
    199c:	fec498e3          	bne	s1,a2,198c <pipe1+0x70>
      total += n;
    19a0:	00aa0a3b          	addw	s4,s4,a0
      cc = cc * 2;
    19a4:	0019979b          	sllw	a5,s3,0x1
    19a8:	0007899b          	sext.w	s3,a5
      if(cc > sizeof(buf))
    19ac:	670d                	lui	a4,0x3
    19ae:	fb377fe3          	bgeu	a4,s3,196c <pipe1+0x50>
        cc = sizeof(buf);
    19b2:	698d                	lui	s3,0x3
    19b4:	bf65                	j	196c <pipe1+0x50>
    printf("%s: pipe() failed\n", s);
    19b6:	85ca                	mv	a1,s2
    19b8:	00005517          	auipc	a0,0x5
    19bc:	0d050513          	add	a0,a0,208 # 6a88 <malloc+0xab2>
    19c0:	00004097          	auipc	ra,0x4
    19c4:	55e080e7          	jalr	1374(ra) # 5f1e <printf>
    exit(1);
    19c8:	4505                	li	a0,1
    19ca:	00004097          	auipc	ra,0x4
    19ce:	1c4080e7          	jalr	452(ra) # 5b8e <exit>
    close(fds[0]);
    19d2:	fa842503          	lw	a0,-88(s0)
    19d6:	00004097          	auipc	ra,0x4
    19da:	1e0080e7          	jalr	480(ra) # 5bb6 <close>
    for(n = 0; n < N; n++){
    19de:	0000bb17          	auipc	s6,0xb
    19e2:	28ab0b13          	add	s6,s6,650 # cc68 <buf>
    19e6:	416004bb          	negw	s1,s6
    19ea:	0ff4f493          	zext.b	s1,s1
    19ee:	409b0993          	add	s3,s6,1033
      if(write(fds[1], buf, SZ) != SZ){
    19f2:	8bda                	mv	s7,s6
    for(n = 0; n < N; n++){
    19f4:	6a85                	lui	s5,0x1
    19f6:	42da8a93          	add	s5,s5,1069 # 142d <copyinstr2+0x9d>
{
    19fa:	87da                	mv	a5,s6
        buf[i] = seq++;
    19fc:	0097873b          	addw	a4,a5,s1
    1a00:	00e78023          	sb	a4,0(a5)
      for(i = 0; i < SZ; i++)
    1a04:	0785                	add	a5,a5,1
    1a06:	fef99be3          	bne	s3,a5,19fc <pipe1+0xe0>
        buf[i] = seq++;
    1a0a:	409a0a1b          	addw	s4,s4,1033
      if(write(fds[1], buf, SZ) != SZ){
    1a0e:	40900613          	li	a2,1033
    1a12:	85de                	mv	a1,s7
    1a14:	fac42503          	lw	a0,-84(s0)
    1a18:	00004097          	auipc	ra,0x4
    1a1c:	196080e7          	jalr	406(ra) # 5bae <write>
    1a20:	40900793          	li	a5,1033
    1a24:	00f51c63          	bne	a0,a5,1a3c <pipe1+0x120>
    for(n = 0; n < N; n++){
    1a28:	24a5                	addw	s1,s1,9
    1a2a:	0ff4f493          	zext.b	s1,s1
    1a2e:	fd5a16e3          	bne	s4,s5,19fa <pipe1+0xde>
    exit(0);
    1a32:	4501                	li	a0,0
    1a34:	00004097          	auipc	ra,0x4
    1a38:	15a080e7          	jalr	346(ra) # 5b8e <exit>
        printf("%s: pipe1 oops 1\n", s);
    1a3c:	85ca                	mv	a1,s2
    1a3e:	00005517          	auipc	a0,0x5
    1a42:	06250513          	add	a0,a0,98 # 6aa0 <malloc+0xaca>
    1a46:	00004097          	auipc	ra,0x4
    1a4a:	4d8080e7          	jalr	1240(ra) # 5f1e <printf>
        exit(1);
    1a4e:	4505                	li	a0,1
    1a50:	00004097          	auipc	ra,0x4
    1a54:	13e080e7          	jalr	318(ra) # 5b8e <exit>
          printf("%s: pipe1 oops 2\n", s);
    1a58:	85ca                	mv	a1,s2
    1a5a:	00005517          	auipc	a0,0x5
    1a5e:	05e50513          	add	a0,a0,94 # 6ab8 <malloc+0xae2>
    1a62:	00004097          	auipc	ra,0x4
    1a66:	4bc080e7          	jalr	1212(ra) # 5f1e <printf>
}
    1a6a:	60e6                	ld	ra,88(sp)
    1a6c:	6446                	ld	s0,80(sp)
    1a6e:	64a6                	ld	s1,72(sp)
    1a70:	6906                	ld	s2,64(sp)
    1a72:	79e2                	ld	s3,56(sp)
    1a74:	7a42                	ld	s4,48(sp)
    1a76:	7aa2                	ld	s5,40(sp)
    1a78:	7b02                	ld	s6,32(sp)
    1a7a:	6be2                	ld	s7,24(sp)
    1a7c:	6125                	add	sp,sp,96
    1a7e:	8082                	ret
    if(total != N * SZ){
    1a80:	6785                	lui	a5,0x1
    1a82:	42d78793          	add	a5,a5,1069 # 142d <copyinstr2+0x9d>
    1a86:	02fa0063          	beq	s4,a5,1aa6 <pipe1+0x18a>
      printf("%s: pipe1 oops 3 total %d\n", total);
    1a8a:	85d2                	mv	a1,s4
    1a8c:	00005517          	auipc	a0,0x5
    1a90:	04450513          	add	a0,a0,68 # 6ad0 <malloc+0xafa>
    1a94:	00004097          	auipc	ra,0x4
    1a98:	48a080e7          	jalr	1162(ra) # 5f1e <printf>
      exit(1);
    1a9c:	4505                	li	a0,1
    1a9e:	00004097          	auipc	ra,0x4
    1aa2:	0f0080e7          	jalr	240(ra) # 5b8e <exit>
    close(fds[0]);
    1aa6:	fa842503          	lw	a0,-88(s0)
    1aaa:	00004097          	auipc	ra,0x4
    1aae:	10c080e7          	jalr	268(ra) # 5bb6 <close>
    wait(&xstatus);
    1ab2:	fa440513          	add	a0,s0,-92
    1ab6:	00004097          	auipc	ra,0x4
    1aba:	0e0080e7          	jalr	224(ra) # 5b96 <wait>
    exit(xstatus);
    1abe:	fa442503          	lw	a0,-92(s0)
    1ac2:	00004097          	auipc	ra,0x4
    1ac6:	0cc080e7          	jalr	204(ra) # 5b8e <exit>
    printf("%s: fork() failed\n", s);
    1aca:	85ca                	mv	a1,s2
    1acc:	00005517          	auipc	a0,0x5
    1ad0:	02450513          	add	a0,a0,36 # 6af0 <malloc+0xb1a>
    1ad4:	00004097          	auipc	ra,0x4
    1ad8:	44a080e7          	jalr	1098(ra) # 5f1e <printf>
    exit(1);
    1adc:	4505                	li	a0,1
    1ade:	00004097          	auipc	ra,0x4
    1ae2:	0b0080e7          	jalr	176(ra) # 5b8e <exit>

0000000000001ae6 <exitwait>:
{
    1ae6:	7139                	add	sp,sp,-64
    1ae8:	fc06                	sd	ra,56(sp)
    1aea:	f822                	sd	s0,48(sp)
    1aec:	f426                	sd	s1,40(sp)
    1aee:	f04a                	sd	s2,32(sp)
    1af0:	ec4e                	sd	s3,24(sp)
    1af2:	e852                	sd	s4,16(sp)
    1af4:	0080                	add	s0,sp,64
    1af6:	8a2a                	mv	s4,a0
  for(i = 0; i < 100; i++){
    1af8:	4901                	li	s2,0
    1afa:	06400993          	li	s3,100
    pid = fork();
    1afe:	00004097          	auipc	ra,0x4
    1b02:	088080e7          	jalr	136(ra) # 5b86 <fork>
    1b06:	84aa                	mv	s1,a0
    if(pid < 0){
    1b08:	02054a63          	bltz	a0,1b3c <exitwait+0x56>
    if(pid){
    1b0c:	c151                	beqz	a0,1b90 <exitwait+0xaa>
      if(wait(&xstate) != pid){
    1b0e:	fcc40513          	add	a0,s0,-52
    1b12:	00004097          	auipc	ra,0x4
    1b16:	084080e7          	jalr	132(ra) # 5b96 <wait>
    1b1a:	02951f63          	bne	a0,s1,1b58 <exitwait+0x72>
      if(i != xstate) {
    1b1e:	fcc42783          	lw	a5,-52(s0)
    1b22:	05279963          	bne	a5,s2,1b74 <exitwait+0x8e>
  for(i = 0; i < 100; i++){
    1b26:	2905                	addw	s2,s2,1
    1b28:	fd391be3          	bne	s2,s3,1afe <exitwait+0x18>
}
    1b2c:	70e2                	ld	ra,56(sp)
    1b2e:	7442                	ld	s0,48(sp)
    1b30:	74a2                	ld	s1,40(sp)
    1b32:	7902                	ld	s2,32(sp)
    1b34:	69e2                	ld	s3,24(sp)
    1b36:	6a42                	ld	s4,16(sp)
    1b38:	6121                	add	sp,sp,64
    1b3a:	8082                	ret
      printf("%s: fork failed\n", s);
    1b3c:	85d2                	mv	a1,s4
    1b3e:	00005517          	auipc	a0,0x5
    1b42:	e4250513          	add	a0,a0,-446 # 6980 <malloc+0x9aa>
    1b46:	00004097          	auipc	ra,0x4
    1b4a:	3d8080e7          	jalr	984(ra) # 5f1e <printf>
      exit(1);
    1b4e:	4505                	li	a0,1
    1b50:	00004097          	auipc	ra,0x4
    1b54:	03e080e7          	jalr	62(ra) # 5b8e <exit>
        printf("%s: wait wrong pid\n", s);
    1b58:	85d2                	mv	a1,s4
    1b5a:	00005517          	auipc	a0,0x5
    1b5e:	fae50513          	add	a0,a0,-82 # 6b08 <malloc+0xb32>
    1b62:	00004097          	auipc	ra,0x4
    1b66:	3bc080e7          	jalr	956(ra) # 5f1e <printf>
        exit(1);
    1b6a:	4505                	li	a0,1
    1b6c:	00004097          	auipc	ra,0x4
    1b70:	022080e7          	jalr	34(ra) # 5b8e <exit>
        printf("%s: wait wrong exit status\n", s);
    1b74:	85d2                	mv	a1,s4
    1b76:	00005517          	auipc	a0,0x5
    1b7a:	faa50513          	add	a0,a0,-86 # 6b20 <malloc+0xb4a>
    1b7e:	00004097          	auipc	ra,0x4
    1b82:	3a0080e7          	jalr	928(ra) # 5f1e <printf>
        exit(1);
    1b86:	4505                	li	a0,1
    1b88:	00004097          	auipc	ra,0x4
    1b8c:	006080e7          	jalr	6(ra) # 5b8e <exit>
      exit(i);
    1b90:	854a                	mv	a0,s2
    1b92:	00004097          	auipc	ra,0x4
    1b96:	ffc080e7          	jalr	-4(ra) # 5b8e <exit>

0000000000001b9a <twochildren>:
{
    1b9a:	1101                	add	sp,sp,-32
    1b9c:	ec06                	sd	ra,24(sp)
    1b9e:	e822                	sd	s0,16(sp)
    1ba0:	e426                	sd	s1,8(sp)
    1ba2:	e04a                	sd	s2,0(sp)
    1ba4:	1000                	add	s0,sp,32
    1ba6:	892a                	mv	s2,a0
    1ba8:	3e800493          	li	s1,1000
    int pid1 = fork();
    1bac:	00004097          	auipc	ra,0x4
    1bb0:	fda080e7          	jalr	-38(ra) # 5b86 <fork>
    if(pid1 < 0){
    1bb4:	02054c63          	bltz	a0,1bec <twochildren+0x52>
    if(pid1 == 0){
    1bb8:	c921                	beqz	a0,1c08 <twochildren+0x6e>
      int pid2 = fork();
    1bba:	00004097          	auipc	ra,0x4
    1bbe:	fcc080e7          	jalr	-52(ra) # 5b86 <fork>
      if(pid2 < 0){
    1bc2:	04054763          	bltz	a0,1c10 <twochildren+0x76>
      if(pid2 == 0){
    1bc6:	c13d                	beqz	a0,1c2c <twochildren+0x92>
        wait(0);
    1bc8:	4501                	li	a0,0
    1bca:	00004097          	auipc	ra,0x4
    1bce:	fcc080e7          	jalr	-52(ra) # 5b96 <wait>
        wait(0);
    1bd2:	4501                	li	a0,0
    1bd4:	00004097          	auipc	ra,0x4
    1bd8:	fc2080e7          	jalr	-62(ra) # 5b96 <wait>
  for(int i = 0; i < 1000; i++){
    1bdc:	34fd                	addw	s1,s1,-1
    1bde:	f4f9                	bnez	s1,1bac <twochildren+0x12>
}
    1be0:	60e2                	ld	ra,24(sp)
    1be2:	6442                	ld	s0,16(sp)
    1be4:	64a2                	ld	s1,8(sp)
    1be6:	6902                	ld	s2,0(sp)
    1be8:	6105                	add	sp,sp,32
    1bea:	8082                	ret
      printf("%s: fork failed\n", s);
    1bec:	85ca                	mv	a1,s2
    1bee:	00005517          	auipc	a0,0x5
    1bf2:	d9250513          	add	a0,a0,-622 # 6980 <malloc+0x9aa>
    1bf6:	00004097          	auipc	ra,0x4
    1bfa:	328080e7          	jalr	808(ra) # 5f1e <printf>
      exit(1);
    1bfe:	4505                	li	a0,1
    1c00:	00004097          	auipc	ra,0x4
    1c04:	f8e080e7          	jalr	-114(ra) # 5b8e <exit>
      exit(0);
    1c08:	00004097          	auipc	ra,0x4
    1c0c:	f86080e7          	jalr	-122(ra) # 5b8e <exit>
        printf("%s: fork failed\n", s);
    1c10:	85ca                	mv	a1,s2
    1c12:	00005517          	auipc	a0,0x5
    1c16:	d6e50513          	add	a0,a0,-658 # 6980 <malloc+0x9aa>
    1c1a:	00004097          	auipc	ra,0x4
    1c1e:	304080e7          	jalr	772(ra) # 5f1e <printf>
        exit(1);
    1c22:	4505                	li	a0,1
    1c24:	00004097          	auipc	ra,0x4
    1c28:	f6a080e7          	jalr	-150(ra) # 5b8e <exit>
        exit(0);
    1c2c:	00004097          	auipc	ra,0x4
    1c30:	f62080e7          	jalr	-158(ra) # 5b8e <exit>

0000000000001c34 <forkfork>:
{
    1c34:	7179                	add	sp,sp,-48
    1c36:	f406                	sd	ra,40(sp)
    1c38:	f022                	sd	s0,32(sp)
    1c3a:	ec26                	sd	s1,24(sp)
    1c3c:	1800                	add	s0,sp,48
    1c3e:	84aa                	mv	s1,a0
    int pid = fork();
    1c40:	00004097          	auipc	ra,0x4
    1c44:	f46080e7          	jalr	-186(ra) # 5b86 <fork>
    if(pid < 0){
    1c48:	04054163          	bltz	a0,1c8a <forkfork+0x56>
    if(pid == 0){
    1c4c:	cd29                	beqz	a0,1ca6 <forkfork+0x72>
    int pid = fork();
    1c4e:	00004097          	auipc	ra,0x4
    1c52:	f38080e7          	jalr	-200(ra) # 5b86 <fork>
    if(pid < 0){
    1c56:	02054a63          	bltz	a0,1c8a <forkfork+0x56>
    if(pid == 0){
    1c5a:	c531                	beqz	a0,1ca6 <forkfork+0x72>
    wait(&xstatus);
    1c5c:	fdc40513          	add	a0,s0,-36
    1c60:	00004097          	auipc	ra,0x4
    1c64:	f36080e7          	jalr	-202(ra) # 5b96 <wait>
    if(xstatus != 0) {
    1c68:	fdc42783          	lw	a5,-36(s0)
    1c6c:	ebbd                	bnez	a5,1ce2 <forkfork+0xae>
    wait(&xstatus);
    1c6e:	fdc40513          	add	a0,s0,-36
    1c72:	00004097          	auipc	ra,0x4
    1c76:	f24080e7          	jalr	-220(ra) # 5b96 <wait>
    if(xstatus != 0) {
    1c7a:	fdc42783          	lw	a5,-36(s0)
    1c7e:	e3b5                	bnez	a5,1ce2 <forkfork+0xae>
}
    1c80:	70a2                	ld	ra,40(sp)
    1c82:	7402                	ld	s0,32(sp)
    1c84:	64e2                	ld	s1,24(sp)
    1c86:	6145                	add	sp,sp,48
    1c88:	8082                	ret
      printf("%s: fork failed", s);
    1c8a:	85a6                	mv	a1,s1
    1c8c:	00005517          	auipc	a0,0x5
    1c90:	eb450513          	add	a0,a0,-332 # 6b40 <malloc+0xb6a>
    1c94:	00004097          	auipc	ra,0x4
    1c98:	28a080e7          	jalr	650(ra) # 5f1e <printf>
      exit(1);
    1c9c:	4505                	li	a0,1
    1c9e:	00004097          	auipc	ra,0x4
    1ca2:	ef0080e7          	jalr	-272(ra) # 5b8e <exit>
{
    1ca6:	0c800493          	li	s1,200
        int pid1 = fork();
    1caa:	00004097          	auipc	ra,0x4
    1cae:	edc080e7          	jalr	-292(ra) # 5b86 <fork>
        if(pid1 < 0){
    1cb2:	00054f63          	bltz	a0,1cd0 <forkfork+0x9c>
        if(pid1 == 0){
    1cb6:	c115                	beqz	a0,1cda <forkfork+0xa6>
        wait(0);
    1cb8:	4501                	li	a0,0
    1cba:	00004097          	auipc	ra,0x4
    1cbe:	edc080e7          	jalr	-292(ra) # 5b96 <wait>
      for(int j = 0; j < 200; j++){
    1cc2:	34fd                	addw	s1,s1,-1
    1cc4:	f0fd                	bnez	s1,1caa <forkfork+0x76>
      exit(0);
    1cc6:	4501                	li	a0,0
    1cc8:	00004097          	auipc	ra,0x4
    1ccc:	ec6080e7          	jalr	-314(ra) # 5b8e <exit>
          exit(1);
    1cd0:	4505                	li	a0,1
    1cd2:	00004097          	auipc	ra,0x4
    1cd6:	ebc080e7          	jalr	-324(ra) # 5b8e <exit>
          exit(0);
    1cda:	00004097          	auipc	ra,0x4
    1cde:	eb4080e7          	jalr	-332(ra) # 5b8e <exit>
      printf("%s: fork in child failed", s);
    1ce2:	85a6                	mv	a1,s1
    1ce4:	00005517          	auipc	a0,0x5
    1ce8:	e6c50513          	add	a0,a0,-404 # 6b50 <malloc+0xb7a>
    1cec:	00004097          	auipc	ra,0x4
    1cf0:	232080e7          	jalr	562(ra) # 5f1e <printf>
      exit(1);
    1cf4:	4505                	li	a0,1
    1cf6:	00004097          	auipc	ra,0x4
    1cfa:	e98080e7          	jalr	-360(ra) # 5b8e <exit>

0000000000001cfe <reparent2>:
{
    1cfe:	1101                	add	sp,sp,-32
    1d00:	ec06                	sd	ra,24(sp)
    1d02:	e822                	sd	s0,16(sp)
    1d04:	e426                	sd	s1,8(sp)
    1d06:	1000                	add	s0,sp,32
    1d08:	32000493          	li	s1,800
    int pid1 = fork();
    1d0c:	00004097          	auipc	ra,0x4
    1d10:	e7a080e7          	jalr	-390(ra) # 5b86 <fork>
    if(pid1 < 0){
    1d14:	00054f63          	bltz	a0,1d32 <reparent2+0x34>
    if(pid1 == 0){
    1d18:	c915                	beqz	a0,1d4c <reparent2+0x4e>
    wait(0);
    1d1a:	4501                	li	a0,0
    1d1c:	00004097          	auipc	ra,0x4
    1d20:	e7a080e7          	jalr	-390(ra) # 5b96 <wait>
  for(int i = 0; i < 800; i++){
    1d24:	34fd                	addw	s1,s1,-1
    1d26:	f0fd                	bnez	s1,1d0c <reparent2+0xe>
  exit(0);
    1d28:	4501                	li	a0,0
    1d2a:	00004097          	auipc	ra,0x4
    1d2e:	e64080e7          	jalr	-412(ra) # 5b8e <exit>
      printf("fork failed\n");
    1d32:	00005517          	auipc	a0,0x5
    1d36:	05650513          	add	a0,a0,86 # 6d88 <malloc+0xdb2>
    1d3a:	00004097          	auipc	ra,0x4
    1d3e:	1e4080e7          	jalr	484(ra) # 5f1e <printf>
      exit(1);
    1d42:	4505                	li	a0,1
    1d44:	00004097          	auipc	ra,0x4
    1d48:	e4a080e7          	jalr	-438(ra) # 5b8e <exit>
      fork();
    1d4c:	00004097          	auipc	ra,0x4
    1d50:	e3a080e7          	jalr	-454(ra) # 5b86 <fork>
      fork();
    1d54:	00004097          	auipc	ra,0x4
    1d58:	e32080e7          	jalr	-462(ra) # 5b86 <fork>
      exit(0);
    1d5c:	4501                	li	a0,0
    1d5e:	00004097          	auipc	ra,0x4
    1d62:	e30080e7          	jalr	-464(ra) # 5b8e <exit>

0000000000001d66 <createdelete>:
{
    1d66:	7175                	add	sp,sp,-144
    1d68:	e506                	sd	ra,136(sp)
    1d6a:	e122                	sd	s0,128(sp)
    1d6c:	fca6                	sd	s1,120(sp)
    1d6e:	f8ca                	sd	s2,112(sp)
    1d70:	f4ce                	sd	s3,104(sp)
    1d72:	f0d2                	sd	s4,96(sp)
    1d74:	ecd6                	sd	s5,88(sp)
    1d76:	e8da                	sd	s6,80(sp)
    1d78:	e4de                	sd	s7,72(sp)
    1d7a:	e0e2                	sd	s8,64(sp)
    1d7c:	fc66                	sd	s9,56(sp)
    1d7e:	0900                	add	s0,sp,144
    1d80:	8caa                	mv	s9,a0
  for(pi = 0; pi < NCHILD; pi++){
    1d82:	4901                	li	s2,0
    1d84:	4991                	li	s3,4
    pid = fork();
    1d86:	00004097          	auipc	ra,0x4
    1d8a:	e00080e7          	jalr	-512(ra) # 5b86 <fork>
    1d8e:	84aa                	mv	s1,a0
    if(pid < 0){
    1d90:	02054f63          	bltz	a0,1dce <createdelete+0x68>
    if(pid == 0){
    1d94:	c939                	beqz	a0,1dea <createdelete+0x84>
  for(pi = 0; pi < NCHILD; pi++){
    1d96:	2905                	addw	s2,s2,1
    1d98:	ff3917e3          	bne	s2,s3,1d86 <createdelete+0x20>
    1d9c:	4491                	li	s1,4
    wait(&xstatus);
    1d9e:	f7c40513          	add	a0,s0,-132
    1da2:	00004097          	auipc	ra,0x4
    1da6:	df4080e7          	jalr	-524(ra) # 5b96 <wait>
    if(xstatus != 0)
    1daa:	f7c42903          	lw	s2,-132(s0)
    1dae:	0e091263          	bnez	s2,1e92 <createdelete+0x12c>
  for(pi = 0; pi < NCHILD; pi++){
    1db2:	34fd                	addw	s1,s1,-1
    1db4:	f4ed                	bnez	s1,1d9e <createdelete+0x38>
  name[0] = name[1] = name[2] = 0;
    1db6:	f8040123          	sb	zero,-126(s0)
    1dba:	03000993          	li	s3,48
    1dbe:	5a7d                	li	s4,-1
    1dc0:	07000c13          	li	s8,112
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1dc4:	4b21                	li	s6,8
      if((i == 0 || i >= N/2) && fd < 0){
    1dc6:	4ba5                	li	s7,9
    for(pi = 0; pi < NCHILD; pi++){
    1dc8:	07400a93          	li	s5,116
    1dcc:	a29d                	j	1f32 <createdelete+0x1cc>
      printf("fork failed\n", s);
    1dce:	85e6                	mv	a1,s9
    1dd0:	00005517          	auipc	a0,0x5
    1dd4:	fb850513          	add	a0,a0,-72 # 6d88 <malloc+0xdb2>
    1dd8:	00004097          	auipc	ra,0x4
    1ddc:	146080e7          	jalr	326(ra) # 5f1e <printf>
      exit(1);
    1de0:	4505                	li	a0,1
    1de2:	00004097          	auipc	ra,0x4
    1de6:	dac080e7          	jalr	-596(ra) # 5b8e <exit>
      name[0] = 'p' + pi;
    1dea:	0709091b          	addw	s2,s2,112
    1dee:	f9240023          	sb	s2,-128(s0)
      name[2] = '\0';
    1df2:	f8040123          	sb	zero,-126(s0)
      for(i = 0; i < N; i++){
    1df6:	4951                	li	s2,20
    1df8:	a015                	j	1e1c <createdelete+0xb6>
          printf("%s: create failed\n", s);
    1dfa:	85e6                	mv	a1,s9
    1dfc:	00005517          	auipc	a0,0x5
    1e00:	c1c50513          	add	a0,a0,-996 # 6a18 <malloc+0xa42>
    1e04:	00004097          	auipc	ra,0x4
    1e08:	11a080e7          	jalr	282(ra) # 5f1e <printf>
          exit(1);
    1e0c:	4505                	li	a0,1
    1e0e:	00004097          	auipc	ra,0x4
    1e12:	d80080e7          	jalr	-640(ra) # 5b8e <exit>
      for(i = 0; i < N; i++){
    1e16:	2485                	addw	s1,s1,1
    1e18:	07248863          	beq	s1,s2,1e88 <createdelete+0x122>
        name[1] = '0' + i;
    1e1c:	0304879b          	addw	a5,s1,48
    1e20:	f8f400a3          	sb	a5,-127(s0)
        fd = open(name, O_CREATE | O_RDWR);
    1e24:	20200593          	li	a1,514
    1e28:	f8040513          	add	a0,s0,-128
    1e2c:	00004097          	auipc	ra,0x4
    1e30:	da2080e7          	jalr	-606(ra) # 5bce <open>
        if(fd < 0){
    1e34:	fc0543e3          	bltz	a0,1dfa <createdelete+0x94>
        close(fd);
    1e38:	00004097          	auipc	ra,0x4
    1e3c:	d7e080e7          	jalr	-642(ra) # 5bb6 <close>
        if(i > 0 && (i % 2 ) == 0){
    1e40:	fc905be3          	blez	s1,1e16 <createdelete+0xb0>
    1e44:	0014f793          	and	a5,s1,1
    1e48:	f7f9                	bnez	a5,1e16 <createdelete+0xb0>
          name[1] = '0' + (i / 2);
    1e4a:	01f4d79b          	srlw	a5,s1,0x1f
    1e4e:	9fa5                	addw	a5,a5,s1
    1e50:	4017d79b          	sraw	a5,a5,0x1
    1e54:	0307879b          	addw	a5,a5,48
    1e58:	f8f400a3          	sb	a5,-127(s0)
          if(unlink(name) < 0){
    1e5c:	f8040513          	add	a0,s0,-128
    1e60:	00004097          	auipc	ra,0x4
    1e64:	d7e080e7          	jalr	-642(ra) # 5bde <unlink>
    1e68:	fa0557e3          	bgez	a0,1e16 <createdelete+0xb0>
            printf("%s: unlink failed\n", s);
    1e6c:	85e6                	mv	a1,s9
    1e6e:	00005517          	auipc	a0,0x5
    1e72:	d0250513          	add	a0,a0,-766 # 6b70 <malloc+0xb9a>
    1e76:	00004097          	auipc	ra,0x4
    1e7a:	0a8080e7          	jalr	168(ra) # 5f1e <printf>
            exit(1);
    1e7e:	4505                	li	a0,1
    1e80:	00004097          	auipc	ra,0x4
    1e84:	d0e080e7          	jalr	-754(ra) # 5b8e <exit>
      exit(0);
    1e88:	4501                	li	a0,0
    1e8a:	00004097          	auipc	ra,0x4
    1e8e:	d04080e7          	jalr	-764(ra) # 5b8e <exit>
      exit(1);
    1e92:	4505                	li	a0,1
    1e94:	00004097          	auipc	ra,0x4
    1e98:	cfa080e7          	jalr	-774(ra) # 5b8e <exit>
        printf("%s: oops createdelete %s didn't exist\n", s, name);
    1e9c:	f8040613          	add	a2,s0,-128
    1ea0:	85e6                	mv	a1,s9
    1ea2:	00005517          	auipc	a0,0x5
    1ea6:	ce650513          	add	a0,a0,-794 # 6b88 <malloc+0xbb2>
    1eaa:	00004097          	auipc	ra,0x4
    1eae:	074080e7          	jalr	116(ra) # 5f1e <printf>
        exit(1);
    1eb2:	4505                	li	a0,1
    1eb4:	00004097          	auipc	ra,0x4
    1eb8:	cda080e7          	jalr	-806(ra) # 5b8e <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1ebc:	054b7163          	bgeu	s6,s4,1efe <createdelete+0x198>
      if(fd >= 0)
    1ec0:	02055a63          	bgez	a0,1ef4 <createdelete+0x18e>
    for(pi = 0; pi < NCHILD; pi++){
    1ec4:	2485                	addw	s1,s1,1
    1ec6:	0ff4f493          	zext.b	s1,s1
    1eca:	05548c63          	beq	s1,s5,1f22 <createdelete+0x1bc>
      name[0] = 'p' + pi;
    1ece:	f8940023          	sb	s1,-128(s0)
      name[1] = '0' + i;
    1ed2:	f93400a3          	sb	s3,-127(s0)
      fd = open(name, 0);
    1ed6:	4581                	li	a1,0
    1ed8:	f8040513          	add	a0,s0,-128
    1edc:	00004097          	auipc	ra,0x4
    1ee0:	cf2080e7          	jalr	-782(ra) # 5bce <open>
      if((i == 0 || i >= N/2) && fd < 0){
    1ee4:	00090463          	beqz	s2,1eec <createdelete+0x186>
    1ee8:	fd2bdae3          	bge	s7,s2,1ebc <createdelete+0x156>
    1eec:	fa0548e3          	bltz	a0,1e9c <createdelete+0x136>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1ef0:	014b7963          	bgeu	s6,s4,1f02 <createdelete+0x19c>
        close(fd);
    1ef4:	00004097          	auipc	ra,0x4
    1ef8:	cc2080e7          	jalr	-830(ra) # 5bb6 <close>
    1efc:	b7e1                	j	1ec4 <createdelete+0x15e>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1efe:	fc0543e3          	bltz	a0,1ec4 <createdelete+0x15e>
        printf("%s: oops createdelete %s did exist\n", s, name);
    1f02:	f8040613          	add	a2,s0,-128
    1f06:	85e6                	mv	a1,s9
    1f08:	00005517          	auipc	a0,0x5
    1f0c:	ca850513          	add	a0,a0,-856 # 6bb0 <malloc+0xbda>
    1f10:	00004097          	auipc	ra,0x4
    1f14:	00e080e7          	jalr	14(ra) # 5f1e <printf>
        exit(1);
    1f18:	4505                	li	a0,1
    1f1a:	00004097          	auipc	ra,0x4
    1f1e:	c74080e7          	jalr	-908(ra) # 5b8e <exit>
  for(i = 0; i < N; i++){
    1f22:	2905                	addw	s2,s2,1
    1f24:	2a05                	addw	s4,s4,1
    1f26:	2985                	addw	s3,s3,1 # 3001 <fourteen+0x13b>
    1f28:	0ff9f993          	zext.b	s3,s3
    1f2c:	47d1                	li	a5,20
    1f2e:	02f90a63          	beq	s2,a5,1f62 <createdelete+0x1fc>
    for(pi = 0; pi < NCHILD; pi++){
    1f32:	84e2                	mv	s1,s8
    1f34:	bf69                	j	1ece <createdelete+0x168>
  for(i = 0; i < N; i++){
    1f36:	2905                	addw	s2,s2,1
    1f38:	0ff97913          	zext.b	s2,s2
    1f3c:	2985                	addw	s3,s3,1
    1f3e:	0ff9f993          	zext.b	s3,s3
    1f42:	03490863          	beq	s2,s4,1f72 <createdelete+0x20c>
  name[0] = name[1] = name[2] = 0;
    1f46:	84d6                	mv	s1,s5
      name[0] = 'p' + i;
    1f48:	f9240023          	sb	s2,-128(s0)
      name[1] = '0' + i;
    1f4c:	f93400a3          	sb	s3,-127(s0)
      unlink(name);
    1f50:	f8040513          	add	a0,s0,-128
    1f54:	00004097          	auipc	ra,0x4
    1f58:	c8a080e7          	jalr	-886(ra) # 5bde <unlink>
    for(pi = 0; pi < NCHILD; pi++){
    1f5c:	34fd                	addw	s1,s1,-1
    1f5e:	f4ed                	bnez	s1,1f48 <createdelete+0x1e2>
    1f60:	bfd9                	j	1f36 <createdelete+0x1d0>
    1f62:	03000993          	li	s3,48
    1f66:	07000913          	li	s2,112
  name[0] = name[1] = name[2] = 0;
    1f6a:	4a91                	li	s5,4
  for(i = 0; i < N; i++){
    1f6c:	08400a13          	li	s4,132
    1f70:	bfd9                	j	1f46 <createdelete+0x1e0>
}
    1f72:	60aa                	ld	ra,136(sp)
    1f74:	640a                	ld	s0,128(sp)
    1f76:	74e6                	ld	s1,120(sp)
    1f78:	7946                	ld	s2,112(sp)
    1f7a:	79a6                	ld	s3,104(sp)
    1f7c:	7a06                	ld	s4,96(sp)
    1f7e:	6ae6                	ld	s5,88(sp)
    1f80:	6b46                	ld	s6,80(sp)
    1f82:	6ba6                	ld	s7,72(sp)
    1f84:	6c06                	ld	s8,64(sp)
    1f86:	7ce2                	ld	s9,56(sp)
    1f88:	6149                	add	sp,sp,144
    1f8a:	8082                	ret

0000000000001f8c <linkunlink>:
{
    1f8c:	711d                	add	sp,sp,-96
    1f8e:	ec86                	sd	ra,88(sp)
    1f90:	e8a2                	sd	s0,80(sp)
    1f92:	e4a6                	sd	s1,72(sp)
    1f94:	e0ca                	sd	s2,64(sp)
    1f96:	fc4e                	sd	s3,56(sp)
    1f98:	f852                	sd	s4,48(sp)
    1f9a:	f456                	sd	s5,40(sp)
    1f9c:	f05a                	sd	s6,32(sp)
    1f9e:	ec5e                	sd	s7,24(sp)
    1fa0:	e862                	sd	s8,16(sp)
    1fa2:	e466                	sd	s9,8(sp)
    1fa4:	1080                	add	s0,sp,96
    1fa6:	84aa                	mv	s1,a0
  unlink("x");
    1fa8:	00004517          	auipc	a0,0x4
    1fac:	1c050513          	add	a0,a0,448 # 6168 <malloc+0x192>
    1fb0:	00004097          	auipc	ra,0x4
    1fb4:	c2e080e7          	jalr	-978(ra) # 5bde <unlink>
  pid = fork();
    1fb8:	00004097          	auipc	ra,0x4
    1fbc:	bce080e7          	jalr	-1074(ra) # 5b86 <fork>
  if(pid < 0){
    1fc0:	02054b63          	bltz	a0,1ff6 <linkunlink+0x6a>
    1fc4:	8c2a                	mv	s8,a0
  unsigned int x = (pid ? 1 : 97);
    1fc6:	06100c93          	li	s9,97
    1fca:	c111                	beqz	a0,1fce <linkunlink+0x42>
    1fcc:	4c85                	li	s9,1
    1fce:	06400493          	li	s1,100
    x = x * 1103515245 + 12345;
    1fd2:	41c659b7          	lui	s3,0x41c65
    1fd6:	e6d9899b          	addw	s3,s3,-403 # 41c64e6d <base+0x41c55205>
    1fda:	690d                	lui	s2,0x3
    1fdc:	0399091b          	addw	s2,s2,57 # 3039 <fourteen+0x173>
    if((x % 3) == 0){
    1fe0:	4a0d                	li	s4,3
    } else if((x % 3) == 1){
    1fe2:	4b05                	li	s6,1
      unlink("x");
    1fe4:	00004a97          	auipc	s5,0x4
    1fe8:	184a8a93          	add	s5,s5,388 # 6168 <malloc+0x192>
      link("cat", "x");
    1fec:	00005b97          	auipc	s7,0x5
    1ff0:	becb8b93          	add	s7,s7,-1044 # 6bd8 <malloc+0xc02>
    1ff4:	a825                	j	202c <linkunlink+0xa0>
    printf("%s: fork failed\n", s);
    1ff6:	85a6                	mv	a1,s1
    1ff8:	00005517          	auipc	a0,0x5
    1ffc:	98850513          	add	a0,a0,-1656 # 6980 <malloc+0x9aa>
    2000:	00004097          	auipc	ra,0x4
    2004:	f1e080e7          	jalr	-226(ra) # 5f1e <printf>
    exit(1);
    2008:	4505                	li	a0,1
    200a:	00004097          	auipc	ra,0x4
    200e:	b84080e7          	jalr	-1148(ra) # 5b8e <exit>
      close(open("x", O_RDWR | O_CREATE));
    2012:	20200593          	li	a1,514
    2016:	8556                	mv	a0,s5
    2018:	00004097          	auipc	ra,0x4
    201c:	bb6080e7          	jalr	-1098(ra) # 5bce <open>
    2020:	00004097          	auipc	ra,0x4
    2024:	b96080e7          	jalr	-1130(ra) # 5bb6 <close>
  for(i = 0; i < 100; i++){
    2028:	34fd                	addw	s1,s1,-1
    202a:	c88d                	beqz	s1,205c <linkunlink+0xd0>
    x = x * 1103515245 + 12345;
    202c:	033c87bb          	mulw	a5,s9,s3
    2030:	012787bb          	addw	a5,a5,s2
    2034:	00078c9b          	sext.w	s9,a5
    if((x % 3) == 0){
    2038:	0347f7bb          	remuw	a5,a5,s4
    203c:	dbf9                	beqz	a5,2012 <linkunlink+0x86>
    } else if((x % 3) == 1){
    203e:	01678863          	beq	a5,s6,204e <linkunlink+0xc2>
      unlink("x");
    2042:	8556                	mv	a0,s5
    2044:	00004097          	auipc	ra,0x4
    2048:	b9a080e7          	jalr	-1126(ra) # 5bde <unlink>
    204c:	bff1                	j	2028 <linkunlink+0x9c>
      link("cat", "x");
    204e:	85d6                	mv	a1,s5
    2050:	855e                	mv	a0,s7
    2052:	00004097          	auipc	ra,0x4
    2056:	b9c080e7          	jalr	-1124(ra) # 5bee <link>
    205a:	b7f9                	j	2028 <linkunlink+0x9c>
  if(pid)
    205c:	020c0463          	beqz	s8,2084 <linkunlink+0xf8>
    wait(0);
    2060:	4501                	li	a0,0
    2062:	00004097          	auipc	ra,0x4
    2066:	b34080e7          	jalr	-1228(ra) # 5b96 <wait>
}
    206a:	60e6                	ld	ra,88(sp)
    206c:	6446                	ld	s0,80(sp)
    206e:	64a6                	ld	s1,72(sp)
    2070:	6906                	ld	s2,64(sp)
    2072:	79e2                	ld	s3,56(sp)
    2074:	7a42                	ld	s4,48(sp)
    2076:	7aa2                	ld	s5,40(sp)
    2078:	7b02                	ld	s6,32(sp)
    207a:	6be2                	ld	s7,24(sp)
    207c:	6c42                	ld	s8,16(sp)
    207e:	6ca2                	ld	s9,8(sp)
    2080:	6125                	add	sp,sp,96
    2082:	8082                	ret
    exit(0);
    2084:	4501                	li	a0,0
    2086:	00004097          	auipc	ra,0x4
    208a:	b08080e7          	jalr	-1272(ra) # 5b8e <exit>

000000000000208e <forktest>:
{
    208e:	7179                	add	sp,sp,-48
    2090:	f406                	sd	ra,40(sp)
    2092:	f022                	sd	s0,32(sp)
    2094:	ec26                	sd	s1,24(sp)
    2096:	e84a                	sd	s2,16(sp)
    2098:	e44e                	sd	s3,8(sp)
    209a:	1800                	add	s0,sp,48
    209c:	89aa                	mv	s3,a0
  for(n=0; n<N; n++){
    209e:	4481                	li	s1,0
    20a0:	3e800913          	li	s2,1000
    pid = fork();
    20a4:	00004097          	auipc	ra,0x4
    20a8:	ae2080e7          	jalr	-1310(ra) # 5b86 <fork>
    if(pid < 0)
    20ac:	02054863          	bltz	a0,20dc <forktest+0x4e>
    if(pid == 0)
    20b0:	c115                	beqz	a0,20d4 <forktest+0x46>
  for(n=0; n<N; n++){
    20b2:	2485                	addw	s1,s1,1
    20b4:	ff2498e3          	bne	s1,s2,20a4 <forktest+0x16>
    printf("%s: fork claimed to work 1000 times!\n", s);
    20b8:	85ce                	mv	a1,s3
    20ba:	00005517          	auipc	a0,0x5
    20be:	b3e50513          	add	a0,a0,-1218 # 6bf8 <malloc+0xc22>
    20c2:	00004097          	auipc	ra,0x4
    20c6:	e5c080e7          	jalr	-420(ra) # 5f1e <printf>
    exit(1);
    20ca:	4505                	li	a0,1
    20cc:	00004097          	auipc	ra,0x4
    20d0:	ac2080e7          	jalr	-1342(ra) # 5b8e <exit>
      exit(0);
    20d4:	00004097          	auipc	ra,0x4
    20d8:	aba080e7          	jalr	-1350(ra) # 5b8e <exit>
  if (n == 0) {
    20dc:	cc9d                	beqz	s1,211a <forktest+0x8c>
  if(n == N){
    20de:	3e800793          	li	a5,1000
    20e2:	fcf48be3          	beq	s1,a5,20b8 <forktest+0x2a>
  for(; n > 0; n--){
    20e6:	00905b63          	blez	s1,20fc <forktest+0x6e>
    if(wait(0) < 0){
    20ea:	4501                	li	a0,0
    20ec:	00004097          	auipc	ra,0x4
    20f0:	aaa080e7          	jalr	-1366(ra) # 5b96 <wait>
    20f4:	04054163          	bltz	a0,2136 <forktest+0xa8>
  for(; n > 0; n--){
    20f8:	34fd                	addw	s1,s1,-1
    20fa:	f8e5                	bnez	s1,20ea <forktest+0x5c>
  if(wait(0) != -1){
    20fc:	4501                	li	a0,0
    20fe:	00004097          	auipc	ra,0x4
    2102:	a98080e7          	jalr	-1384(ra) # 5b96 <wait>
    2106:	57fd                	li	a5,-1
    2108:	04f51563          	bne	a0,a5,2152 <forktest+0xc4>
}
    210c:	70a2                	ld	ra,40(sp)
    210e:	7402                	ld	s0,32(sp)
    2110:	64e2                	ld	s1,24(sp)
    2112:	6942                	ld	s2,16(sp)
    2114:	69a2                	ld	s3,8(sp)
    2116:	6145                	add	sp,sp,48
    2118:	8082                	ret
    printf("%s: no fork at all!\n", s);
    211a:	85ce                	mv	a1,s3
    211c:	00005517          	auipc	a0,0x5
    2120:	ac450513          	add	a0,a0,-1340 # 6be0 <malloc+0xc0a>
    2124:	00004097          	auipc	ra,0x4
    2128:	dfa080e7          	jalr	-518(ra) # 5f1e <printf>
    exit(1);
    212c:	4505                	li	a0,1
    212e:	00004097          	auipc	ra,0x4
    2132:	a60080e7          	jalr	-1440(ra) # 5b8e <exit>
      printf("%s: wait stopped early\n", s);
    2136:	85ce                	mv	a1,s3
    2138:	00005517          	auipc	a0,0x5
    213c:	ae850513          	add	a0,a0,-1304 # 6c20 <malloc+0xc4a>
    2140:	00004097          	auipc	ra,0x4
    2144:	dde080e7          	jalr	-546(ra) # 5f1e <printf>
      exit(1);
    2148:	4505                	li	a0,1
    214a:	00004097          	auipc	ra,0x4
    214e:	a44080e7          	jalr	-1468(ra) # 5b8e <exit>
    printf("%s: wait got too many\n", s);
    2152:	85ce                	mv	a1,s3
    2154:	00005517          	auipc	a0,0x5
    2158:	ae450513          	add	a0,a0,-1308 # 6c38 <malloc+0xc62>
    215c:	00004097          	auipc	ra,0x4
    2160:	dc2080e7          	jalr	-574(ra) # 5f1e <printf>
    exit(1);
    2164:	4505                	li	a0,1
    2166:	00004097          	auipc	ra,0x4
    216a:	a28080e7          	jalr	-1496(ra) # 5b8e <exit>

000000000000216e <kernmem>:
{
    216e:	715d                	add	sp,sp,-80
    2170:	e486                	sd	ra,72(sp)
    2172:	e0a2                	sd	s0,64(sp)
    2174:	fc26                	sd	s1,56(sp)
    2176:	f84a                	sd	s2,48(sp)
    2178:	f44e                	sd	s3,40(sp)
    217a:	f052                	sd	s4,32(sp)
    217c:	ec56                	sd	s5,24(sp)
    217e:	0880                	add	s0,sp,80
    2180:	8a2a                	mv	s4,a0
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    2182:	4485                	li	s1,1
    2184:	04fe                	sll	s1,s1,0x1f
    if(xstatus != -1)  // did kernel kill child?
    2186:	5afd                	li	s5,-1
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    2188:	69b1                	lui	s3,0xc
    218a:	35098993          	add	s3,s3,848 # c350 <uninit+0x1df8>
    218e:	1003d937          	lui	s2,0x1003d
    2192:	090e                	sll	s2,s2,0x3
    2194:	48090913          	add	s2,s2,1152 # 1003d480 <base+0x1002d818>
    pid = fork();
    2198:	00004097          	auipc	ra,0x4
    219c:	9ee080e7          	jalr	-1554(ra) # 5b86 <fork>
    if(pid < 0){
    21a0:	02054963          	bltz	a0,21d2 <kernmem+0x64>
    if(pid == 0){
    21a4:	c529                	beqz	a0,21ee <kernmem+0x80>
    wait(&xstatus);
    21a6:	fbc40513          	add	a0,s0,-68
    21aa:	00004097          	auipc	ra,0x4
    21ae:	9ec080e7          	jalr	-1556(ra) # 5b96 <wait>
    if(xstatus != -1)  // did kernel kill child?
    21b2:	fbc42783          	lw	a5,-68(s0)
    21b6:	05579d63          	bne	a5,s5,2210 <kernmem+0xa2>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    21ba:	94ce                	add	s1,s1,s3
    21bc:	fd249ee3          	bne	s1,s2,2198 <kernmem+0x2a>
}
    21c0:	60a6                	ld	ra,72(sp)
    21c2:	6406                	ld	s0,64(sp)
    21c4:	74e2                	ld	s1,56(sp)
    21c6:	7942                	ld	s2,48(sp)
    21c8:	79a2                	ld	s3,40(sp)
    21ca:	7a02                	ld	s4,32(sp)
    21cc:	6ae2                	ld	s5,24(sp)
    21ce:	6161                	add	sp,sp,80
    21d0:	8082                	ret
      printf("%s: fork failed\n", s);
    21d2:	85d2                	mv	a1,s4
    21d4:	00004517          	auipc	a0,0x4
    21d8:	7ac50513          	add	a0,a0,1964 # 6980 <malloc+0x9aa>
    21dc:	00004097          	auipc	ra,0x4
    21e0:	d42080e7          	jalr	-702(ra) # 5f1e <printf>
      exit(1);
    21e4:	4505                	li	a0,1
    21e6:	00004097          	auipc	ra,0x4
    21ea:	9a8080e7          	jalr	-1624(ra) # 5b8e <exit>
      printf("%s: oops could read %x = %x\n", s, a, *a);
    21ee:	0004c683          	lbu	a3,0(s1)
    21f2:	8626                	mv	a2,s1
    21f4:	85d2                	mv	a1,s4
    21f6:	00005517          	auipc	a0,0x5
    21fa:	a5a50513          	add	a0,a0,-1446 # 6c50 <malloc+0xc7a>
    21fe:	00004097          	auipc	ra,0x4
    2202:	d20080e7          	jalr	-736(ra) # 5f1e <printf>
      exit(1);
    2206:	4505                	li	a0,1
    2208:	00004097          	auipc	ra,0x4
    220c:	986080e7          	jalr	-1658(ra) # 5b8e <exit>
      exit(1);
    2210:	4505                	li	a0,1
    2212:	00004097          	auipc	ra,0x4
    2216:	97c080e7          	jalr	-1668(ra) # 5b8e <exit>

000000000000221a <MAXVAplus>:
{
    221a:	7179                	add	sp,sp,-48
    221c:	f406                	sd	ra,40(sp)
    221e:	f022                	sd	s0,32(sp)
    2220:	ec26                	sd	s1,24(sp)
    2222:	e84a                	sd	s2,16(sp)
    2224:	1800                	add	s0,sp,48
  volatile uint64 a = MAXVA;
    2226:	4785                	li	a5,1
    2228:	179a                	sll	a5,a5,0x26
    222a:	fcf43c23          	sd	a5,-40(s0)
  for( ; a != 0; a <<= 1){
    222e:	fd843783          	ld	a5,-40(s0)
    2232:	cf85                	beqz	a5,226a <MAXVAplus+0x50>
    2234:	892a                	mv	s2,a0
    if(xstatus != -1)  // did kernel kill child?
    2236:	54fd                	li	s1,-1
    pid = fork();
    2238:	00004097          	auipc	ra,0x4
    223c:	94e080e7          	jalr	-1714(ra) # 5b86 <fork>
    if(pid < 0){
    2240:	02054b63          	bltz	a0,2276 <MAXVAplus+0x5c>
    if(pid == 0){
    2244:	c539                	beqz	a0,2292 <MAXVAplus+0x78>
    wait(&xstatus);
    2246:	fd440513          	add	a0,s0,-44
    224a:	00004097          	auipc	ra,0x4
    224e:	94c080e7          	jalr	-1716(ra) # 5b96 <wait>
    if(xstatus != -1)  // did kernel kill child?
    2252:	fd442783          	lw	a5,-44(s0)
    2256:	06979463          	bne	a5,s1,22be <MAXVAplus+0xa4>
  for( ; a != 0; a <<= 1){
    225a:	fd843783          	ld	a5,-40(s0)
    225e:	0786                	sll	a5,a5,0x1
    2260:	fcf43c23          	sd	a5,-40(s0)
    2264:	fd843783          	ld	a5,-40(s0)
    2268:	fbe1                	bnez	a5,2238 <MAXVAplus+0x1e>
}
    226a:	70a2                	ld	ra,40(sp)
    226c:	7402                	ld	s0,32(sp)
    226e:	64e2                	ld	s1,24(sp)
    2270:	6942                	ld	s2,16(sp)
    2272:	6145                	add	sp,sp,48
    2274:	8082                	ret
      printf("%s: fork failed\n", s);
    2276:	85ca                	mv	a1,s2
    2278:	00004517          	auipc	a0,0x4
    227c:	70850513          	add	a0,a0,1800 # 6980 <malloc+0x9aa>
    2280:	00004097          	auipc	ra,0x4
    2284:	c9e080e7          	jalr	-866(ra) # 5f1e <printf>
      exit(1);
    2288:	4505                	li	a0,1
    228a:	00004097          	auipc	ra,0x4
    228e:	904080e7          	jalr	-1788(ra) # 5b8e <exit>
      *(char*)a = 99;
    2292:	fd843783          	ld	a5,-40(s0)
    2296:	06300713          	li	a4,99
    229a:	00e78023          	sb	a4,0(a5)
      printf("%s: oops wrote %x\n", s, a);
    229e:	fd843603          	ld	a2,-40(s0)
    22a2:	85ca                	mv	a1,s2
    22a4:	00005517          	auipc	a0,0x5
    22a8:	9cc50513          	add	a0,a0,-1588 # 6c70 <malloc+0xc9a>
    22ac:	00004097          	auipc	ra,0x4
    22b0:	c72080e7          	jalr	-910(ra) # 5f1e <printf>
      exit(1);
    22b4:	4505                	li	a0,1
    22b6:	00004097          	auipc	ra,0x4
    22ba:	8d8080e7          	jalr	-1832(ra) # 5b8e <exit>
      exit(1);
    22be:	4505                	li	a0,1
    22c0:	00004097          	auipc	ra,0x4
    22c4:	8ce080e7          	jalr	-1842(ra) # 5b8e <exit>

00000000000022c8 <bigargtest>:
{
    22c8:	7179                	add	sp,sp,-48
    22ca:	f406                	sd	ra,40(sp)
    22cc:	f022                	sd	s0,32(sp)
    22ce:	ec26                	sd	s1,24(sp)
    22d0:	1800                	add	s0,sp,48
    22d2:	84aa                	mv	s1,a0
  unlink("bigarg-ok");
    22d4:	00005517          	auipc	a0,0x5
    22d8:	9b450513          	add	a0,a0,-1612 # 6c88 <malloc+0xcb2>
    22dc:	00004097          	auipc	ra,0x4
    22e0:	902080e7          	jalr	-1790(ra) # 5bde <unlink>
  pid = fork();
    22e4:	00004097          	auipc	ra,0x4
    22e8:	8a2080e7          	jalr	-1886(ra) # 5b86 <fork>
  if(pid == 0){
    22ec:	c121                	beqz	a0,232c <bigargtest+0x64>
  } else if(pid < 0){
    22ee:	0a054063          	bltz	a0,238e <bigargtest+0xc6>
  wait(&xstatus);
    22f2:	fdc40513          	add	a0,s0,-36
    22f6:	00004097          	auipc	ra,0x4
    22fa:	8a0080e7          	jalr	-1888(ra) # 5b96 <wait>
  if(xstatus != 0)
    22fe:	fdc42503          	lw	a0,-36(s0)
    2302:	e545                	bnez	a0,23aa <bigargtest+0xe2>
  fd = open("bigarg-ok", 0);
    2304:	4581                	li	a1,0
    2306:	00005517          	auipc	a0,0x5
    230a:	98250513          	add	a0,a0,-1662 # 6c88 <malloc+0xcb2>
    230e:	00004097          	auipc	ra,0x4
    2312:	8c0080e7          	jalr	-1856(ra) # 5bce <open>
  if(fd < 0){
    2316:	08054e63          	bltz	a0,23b2 <bigargtest+0xea>
  close(fd);
    231a:	00004097          	auipc	ra,0x4
    231e:	89c080e7          	jalr	-1892(ra) # 5bb6 <close>
}
    2322:	70a2                	ld	ra,40(sp)
    2324:	7402                	ld	s0,32(sp)
    2326:	64e2                	ld	s1,24(sp)
    2328:	6145                	add	sp,sp,48
    232a:	8082                	ret
    232c:	00007797          	auipc	a5,0x7
    2330:	12478793          	add	a5,a5,292 # 9450 <args.1>
    2334:	00007697          	auipc	a3,0x7
    2338:	21468693          	add	a3,a3,532 # 9548 <args.1+0xf8>
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    233c:	00005717          	auipc	a4,0x5
    2340:	95c70713          	add	a4,a4,-1700 # 6c98 <malloc+0xcc2>
    2344:	e398                	sd	a4,0(a5)
    for(i = 0; i < MAXARG-1; i++)
    2346:	07a1                	add	a5,a5,8
    2348:	fed79ee3          	bne	a5,a3,2344 <bigargtest+0x7c>
    args[MAXARG-1] = 0;
    234c:	00007597          	auipc	a1,0x7
    2350:	10458593          	add	a1,a1,260 # 9450 <args.1>
    2354:	0e05bc23          	sd	zero,248(a1)
    exec("echo", args);
    2358:	00004517          	auipc	a0,0x4
    235c:	da050513          	add	a0,a0,-608 # 60f8 <malloc+0x122>
    2360:	00004097          	auipc	ra,0x4
    2364:	866080e7          	jalr	-1946(ra) # 5bc6 <exec>
    fd = open("bigarg-ok", O_CREATE);
    2368:	20000593          	li	a1,512
    236c:	00005517          	auipc	a0,0x5
    2370:	91c50513          	add	a0,a0,-1764 # 6c88 <malloc+0xcb2>
    2374:	00004097          	auipc	ra,0x4
    2378:	85a080e7          	jalr	-1958(ra) # 5bce <open>
    close(fd);
    237c:	00004097          	auipc	ra,0x4
    2380:	83a080e7          	jalr	-1990(ra) # 5bb6 <close>
    exit(0);
    2384:	4501                	li	a0,0
    2386:	00004097          	auipc	ra,0x4
    238a:	808080e7          	jalr	-2040(ra) # 5b8e <exit>
    printf("%s: bigargtest: fork failed\n", s);
    238e:	85a6                	mv	a1,s1
    2390:	00005517          	auipc	a0,0x5
    2394:	9e850513          	add	a0,a0,-1560 # 6d78 <malloc+0xda2>
    2398:	00004097          	auipc	ra,0x4
    239c:	b86080e7          	jalr	-1146(ra) # 5f1e <printf>
    exit(1);
    23a0:	4505                	li	a0,1
    23a2:	00003097          	auipc	ra,0x3
    23a6:	7ec080e7          	jalr	2028(ra) # 5b8e <exit>
    exit(xstatus);
    23aa:	00003097          	auipc	ra,0x3
    23ae:	7e4080e7          	jalr	2020(ra) # 5b8e <exit>
    printf("%s: bigarg test failed!\n", s);
    23b2:	85a6                	mv	a1,s1
    23b4:	00005517          	auipc	a0,0x5
    23b8:	9e450513          	add	a0,a0,-1564 # 6d98 <malloc+0xdc2>
    23bc:	00004097          	auipc	ra,0x4
    23c0:	b62080e7          	jalr	-1182(ra) # 5f1e <printf>
    exit(1);
    23c4:	4505                	li	a0,1
    23c6:	00003097          	auipc	ra,0x3
    23ca:	7c8080e7          	jalr	1992(ra) # 5b8e <exit>

00000000000023ce <stacktest>:
{
    23ce:	7179                	add	sp,sp,-48
    23d0:	f406                	sd	ra,40(sp)
    23d2:	f022                	sd	s0,32(sp)
    23d4:	ec26                	sd	s1,24(sp)
    23d6:	1800                	add	s0,sp,48
    23d8:	84aa                	mv	s1,a0
  pid = fork();
    23da:	00003097          	auipc	ra,0x3
    23de:	7ac080e7          	jalr	1964(ra) # 5b86 <fork>
  if(pid == 0) {
    23e2:	c115                	beqz	a0,2406 <stacktest+0x38>
  } else if(pid < 0){
    23e4:	04054463          	bltz	a0,242c <stacktest+0x5e>
  wait(&xstatus);
    23e8:	fdc40513          	add	a0,s0,-36
    23ec:	00003097          	auipc	ra,0x3
    23f0:	7aa080e7          	jalr	1962(ra) # 5b96 <wait>
  if(xstatus == -1)  // kernel killed child?
    23f4:	fdc42503          	lw	a0,-36(s0)
    23f8:	57fd                	li	a5,-1
    23fa:	04f50763          	beq	a0,a5,2448 <stacktest+0x7a>
    exit(xstatus);
    23fe:	00003097          	auipc	ra,0x3
    2402:	790080e7          	jalr	1936(ra) # 5b8e <exit>

static inline uint64
r_sp()
{
  uint64 x;
  asm volatile("mv %0, sp" : "=r" (x) );
    2406:	870a                	mv	a4,sp
    printf("%s: stacktest: read below stack %p\n", s, *sp);
    2408:	77fd                	lui	a5,0xfffff
    240a:	97ba                	add	a5,a5,a4
    240c:	0007c603          	lbu	a2,0(a5) # fffffffffffff000 <base+0xfffffffffffef398>
    2410:	85a6                	mv	a1,s1
    2412:	00005517          	auipc	a0,0x5
    2416:	9a650513          	add	a0,a0,-1626 # 6db8 <malloc+0xde2>
    241a:	00004097          	auipc	ra,0x4
    241e:	b04080e7          	jalr	-1276(ra) # 5f1e <printf>
    exit(1);
    2422:	4505                	li	a0,1
    2424:	00003097          	auipc	ra,0x3
    2428:	76a080e7          	jalr	1898(ra) # 5b8e <exit>
    printf("%s: fork failed\n", s);
    242c:	85a6                	mv	a1,s1
    242e:	00004517          	auipc	a0,0x4
    2432:	55250513          	add	a0,a0,1362 # 6980 <malloc+0x9aa>
    2436:	00004097          	auipc	ra,0x4
    243a:	ae8080e7          	jalr	-1304(ra) # 5f1e <printf>
    exit(1);
    243e:	4505                	li	a0,1
    2440:	00003097          	auipc	ra,0x3
    2444:	74e080e7          	jalr	1870(ra) # 5b8e <exit>
    exit(0);
    2448:	4501                	li	a0,0
    244a:	00003097          	auipc	ra,0x3
    244e:	744080e7          	jalr	1860(ra) # 5b8e <exit>

0000000000002452 <textwrite>:
{
    2452:	7179                	add	sp,sp,-48
    2454:	f406                	sd	ra,40(sp)
    2456:	f022                	sd	s0,32(sp)
    2458:	ec26                	sd	s1,24(sp)
    245a:	1800                	add	s0,sp,48
    245c:	84aa                	mv	s1,a0
  pid = fork();
    245e:	00003097          	auipc	ra,0x3
    2462:	728080e7          	jalr	1832(ra) # 5b86 <fork>
  if(pid == 0) {
    2466:	c115                	beqz	a0,248a <textwrite+0x38>
  } else if(pid < 0){
    2468:	02054963          	bltz	a0,249a <textwrite+0x48>
  wait(&xstatus);
    246c:	fdc40513          	add	a0,s0,-36
    2470:	00003097          	auipc	ra,0x3
    2474:	726080e7          	jalr	1830(ra) # 5b96 <wait>
  if(xstatus == -1)  // kernel killed child?
    2478:	fdc42503          	lw	a0,-36(s0)
    247c:	57fd                	li	a5,-1
    247e:	02f50c63          	beq	a0,a5,24b6 <textwrite+0x64>
    exit(xstatus);
    2482:	00003097          	auipc	ra,0x3
    2486:	70c080e7          	jalr	1804(ra) # 5b8e <exit>
    *addr = 10;
    248a:	47a9                	li	a5,10
    248c:	00f02023          	sw	a5,0(zero) # 0 <copyinstr1>
    exit(1);
    2490:	4505                	li	a0,1
    2492:	00003097          	auipc	ra,0x3
    2496:	6fc080e7          	jalr	1788(ra) # 5b8e <exit>
    printf("%s: fork failed\n", s);
    249a:	85a6                	mv	a1,s1
    249c:	00004517          	auipc	a0,0x4
    24a0:	4e450513          	add	a0,a0,1252 # 6980 <malloc+0x9aa>
    24a4:	00004097          	auipc	ra,0x4
    24a8:	a7a080e7          	jalr	-1414(ra) # 5f1e <printf>
    exit(1);
    24ac:	4505                	li	a0,1
    24ae:	00003097          	auipc	ra,0x3
    24b2:	6e0080e7          	jalr	1760(ra) # 5b8e <exit>
    exit(0);
    24b6:	4501                	li	a0,0
    24b8:	00003097          	auipc	ra,0x3
    24bc:	6d6080e7          	jalr	1750(ra) # 5b8e <exit>

00000000000024c0 <manywrites>:
{
    24c0:	711d                	add	sp,sp,-96
    24c2:	ec86                	sd	ra,88(sp)
    24c4:	e8a2                	sd	s0,80(sp)
    24c6:	e4a6                	sd	s1,72(sp)
    24c8:	e0ca                	sd	s2,64(sp)
    24ca:	fc4e                	sd	s3,56(sp)
    24cc:	f852                	sd	s4,48(sp)
    24ce:	f456                	sd	s5,40(sp)
    24d0:	f05a                	sd	s6,32(sp)
    24d2:	ec5e                	sd	s7,24(sp)
    24d4:	1080                	add	s0,sp,96
    24d6:	8aaa                	mv	s5,a0
  for(int ci = 0; ci < nchildren; ci++){
    24d8:	4981                	li	s3,0
    24da:	4911                	li	s2,4
    int pid = fork();
    24dc:	00003097          	auipc	ra,0x3
    24e0:	6aa080e7          	jalr	1706(ra) # 5b86 <fork>
    24e4:	84aa                	mv	s1,a0
    if(pid < 0){
    24e6:	02054963          	bltz	a0,2518 <manywrites+0x58>
    if(pid == 0){
    24ea:	c521                	beqz	a0,2532 <manywrites+0x72>
  for(int ci = 0; ci < nchildren; ci++){
    24ec:	2985                	addw	s3,s3,1
    24ee:	ff2997e3          	bne	s3,s2,24dc <manywrites+0x1c>
    24f2:	4491                	li	s1,4
    int st = 0;
    24f4:	fa042423          	sw	zero,-88(s0)
    wait(&st);
    24f8:	fa840513          	add	a0,s0,-88
    24fc:	00003097          	auipc	ra,0x3
    2500:	69a080e7          	jalr	1690(ra) # 5b96 <wait>
    if(st != 0)
    2504:	fa842503          	lw	a0,-88(s0)
    2508:	ed6d                	bnez	a0,2602 <manywrites+0x142>
  for(int ci = 0; ci < nchildren; ci++){
    250a:	34fd                	addw	s1,s1,-1
    250c:	f4e5                	bnez	s1,24f4 <manywrites+0x34>
  exit(0);
    250e:	4501                	li	a0,0
    2510:	00003097          	auipc	ra,0x3
    2514:	67e080e7          	jalr	1662(ra) # 5b8e <exit>
      printf("fork failed\n");
    2518:	00005517          	auipc	a0,0x5
    251c:	87050513          	add	a0,a0,-1936 # 6d88 <malloc+0xdb2>
    2520:	00004097          	auipc	ra,0x4
    2524:	9fe080e7          	jalr	-1538(ra) # 5f1e <printf>
      exit(1);
    2528:	4505                	li	a0,1
    252a:	00003097          	auipc	ra,0x3
    252e:	664080e7          	jalr	1636(ra) # 5b8e <exit>
      name[0] = 'b';
    2532:	06200793          	li	a5,98
    2536:	faf40423          	sb	a5,-88(s0)
      name[1] = 'a' + ci;
    253a:	0619879b          	addw	a5,s3,97
    253e:	faf404a3          	sb	a5,-87(s0)
      name[2] = '\0';
    2542:	fa040523          	sb	zero,-86(s0)
      unlink(name);
    2546:	fa840513          	add	a0,s0,-88
    254a:	00003097          	auipc	ra,0x3
    254e:	694080e7          	jalr	1684(ra) # 5bde <unlink>
    2552:	4bf9                	li	s7,30
          int cc = write(fd, buf, sz);
    2554:	0000ab17          	auipc	s6,0xa
    2558:	714b0b13          	add	s6,s6,1812 # cc68 <buf>
        for(int i = 0; i < ci+1; i++){
    255c:	8a26                	mv	s4,s1
    255e:	0209ce63          	bltz	s3,259a <manywrites+0xda>
          int fd = open(name, O_CREATE | O_RDWR);
    2562:	20200593          	li	a1,514
    2566:	fa840513          	add	a0,s0,-88
    256a:	00003097          	auipc	ra,0x3
    256e:	664080e7          	jalr	1636(ra) # 5bce <open>
    2572:	892a                	mv	s2,a0
          if(fd < 0){
    2574:	04054763          	bltz	a0,25c2 <manywrites+0x102>
          int cc = write(fd, buf, sz);
    2578:	660d                	lui	a2,0x3
    257a:	85da                	mv	a1,s6
    257c:	00003097          	auipc	ra,0x3
    2580:	632080e7          	jalr	1586(ra) # 5bae <write>
          if(cc != sz){
    2584:	678d                	lui	a5,0x3
    2586:	04f51e63          	bne	a0,a5,25e2 <manywrites+0x122>
          close(fd);
    258a:	854a                	mv	a0,s2
    258c:	00003097          	auipc	ra,0x3
    2590:	62a080e7          	jalr	1578(ra) # 5bb6 <close>
        for(int i = 0; i < ci+1; i++){
    2594:	2a05                	addw	s4,s4,1
    2596:	fd49d6e3          	bge	s3,s4,2562 <manywrites+0xa2>
        unlink(name);
    259a:	fa840513          	add	a0,s0,-88
    259e:	00003097          	auipc	ra,0x3
    25a2:	640080e7          	jalr	1600(ra) # 5bde <unlink>
      for(int iters = 0; iters < howmany; iters++){
    25a6:	3bfd                	addw	s7,s7,-1
    25a8:	fa0b9ae3          	bnez	s7,255c <manywrites+0x9c>
      unlink(name);
    25ac:	fa840513          	add	a0,s0,-88
    25b0:	00003097          	auipc	ra,0x3
    25b4:	62e080e7          	jalr	1582(ra) # 5bde <unlink>
      exit(0);
    25b8:	4501                	li	a0,0
    25ba:	00003097          	auipc	ra,0x3
    25be:	5d4080e7          	jalr	1492(ra) # 5b8e <exit>
            printf("%s: cannot create %s\n", s, name);
    25c2:	fa840613          	add	a2,s0,-88
    25c6:	85d6                	mv	a1,s5
    25c8:	00005517          	auipc	a0,0x5
    25cc:	81850513          	add	a0,a0,-2024 # 6de0 <malloc+0xe0a>
    25d0:	00004097          	auipc	ra,0x4
    25d4:	94e080e7          	jalr	-1714(ra) # 5f1e <printf>
            exit(1);
    25d8:	4505                	li	a0,1
    25da:	00003097          	auipc	ra,0x3
    25de:	5b4080e7          	jalr	1460(ra) # 5b8e <exit>
            printf("%s: write(%d) ret %d\n", s, sz, cc);
    25e2:	86aa                	mv	a3,a0
    25e4:	660d                	lui	a2,0x3
    25e6:	85d6                	mv	a1,s5
    25e8:	00004517          	auipc	a0,0x4
    25ec:	be050513          	add	a0,a0,-1056 # 61c8 <malloc+0x1f2>
    25f0:	00004097          	auipc	ra,0x4
    25f4:	92e080e7          	jalr	-1746(ra) # 5f1e <printf>
            exit(1);
    25f8:	4505                	li	a0,1
    25fa:	00003097          	auipc	ra,0x3
    25fe:	594080e7          	jalr	1428(ra) # 5b8e <exit>
      exit(st);
    2602:	00003097          	auipc	ra,0x3
    2606:	58c080e7          	jalr	1420(ra) # 5b8e <exit>

000000000000260a <copyinstr3>:
{
    260a:	7179                	add	sp,sp,-48
    260c:	f406                	sd	ra,40(sp)
    260e:	f022                	sd	s0,32(sp)
    2610:	ec26                	sd	s1,24(sp)
    2612:	1800                	add	s0,sp,48
  sbrk(8192);
    2614:	6509                	lui	a0,0x2
    2616:	00003097          	auipc	ra,0x3
    261a:	600080e7          	jalr	1536(ra) # 5c16 <sbrk>
  uint64 top = (uint64) sbrk(0);
    261e:	4501                	li	a0,0
    2620:	00003097          	auipc	ra,0x3
    2624:	5f6080e7          	jalr	1526(ra) # 5c16 <sbrk>
  if((top % PGSIZE) != 0){
    2628:	03451793          	sll	a5,a0,0x34
    262c:	e3c9                	bnez	a5,26ae <copyinstr3+0xa4>
  top = (uint64) sbrk(0);
    262e:	4501                	li	a0,0
    2630:	00003097          	auipc	ra,0x3
    2634:	5e6080e7          	jalr	1510(ra) # 5c16 <sbrk>
  if(top % PGSIZE){
    2638:	03451793          	sll	a5,a0,0x34
    263c:	e3d9                	bnez	a5,26c2 <copyinstr3+0xb8>
  char *b = (char *) (top - 1);
    263e:	fff50493          	add	s1,a0,-1 # 1fff <linkunlink+0x73>
  *b = 'x';
    2642:	07800793          	li	a5,120
    2646:	fef50fa3          	sb	a5,-1(a0)
  int ret = unlink(b);
    264a:	8526                	mv	a0,s1
    264c:	00003097          	auipc	ra,0x3
    2650:	592080e7          	jalr	1426(ra) # 5bde <unlink>
  if(ret != -1){
    2654:	57fd                	li	a5,-1
    2656:	08f51363          	bne	a0,a5,26dc <copyinstr3+0xd2>
  int fd = open(b, O_CREATE | O_WRONLY);
    265a:	20100593          	li	a1,513
    265e:	8526                	mv	a0,s1
    2660:	00003097          	auipc	ra,0x3
    2664:	56e080e7          	jalr	1390(ra) # 5bce <open>
  if(fd != -1){
    2668:	57fd                	li	a5,-1
    266a:	08f51863          	bne	a0,a5,26fa <copyinstr3+0xf0>
  ret = link(b, b);
    266e:	85a6                	mv	a1,s1
    2670:	8526                	mv	a0,s1
    2672:	00003097          	auipc	ra,0x3
    2676:	57c080e7          	jalr	1404(ra) # 5bee <link>
  if(ret != -1){
    267a:	57fd                	li	a5,-1
    267c:	08f51e63          	bne	a0,a5,2718 <copyinstr3+0x10e>
  char *args[] = { "xx", 0 };
    2680:	00005797          	auipc	a5,0x5
    2684:	3a878793          	add	a5,a5,936 # 7a28 <malloc+0x1a52>
    2688:	fcf43823          	sd	a5,-48(s0)
    268c:	fc043c23          	sd	zero,-40(s0)
  ret = exec(b, args);
    2690:	fd040593          	add	a1,s0,-48
    2694:	8526                	mv	a0,s1
    2696:	00003097          	auipc	ra,0x3
    269a:	530080e7          	jalr	1328(ra) # 5bc6 <exec>
  if(ret != -1){
    269e:	57fd                	li	a5,-1
    26a0:	08f51c63          	bne	a0,a5,2738 <copyinstr3+0x12e>
}
    26a4:	70a2                	ld	ra,40(sp)
    26a6:	7402                	ld	s0,32(sp)
    26a8:	64e2                	ld	s1,24(sp)
    26aa:	6145                	add	sp,sp,48
    26ac:	8082                	ret
    sbrk(PGSIZE - (top % PGSIZE));
    26ae:	0347d513          	srl	a0,a5,0x34
    26b2:	6785                	lui	a5,0x1
    26b4:	40a7853b          	subw	a0,a5,a0
    26b8:	00003097          	auipc	ra,0x3
    26bc:	55e080e7          	jalr	1374(ra) # 5c16 <sbrk>
    26c0:	b7bd                	j	262e <copyinstr3+0x24>
    printf("oops\n");
    26c2:	00004517          	auipc	a0,0x4
    26c6:	73650513          	add	a0,a0,1846 # 6df8 <malloc+0xe22>
    26ca:	00004097          	auipc	ra,0x4
    26ce:	854080e7          	jalr	-1964(ra) # 5f1e <printf>
    exit(1);
    26d2:	4505                	li	a0,1
    26d4:	00003097          	auipc	ra,0x3
    26d8:	4ba080e7          	jalr	1210(ra) # 5b8e <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    26dc:	862a                	mv	a2,a0
    26de:	85a6                	mv	a1,s1
    26e0:	00004517          	auipc	a0,0x4
    26e4:	1c050513          	add	a0,a0,448 # 68a0 <malloc+0x8ca>
    26e8:	00004097          	auipc	ra,0x4
    26ec:	836080e7          	jalr	-1994(ra) # 5f1e <printf>
    exit(1);
    26f0:	4505                	li	a0,1
    26f2:	00003097          	auipc	ra,0x3
    26f6:	49c080e7          	jalr	1180(ra) # 5b8e <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    26fa:	862a                	mv	a2,a0
    26fc:	85a6                	mv	a1,s1
    26fe:	00004517          	auipc	a0,0x4
    2702:	1c250513          	add	a0,a0,450 # 68c0 <malloc+0x8ea>
    2706:	00004097          	auipc	ra,0x4
    270a:	818080e7          	jalr	-2024(ra) # 5f1e <printf>
    exit(1);
    270e:	4505                	li	a0,1
    2710:	00003097          	auipc	ra,0x3
    2714:	47e080e7          	jalr	1150(ra) # 5b8e <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    2718:	86aa                	mv	a3,a0
    271a:	8626                	mv	a2,s1
    271c:	85a6                	mv	a1,s1
    271e:	00004517          	auipc	a0,0x4
    2722:	1c250513          	add	a0,a0,450 # 68e0 <malloc+0x90a>
    2726:	00003097          	auipc	ra,0x3
    272a:	7f8080e7          	jalr	2040(ra) # 5f1e <printf>
    exit(1);
    272e:	4505                	li	a0,1
    2730:	00003097          	auipc	ra,0x3
    2734:	45e080e7          	jalr	1118(ra) # 5b8e <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    2738:	567d                	li	a2,-1
    273a:	85a6                	mv	a1,s1
    273c:	00004517          	auipc	a0,0x4
    2740:	1cc50513          	add	a0,a0,460 # 6908 <malloc+0x932>
    2744:	00003097          	auipc	ra,0x3
    2748:	7da080e7          	jalr	2010(ra) # 5f1e <printf>
    exit(1);
    274c:	4505                	li	a0,1
    274e:	00003097          	auipc	ra,0x3
    2752:	440080e7          	jalr	1088(ra) # 5b8e <exit>

0000000000002756 <sbrkbasic>:
{
    2756:	7139                	add	sp,sp,-64
    2758:	fc06                	sd	ra,56(sp)
    275a:	f822                	sd	s0,48(sp)
    275c:	f426                	sd	s1,40(sp)
    275e:	f04a                	sd	s2,32(sp)
    2760:	ec4e                	sd	s3,24(sp)
    2762:	e852                	sd	s4,16(sp)
    2764:	0080                	add	s0,sp,64
    2766:	8a2a                	mv	s4,a0
  pid = fork();
    2768:	00003097          	auipc	ra,0x3
    276c:	41e080e7          	jalr	1054(ra) # 5b86 <fork>
  if(pid < 0){
    2770:	02054c63          	bltz	a0,27a8 <sbrkbasic+0x52>
  if(pid == 0){
    2774:	ed21                	bnez	a0,27cc <sbrkbasic+0x76>
    a = sbrk(TOOMUCH);
    2776:	40000537          	lui	a0,0x40000
    277a:	00003097          	auipc	ra,0x3
    277e:	49c080e7          	jalr	1180(ra) # 5c16 <sbrk>
    if(a == (char*)0xffffffffffffffffL){
    2782:	57fd                	li	a5,-1
    2784:	02f50f63          	beq	a0,a5,27c2 <sbrkbasic+0x6c>
    for(b = a; b < a+TOOMUCH; b += 4096){
    2788:	400007b7          	lui	a5,0x40000
    278c:	97aa                	add	a5,a5,a0
      *b = 99;
    278e:	06300693          	li	a3,99
    for(b = a; b < a+TOOMUCH; b += 4096){
    2792:	6705                	lui	a4,0x1
      *b = 99;
    2794:	00d50023          	sb	a3,0(a0) # 40000000 <base+0x3fff0398>
    for(b = a; b < a+TOOMUCH; b += 4096){
    2798:	953a                	add	a0,a0,a4
    279a:	fef51de3          	bne	a0,a5,2794 <sbrkbasic+0x3e>
    exit(1);
    279e:	4505                	li	a0,1
    27a0:	00003097          	auipc	ra,0x3
    27a4:	3ee080e7          	jalr	1006(ra) # 5b8e <exit>
    printf("fork failed in sbrkbasic\n");
    27a8:	00004517          	auipc	a0,0x4
    27ac:	65850513          	add	a0,a0,1624 # 6e00 <malloc+0xe2a>
    27b0:	00003097          	auipc	ra,0x3
    27b4:	76e080e7          	jalr	1902(ra) # 5f1e <printf>
    exit(1);
    27b8:	4505                	li	a0,1
    27ba:	00003097          	auipc	ra,0x3
    27be:	3d4080e7          	jalr	980(ra) # 5b8e <exit>
      exit(0);
    27c2:	4501                	li	a0,0
    27c4:	00003097          	auipc	ra,0x3
    27c8:	3ca080e7          	jalr	970(ra) # 5b8e <exit>
  wait(&xstatus);
    27cc:	fcc40513          	add	a0,s0,-52
    27d0:	00003097          	auipc	ra,0x3
    27d4:	3c6080e7          	jalr	966(ra) # 5b96 <wait>
  if(xstatus == 1){
    27d8:	fcc42703          	lw	a4,-52(s0)
    27dc:	4785                	li	a5,1
    27de:	00f70d63          	beq	a4,a5,27f8 <sbrkbasic+0xa2>
  a = sbrk(0);
    27e2:	4501                	li	a0,0
    27e4:	00003097          	auipc	ra,0x3
    27e8:	432080e7          	jalr	1074(ra) # 5c16 <sbrk>
    27ec:	84aa                	mv	s1,a0
  for(i = 0; i < 5000; i++){
    27ee:	4901                	li	s2,0
    27f0:	6985                	lui	s3,0x1
    27f2:	38898993          	add	s3,s3,904 # 1388 <badarg+0x3e>
    27f6:	a005                	j	2816 <sbrkbasic+0xc0>
    printf("%s: too much memory allocated!\n", s);
    27f8:	85d2                	mv	a1,s4
    27fa:	00004517          	auipc	a0,0x4
    27fe:	62650513          	add	a0,a0,1574 # 6e20 <malloc+0xe4a>
    2802:	00003097          	auipc	ra,0x3
    2806:	71c080e7          	jalr	1820(ra) # 5f1e <printf>
    exit(1);
    280a:	4505                	li	a0,1
    280c:	00003097          	auipc	ra,0x3
    2810:	382080e7          	jalr	898(ra) # 5b8e <exit>
    a = b + 1;
    2814:	84be                	mv	s1,a5
    b = sbrk(1);
    2816:	4505                	li	a0,1
    2818:	00003097          	auipc	ra,0x3
    281c:	3fe080e7          	jalr	1022(ra) # 5c16 <sbrk>
    if(b != a){
    2820:	04951c63          	bne	a0,s1,2878 <sbrkbasic+0x122>
    *b = 1;
    2824:	4785                	li	a5,1
    2826:	00f48023          	sb	a5,0(s1)
    a = b + 1;
    282a:	00148793          	add	a5,s1,1
  for(i = 0; i < 5000; i++){
    282e:	2905                	addw	s2,s2,1
    2830:	ff3912e3          	bne	s2,s3,2814 <sbrkbasic+0xbe>
  pid = fork();
    2834:	00003097          	auipc	ra,0x3
    2838:	352080e7          	jalr	850(ra) # 5b86 <fork>
    283c:	892a                	mv	s2,a0
  if(pid < 0){
    283e:	04054e63          	bltz	a0,289a <sbrkbasic+0x144>
  c = sbrk(1);
    2842:	4505                	li	a0,1
    2844:	00003097          	auipc	ra,0x3
    2848:	3d2080e7          	jalr	978(ra) # 5c16 <sbrk>
  c = sbrk(1);
    284c:	4505                	li	a0,1
    284e:	00003097          	auipc	ra,0x3
    2852:	3c8080e7          	jalr	968(ra) # 5c16 <sbrk>
  if(c != a + 1){
    2856:	0489                	add	s1,s1,2
    2858:	04a48f63          	beq	s1,a0,28b6 <sbrkbasic+0x160>
    printf("%s: sbrk test failed post-fork\n", s);
    285c:	85d2                	mv	a1,s4
    285e:	00004517          	auipc	a0,0x4
    2862:	62250513          	add	a0,a0,1570 # 6e80 <malloc+0xeaa>
    2866:	00003097          	auipc	ra,0x3
    286a:	6b8080e7          	jalr	1720(ra) # 5f1e <printf>
    exit(1);
    286e:	4505                	li	a0,1
    2870:	00003097          	auipc	ra,0x3
    2874:	31e080e7          	jalr	798(ra) # 5b8e <exit>
      printf("%s: sbrk test failed %d %x %x\n", s, i, a, b);
    2878:	872a                	mv	a4,a0
    287a:	86a6                	mv	a3,s1
    287c:	864a                	mv	a2,s2
    287e:	85d2                	mv	a1,s4
    2880:	00004517          	auipc	a0,0x4
    2884:	5c050513          	add	a0,a0,1472 # 6e40 <malloc+0xe6a>
    2888:	00003097          	auipc	ra,0x3
    288c:	696080e7          	jalr	1686(ra) # 5f1e <printf>
      exit(1);
    2890:	4505                	li	a0,1
    2892:	00003097          	auipc	ra,0x3
    2896:	2fc080e7          	jalr	764(ra) # 5b8e <exit>
    printf("%s: sbrk test fork failed\n", s);
    289a:	85d2                	mv	a1,s4
    289c:	00004517          	auipc	a0,0x4
    28a0:	5c450513          	add	a0,a0,1476 # 6e60 <malloc+0xe8a>
    28a4:	00003097          	auipc	ra,0x3
    28a8:	67a080e7          	jalr	1658(ra) # 5f1e <printf>
    exit(1);
    28ac:	4505                	li	a0,1
    28ae:	00003097          	auipc	ra,0x3
    28b2:	2e0080e7          	jalr	736(ra) # 5b8e <exit>
  if(pid == 0)
    28b6:	00091763          	bnez	s2,28c4 <sbrkbasic+0x16e>
    exit(0);
    28ba:	4501                	li	a0,0
    28bc:	00003097          	auipc	ra,0x3
    28c0:	2d2080e7          	jalr	722(ra) # 5b8e <exit>
  wait(&xstatus);
    28c4:	fcc40513          	add	a0,s0,-52
    28c8:	00003097          	auipc	ra,0x3
    28cc:	2ce080e7          	jalr	718(ra) # 5b96 <wait>
  exit(xstatus);
    28d0:	fcc42503          	lw	a0,-52(s0)
    28d4:	00003097          	auipc	ra,0x3
    28d8:	2ba080e7          	jalr	698(ra) # 5b8e <exit>

00000000000028dc <sbrkmuch>:
{
    28dc:	7179                	add	sp,sp,-48
    28de:	f406                	sd	ra,40(sp)
    28e0:	f022                	sd	s0,32(sp)
    28e2:	ec26                	sd	s1,24(sp)
    28e4:	e84a                	sd	s2,16(sp)
    28e6:	e44e                	sd	s3,8(sp)
    28e8:	e052                	sd	s4,0(sp)
    28ea:	1800                	add	s0,sp,48
    28ec:	89aa                	mv	s3,a0
  oldbrk = sbrk(0);
    28ee:	4501                	li	a0,0
    28f0:	00003097          	auipc	ra,0x3
    28f4:	326080e7          	jalr	806(ra) # 5c16 <sbrk>
    28f8:	892a                	mv	s2,a0
  a = sbrk(0);
    28fa:	4501                	li	a0,0
    28fc:	00003097          	auipc	ra,0x3
    2900:	31a080e7          	jalr	794(ra) # 5c16 <sbrk>
    2904:	84aa                	mv	s1,a0
  p = sbrk(amt);
    2906:	06400537          	lui	a0,0x6400
    290a:	9d05                	subw	a0,a0,s1
    290c:	00003097          	auipc	ra,0x3
    2910:	30a080e7          	jalr	778(ra) # 5c16 <sbrk>
  if (p != a) {
    2914:	0ca49863          	bne	s1,a0,29e4 <sbrkmuch+0x108>
  char *eee = sbrk(0);
    2918:	4501                	li	a0,0
    291a:	00003097          	auipc	ra,0x3
    291e:	2fc080e7          	jalr	764(ra) # 5c16 <sbrk>
    2922:	87aa                	mv	a5,a0
  for(char *pp = a; pp < eee; pp += 4096)
    2924:	00a4f963          	bgeu	s1,a0,2936 <sbrkmuch+0x5a>
    *pp = 1;
    2928:	4685                	li	a3,1
  for(char *pp = a; pp < eee; pp += 4096)
    292a:	6705                	lui	a4,0x1
    *pp = 1;
    292c:	00d48023          	sb	a3,0(s1)
  for(char *pp = a; pp < eee; pp += 4096)
    2930:	94ba                	add	s1,s1,a4
    2932:	fef4ede3          	bltu	s1,a5,292c <sbrkmuch+0x50>
  *lastaddr = 99;
    2936:	064007b7          	lui	a5,0x6400
    293a:	06300713          	li	a4,99
    293e:	fee78fa3          	sb	a4,-1(a5) # 63fffff <base+0x63f0397>
  a = sbrk(0);
    2942:	4501                	li	a0,0
    2944:	00003097          	auipc	ra,0x3
    2948:	2d2080e7          	jalr	722(ra) # 5c16 <sbrk>
    294c:	84aa                	mv	s1,a0
  c = sbrk(-PGSIZE);
    294e:	757d                	lui	a0,0xfffff
    2950:	00003097          	auipc	ra,0x3
    2954:	2c6080e7          	jalr	710(ra) # 5c16 <sbrk>
  if(c == (char*)0xffffffffffffffffL){
    2958:	57fd                	li	a5,-1
    295a:	0af50363          	beq	a0,a5,2a00 <sbrkmuch+0x124>
  c = sbrk(0);
    295e:	4501                	li	a0,0
    2960:	00003097          	auipc	ra,0x3
    2964:	2b6080e7          	jalr	694(ra) # 5c16 <sbrk>
  if(c != a - PGSIZE){
    2968:	77fd                	lui	a5,0xfffff
    296a:	97a6                	add	a5,a5,s1
    296c:	0af51863          	bne	a0,a5,2a1c <sbrkmuch+0x140>
  a = sbrk(0);
    2970:	4501                	li	a0,0
    2972:	00003097          	auipc	ra,0x3
    2976:	2a4080e7          	jalr	676(ra) # 5c16 <sbrk>
    297a:	84aa                	mv	s1,a0
  c = sbrk(PGSIZE);
    297c:	6505                	lui	a0,0x1
    297e:	00003097          	auipc	ra,0x3
    2982:	298080e7          	jalr	664(ra) # 5c16 <sbrk>
    2986:	8a2a                	mv	s4,a0
  if(c != a || sbrk(0) != a + PGSIZE){
    2988:	0aa49a63          	bne	s1,a0,2a3c <sbrkmuch+0x160>
    298c:	4501                	li	a0,0
    298e:	00003097          	auipc	ra,0x3
    2992:	288080e7          	jalr	648(ra) # 5c16 <sbrk>
    2996:	6785                	lui	a5,0x1
    2998:	97a6                	add	a5,a5,s1
    299a:	0af51163          	bne	a0,a5,2a3c <sbrkmuch+0x160>
  if(*lastaddr == 99){
    299e:	064007b7          	lui	a5,0x6400
    29a2:	fff7c703          	lbu	a4,-1(a5) # 63fffff <base+0x63f0397>
    29a6:	06300793          	li	a5,99
    29aa:	0af70963          	beq	a4,a5,2a5c <sbrkmuch+0x180>
  a = sbrk(0);
    29ae:	4501                	li	a0,0
    29b0:	00003097          	auipc	ra,0x3
    29b4:	266080e7          	jalr	614(ra) # 5c16 <sbrk>
    29b8:	84aa                	mv	s1,a0
  c = sbrk(-(sbrk(0) - oldbrk));
    29ba:	4501                	li	a0,0
    29bc:	00003097          	auipc	ra,0x3
    29c0:	25a080e7          	jalr	602(ra) # 5c16 <sbrk>
    29c4:	40a9053b          	subw	a0,s2,a0
    29c8:	00003097          	auipc	ra,0x3
    29cc:	24e080e7          	jalr	590(ra) # 5c16 <sbrk>
  if(c != a){
    29d0:	0aa49463          	bne	s1,a0,2a78 <sbrkmuch+0x19c>
}
    29d4:	70a2                	ld	ra,40(sp)
    29d6:	7402                	ld	s0,32(sp)
    29d8:	64e2                	ld	s1,24(sp)
    29da:	6942                	ld	s2,16(sp)
    29dc:	69a2                	ld	s3,8(sp)
    29de:	6a02                	ld	s4,0(sp)
    29e0:	6145                	add	sp,sp,48
    29e2:	8082                	ret
    printf("%s: sbrk test failed to grow big address space; enough phys mem?\n", s);
    29e4:	85ce                	mv	a1,s3
    29e6:	00004517          	auipc	a0,0x4
    29ea:	4ba50513          	add	a0,a0,1210 # 6ea0 <malloc+0xeca>
    29ee:	00003097          	auipc	ra,0x3
    29f2:	530080e7          	jalr	1328(ra) # 5f1e <printf>
    exit(1);
    29f6:	4505                	li	a0,1
    29f8:	00003097          	auipc	ra,0x3
    29fc:	196080e7          	jalr	406(ra) # 5b8e <exit>
    printf("%s: sbrk could not deallocate\n", s);
    2a00:	85ce                	mv	a1,s3
    2a02:	00004517          	auipc	a0,0x4
    2a06:	4e650513          	add	a0,a0,1254 # 6ee8 <malloc+0xf12>
    2a0a:	00003097          	auipc	ra,0x3
    2a0e:	514080e7          	jalr	1300(ra) # 5f1e <printf>
    exit(1);
    2a12:	4505                	li	a0,1
    2a14:	00003097          	auipc	ra,0x3
    2a18:	17a080e7          	jalr	378(ra) # 5b8e <exit>
    printf("%s: sbrk deallocation produced wrong address, a %x c %x\n", s, a, c);
    2a1c:	86aa                	mv	a3,a0
    2a1e:	8626                	mv	a2,s1
    2a20:	85ce                	mv	a1,s3
    2a22:	00004517          	auipc	a0,0x4
    2a26:	4e650513          	add	a0,a0,1254 # 6f08 <malloc+0xf32>
    2a2a:	00003097          	auipc	ra,0x3
    2a2e:	4f4080e7          	jalr	1268(ra) # 5f1e <printf>
    exit(1);
    2a32:	4505                	li	a0,1
    2a34:	00003097          	auipc	ra,0x3
    2a38:	15a080e7          	jalr	346(ra) # 5b8e <exit>
    printf("%s: sbrk re-allocation failed, a %x c %x\n", s, a, c);
    2a3c:	86d2                	mv	a3,s4
    2a3e:	8626                	mv	a2,s1
    2a40:	85ce                	mv	a1,s3
    2a42:	00004517          	auipc	a0,0x4
    2a46:	50650513          	add	a0,a0,1286 # 6f48 <malloc+0xf72>
    2a4a:	00003097          	auipc	ra,0x3
    2a4e:	4d4080e7          	jalr	1236(ra) # 5f1e <printf>
    exit(1);
    2a52:	4505                	li	a0,1
    2a54:	00003097          	auipc	ra,0x3
    2a58:	13a080e7          	jalr	314(ra) # 5b8e <exit>
    printf("%s: sbrk de-allocation didn't really deallocate\n", s);
    2a5c:	85ce                	mv	a1,s3
    2a5e:	00004517          	auipc	a0,0x4
    2a62:	51a50513          	add	a0,a0,1306 # 6f78 <malloc+0xfa2>
    2a66:	00003097          	auipc	ra,0x3
    2a6a:	4b8080e7          	jalr	1208(ra) # 5f1e <printf>
    exit(1);
    2a6e:	4505                	li	a0,1
    2a70:	00003097          	auipc	ra,0x3
    2a74:	11e080e7          	jalr	286(ra) # 5b8e <exit>
    printf("%s: sbrk downsize failed, a %x c %x\n", s, a, c);
    2a78:	86aa                	mv	a3,a0
    2a7a:	8626                	mv	a2,s1
    2a7c:	85ce                	mv	a1,s3
    2a7e:	00004517          	auipc	a0,0x4
    2a82:	53250513          	add	a0,a0,1330 # 6fb0 <malloc+0xfda>
    2a86:	00003097          	auipc	ra,0x3
    2a8a:	498080e7          	jalr	1176(ra) # 5f1e <printf>
    exit(1);
    2a8e:	4505                	li	a0,1
    2a90:	00003097          	auipc	ra,0x3
    2a94:	0fe080e7          	jalr	254(ra) # 5b8e <exit>

0000000000002a98 <sbrkarg>:
{
    2a98:	7179                	add	sp,sp,-48
    2a9a:	f406                	sd	ra,40(sp)
    2a9c:	f022                	sd	s0,32(sp)
    2a9e:	ec26                	sd	s1,24(sp)
    2aa0:	e84a                	sd	s2,16(sp)
    2aa2:	e44e                	sd	s3,8(sp)
    2aa4:	1800                	add	s0,sp,48
    2aa6:	89aa                	mv	s3,a0
  a = sbrk(PGSIZE);
    2aa8:	6505                	lui	a0,0x1
    2aaa:	00003097          	auipc	ra,0x3
    2aae:	16c080e7          	jalr	364(ra) # 5c16 <sbrk>
    2ab2:	892a                	mv	s2,a0
  fd = open("sbrk", O_CREATE|O_WRONLY);
    2ab4:	20100593          	li	a1,513
    2ab8:	00004517          	auipc	a0,0x4
    2abc:	52050513          	add	a0,a0,1312 # 6fd8 <malloc+0x1002>
    2ac0:	00003097          	auipc	ra,0x3
    2ac4:	10e080e7          	jalr	270(ra) # 5bce <open>
    2ac8:	84aa                	mv	s1,a0
  unlink("sbrk");
    2aca:	00004517          	auipc	a0,0x4
    2ace:	50e50513          	add	a0,a0,1294 # 6fd8 <malloc+0x1002>
    2ad2:	00003097          	auipc	ra,0x3
    2ad6:	10c080e7          	jalr	268(ra) # 5bde <unlink>
  if(fd < 0)  {
    2ada:	0404c163          	bltz	s1,2b1c <sbrkarg+0x84>
  if ((n = write(fd, a, PGSIZE)) < 0) {
    2ade:	6605                	lui	a2,0x1
    2ae0:	85ca                	mv	a1,s2
    2ae2:	8526                	mv	a0,s1
    2ae4:	00003097          	auipc	ra,0x3
    2ae8:	0ca080e7          	jalr	202(ra) # 5bae <write>
    2aec:	04054663          	bltz	a0,2b38 <sbrkarg+0xa0>
  close(fd);
    2af0:	8526                	mv	a0,s1
    2af2:	00003097          	auipc	ra,0x3
    2af6:	0c4080e7          	jalr	196(ra) # 5bb6 <close>
  a = sbrk(PGSIZE);
    2afa:	6505                	lui	a0,0x1
    2afc:	00003097          	auipc	ra,0x3
    2b00:	11a080e7          	jalr	282(ra) # 5c16 <sbrk>
  if(pipe((int *) a) != 0){
    2b04:	00003097          	auipc	ra,0x3
    2b08:	09a080e7          	jalr	154(ra) # 5b9e <pipe>
    2b0c:	e521                	bnez	a0,2b54 <sbrkarg+0xbc>
}
    2b0e:	70a2                	ld	ra,40(sp)
    2b10:	7402                	ld	s0,32(sp)
    2b12:	64e2                	ld	s1,24(sp)
    2b14:	6942                	ld	s2,16(sp)
    2b16:	69a2                	ld	s3,8(sp)
    2b18:	6145                	add	sp,sp,48
    2b1a:	8082                	ret
    printf("%s: open sbrk failed\n", s);
    2b1c:	85ce                	mv	a1,s3
    2b1e:	00004517          	auipc	a0,0x4
    2b22:	4c250513          	add	a0,a0,1218 # 6fe0 <malloc+0x100a>
    2b26:	00003097          	auipc	ra,0x3
    2b2a:	3f8080e7          	jalr	1016(ra) # 5f1e <printf>
    exit(1);
    2b2e:	4505                	li	a0,1
    2b30:	00003097          	auipc	ra,0x3
    2b34:	05e080e7          	jalr	94(ra) # 5b8e <exit>
    printf("%s: write sbrk failed\n", s);
    2b38:	85ce                	mv	a1,s3
    2b3a:	00004517          	auipc	a0,0x4
    2b3e:	4be50513          	add	a0,a0,1214 # 6ff8 <malloc+0x1022>
    2b42:	00003097          	auipc	ra,0x3
    2b46:	3dc080e7          	jalr	988(ra) # 5f1e <printf>
    exit(1);
    2b4a:	4505                	li	a0,1
    2b4c:	00003097          	auipc	ra,0x3
    2b50:	042080e7          	jalr	66(ra) # 5b8e <exit>
    printf("%s: pipe() failed\n", s);
    2b54:	85ce                	mv	a1,s3
    2b56:	00004517          	auipc	a0,0x4
    2b5a:	f3250513          	add	a0,a0,-206 # 6a88 <malloc+0xab2>
    2b5e:	00003097          	auipc	ra,0x3
    2b62:	3c0080e7          	jalr	960(ra) # 5f1e <printf>
    exit(1);
    2b66:	4505                	li	a0,1
    2b68:	00003097          	auipc	ra,0x3
    2b6c:	026080e7          	jalr	38(ra) # 5b8e <exit>

0000000000002b70 <argptest>:
{
    2b70:	1101                	add	sp,sp,-32
    2b72:	ec06                	sd	ra,24(sp)
    2b74:	e822                	sd	s0,16(sp)
    2b76:	e426                	sd	s1,8(sp)
    2b78:	e04a                	sd	s2,0(sp)
    2b7a:	1000                	add	s0,sp,32
    2b7c:	892a                	mv	s2,a0
  fd = open("init", O_RDONLY);
    2b7e:	4581                	li	a1,0
    2b80:	00004517          	auipc	a0,0x4
    2b84:	49050513          	add	a0,a0,1168 # 7010 <malloc+0x103a>
    2b88:	00003097          	auipc	ra,0x3
    2b8c:	046080e7          	jalr	70(ra) # 5bce <open>
  if (fd < 0) {
    2b90:	02054b63          	bltz	a0,2bc6 <argptest+0x56>
    2b94:	84aa                	mv	s1,a0
  read(fd, sbrk(0) - 1, -1);
    2b96:	4501                	li	a0,0
    2b98:	00003097          	auipc	ra,0x3
    2b9c:	07e080e7          	jalr	126(ra) # 5c16 <sbrk>
    2ba0:	567d                	li	a2,-1
    2ba2:	fff50593          	add	a1,a0,-1
    2ba6:	8526                	mv	a0,s1
    2ba8:	00003097          	auipc	ra,0x3
    2bac:	ffe080e7          	jalr	-2(ra) # 5ba6 <read>
  close(fd);
    2bb0:	8526                	mv	a0,s1
    2bb2:	00003097          	auipc	ra,0x3
    2bb6:	004080e7          	jalr	4(ra) # 5bb6 <close>
}
    2bba:	60e2                	ld	ra,24(sp)
    2bbc:	6442                	ld	s0,16(sp)
    2bbe:	64a2                	ld	s1,8(sp)
    2bc0:	6902                	ld	s2,0(sp)
    2bc2:	6105                	add	sp,sp,32
    2bc4:	8082                	ret
    printf("%s: open failed\n", s);
    2bc6:	85ca                	mv	a1,s2
    2bc8:	00004517          	auipc	a0,0x4
    2bcc:	dd050513          	add	a0,a0,-560 # 6998 <malloc+0x9c2>
    2bd0:	00003097          	auipc	ra,0x3
    2bd4:	34e080e7          	jalr	846(ra) # 5f1e <printf>
    exit(1);
    2bd8:	4505                	li	a0,1
    2bda:	00003097          	auipc	ra,0x3
    2bde:	fb4080e7          	jalr	-76(ra) # 5b8e <exit>

0000000000002be2 <sbrkbugs>:
{
    2be2:	1141                	add	sp,sp,-16
    2be4:	e406                	sd	ra,8(sp)
    2be6:	e022                	sd	s0,0(sp)
    2be8:	0800                	add	s0,sp,16
  int pid = fork();
    2bea:	00003097          	auipc	ra,0x3
    2bee:	f9c080e7          	jalr	-100(ra) # 5b86 <fork>
  if(pid < 0){
    2bf2:	02054263          	bltz	a0,2c16 <sbrkbugs+0x34>
  if(pid == 0){
    2bf6:	ed0d                	bnez	a0,2c30 <sbrkbugs+0x4e>
    int sz = (uint64) sbrk(0);
    2bf8:	00003097          	auipc	ra,0x3
    2bfc:	01e080e7          	jalr	30(ra) # 5c16 <sbrk>
    sbrk(-sz);
    2c00:	40a0053b          	negw	a0,a0
    2c04:	00003097          	auipc	ra,0x3
    2c08:	012080e7          	jalr	18(ra) # 5c16 <sbrk>
    exit(0);
    2c0c:	4501                	li	a0,0
    2c0e:	00003097          	auipc	ra,0x3
    2c12:	f80080e7          	jalr	-128(ra) # 5b8e <exit>
    printf("fork failed\n");
    2c16:	00004517          	auipc	a0,0x4
    2c1a:	17250513          	add	a0,a0,370 # 6d88 <malloc+0xdb2>
    2c1e:	00003097          	auipc	ra,0x3
    2c22:	300080e7          	jalr	768(ra) # 5f1e <printf>
    exit(1);
    2c26:	4505                	li	a0,1
    2c28:	00003097          	auipc	ra,0x3
    2c2c:	f66080e7          	jalr	-154(ra) # 5b8e <exit>
  wait(0);
    2c30:	4501                	li	a0,0
    2c32:	00003097          	auipc	ra,0x3
    2c36:	f64080e7          	jalr	-156(ra) # 5b96 <wait>
  pid = fork();
    2c3a:	00003097          	auipc	ra,0x3
    2c3e:	f4c080e7          	jalr	-180(ra) # 5b86 <fork>
  if(pid < 0){
    2c42:	02054563          	bltz	a0,2c6c <sbrkbugs+0x8a>
  if(pid == 0){
    2c46:	e121                	bnez	a0,2c86 <sbrkbugs+0xa4>
    int sz = (uint64) sbrk(0);
    2c48:	00003097          	auipc	ra,0x3
    2c4c:	fce080e7          	jalr	-50(ra) # 5c16 <sbrk>
    sbrk(-(sz - 3500));
    2c50:	6785                	lui	a5,0x1
    2c52:	dac7879b          	addw	a5,a5,-596 # dac <unlinkread+0x6e>
    2c56:	40a7853b          	subw	a0,a5,a0
    2c5a:	00003097          	auipc	ra,0x3
    2c5e:	fbc080e7          	jalr	-68(ra) # 5c16 <sbrk>
    exit(0);
    2c62:	4501                	li	a0,0
    2c64:	00003097          	auipc	ra,0x3
    2c68:	f2a080e7          	jalr	-214(ra) # 5b8e <exit>
    printf("fork failed\n");
    2c6c:	00004517          	auipc	a0,0x4
    2c70:	11c50513          	add	a0,a0,284 # 6d88 <malloc+0xdb2>
    2c74:	00003097          	auipc	ra,0x3
    2c78:	2aa080e7          	jalr	682(ra) # 5f1e <printf>
    exit(1);
    2c7c:	4505                	li	a0,1
    2c7e:	00003097          	auipc	ra,0x3
    2c82:	f10080e7          	jalr	-240(ra) # 5b8e <exit>
  wait(0);
    2c86:	4501                	li	a0,0
    2c88:	00003097          	auipc	ra,0x3
    2c8c:	f0e080e7          	jalr	-242(ra) # 5b96 <wait>
  pid = fork();
    2c90:	00003097          	auipc	ra,0x3
    2c94:	ef6080e7          	jalr	-266(ra) # 5b86 <fork>
  if(pid < 0){
    2c98:	02054a63          	bltz	a0,2ccc <sbrkbugs+0xea>
  if(pid == 0){
    2c9c:	e529                	bnez	a0,2ce6 <sbrkbugs+0x104>
    sbrk((10*4096 + 2048) - (uint64)sbrk(0));
    2c9e:	00003097          	auipc	ra,0x3
    2ca2:	f78080e7          	jalr	-136(ra) # 5c16 <sbrk>
    2ca6:	67ad                	lui	a5,0xb
    2ca8:	8007879b          	addw	a5,a5,-2048 # a800 <uninit+0x2a8>
    2cac:	40a7853b          	subw	a0,a5,a0
    2cb0:	00003097          	auipc	ra,0x3
    2cb4:	f66080e7          	jalr	-154(ra) # 5c16 <sbrk>
    sbrk(-10);
    2cb8:	5559                	li	a0,-10
    2cba:	00003097          	auipc	ra,0x3
    2cbe:	f5c080e7          	jalr	-164(ra) # 5c16 <sbrk>
    exit(0);
    2cc2:	4501                	li	a0,0
    2cc4:	00003097          	auipc	ra,0x3
    2cc8:	eca080e7          	jalr	-310(ra) # 5b8e <exit>
    printf("fork failed\n");
    2ccc:	00004517          	auipc	a0,0x4
    2cd0:	0bc50513          	add	a0,a0,188 # 6d88 <malloc+0xdb2>
    2cd4:	00003097          	auipc	ra,0x3
    2cd8:	24a080e7          	jalr	586(ra) # 5f1e <printf>
    exit(1);
    2cdc:	4505                	li	a0,1
    2cde:	00003097          	auipc	ra,0x3
    2ce2:	eb0080e7          	jalr	-336(ra) # 5b8e <exit>
  wait(0);
    2ce6:	4501                	li	a0,0
    2ce8:	00003097          	auipc	ra,0x3
    2cec:	eae080e7          	jalr	-338(ra) # 5b96 <wait>
  exit(0);
    2cf0:	4501                	li	a0,0
    2cf2:	00003097          	auipc	ra,0x3
    2cf6:	e9c080e7          	jalr	-356(ra) # 5b8e <exit>

0000000000002cfa <sbrklast>:
{
    2cfa:	7179                	add	sp,sp,-48
    2cfc:	f406                	sd	ra,40(sp)
    2cfe:	f022                	sd	s0,32(sp)
    2d00:	ec26                	sd	s1,24(sp)
    2d02:	e84a                	sd	s2,16(sp)
    2d04:	e44e                	sd	s3,8(sp)
    2d06:	e052                	sd	s4,0(sp)
    2d08:	1800                	add	s0,sp,48
  uint64 top = (uint64) sbrk(0);
    2d0a:	4501                	li	a0,0
    2d0c:	00003097          	auipc	ra,0x3
    2d10:	f0a080e7          	jalr	-246(ra) # 5c16 <sbrk>
  if((top % 4096) != 0)
    2d14:	03451793          	sll	a5,a0,0x34
    2d18:	ebd9                	bnez	a5,2dae <sbrklast+0xb4>
  sbrk(4096);
    2d1a:	6505                	lui	a0,0x1
    2d1c:	00003097          	auipc	ra,0x3
    2d20:	efa080e7          	jalr	-262(ra) # 5c16 <sbrk>
  sbrk(10);
    2d24:	4529                	li	a0,10
    2d26:	00003097          	auipc	ra,0x3
    2d2a:	ef0080e7          	jalr	-272(ra) # 5c16 <sbrk>
  sbrk(-20);
    2d2e:	5531                	li	a0,-20
    2d30:	00003097          	auipc	ra,0x3
    2d34:	ee6080e7          	jalr	-282(ra) # 5c16 <sbrk>
  top = (uint64) sbrk(0);
    2d38:	4501                	li	a0,0
    2d3a:	00003097          	auipc	ra,0x3
    2d3e:	edc080e7          	jalr	-292(ra) # 5c16 <sbrk>
    2d42:	84aa                	mv	s1,a0
  char *p = (char *) (top - 64);
    2d44:	fc050913          	add	s2,a0,-64 # fc0 <linktest+0xcc>
  p[0] = 'x';
    2d48:	07800a13          	li	s4,120
    2d4c:	fd450023          	sb	s4,-64(a0)
  p[1] = '\0';
    2d50:	fc0500a3          	sb	zero,-63(a0)
  int fd = open(p, O_RDWR|O_CREATE);
    2d54:	20200593          	li	a1,514
    2d58:	854a                	mv	a0,s2
    2d5a:	00003097          	auipc	ra,0x3
    2d5e:	e74080e7          	jalr	-396(ra) # 5bce <open>
    2d62:	89aa                	mv	s3,a0
  write(fd, p, 1);
    2d64:	4605                	li	a2,1
    2d66:	85ca                	mv	a1,s2
    2d68:	00003097          	auipc	ra,0x3
    2d6c:	e46080e7          	jalr	-442(ra) # 5bae <write>
  close(fd);
    2d70:	854e                	mv	a0,s3
    2d72:	00003097          	auipc	ra,0x3
    2d76:	e44080e7          	jalr	-444(ra) # 5bb6 <close>
  fd = open(p, O_RDWR);
    2d7a:	4589                	li	a1,2
    2d7c:	854a                	mv	a0,s2
    2d7e:	00003097          	auipc	ra,0x3
    2d82:	e50080e7          	jalr	-432(ra) # 5bce <open>
  p[0] = '\0';
    2d86:	fc048023          	sb	zero,-64(s1)
  read(fd, p, 1);
    2d8a:	4605                	li	a2,1
    2d8c:	85ca                	mv	a1,s2
    2d8e:	00003097          	auipc	ra,0x3
    2d92:	e18080e7          	jalr	-488(ra) # 5ba6 <read>
  if(p[0] != 'x')
    2d96:	fc04c783          	lbu	a5,-64(s1)
    2d9a:	03479463          	bne	a5,s4,2dc2 <sbrklast+0xc8>
}
    2d9e:	70a2                	ld	ra,40(sp)
    2da0:	7402                	ld	s0,32(sp)
    2da2:	64e2                	ld	s1,24(sp)
    2da4:	6942                	ld	s2,16(sp)
    2da6:	69a2                	ld	s3,8(sp)
    2da8:	6a02                	ld	s4,0(sp)
    2daa:	6145                	add	sp,sp,48
    2dac:	8082                	ret
    sbrk(4096 - (top % 4096));
    2dae:	0347d513          	srl	a0,a5,0x34
    2db2:	6785                	lui	a5,0x1
    2db4:	40a7853b          	subw	a0,a5,a0
    2db8:	00003097          	auipc	ra,0x3
    2dbc:	e5e080e7          	jalr	-418(ra) # 5c16 <sbrk>
    2dc0:	bfa9                	j	2d1a <sbrklast+0x20>
    exit(1);
    2dc2:	4505                	li	a0,1
    2dc4:	00003097          	auipc	ra,0x3
    2dc8:	dca080e7          	jalr	-566(ra) # 5b8e <exit>

0000000000002dcc <sbrk8000>:
{
    2dcc:	1141                	add	sp,sp,-16
    2dce:	e406                	sd	ra,8(sp)
    2dd0:	e022                	sd	s0,0(sp)
    2dd2:	0800                	add	s0,sp,16
  sbrk(0x80000004);
    2dd4:	80000537          	lui	a0,0x80000
    2dd8:	0511                	add	a0,a0,4 # ffffffff80000004 <base+0xffffffff7fff039c>
    2dda:	00003097          	auipc	ra,0x3
    2dde:	e3c080e7          	jalr	-452(ra) # 5c16 <sbrk>
  volatile char *top = sbrk(0);
    2de2:	4501                	li	a0,0
    2de4:	00003097          	auipc	ra,0x3
    2de8:	e32080e7          	jalr	-462(ra) # 5c16 <sbrk>
  *(top-1) = *(top-1) + 1;
    2dec:	fff54783          	lbu	a5,-1(a0)
    2df0:	2785                	addw	a5,a5,1 # 1001 <linktest+0x10d>
    2df2:	0ff7f793          	zext.b	a5,a5
    2df6:	fef50fa3          	sb	a5,-1(a0)
}
    2dfa:	60a2                	ld	ra,8(sp)
    2dfc:	6402                	ld	s0,0(sp)
    2dfe:	0141                	add	sp,sp,16
    2e00:	8082                	ret

0000000000002e02 <execout>:
{
    2e02:	715d                	add	sp,sp,-80
    2e04:	e486                	sd	ra,72(sp)
    2e06:	e0a2                	sd	s0,64(sp)
    2e08:	fc26                	sd	s1,56(sp)
    2e0a:	f84a                	sd	s2,48(sp)
    2e0c:	f44e                	sd	s3,40(sp)
    2e0e:	f052                	sd	s4,32(sp)
    2e10:	0880                	add	s0,sp,80
  for(int avail = 0; avail < 15; avail++){
    2e12:	4901                	li	s2,0
    2e14:	49bd                	li	s3,15
    int pid = fork();
    2e16:	00003097          	auipc	ra,0x3
    2e1a:	d70080e7          	jalr	-656(ra) # 5b86 <fork>
    2e1e:	84aa                	mv	s1,a0
    if(pid < 0){
    2e20:	02054063          	bltz	a0,2e40 <execout+0x3e>
    } else if(pid == 0){
    2e24:	c91d                	beqz	a0,2e5a <execout+0x58>
      wait((int*)0);
    2e26:	4501                	li	a0,0
    2e28:	00003097          	auipc	ra,0x3
    2e2c:	d6e080e7          	jalr	-658(ra) # 5b96 <wait>
  for(int avail = 0; avail < 15; avail++){
    2e30:	2905                	addw	s2,s2,1
    2e32:	ff3912e3          	bne	s2,s3,2e16 <execout+0x14>
  exit(0);
    2e36:	4501                	li	a0,0
    2e38:	00003097          	auipc	ra,0x3
    2e3c:	d56080e7          	jalr	-682(ra) # 5b8e <exit>
      printf("fork failed\n");
    2e40:	00004517          	auipc	a0,0x4
    2e44:	f4850513          	add	a0,a0,-184 # 6d88 <malloc+0xdb2>
    2e48:	00003097          	auipc	ra,0x3
    2e4c:	0d6080e7          	jalr	214(ra) # 5f1e <printf>
      exit(1);
    2e50:	4505                	li	a0,1
    2e52:	00003097          	auipc	ra,0x3
    2e56:	d3c080e7          	jalr	-708(ra) # 5b8e <exit>
        if(a == 0xffffffffffffffffLL)
    2e5a:	59fd                	li	s3,-1
        *(char*)(a + 4096 - 1) = 1;
    2e5c:	4a05                	li	s4,1
        uint64 a = (uint64) sbrk(4096);
    2e5e:	6505                	lui	a0,0x1
    2e60:	00003097          	auipc	ra,0x3
    2e64:	db6080e7          	jalr	-586(ra) # 5c16 <sbrk>
        if(a == 0xffffffffffffffffLL)
    2e68:	01350763          	beq	a0,s3,2e76 <execout+0x74>
        *(char*)(a + 4096 - 1) = 1;
    2e6c:	6785                	lui	a5,0x1
    2e6e:	97aa                	add	a5,a5,a0
    2e70:	ff478fa3          	sb	s4,-1(a5) # fff <linktest+0x10b>
      while(1){
    2e74:	b7ed                	j	2e5e <execout+0x5c>
      for(int i = 0; i < avail; i++)
    2e76:	01205a63          	blez	s2,2e8a <execout+0x88>
        sbrk(-4096);
    2e7a:	757d                	lui	a0,0xfffff
    2e7c:	00003097          	auipc	ra,0x3
    2e80:	d9a080e7          	jalr	-614(ra) # 5c16 <sbrk>
      for(int i = 0; i < avail; i++)
    2e84:	2485                	addw	s1,s1,1
    2e86:	ff249ae3          	bne	s1,s2,2e7a <execout+0x78>
      close(1);
    2e8a:	4505                	li	a0,1
    2e8c:	00003097          	auipc	ra,0x3
    2e90:	d2a080e7          	jalr	-726(ra) # 5bb6 <close>
      char *args[] = { "echo", "x", 0 };
    2e94:	00003517          	auipc	a0,0x3
    2e98:	26450513          	add	a0,a0,612 # 60f8 <malloc+0x122>
    2e9c:	faa43c23          	sd	a0,-72(s0)
    2ea0:	00003797          	auipc	a5,0x3
    2ea4:	2c878793          	add	a5,a5,712 # 6168 <malloc+0x192>
    2ea8:	fcf43023          	sd	a5,-64(s0)
    2eac:	fc043423          	sd	zero,-56(s0)
      exec("echo", args);
    2eb0:	fb840593          	add	a1,s0,-72
    2eb4:	00003097          	auipc	ra,0x3
    2eb8:	d12080e7          	jalr	-750(ra) # 5bc6 <exec>
      exit(0);
    2ebc:	4501                	li	a0,0
    2ebe:	00003097          	auipc	ra,0x3
    2ec2:	cd0080e7          	jalr	-816(ra) # 5b8e <exit>

0000000000002ec6 <fourteen>:
{
    2ec6:	1101                	add	sp,sp,-32
    2ec8:	ec06                	sd	ra,24(sp)
    2eca:	e822                	sd	s0,16(sp)
    2ecc:	e426                	sd	s1,8(sp)
    2ece:	1000                	add	s0,sp,32
    2ed0:	84aa                	mv	s1,a0
  if(mkdir("12345678901234") != 0){
    2ed2:	00004517          	auipc	a0,0x4
    2ed6:	31650513          	add	a0,a0,790 # 71e8 <malloc+0x1212>
    2eda:	00003097          	auipc	ra,0x3
    2ede:	d1c080e7          	jalr	-740(ra) # 5bf6 <mkdir>
    2ee2:	e165                	bnez	a0,2fc2 <fourteen+0xfc>
  if(mkdir("12345678901234/123456789012345") != 0){
    2ee4:	00004517          	auipc	a0,0x4
    2ee8:	15c50513          	add	a0,a0,348 # 7040 <malloc+0x106a>
    2eec:	00003097          	auipc	ra,0x3
    2ef0:	d0a080e7          	jalr	-758(ra) # 5bf6 <mkdir>
    2ef4:	e56d                	bnez	a0,2fde <fourteen+0x118>
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    2ef6:	20000593          	li	a1,512
    2efa:	00004517          	auipc	a0,0x4
    2efe:	19e50513          	add	a0,a0,414 # 7098 <malloc+0x10c2>
    2f02:	00003097          	auipc	ra,0x3
    2f06:	ccc080e7          	jalr	-820(ra) # 5bce <open>
  if(fd < 0){
    2f0a:	0e054863          	bltz	a0,2ffa <fourteen+0x134>
  close(fd);
    2f0e:	00003097          	auipc	ra,0x3
    2f12:	ca8080e7          	jalr	-856(ra) # 5bb6 <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    2f16:	4581                	li	a1,0
    2f18:	00004517          	auipc	a0,0x4
    2f1c:	1f850513          	add	a0,a0,504 # 7110 <malloc+0x113a>
    2f20:	00003097          	auipc	ra,0x3
    2f24:	cae080e7          	jalr	-850(ra) # 5bce <open>
  if(fd < 0){
    2f28:	0e054763          	bltz	a0,3016 <fourteen+0x150>
  close(fd);
    2f2c:	00003097          	auipc	ra,0x3
    2f30:	c8a080e7          	jalr	-886(ra) # 5bb6 <close>
  if(mkdir("12345678901234/12345678901234") == 0){
    2f34:	00004517          	auipc	a0,0x4
    2f38:	24c50513          	add	a0,a0,588 # 7180 <malloc+0x11aa>
    2f3c:	00003097          	auipc	ra,0x3
    2f40:	cba080e7          	jalr	-838(ra) # 5bf6 <mkdir>
    2f44:	c57d                	beqz	a0,3032 <fourteen+0x16c>
  if(mkdir("123456789012345/12345678901234") == 0){
    2f46:	00004517          	auipc	a0,0x4
    2f4a:	29250513          	add	a0,a0,658 # 71d8 <malloc+0x1202>
    2f4e:	00003097          	auipc	ra,0x3
    2f52:	ca8080e7          	jalr	-856(ra) # 5bf6 <mkdir>
    2f56:	cd65                	beqz	a0,304e <fourteen+0x188>
  unlink("123456789012345/12345678901234");
    2f58:	00004517          	auipc	a0,0x4
    2f5c:	28050513          	add	a0,a0,640 # 71d8 <malloc+0x1202>
    2f60:	00003097          	auipc	ra,0x3
    2f64:	c7e080e7          	jalr	-898(ra) # 5bde <unlink>
  unlink("12345678901234/12345678901234");
    2f68:	00004517          	auipc	a0,0x4
    2f6c:	21850513          	add	a0,a0,536 # 7180 <malloc+0x11aa>
    2f70:	00003097          	auipc	ra,0x3
    2f74:	c6e080e7          	jalr	-914(ra) # 5bde <unlink>
  unlink("12345678901234/12345678901234/12345678901234");
    2f78:	00004517          	auipc	a0,0x4
    2f7c:	19850513          	add	a0,a0,408 # 7110 <malloc+0x113a>
    2f80:	00003097          	auipc	ra,0x3
    2f84:	c5e080e7          	jalr	-930(ra) # 5bde <unlink>
  unlink("123456789012345/123456789012345/123456789012345");
    2f88:	00004517          	auipc	a0,0x4
    2f8c:	11050513          	add	a0,a0,272 # 7098 <malloc+0x10c2>
    2f90:	00003097          	auipc	ra,0x3
    2f94:	c4e080e7          	jalr	-946(ra) # 5bde <unlink>
  unlink("12345678901234/123456789012345");
    2f98:	00004517          	auipc	a0,0x4
    2f9c:	0a850513          	add	a0,a0,168 # 7040 <malloc+0x106a>
    2fa0:	00003097          	auipc	ra,0x3
    2fa4:	c3e080e7          	jalr	-962(ra) # 5bde <unlink>
  unlink("12345678901234");
    2fa8:	00004517          	auipc	a0,0x4
    2fac:	24050513          	add	a0,a0,576 # 71e8 <malloc+0x1212>
    2fb0:	00003097          	auipc	ra,0x3
    2fb4:	c2e080e7          	jalr	-978(ra) # 5bde <unlink>
}
    2fb8:	60e2                	ld	ra,24(sp)
    2fba:	6442                	ld	s0,16(sp)
    2fbc:	64a2                	ld	s1,8(sp)
    2fbe:	6105                	add	sp,sp,32
    2fc0:	8082                	ret
    printf("%s: mkdir 12345678901234 failed\n", s);
    2fc2:	85a6                	mv	a1,s1
    2fc4:	00004517          	auipc	a0,0x4
    2fc8:	05450513          	add	a0,a0,84 # 7018 <malloc+0x1042>
    2fcc:	00003097          	auipc	ra,0x3
    2fd0:	f52080e7          	jalr	-174(ra) # 5f1e <printf>
    exit(1);
    2fd4:	4505                	li	a0,1
    2fd6:	00003097          	auipc	ra,0x3
    2fda:	bb8080e7          	jalr	-1096(ra) # 5b8e <exit>
    printf("%s: mkdir 12345678901234/123456789012345 failed\n", s);
    2fde:	85a6                	mv	a1,s1
    2fe0:	00004517          	auipc	a0,0x4
    2fe4:	08050513          	add	a0,a0,128 # 7060 <malloc+0x108a>
    2fe8:	00003097          	auipc	ra,0x3
    2fec:	f36080e7          	jalr	-202(ra) # 5f1e <printf>
    exit(1);
    2ff0:	4505                	li	a0,1
    2ff2:	00003097          	auipc	ra,0x3
    2ff6:	b9c080e7          	jalr	-1124(ra) # 5b8e <exit>
    printf("%s: create 123456789012345/123456789012345/123456789012345 failed\n", s);
    2ffa:	85a6                	mv	a1,s1
    2ffc:	00004517          	auipc	a0,0x4
    3000:	0cc50513          	add	a0,a0,204 # 70c8 <malloc+0x10f2>
    3004:	00003097          	auipc	ra,0x3
    3008:	f1a080e7          	jalr	-230(ra) # 5f1e <printf>
    exit(1);
    300c:	4505                	li	a0,1
    300e:	00003097          	auipc	ra,0x3
    3012:	b80080e7          	jalr	-1152(ra) # 5b8e <exit>
    printf("%s: open 12345678901234/12345678901234/12345678901234 failed\n", s);
    3016:	85a6                	mv	a1,s1
    3018:	00004517          	auipc	a0,0x4
    301c:	12850513          	add	a0,a0,296 # 7140 <malloc+0x116a>
    3020:	00003097          	auipc	ra,0x3
    3024:	efe080e7          	jalr	-258(ra) # 5f1e <printf>
    exit(1);
    3028:	4505                	li	a0,1
    302a:	00003097          	auipc	ra,0x3
    302e:	b64080e7          	jalr	-1180(ra) # 5b8e <exit>
    printf("%s: mkdir 12345678901234/12345678901234 succeeded!\n", s);
    3032:	85a6                	mv	a1,s1
    3034:	00004517          	auipc	a0,0x4
    3038:	16c50513          	add	a0,a0,364 # 71a0 <malloc+0x11ca>
    303c:	00003097          	auipc	ra,0x3
    3040:	ee2080e7          	jalr	-286(ra) # 5f1e <printf>
    exit(1);
    3044:	4505                	li	a0,1
    3046:	00003097          	auipc	ra,0x3
    304a:	b48080e7          	jalr	-1208(ra) # 5b8e <exit>
    printf("%s: mkdir 12345678901234/123456789012345 succeeded!\n", s);
    304e:	85a6                	mv	a1,s1
    3050:	00004517          	auipc	a0,0x4
    3054:	1a850513          	add	a0,a0,424 # 71f8 <malloc+0x1222>
    3058:	00003097          	auipc	ra,0x3
    305c:	ec6080e7          	jalr	-314(ra) # 5f1e <printf>
    exit(1);
    3060:	4505                	li	a0,1
    3062:	00003097          	auipc	ra,0x3
    3066:	b2c080e7          	jalr	-1236(ra) # 5b8e <exit>

000000000000306a <diskfull>:
{
    306a:	b9010113          	add	sp,sp,-1136
    306e:	46113423          	sd	ra,1128(sp)
    3072:	46813023          	sd	s0,1120(sp)
    3076:	44913c23          	sd	s1,1112(sp)
    307a:	45213823          	sd	s2,1104(sp)
    307e:	45313423          	sd	s3,1096(sp)
    3082:	45413023          	sd	s4,1088(sp)
    3086:	43513c23          	sd	s5,1080(sp)
    308a:	43613823          	sd	s6,1072(sp)
    308e:	43713423          	sd	s7,1064(sp)
    3092:	43813023          	sd	s8,1056(sp)
    3096:	47010413          	add	s0,sp,1136
    309a:	8c2a                	mv	s8,a0
  unlink("diskfulldir");
    309c:	00004517          	auipc	a0,0x4
    30a0:	19450513          	add	a0,a0,404 # 7230 <malloc+0x125a>
    30a4:	00003097          	auipc	ra,0x3
    30a8:	b3a080e7          	jalr	-1222(ra) # 5bde <unlink>
  for(fi = 0; done == 0; fi++){
    30ac:	4a01                	li	s4,0
    name[0] = 'b';
    30ae:	06200b13          	li	s6,98
    name[1] = 'i';
    30b2:	06900a93          	li	s5,105
    name[2] = 'g';
    30b6:	06700993          	li	s3,103
    30ba:	10c00b93          	li	s7,268
    30be:	aabd                	j	323c <diskfull+0x1d2>
      printf("%s: could not create file %s\n", s, name);
    30c0:	b9040613          	add	a2,s0,-1136
    30c4:	85e2                	mv	a1,s8
    30c6:	00004517          	auipc	a0,0x4
    30ca:	17a50513          	add	a0,a0,378 # 7240 <malloc+0x126a>
    30ce:	00003097          	auipc	ra,0x3
    30d2:	e50080e7          	jalr	-432(ra) # 5f1e <printf>
      break;
    30d6:	a821                	j	30ee <diskfull+0x84>
        close(fd);
    30d8:	854a                	mv	a0,s2
    30da:	00003097          	auipc	ra,0x3
    30de:	adc080e7          	jalr	-1316(ra) # 5bb6 <close>
    close(fd);
    30e2:	854a                	mv	a0,s2
    30e4:	00003097          	auipc	ra,0x3
    30e8:	ad2080e7          	jalr	-1326(ra) # 5bb6 <close>
  for(fi = 0; done == 0; fi++){
    30ec:	2a05                	addw	s4,s4,1
  for(int i = 0; i < nzz; i++){
    30ee:	4481                	li	s1,0
    name[0] = 'z';
    30f0:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
    30f4:	08000993          	li	s3,128
    name[0] = 'z';
    30f8:	bb240823          	sb	s2,-1104(s0)
    name[1] = 'z';
    30fc:	bb2408a3          	sb	s2,-1103(s0)
    name[2] = '0' + (i / 32);
    3100:	41f4d71b          	sraw	a4,s1,0x1f
    3104:	01b7571b          	srlw	a4,a4,0x1b
    3108:	009707bb          	addw	a5,a4,s1
    310c:	4057d69b          	sraw	a3,a5,0x5
    3110:	0306869b          	addw	a3,a3,48
    3114:	bad40923          	sb	a3,-1102(s0)
    name[3] = '0' + (i % 32);
    3118:	8bfd                	and	a5,a5,31
    311a:	9f99                	subw	a5,a5,a4
    311c:	0307879b          	addw	a5,a5,48
    3120:	baf409a3          	sb	a5,-1101(s0)
    name[4] = '\0';
    3124:	ba040a23          	sb	zero,-1100(s0)
    unlink(name);
    3128:	bb040513          	add	a0,s0,-1104
    312c:	00003097          	auipc	ra,0x3
    3130:	ab2080e7          	jalr	-1358(ra) # 5bde <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    3134:	60200593          	li	a1,1538
    3138:	bb040513          	add	a0,s0,-1104
    313c:	00003097          	auipc	ra,0x3
    3140:	a92080e7          	jalr	-1390(ra) # 5bce <open>
    if(fd < 0)
    3144:	00054963          	bltz	a0,3156 <diskfull+0xec>
    close(fd);
    3148:	00003097          	auipc	ra,0x3
    314c:	a6e080e7          	jalr	-1426(ra) # 5bb6 <close>
  for(int i = 0; i < nzz; i++){
    3150:	2485                	addw	s1,s1,1
    3152:	fb3493e3          	bne	s1,s3,30f8 <diskfull+0x8e>
  if(mkdir("diskfulldir") == 0)
    3156:	00004517          	auipc	a0,0x4
    315a:	0da50513          	add	a0,a0,218 # 7230 <malloc+0x125a>
    315e:	00003097          	auipc	ra,0x3
    3162:	a98080e7          	jalr	-1384(ra) # 5bf6 <mkdir>
    3166:	12050963          	beqz	a0,3298 <diskfull+0x22e>
  unlink("diskfulldir");
    316a:	00004517          	auipc	a0,0x4
    316e:	0c650513          	add	a0,a0,198 # 7230 <malloc+0x125a>
    3172:	00003097          	auipc	ra,0x3
    3176:	a6c080e7          	jalr	-1428(ra) # 5bde <unlink>
  for(int i = 0; i < nzz; i++){
    317a:	4481                	li	s1,0
    name[0] = 'z';
    317c:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
    3180:	08000993          	li	s3,128
    name[0] = 'z';
    3184:	bb240823          	sb	s2,-1104(s0)
    name[1] = 'z';
    3188:	bb2408a3          	sb	s2,-1103(s0)
    name[2] = '0' + (i / 32);
    318c:	41f4d71b          	sraw	a4,s1,0x1f
    3190:	01b7571b          	srlw	a4,a4,0x1b
    3194:	009707bb          	addw	a5,a4,s1
    3198:	4057d69b          	sraw	a3,a5,0x5
    319c:	0306869b          	addw	a3,a3,48
    31a0:	bad40923          	sb	a3,-1102(s0)
    name[3] = '0' + (i % 32);
    31a4:	8bfd                	and	a5,a5,31
    31a6:	9f99                	subw	a5,a5,a4
    31a8:	0307879b          	addw	a5,a5,48
    31ac:	baf409a3          	sb	a5,-1101(s0)
    name[4] = '\0';
    31b0:	ba040a23          	sb	zero,-1100(s0)
    unlink(name);
    31b4:	bb040513          	add	a0,s0,-1104
    31b8:	00003097          	auipc	ra,0x3
    31bc:	a26080e7          	jalr	-1498(ra) # 5bde <unlink>
  for(int i = 0; i < nzz; i++){
    31c0:	2485                	addw	s1,s1,1
    31c2:	fd3491e3          	bne	s1,s3,3184 <diskfull+0x11a>
  for(int i = 0; i < fi; i++){
    31c6:	03405e63          	blez	s4,3202 <diskfull+0x198>
    31ca:	4481                	li	s1,0
    name[0] = 'b';
    31cc:	06200a93          	li	s5,98
    name[1] = 'i';
    31d0:	06900993          	li	s3,105
    name[2] = 'g';
    31d4:	06700913          	li	s2,103
    name[0] = 'b';
    31d8:	bb540823          	sb	s5,-1104(s0)
    name[1] = 'i';
    31dc:	bb3408a3          	sb	s3,-1103(s0)
    name[2] = 'g';
    31e0:	bb240923          	sb	s2,-1102(s0)
    name[3] = '0' + i;
    31e4:	0304879b          	addw	a5,s1,48
    31e8:	baf409a3          	sb	a5,-1101(s0)
    name[4] = '\0';
    31ec:	ba040a23          	sb	zero,-1100(s0)
    unlink(name);
    31f0:	bb040513          	add	a0,s0,-1104
    31f4:	00003097          	auipc	ra,0x3
    31f8:	9ea080e7          	jalr	-1558(ra) # 5bde <unlink>
  for(int i = 0; i < fi; i++){
    31fc:	2485                	addw	s1,s1,1
    31fe:	fd449de3          	bne	s1,s4,31d8 <diskfull+0x16e>
}
    3202:	46813083          	ld	ra,1128(sp)
    3206:	46013403          	ld	s0,1120(sp)
    320a:	45813483          	ld	s1,1112(sp)
    320e:	45013903          	ld	s2,1104(sp)
    3212:	44813983          	ld	s3,1096(sp)
    3216:	44013a03          	ld	s4,1088(sp)
    321a:	43813a83          	ld	s5,1080(sp)
    321e:	43013b03          	ld	s6,1072(sp)
    3222:	42813b83          	ld	s7,1064(sp)
    3226:	42013c03          	ld	s8,1056(sp)
    322a:	47010113          	add	sp,sp,1136
    322e:	8082                	ret
    close(fd);
    3230:	854a                	mv	a0,s2
    3232:	00003097          	auipc	ra,0x3
    3236:	984080e7          	jalr	-1660(ra) # 5bb6 <close>
  for(fi = 0; done == 0; fi++){
    323a:	2a05                	addw	s4,s4,1
    name[0] = 'b';
    323c:	b9640823          	sb	s6,-1136(s0)
    name[1] = 'i';
    3240:	b95408a3          	sb	s5,-1135(s0)
    name[2] = 'g';
    3244:	b9340923          	sb	s3,-1134(s0)
    name[3] = '0' + fi;
    3248:	030a079b          	addw	a5,s4,48
    324c:	b8f409a3          	sb	a5,-1133(s0)
    name[4] = '\0';
    3250:	b8040a23          	sb	zero,-1132(s0)
    unlink(name);
    3254:	b9040513          	add	a0,s0,-1136
    3258:	00003097          	auipc	ra,0x3
    325c:	986080e7          	jalr	-1658(ra) # 5bde <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    3260:	60200593          	li	a1,1538
    3264:	b9040513          	add	a0,s0,-1136
    3268:	00003097          	auipc	ra,0x3
    326c:	966080e7          	jalr	-1690(ra) # 5bce <open>
    3270:	892a                	mv	s2,a0
    if(fd < 0){
    3272:	e40547e3          	bltz	a0,30c0 <diskfull+0x56>
    3276:	84de                	mv	s1,s7
      if(write(fd, buf, BSIZE) != BSIZE){
    3278:	40000613          	li	a2,1024
    327c:	bb040593          	add	a1,s0,-1104
    3280:	854a                	mv	a0,s2
    3282:	00003097          	auipc	ra,0x3
    3286:	92c080e7          	jalr	-1748(ra) # 5bae <write>
    328a:	40000793          	li	a5,1024
    328e:	e4f515e3          	bne	a0,a5,30d8 <diskfull+0x6e>
    for(int i = 0; i < MAXFILE; i++){
    3292:	34fd                	addw	s1,s1,-1
    3294:	f0f5                	bnez	s1,3278 <diskfull+0x20e>
    3296:	bf69                	j	3230 <diskfull+0x1c6>
    printf("%s: mkdir(diskfulldir) unexpectedly succeeded!\n");
    3298:	00004517          	auipc	a0,0x4
    329c:	fc850513          	add	a0,a0,-56 # 7260 <malloc+0x128a>
    32a0:	00003097          	auipc	ra,0x3
    32a4:	c7e080e7          	jalr	-898(ra) # 5f1e <printf>
    32a8:	b5c9                	j	316a <diskfull+0x100>

00000000000032aa <iputtest>:
{
    32aa:	1101                	add	sp,sp,-32
    32ac:	ec06                	sd	ra,24(sp)
    32ae:	e822                	sd	s0,16(sp)
    32b0:	e426                	sd	s1,8(sp)
    32b2:	1000                	add	s0,sp,32
    32b4:	84aa                	mv	s1,a0
  if(mkdir("iputdir") < 0){
    32b6:	00004517          	auipc	a0,0x4
    32ba:	fda50513          	add	a0,a0,-38 # 7290 <malloc+0x12ba>
    32be:	00003097          	auipc	ra,0x3
    32c2:	938080e7          	jalr	-1736(ra) # 5bf6 <mkdir>
    32c6:	04054563          	bltz	a0,3310 <iputtest+0x66>
  if(chdir("iputdir") < 0){
    32ca:	00004517          	auipc	a0,0x4
    32ce:	fc650513          	add	a0,a0,-58 # 7290 <malloc+0x12ba>
    32d2:	00003097          	auipc	ra,0x3
    32d6:	92c080e7          	jalr	-1748(ra) # 5bfe <chdir>
    32da:	04054963          	bltz	a0,332c <iputtest+0x82>
  if(unlink("../iputdir") < 0){
    32de:	00004517          	auipc	a0,0x4
    32e2:	ff250513          	add	a0,a0,-14 # 72d0 <malloc+0x12fa>
    32e6:	00003097          	auipc	ra,0x3
    32ea:	8f8080e7          	jalr	-1800(ra) # 5bde <unlink>
    32ee:	04054d63          	bltz	a0,3348 <iputtest+0x9e>
  if(chdir("/") < 0){
    32f2:	00004517          	auipc	a0,0x4
    32f6:	00e50513          	add	a0,a0,14 # 7300 <malloc+0x132a>
    32fa:	00003097          	auipc	ra,0x3
    32fe:	904080e7          	jalr	-1788(ra) # 5bfe <chdir>
    3302:	06054163          	bltz	a0,3364 <iputtest+0xba>
}
    3306:	60e2                	ld	ra,24(sp)
    3308:	6442                	ld	s0,16(sp)
    330a:	64a2                	ld	s1,8(sp)
    330c:	6105                	add	sp,sp,32
    330e:	8082                	ret
    printf("%s: mkdir failed\n", s);
    3310:	85a6                	mv	a1,s1
    3312:	00004517          	auipc	a0,0x4
    3316:	f8650513          	add	a0,a0,-122 # 7298 <malloc+0x12c2>
    331a:	00003097          	auipc	ra,0x3
    331e:	c04080e7          	jalr	-1020(ra) # 5f1e <printf>
    exit(1);
    3322:	4505                	li	a0,1
    3324:	00003097          	auipc	ra,0x3
    3328:	86a080e7          	jalr	-1942(ra) # 5b8e <exit>
    printf("%s: chdir iputdir failed\n", s);
    332c:	85a6                	mv	a1,s1
    332e:	00004517          	auipc	a0,0x4
    3332:	f8250513          	add	a0,a0,-126 # 72b0 <malloc+0x12da>
    3336:	00003097          	auipc	ra,0x3
    333a:	be8080e7          	jalr	-1048(ra) # 5f1e <printf>
    exit(1);
    333e:	4505                	li	a0,1
    3340:	00003097          	auipc	ra,0x3
    3344:	84e080e7          	jalr	-1970(ra) # 5b8e <exit>
    printf("%s: unlink ../iputdir failed\n", s);
    3348:	85a6                	mv	a1,s1
    334a:	00004517          	auipc	a0,0x4
    334e:	f9650513          	add	a0,a0,-106 # 72e0 <malloc+0x130a>
    3352:	00003097          	auipc	ra,0x3
    3356:	bcc080e7          	jalr	-1076(ra) # 5f1e <printf>
    exit(1);
    335a:	4505                	li	a0,1
    335c:	00003097          	auipc	ra,0x3
    3360:	832080e7          	jalr	-1998(ra) # 5b8e <exit>
    printf("%s: chdir / failed\n", s);
    3364:	85a6                	mv	a1,s1
    3366:	00004517          	auipc	a0,0x4
    336a:	fa250513          	add	a0,a0,-94 # 7308 <malloc+0x1332>
    336e:	00003097          	auipc	ra,0x3
    3372:	bb0080e7          	jalr	-1104(ra) # 5f1e <printf>
    exit(1);
    3376:	4505                	li	a0,1
    3378:	00003097          	auipc	ra,0x3
    337c:	816080e7          	jalr	-2026(ra) # 5b8e <exit>

0000000000003380 <exitiputtest>:
{
    3380:	7179                	add	sp,sp,-48
    3382:	f406                	sd	ra,40(sp)
    3384:	f022                	sd	s0,32(sp)
    3386:	ec26                	sd	s1,24(sp)
    3388:	1800                	add	s0,sp,48
    338a:	84aa                	mv	s1,a0
  pid = fork();
    338c:	00002097          	auipc	ra,0x2
    3390:	7fa080e7          	jalr	2042(ra) # 5b86 <fork>
  if(pid < 0){
    3394:	04054663          	bltz	a0,33e0 <exitiputtest+0x60>
  if(pid == 0){
    3398:	ed45                	bnez	a0,3450 <exitiputtest+0xd0>
    if(mkdir("iputdir") < 0){
    339a:	00004517          	auipc	a0,0x4
    339e:	ef650513          	add	a0,a0,-266 # 7290 <malloc+0x12ba>
    33a2:	00003097          	auipc	ra,0x3
    33a6:	854080e7          	jalr	-1964(ra) # 5bf6 <mkdir>
    33aa:	04054963          	bltz	a0,33fc <exitiputtest+0x7c>
    if(chdir("iputdir") < 0){
    33ae:	00004517          	auipc	a0,0x4
    33b2:	ee250513          	add	a0,a0,-286 # 7290 <malloc+0x12ba>
    33b6:	00003097          	auipc	ra,0x3
    33ba:	848080e7          	jalr	-1976(ra) # 5bfe <chdir>
    33be:	04054d63          	bltz	a0,3418 <exitiputtest+0x98>
    if(unlink("../iputdir") < 0){
    33c2:	00004517          	auipc	a0,0x4
    33c6:	f0e50513          	add	a0,a0,-242 # 72d0 <malloc+0x12fa>
    33ca:	00003097          	auipc	ra,0x3
    33ce:	814080e7          	jalr	-2028(ra) # 5bde <unlink>
    33d2:	06054163          	bltz	a0,3434 <exitiputtest+0xb4>
    exit(0);
    33d6:	4501                	li	a0,0
    33d8:	00002097          	auipc	ra,0x2
    33dc:	7b6080e7          	jalr	1974(ra) # 5b8e <exit>
    printf("%s: fork failed\n", s);
    33e0:	85a6                	mv	a1,s1
    33e2:	00003517          	auipc	a0,0x3
    33e6:	59e50513          	add	a0,a0,1438 # 6980 <malloc+0x9aa>
    33ea:	00003097          	auipc	ra,0x3
    33ee:	b34080e7          	jalr	-1228(ra) # 5f1e <printf>
    exit(1);
    33f2:	4505                	li	a0,1
    33f4:	00002097          	auipc	ra,0x2
    33f8:	79a080e7          	jalr	1946(ra) # 5b8e <exit>
      printf("%s: mkdir failed\n", s);
    33fc:	85a6                	mv	a1,s1
    33fe:	00004517          	auipc	a0,0x4
    3402:	e9a50513          	add	a0,a0,-358 # 7298 <malloc+0x12c2>
    3406:	00003097          	auipc	ra,0x3
    340a:	b18080e7          	jalr	-1256(ra) # 5f1e <printf>
      exit(1);
    340e:	4505                	li	a0,1
    3410:	00002097          	auipc	ra,0x2
    3414:	77e080e7          	jalr	1918(ra) # 5b8e <exit>
      printf("%s: child chdir failed\n", s);
    3418:	85a6                	mv	a1,s1
    341a:	00004517          	auipc	a0,0x4
    341e:	f0650513          	add	a0,a0,-250 # 7320 <malloc+0x134a>
    3422:	00003097          	auipc	ra,0x3
    3426:	afc080e7          	jalr	-1284(ra) # 5f1e <printf>
      exit(1);
    342a:	4505                	li	a0,1
    342c:	00002097          	auipc	ra,0x2
    3430:	762080e7          	jalr	1890(ra) # 5b8e <exit>
      printf("%s: unlink ../iputdir failed\n", s);
    3434:	85a6                	mv	a1,s1
    3436:	00004517          	auipc	a0,0x4
    343a:	eaa50513          	add	a0,a0,-342 # 72e0 <malloc+0x130a>
    343e:	00003097          	auipc	ra,0x3
    3442:	ae0080e7          	jalr	-1312(ra) # 5f1e <printf>
      exit(1);
    3446:	4505                	li	a0,1
    3448:	00002097          	auipc	ra,0x2
    344c:	746080e7          	jalr	1862(ra) # 5b8e <exit>
  wait(&xstatus);
    3450:	fdc40513          	add	a0,s0,-36
    3454:	00002097          	auipc	ra,0x2
    3458:	742080e7          	jalr	1858(ra) # 5b96 <wait>
  exit(xstatus);
    345c:	fdc42503          	lw	a0,-36(s0)
    3460:	00002097          	auipc	ra,0x2
    3464:	72e080e7          	jalr	1838(ra) # 5b8e <exit>

0000000000003468 <dirtest>:
{
    3468:	1101                	add	sp,sp,-32
    346a:	ec06                	sd	ra,24(sp)
    346c:	e822                	sd	s0,16(sp)
    346e:	e426                	sd	s1,8(sp)
    3470:	1000                	add	s0,sp,32
    3472:	84aa                	mv	s1,a0
  if(mkdir("dir0") < 0){
    3474:	00004517          	auipc	a0,0x4
    3478:	ec450513          	add	a0,a0,-316 # 7338 <malloc+0x1362>
    347c:	00002097          	auipc	ra,0x2
    3480:	77a080e7          	jalr	1914(ra) # 5bf6 <mkdir>
    3484:	04054563          	bltz	a0,34ce <dirtest+0x66>
  if(chdir("dir0") < 0){
    3488:	00004517          	auipc	a0,0x4
    348c:	eb050513          	add	a0,a0,-336 # 7338 <malloc+0x1362>
    3490:	00002097          	auipc	ra,0x2
    3494:	76e080e7          	jalr	1902(ra) # 5bfe <chdir>
    3498:	04054963          	bltz	a0,34ea <dirtest+0x82>
  if(chdir("..") < 0){
    349c:	00004517          	auipc	a0,0x4
    34a0:	ebc50513          	add	a0,a0,-324 # 7358 <malloc+0x1382>
    34a4:	00002097          	auipc	ra,0x2
    34a8:	75a080e7          	jalr	1882(ra) # 5bfe <chdir>
    34ac:	04054d63          	bltz	a0,3506 <dirtest+0x9e>
  if(unlink("dir0") < 0){
    34b0:	00004517          	auipc	a0,0x4
    34b4:	e8850513          	add	a0,a0,-376 # 7338 <malloc+0x1362>
    34b8:	00002097          	auipc	ra,0x2
    34bc:	726080e7          	jalr	1830(ra) # 5bde <unlink>
    34c0:	06054163          	bltz	a0,3522 <dirtest+0xba>
}
    34c4:	60e2                	ld	ra,24(sp)
    34c6:	6442                	ld	s0,16(sp)
    34c8:	64a2                	ld	s1,8(sp)
    34ca:	6105                	add	sp,sp,32
    34cc:	8082                	ret
    printf("%s: mkdir failed\n", s);
    34ce:	85a6                	mv	a1,s1
    34d0:	00004517          	auipc	a0,0x4
    34d4:	dc850513          	add	a0,a0,-568 # 7298 <malloc+0x12c2>
    34d8:	00003097          	auipc	ra,0x3
    34dc:	a46080e7          	jalr	-1466(ra) # 5f1e <printf>
    exit(1);
    34e0:	4505                	li	a0,1
    34e2:	00002097          	auipc	ra,0x2
    34e6:	6ac080e7          	jalr	1708(ra) # 5b8e <exit>
    printf("%s: chdir dir0 failed\n", s);
    34ea:	85a6                	mv	a1,s1
    34ec:	00004517          	auipc	a0,0x4
    34f0:	e5450513          	add	a0,a0,-428 # 7340 <malloc+0x136a>
    34f4:	00003097          	auipc	ra,0x3
    34f8:	a2a080e7          	jalr	-1494(ra) # 5f1e <printf>
    exit(1);
    34fc:	4505                	li	a0,1
    34fe:	00002097          	auipc	ra,0x2
    3502:	690080e7          	jalr	1680(ra) # 5b8e <exit>
    printf("%s: chdir .. failed\n", s);
    3506:	85a6                	mv	a1,s1
    3508:	00004517          	auipc	a0,0x4
    350c:	e5850513          	add	a0,a0,-424 # 7360 <malloc+0x138a>
    3510:	00003097          	auipc	ra,0x3
    3514:	a0e080e7          	jalr	-1522(ra) # 5f1e <printf>
    exit(1);
    3518:	4505                	li	a0,1
    351a:	00002097          	auipc	ra,0x2
    351e:	674080e7          	jalr	1652(ra) # 5b8e <exit>
    printf("%s: unlink dir0 failed\n", s);
    3522:	85a6                	mv	a1,s1
    3524:	00004517          	auipc	a0,0x4
    3528:	e5450513          	add	a0,a0,-428 # 7378 <malloc+0x13a2>
    352c:	00003097          	auipc	ra,0x3
    3530:	9f2080e7          	jalr	-1550(ra) # 5f1e <printf>
    exit(1);
    3534:	4505                	li	a0,1
    3536:	00002097          	auipc	ra,0x2
    353a:	658080e7          	jalr	1624(ra) # 5b8e <exit>

000000000000353e <subdir>:
{
    353e:	1101                	add	sp,sp,-32
    3540:	ec06                	sd	ra,24(sp)
    3542:	e822                	sd	s0,16(sp)
    3544:	e426                	sd	s1,8(sp)
    3546:	e04a                	sd	s2,0(sp)
    3548:	1000                	add	s0,sp,32
    354a:	892a                	mv	s2,a0
  unlink("ff");
    354c:	00004517          	auipc	a0,0x4
    3550:	f7450513          	add	a0,a0,-140 # 74c0 <malloc+0x14ea>
    3554:	00002097          	auipc	ra,0x2
    3558:	68a080e7          	jalr	1674(ra) # 5bde <unlink>
  if(mkdir("dd") != 0){
    355c:	00004517          	auipc	a0,0x4
    3560:	e3450513          	add	a0,a0,-460 # 7390 <malloc+0x13ba>
    3564:	00002097          	auipc	ra,0x2
    3568:	692080e7          	jalr	1682(ra) # 5bf6 <mkdir>
    356c:	38051663          	bnez	a0,38f8 <subdir+0x3ba>
  fd = open("dd/ff", O_CREATE | O_RDWR);
    3570:	20200593          	li	a1,514
    3574:	00004517          	auipc	a0,0x4
    3578:	e3c50513          	add	a0,a0,-452 # 73b0 <malloc+0x13da>
    357c:	00002097          	auipc	ra,0x2
    3580:	652080e7          	jalr	1618(ra) # 5bce <open>
    3584:	84aa                	mv	s1,a0
  if(fd < 0){
    3586:	38054763          	bltz	a0,3914 <subdir+0x3d6>
  write(fd, "ff", 2);
    358a:	4609                	li	a2,2
    358c:	00004597          	auipc	a1,0x4
    3590:	f3458593          	add	a1,a1,-204 # 74c0 <malloc+0x14ea>
    3594:	00002097          	auipc	ra,0x2
    3598:	61a080e7          	jalr	1562(ra) # 5bae <write>
  close(fd);
    359c:	8526                	mv	a0,s1
    359e:	00002097          	auipc	ra,0x2
    35a2:	618080e7          	jalr	1560(ra) # 5bb6 <close>
  if(unlink("dd") >= 0){
    35a6:	00004517          	auipc	a0,0x4
    35aa:	dea50513          	add	a0,a0,-534 # 7390 <malloc+0x13ba>
    35ae:	00002097          	auipc	ra,0x2
    35b2:	630080e7          	jalr	1584(ra) # 5bde <unlink>
    35b6:	36055d63          	bgez	a0,3930 <subdir+0x3f2>
  if(mkdir("/dd/dd") != 0){
    35ba:	00004517          	auipc	a0,0x4
    35be:	e4e50513          	add	a0,a0,-434 # 7408 <malloc+0x1432>
    35c2:	00002097          	auipc	ra,0x2
    35c6:	634080e7          	jalr	1588(ra) # 5bf6 <mkdir>
    35ca:	38051163          	bnez	a0,394c <subdir+0x40e>
  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    35ce:	20200593          	li	a1,514
    35d2:	00004517          	auipc	a0,0x4
    35d6:	e5e50513          	add	a0,a0,-418 # 7430 <malloc+0x145a>
    35da:	00002097          	auipc	ra,0x2
    35de:	5f4080e7          	jalr	1524(ra) # 5bce <open>
    35e2:	84aa                	mv	s1,a0
  if(fd < 0){
    35e4:	38054263          	bltz	a0,3968 <subdir+0x42a>
  write(fd, "FF", 2);
    35e8:	4609                	li	a2,2
    35ea:	00004597          	auipc	a1,0x4
    35ee:	e7658593          	add	a1,a1,-394 # 7460 <malloc+0x148a>
    35f2:	00002097          	auipc	ra,0x2
    35f6:	5bc080e7          	jalr	1468(ra) # 5bae <write>
  close(fd);
    35fa:	8526                	mv	a0,s1
    35fc:	00002097          	auipc	ra,0x2
    3600:	5ba080e7          	jalr	1466(ra) # 5bb6 <close>
  fd = open("dd/dd/../ff", 0);
    3604:	4581                	li	a1,0
    3606:	00004517          	auipc	a0,0x4
    360a:	e6250513          	add	a0,a0,-414 # 7468 <malloc+0x1492>
    360e:	00002097          	auipc	ra,0x2
    3612:	5c0080e7          	jalr	1472(ra) # 5bce <open>
    3616:	84aa                	mv	s1,a0
  if(fd < 0){
    3618:	36054663          	bltz	a0,3984 <subdir+0x446>
  cc = read(fd, buf, sizeof(buf));
    361c:	660d                	lui	a2,0x3
    361e:	00009597          	auipc	a1,0x9
    3622:	64a58593          	add	a1,a1,1610 # cc68 <buf>
    3626:	00002097          	auipc	ra,0x2
    362a:	580080e7          	jalr	1408(ra) # 5ba6 <read>
  if(cc != 2 || buf[0] != 'f'){
    362e:	4789                	li	a5,2
    3630:	36f51863          	bne	a0,a5,39a0 <subdir+0x462>
    3634:	00009717          	auipc	a4,0x9
    3638:	63474703          	lbu	a4,1588(a4) # cc68 <buf>
    363c:	06600793          	li	a5,102
    3640:	36f71063          	bne	a4,a5,39a0 <subdir+0x462>
  close(fd);
    3644:	8526                	mv	a0,s1
    3646:	00002097          	auipc	ra,0x2
    364a:	570080e7          	jalr	1392(ra) # 5bb6 <close>
  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    364e:	00004597          	auipc	a1,0x4
    3652:	e6a58593          	add	a1,a1,-406 # 74b8 <malloc+0x14e2>
    3656:	00004517          	auipc	a0,0x4
    365a:	dda50513          	add	a0,a0,-550 # 7430 <malloc+0x145a>
    365e:	00002097          	auipc	ra,0x2
    3662:	590080e7          	jalr	1424(ra) # 5bee <link>
    3666:	34051b63          	bnez	a0,39bc <subdir+0x47e>
  if(unlink("dd/dd/ff") != 0){
    366a:	00004517          	auipc	a0,0x4
    366e:	dc650513          	add	a0,a0,-570 # 7430 <malloc+0x145a>
    3672:	00002097          	auipc	ra,0x2
    3676:	56c080e7          	jalr	1388(ra) # 5bde <unlink>
    367a:	34051f63          	bnez	a0,39d8 <subdir+0x49a>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    367e:	4581                	li	a1,0
    3680:	00004517          	auipc	a0,0x4
    3684:	db050513          	add	a0,a0,-592 # 7430 <malloc+0x145a>
    3688:	00002097          	auipc	ra,0x2
    368c:	546080e7          	jalr	1350(ra) # 5bce <open>
    3690:	36055263          	bgez	a0,39f4 <subdir+0x4b6>
  if(chdir("dd") != 0){
    3694:	00004517          	auipc	a0,0x4
    3698:	cfc50513          	add	a0,a0,-772 # 7390 <malloc+0x13ba>
    369c:	00002097          	auipc	ra,0x2
    36a0:	562080e7          	jalr	1378(ra) # 5bfe <chdir>
    36a4:	36051663          	bnez	a0,3a10 <subdir+0x4d2>
  if(chdir("dd/../../dd") != 0){
    36a8:	00004517          	auipc	a0,0x4
    36ac:	ea850513          	add	a0,a0,-344 # 7550 <malloc+0x157a>
    36b0:	00002097          	auipc	ra,0x2
    36b4:	54e080e7          	jalr	1358(ra) # 5bfe <chdir>
    36b8:	36051a63          	bnez	a0,3a2c <subdir+0x4ee>
  if(chdir("dd/../../../dd") != 0){
    36bc:	00004517          	auipc	a0,0x4
    36c0:	ec450513          	add	a0,a0,-316 # 7580 <malloc+0x15aa>
    36c4:	00002097          	auipc	ra,0x2
    36c8:	53a080e7          	jalr	1338(ra) # 5bfe <chdir>
    36cc:	36051e63          	bnez	a0,3a48 <subdir+0x50a>
  if(chdir("./..") != 0){
    36d0:	00004517          	auipc	a0,0x4
    36d4:	ee050513          	add	a0,a0,-288 # 75b0 <malloc+0x15da>
    36d8:	00002097          	auipc	ra,0x2
    36dc:	526080e7          	jalr	1318(ra) # 5bfe <chdir>
    36e0:	38051263          	bnez	a0,3a64 <subdir+0x526>
  fd = open("dd/dd/ffff", 0);
    36e4:	4581                	li	a1,0
    36e6:	00004517          	auipc	a0,0x4
    36ea:	dd250513          	add	a0,a0,-558 # 74b8 <malloc+0x14e2>
    36ee:	00002097          	auipc	ra,0x2
    36f2:	4e0080e7          	jalr	1248(ra) # 5bce <open>
    36f6:	84aa                	mv	s1,a0
  if(fd < 0){
    36f8:	38054463          	bltz	a0,3a80 <subdir+0x542>
  if(read(fd, buf, sizeof(buf)) != 2){
    36fc:	660d                	lui	a2,0x3
    36fe:	00009597          	auipc	a1,0x9
    3702:	56a58593          	add	a1,a1,1386 # cc68 <buf>
    3706:	00002097          	auipc	ra,0x2
    370a:	4a0080e7          	jalr	1184(ra) # 5ba6 <read>
    370e:	4789                	li	a5,2
    3710:	38f51663          	bne	a0,a5,3a9c <subdir+0x55e>
  close(fd);
    3714:	8526                	mv	a0,s1
    3716:	00002097          	auipc	ra,0x2
    371a:	4a0080e7          	jalr	1184(ra) # 5bb6 <close>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    371e:	4581                	li	a1,0
    3720:	00004517          	auipc	a0,0x4
    3724:	d1050513          	add	a0,a0,-752 # 7430 <malloc+0x145a>
    3728:	00002097          	auipc	ra,0x2
    372c:	4a6080e7          	jalr	1190(ra) # 5bce <open>
    3730:	38055463          	bgez	a0,3ab8 <subdir+0x57a>
  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    3734:	20200593          	li	a1,514
    3738:	00004517          	auipc	a0,0x4
    373c:	f0850513          	add	a0,a0,-248 # 7640 <malloc+0x166a>
    3740:	00002097          	auipc	ra,0x2
    3744:	48e080e7          	jalr	1166(ra) # 5bce <open>
    3748:	38055663          	bgez	a0,3ad4 <subdir+0x596>
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    374c:	20200593          	li	a1,514
    3750:	00004517          	auipc	a0,0x4
    3754:	f2050513          	add	a0,a0,-224 # 7670 <malloc+0x169a>
    3758:	00002097          	auipc	ra,0x2
    375c:	476080e7          	jalr	1142(ra) # 5bce <open>
    3760:	38055863          	bgez	a0,3af0 <subdir+0x5b2>
  if(open("dd", O_CREATE) >= 0){
    3764:	20000593          	li	a1,512
    3768:	00004517          	auipc	a0,0x4
    376c:	c2850513          	add	a0,a0,-984 # 7390 <malloc+0x13ba>
    3770:	00002097          	auipc	ra,0x2
    3774:	45e080e7          	jalr	1118(ra) # 5bce <open>
    3778:	38055a63          	bgez	a0,3b0c <subdir+0x5ce>
  if(open("dd", O_RDWR) >= 0){
    377c:	4589                	li	a1,2
    377e:	00004517          	auipc	a0,0x4
    3782:	c1250513          	add	a0,a0,-1006 # 7390 <malloc+0x13ba>
    3786:	00002097          	auipc	ra,0x2
    378a:	448080e7          	jalr	1096(ra) # 5bce <open>
    378e:	38055d63          	bgez	a0,3b28 <subdir+0x5ea>
  if(open("dd", O_WRONLY) >= 0){
    3792:	4585                	li	a1,1
    3794:	00004517          	auipc	a0,0x4
    3798:	bfc50513          	add	a0,a0,-1028 # 7390 <malloc+0x13ba>
    379c:	00002097          	auipc	ra,0x2
    37a0:	432080e7          	jalr	1074(ra) # 5bce <open>
    37a4:	3a055063          	bgez	a0,3b44 <subdir+0x606>
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    37a8:	00004597          	auipc	a1,0x4
    37ac:	f5858593          	add	a1,a1,-168 # 7700 <malloc+0x172a>
    37b0:	00004517          	auipc	a0,0x4
    37b4:	e9050513          	add	a0,a0,-368 # 7640 <malloc+0x166a>
    37b8:	00002097          	auipc	ra,0x2
    37bc:	436080e7          	jalr	1078(ra) # 5bee <link>
    37c0:	3a050063          	beqz	a0,3b60 <subdir+0x622>
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    37c4:	00004597          	auipc	a1,0x4
    37c8:	f3c58593          	add	a1,a1,-196 # 7700 <malloc+0x172a>
    37cc:	00004517          	auipc	a0,0x4
    37d0:	ea450513          	add	a0,a0,-348 # 7670 <malloc+0x169a>
    37d4:	00002097          	auipc	ra,0x2
    37d8:	41a080e7          	jalr	1050(ra) # 5bee <link>
    37dc:	3a050063          	beqz	a0,3b7c <subdir+0x63e>
  if(link("dd/ff", "dd/dd/ffff") == 0){
    37e0:	00004597          	auipc	a1,0x4
    37e4:	cd858593          	add	a1,a1,-808 # 74b8 <malloc+0x14e2>
    37e8:	00004517          	auipc	a0,0x4
    37ec:	bc850513          	add	a0,a0,-1080 # 73b0 <malloc+0x13da>
    37f0:	00002097          	auipc	ra,0x2
    37f4:	3fe080e7          	jalr	1022(ra) # 5bee <link>
    37f8:	3a050063          	beqz	a0,3b98 <subdir+0x65a>
  if(mkdir("dd/ff/ff") == 0){
    37fc:	00004517          	auipc	a0,0x4
    3800:	e4450513          	add	a0,a0,-444 # 7640 <malloc+0x166a>
    3804:	00002097          	auipc	ra,0x2
    3808:	3f2080e7          	jalr	1010(ra) # 5bf6 <mkdir>
    380c:	3a050463          	beqz	a0,3bb4 <subdir+0x676>
  if(mkdir("dd/xx/ff") == 0){
    3810:	00004517          	auipc	a0,0x4
    3814:	e6050513          	add	a0,a0,-416 # 7670 <malloc+0x169a>
    3818:	00002097          	auipc	ra,0x2
    381c:	3de080e7          	jalr	990(ra) # 5bf6 <mkdir>
    3820:	3a050863          	beqz	a0,3bd0 <subdir+0x692>
  if(mkdir("dd/dd/ffff") == 0){
    3824:	00004517          	auipc	a0,0x4
    3828:	c9450513          	add	a0,a0,-876 # 74b8 <malloc+0x14e2>
    382c:	00002097          	auipc	ra,0x2
    3830:	3ca080e7          	jalr	970(ra) # 5bf6 <mkdir>
    3834:	3a050c63          	beqz	a0,3bec <subdir+0x6ae>
  if(unlink("dd/xx/ff") == 0){
    3838:	00004517          	auipc	a0,0x4
    383c:	e3850513          	add	a0,a0,-456 # 7670 <malloc+0x169a>
    3840:	00002097          	auipc	ra,0x2
    3844:	39e080e7          	jalr	926(ra) # 5bde <unlink>
    3848:	3c050063          	beqz	a0,3c08 <subdir+0x6ca>
  if(unlink("dd/ff/ff") == 0){
    384c:	00004517          	auipc	a0,0x4
    3850:	df450513          	add	a0,a0,-524 # 7640 <malloc+0x166a>
    3854:	00002097          	auipc	ra,0x2
    3858:	38a080e7          	jalr	906(ra) # 5bde <unlink>
    385c:	3c050463          	beqz	a0,3c24 <subdir+0x6e6>
  if(chdir("dd/ff") == 0){
    3860:	00004517          	auipc	a0,0x4
    3864:	b5050513          	add	a0,a0,-1200 # 73b0 <malloc+0x13da>
    3868:	00002097          	auipc	ra,0x2
    386c:	396080e7          	jalr	918(ra) # 5bfe <chdir>
    3870:	3c050863          	beqz	a0,3c40 <subdir+0x702>
  if(chdir("dd/xx") == 0){
    3874:	00004517          	auipc	a0,0x4
    3878:	fdc50513          	add	a0,a0,-36 # 7850 <malloc+0x187a>
    387c:	00002097          	auipc	ra,0x2
    3880:	382080e7          	jalr	898(ra) # 5bfe <chdir>
    3884:	3c050c63          	beqz	a0,3c5c <subdir+0x71e>
  if(unlink("dd/dd/ffff") != 0){
    3888:	00004517          	auipc	a0,0x4
    388c:	c3050513          	add	a0,a0,-976 # 74b8 <malloc+0x14e2>
    3890:	00002097          	auipc	ra,0x2
    3894:	34e080e7          	jalr	846(ra) # 5bde <unlink>
    3898:	3e051063          	bnez	a0,3c78 <subdir+0x73a>
  if(unlink("dd/ff") != 0){
    389c:	00004517          	auipc	a0,0x4
    38a0:	b1450513          	add	a0,a0,-1260 # 73b0 <malloc+0x13da>
    38a4:	00002097          	auipc	ra,0x2
    38a8:	33a080e7          	jalr	826(ra) # 5bde <unlink>
    38ac:	3e051463          	bnez	a0,3c94 <subdir+0x756>
  if(unlink("dd") == 0){
    38b0:	00004517          	auipc	a0,0x4
    38b4:	ae050513          	add	a0,a0,-1312 # 7390 <malloc+0x13ba>
    38b8:	00002097          	auipc	ra,0x2
    38bc:	326080e7          	jalr	806(ra) # 5bde <unlink>
    38c0:	3e050863          	beqz	a0,3cb0 <subdir+0x772>
  if(unlink("dd/dd") < 0){
    38c4:	00004517          	auipc	a0,0x4
    38c8:	ffc50513          	add	a0,a0,-4 # 78c0 <malloc+0x18ea>
    38cc:	00002097          	auipc	ra,0x2
    38d0:	312080e7          	jalr	786(ra) # 5bde <unlink>
    38d4:	3e054c63          	bltz	a0,3ccc <subdir+0x78e>
  if(unlink("dd") < 0){
    38d8:	00004517          	auipc	a0,0x4
    38dc:	ab850513          	add	a0,a0,-1352 # 7390 <malloc+0x13ba>
    38e0:	00002097          	auipc	ra,0x2
    38e4:	2fe080e7          	jalr	766(ra) # 5bde <unlink>
    38e8:	40054063          	bltz	a0,3ce8 <subdir+0x7aa>
}
    38ec:	60e2                	ld	ra,24(sp)
    38ee:	6442                	ld	s0,16(sp)
    38f0:	64a2                	ld	s1,8(sp)
    38f2:	6902                	ld	s2,0(sp)
    38f4:	6105                	add	sp,sp,32
    38f6:	8082                	ret
    printf("%s: mkdir dd failed\n", s);
    38f8:	85ca                	mv	a1,s2
    38fa:	00004517          	auipc	a0,0x4
    38fe:	a9e50513          	add	a0,a0,-1378 # 7398 <malloc+0x13c2>
    3902:	00002097          	auipc	ra,0x2
    3906:	61c080e7          	jalr	1564(ra) # 5f1e <printf>
    exit(1);
    390a:	4505                	li	a0,1
    390c:	00002097          	auipc	ra,0x2
    3910:	282080e7          	jalr	642(ra) # 5b8e <exit>
    printf("%s: create dd/ff failed\n", s);
    3914:	85ca                	mv	a1,s2
    3916:	00004517          	auipc	a0,0x4
    391a:	aa250513          	add	a0,a0,-1374 # 73b8 <malloc+0x13e2>
    391e:	00002097          	auipc	ra,0x2
    3922:	600080e7          	jalr	1536(ra) # 5f1e <printf>
    exit(1);
    3926:	4505                	li	a0,1
    3928:	00002097          	auipc	ra,0x2
    392c:	266080e7          	jalr	614(ra) # 5b8e <exit>
    printf("%s: unlink dd (non-empty dir) succeeded!\n", s);
    3930:	85ca                	mv	a1,s2
    3932:	00004517          	auipc	a0,0x4
    3936:	aa650513          	add	a0,a0,-1370 # 73d8 <malloc+0x1402>
    393a:	00002097          	auipc	ra,0x2
    393e:	5e4080e7          	jalr	1508(ra) # 5f1e <printf>
    exit(1);
    3942:	4505                	li	a0,1
    3944:	00002097          	auipc	ra,0x2
    3948:	24a080e7          	jalr	586(ra) # 5b8e <exit>
    printf("subdir mkdir dd/dd failed\n", s);
    394c:	85ca                	mv	a1,s2
    394e:	00004517          	auipc	a0,0x4
    3952:	ac250513          	add	a0,a0,-1342 # 7410 <malloc+0x143a>
    3956:	00002097          	auipc	ra,0x2
    395a:	5c8080e7          	jalr	1480(ra) # 5f1e <printf>
    exit(1);
    395e:	4505                	li	a0,1
    3960:	00002097          	auipc	ra,0x2
    3964:	22e080e7          	jalr	558(ra) # 5b8e <exit>
    printf("%s: create dd/dd/ff failed\n", s);
    3968:	85ca                	mv	a1,s2
    396a:	00004517          	auipc	a0,0x4
    396e:	ad650513          	add	a0,a0,-1322 # 7440 <malloc+0x146a>
    3972:	00002097          	auipc	ra,0x2
    3976:	5ac080e7          	jalr	1452(ra) # 5f1e <printf>
    exit(1);
    397a:	4505                	li	a0,1
    397c:	00002097          	auipc	ra,0x2
    3980:	212080e7          	jalr	530(ra) # 5b8e <exit>
    printf("%s: open dd/dd/../ff failed\n", s);
    3984:	85ca                	mv	a1,s2
    3986:	00004517          	auipc	a0,0x4
    398a:	af250513          	add	a0,a0,-1294 # 7478 <malloc+0x14a2>
    398e:	00002097          	auipc	ra,0x2
    3992:	590080e7          	jalr	1424(ra) # 5f1e <printf>
    exit(1);
    3996:	4505                	li	a0,1
    3998:	00002097          	auipc	ra,0x2
    399c:	1f6080e7          	jalr	502(ra) # 5b8e <exit>
    printf("%s: dd/dd/../ff wrong content\n", s);
    39a0:	85ca                	mv	a1,s2
    39a2:	00004517          	auipc	a0,0x4
    39a6:	af650513          	add	a0,a0,-1290 # 7498 <malloc+0x14c2>
    39aa:	00002097          	auipc	ra,0x2
    39ae:	574080e7          	jalr	1396(ra) # 5f1e <printf>
    exit(1);
    39b2:	4505                	li	a0,1
    39b4:	00002097          	auipc	ra,0x2
    39b8:	1da080e7          	jalr	474(ra) # 5b8e <exit>
    printf("link dd/dd/ff dd/dd/ffff failed\n", s);
    39bc:	85ca                	mv	a1,s2
    39be:	00004517          	auipc	a0,0x4
    39c2:	b0a50513          	add	a0,a0,-1270 # 74c8 <malloc+0x14f2>
    39c6:	00002097          	auipc	ra,0x2
    39ca:	558080e7          	jalr	1368(ra) # 5f1e <printf>
    exit(1);
    39ce:	4505                	li	a0,1
    39d0:	00002097          	auipc	ra,0x2
    39d4:	1be080e7          	jalr	446(ra) # 5b8e <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    39d8:	85ca                	mv	a1,s2
    39da:	00004517          	auipc	a0,0x4
    39de:	b1650513          	add	a0,a0,-1258 # 74f0 <malloc+0x151a>
    39e2:	00002097          	auipc	ra,0x2
    39e6:	53c080e7          	jalr	1340(ra) # 5f1e <printf>
    exit(1);
    39ea:	4505                	li	a0,1
    39ec:	00002097          	auipc	ra,0x2
    39f0:	1a2080e7          	jalr	418(ra) # 5b8e <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded\n", s);
    39f4:	85ca                	mv	a1,s2
    39f6:	00004517          	auipc	a0,0x4
    39fa:	b1a50513          	add	a0,a0,-1254 # 7510 <malloc+0x153a>
    39fe:	00002097          	auipc	ra,0x2
    3a02:	520080e7          	jalr	1312(ra) # 5f1e <printf>
    exit(1);
    3a06:	4505                	li	a0,1
    3a08:	00002097          	auipc	ra,0x2
    3a0c:	186080e7          	jalr	390(ra) # 5b8e <exit>
    printf("%s: chdir dd failed\n", s);
    3a10:	85ca                	mv	a1,s2
    3a12:	00004517          	auipc	a0,0x4
    3a16:	b2650513          	add	a0,a0,-1242 # 7538 <malloc+0x1562>
    3a1a:	00002097          	auipc	ra,0x2
    3a1e:	504080e7          	jalr	1284(ra) # 5f1e <printf>
    exit(1);
    3a22:	4505                	li	a0,1
    3a24:	00002097          	auipc	ra,0x2
    3a28:	16a080e7          	jalr	362(ra) # 5b8e <exit>
    printf("%s: chdir dd/../../dd failed\n", s);
    3a2c:	85ca                	mv	a1,s2
    3a2e:	00004517          	auipc	a0,0x4
    3a32:	b3250513          	add	a0,a0,-1230 # 7560 <malloc+0x158a>
    3a36:	00002097          	auipc	ra,0x2
    3a3a:	4e8080e7          	jalr	1256(ra) # 5f1e <printf>
    exit(1);
    3a3e:	4505                	li	a0,1
    3a40:	00002097          	auipc	ra,0x2
    3a44:	14e080e7          	jalr	334(ra) # 5b8e <exit>
    printf("chdir dd/../../dd failed\n", s);
    3a48:	85ca                	mv	a1,s2
    3a4a:	00004517          	auipc	a0,0x4
    3a4e:	b4650513          	add	a0,a0,-1210 # 7590 <malloc+0x15ba>
    3a52:	00002097          	auipc	ra,0x2
    3a56:	4cc080e7          	jalr	1228(ra) # 5f1e <printf>
    exit(1);
    3a5a:	4505                	li	a0,1
    3a5c:	00002097          	auipc	ra,0x2
    3a60:	132080e7          	jalr	306(ra) # 5b8e <exit>
    printf("%s: chdir ./.. failed\n", s);
    3a64:	85ca                	mv	a1,s2
    3a66:	00004517          	auipc	a0,0x4
    3a6a:	b5250513          	add	a0,a0,-1198 # 75b8 <malloc+0x15e2>
    3a6e:	00002097          	auipc	ra,0x2
    3a72:	4b0080e7          	jalr	1200(ra) # 5f1e <printf>
    exit(1);
    3a76:	4505                	li	a0,1
    3a78:	00002097          	auipc	ra,0x2
    3a7c:	116080e7          	jalr	278(ra) # 5b8e <exit>
    printf("%s: open dd/dd/ffff failed\n", s);
    3a80:	85ca                	mv	a1,s2
    3a82:	00004517          	auipc	a0,0x4
    3a86:	b4e50513          	add	a0,a0,-1202 # 75d0 <malloc+0x15fa>
    3a8a:	00002097          	auipc	ra,0x2
    3a8e:	494080e7          	jalr	1172(ra) # 5f1e <printf>
    exit(1);
    3a92:	4505                	li	a0,1
    3a94:	00002097          	auipc	ra,0x2
    3a98:	0fa080e7          	jalr	250(ra) # 5b8e <exit>
    printf("%s: read dd/dd/ffff wrong len\n", s);
    3a9c:	85ca                	mv	a1,s2
    3a9e:	00004517          	auipc	a0,0x4
    3aa2:	b5250513          	add	a0,a0,-1198 # 75f0 <malloc+0x161a>
    3aa6:	00002097          	auipc	ra,0x2
    3aaa:	478080e7          	jalr	1144(ra) # 5f1e <printf>
    exit(1);
    3aae:	4505                	li	a0,1
    3ab0:	00002097          	auipc	ra,0x2
    3ab4:	0de080e7          	jalr	222(ra) # 5b8e <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded!\n", s);
    3ab8:	85ca                	mv	a1,s2
    3aba:	00004517          	auipc	a0,0x4
    3abe:	b5650513          	add	a0,a0,-1194 # 7610 <malloc+0x163a>
    3ac2:	00002097          	auipc	ra,0x2
    3ac6:	45c080e7          	jalr	1116(ra) # 5f1e <printf>
    exit(1);
    3aca:	4505                	li	a0,1
    3acc:	00002097          	auipc	ra,0x2
    3ad0:	0c2080e7          	jalr	194(ra) # 5b8e <exit>
    printf("%s: create dd/ff/ff succeeded!\n", s);
    3ad4:	85ca                	mv	a1,s2
    3ad6:	00004517          	auipc	a0,0x4
    3ada:	b7a50513          	add	a0,a0,-1158 # 7650 <malloc+0x167a>
    3ade:	00002097          	auipc	ra,0x2
    3ae2:	440080e7          	jalr	1088(ra) # 5f1e <printf>
    exit(1);
    3ae6:	4505                	li	a0,1
    3ae8:	00002097          	auipc	ra,0x2
    3aec:	0a6080e7          	jalr	166(ra) # 5b8e <exit>
    printf("%s: create dd/xx/ff succeeded!\n", s);
    3af0:	85ca                	mv	a1,s2
    3af2:	00004517          	auipc	a0,0x4
    3af6:	b8e50513          	add	a0,a0,-1138 # 7680 <malloc+0x16aa>
    3afa:	00002097          	auipc	ra,0x2
    3afe:	424080e7          	jalr	1060(ra) # 5f1e <printf>
    exit(1);
    3b02:	4505                	li	a0,1
    3b04:	00002097          	auipc	ra,0x2
    3b08:	08a080e7          	jalr	138(ra) # 5b8e <exit>
    printf("%s: create dd succeeded!\n", s);
    3b0c:	85ca                	mv	a1,s2
    3b0e:	00004517          	auipc	a0,0x4
    3b12:	b9250513          	add	a0,a0,-1134 # 76a0 <malloc+0x16ca>
    3b16:	00002097          	auipc	ra,0x2
    3b1a:	408080e7          	jalr	1032(ra) # 5f1e <printf>
    exit(1);
    3b1e:	4505                	li	a0,1
    3b20:	00002097          	auipc	ra,0x2
    3b24:	06e080e7          	jalr	110(ra) # 5b8e <exit>
    printf("%s: open dd rdwr succeeded!\n", s);
    3b28:	85ca                	mv	a1,s2
    3b2a:	00004517          	auipc	a0,0x4
    3b2e:	b9650513          	add	a0,a0,-1130 # 76c0 <malloc+0x16ea>
    3b32:	00002097          	auipc	ra,0x2
    3b36:	3ec080e7          	jalr	1004(ra) # 5f1e <printf>
    exit(1);
    3b3a:	4505                	li	a0,1
    3b3c:	00002097          	auipc	ra,0x2
    3b40:	052080e7          	jalr	82(ra) # 5b8e <exit>
    printf("%s: open dd wronly succeeded!\n", s);
    3b44:	85ca                	mv	a1,s2
    3b46:	00004517          	auipc	a0,0x4
    3b4a:	b9a50513          	add	a0,a0,-1126 # 76e0 <malloc+0x170a>
    3b4e:	00002097          	auipc	ra,0x2
    3b52:	3d0080e7          	jalr	976(ra) # 5f1e <printf>
    exit(1);
    3b56:	4505                	li	a0,1
    3b58:	00002097          	auipc	ra,0x2
    3b5c:	036080e7          	jalr	54(ra) # 5b8e <exit>
    printf("%s: link dd/ff/ff dd/dd/xx succeeded!\n", s);
    3b60:	85ca                	mv	a1,s2
    3b62:	00004517          	auipc	a0,0x4
    3b66:	bae50513          	add	a0,a0,-1106 # 7710 <malloc+0x173a>
    3b6a:	00002097          	auipc	ra,0x2
    3b6e:	3b4080e7          	jalr	948(ra) # 5f1e <printf>
    exit(1);
    3b72:	4505                	li	a0,1
    3b74:	00002097          	auipc	ra,0x2
    3b78:	01a080e7          	jalr	26(ra) # 5b8e <exit>
    printf("%s: link dd/xx/ff dd/dd/xx succeeded!\n", s);
    3b7c:	85ca                	mv	a1,s2
    3b7e:	00004517          	auipc	a0,0x4
    3b82:	bba50513          	add	a0,a0,-1094 # 7738 <malloc+0x1762>
    3b86:	00002097          	auipc	ra,0x2
    3b8a:	398080e7          	jalr	920(ra) # 5f1e <printf>
    exit(1);
    3b8e:	4505                	li	a0,1
    3b90:	00002097          	auipc	ra,0x2
    3b94:	ffe080e7          	jalr	-2(ra) # 5b8e <exit>
    printf("%s: link dd/ff dd/dd/ffff succeeded!\n", s);
    3b98:	85ca                	mv	a1,s2
    3b9a:	00004517          	auipc	a0,0x4
    3b9e:	bc650513          	add	a0,a0,-1082 # 7760 <malloc+0x178a>
    3ba2:	00002097          	auipc	ra,0x2
    3ba6:	37c080e7          	jalr	892(ra) # 5f1e <printf>
    exit(1);
    3baa:	4505                	li	a0,1
    3bac:	00002097          	auipc	ra,0x2
    3bb0:	fe2080e7          	jalr	-30(ra) # 5b8e <exit>
    printf("%s: mkdir dd/ff/ff succeeded!\n", s);
    3bb4:	85ca                	mv	a1,s2
    3bb6:	00004517          	auipc	a0,0x4
    3bba:	bd250513          	add	a0,a0,-1070 # 7788 <malloc+0x17b2>
    3bbe:	00002097          	auipc	ra,0x2
    3bc2:	360080e7          	jalr	864(ra) # 5f1e <printf>
    exit(1);
    3bc6:	4505                	li	a0,1
    3bc8:	00002097          	auipc	ra,0x2
    3bcc:	fc6080e7          	jalr	-58(ra) # 5b8e <exit>
    printf("%s: mkdir dd/xx/ff succeeded!\n", s);
    3bd0:	85ca                	mv	a1,s2
    3bd2:	00004517          	auipc	a0,0x4
    3bd6:	bd650513          	add	a0,a0,-1066 # 77a8 <malloc+0x17d2>
    3bda:	00002097          	auipc	ra,0x2
    3bde:	344080e7          	jalr	836(ra) # 5f1e <printf>
    exit(1);
    3be2:	4505                	li	a0,1
    3be4:	00002097          	auipc	ra,0x2
    3be8:	faa080e7          	jalr	-86(ra) # 5b8e <exit>
    printf("%s: mkdir dd/dd/ffff succeeded!\n", s);
    3bec:	85ca                	mv	a1,s2
    3bee:	00004517          	auipc	a0,0x4
    3bf2:	bda50513          	add	a0,a0,-1062 # 77c8 <malloc+0x17f2>
    3bf6:	00002097          	auipc	ra,0x2
    3bfa:	328080e7          	jalr	808(ra) # 5f1e <printf>
    exit(1);
    3bfe:	4505                	li	a0,1
    3c00:	00002097          	auipc	ra,0x2
    3c04:	f8e080e7          	jalr	-114(ra) # 5b8e <exit>
    printf("%s: unlink dd/xx/ff succeeded!\n", s);
    3c08:	85ca                	mv	a1,s2
    3c0a:	00004517          	auipc	a0,0x4
    3c0e:	be650513          	add	a0,a0,-1050 # 77f0 <malloc+0x181a>
    3c12:	00002097          	auipc	ra,0x2
    3c16:	30c080e7          	jalr	780(ra) # 5f1e <printf>
    exit(1);
    3c1a:	4505                	li	a0,1
    3c1c:	00002097          	auipc	ra,0x2
    3c20:	f72080e7          	jalr	-142(ra) # 5b8e <exit>
    printf("%s: unlink dd/ff/ff succeeded!\n", s);
    3c24:	85ca                	mv	a1,s2
    3c26:	00004517          	auipc	a0,0x4
    3c2a:	bea50513          	add	a0,a0,-1046 # 7810 <malloc+0x183a>
    3c2e:	00002097          	auipc	ra,0x2
    3c32:	2f0080e7          	jalr	752(ra) # 5f1e <printf>
    exit(1);
    3c36:	4505                	li	a0,1
    3c38:	00002097          	auipc	ra,0x2
    3c3c:	f56080e7          	jalr	-170(ra) # 5b8e <exit>
    printf("%s: chdir dd/ff succeeded!\n", s);
    3c40:	85ca                	mv	a1,s2
    3c42:	00004517          	auipc	a0,0x4
    3c46:	bee50513          	add	a0,a0,-1042 # 7830 <malloc+0x185a>
    3c4a:	00002097          	auipc	ra,0x2
    3c4e:	2d4080e7          	jalr	724(ra) # 5f1e <printf>
    exit(1);
    3c52:	4505                	li	a0,1
    3c54:	00002097          	auipc	ra,0x2
    3c58:	f3a080e7          	jalr	-198(ra) # 5b8e <exit>
    printf("%s: chdir dd/xx succeeded!\n", s);
    3c5c:	85ca                	mv	a1,s2
    3c5e:	00004517          	auipc	a0,0x4
    3c62:	bfa50513          	add	a0,a0,-1030 # 7858 <malloc+0x1882>
    3c66:	00002097          	auipc	ra,0x2
    3c6a:	2b8080e7          	jalr	696(ra) # 5f1e <printf>
    exit(1);
    3c6e:	4505                	li	a0,1
    3c70:	00002097          	auipc	ra,0x2
    3c74:	f1e080e7          	jalr	-226(ra) # 5b8e <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    3c78:	85ca                	mv	a1,s2
    3c7a:	00004517          	auipc	a0,0x4
    3c7e:	87650513          	add	a0,a0,-1930 # 74f0 <malloc+0x151a>
    3c82:	00002097          	auipc	ra,0x2
    3c86:	29c080e7          	jalr	668(ra) # 5f1e <printf>
    exit(1);
    3c8a:	4505                	li	a0,1
    3c8c:	00002097          	auipc	ra,0x2
    3c90:	f02080e7          	jalr	-254(ra) # 5b8e <exit>
    printf("%s: unlink dd/ff failed\n", s);
    3c94:	85ca                	mv	a1,s2
    3c96:	00004517          	auipc	a0,0x4
    3c9a:	be250513          	add	a0,a0,-1054 # 7878 <malloc+0x18a2>
    3c9e:	00002097          	auipc	ra,0x2
    3ca2:	280080e7          	jalr	640(ra) # 5f1e <printf>
    exit(1);
    3ca6:	4505                	li	a0,1
    3ca8:	00002097          	auipc	ra,0x2
    3cac:	ee6080e7          	jalr	-282(ra) # 5b8e <exit>
    printf("%s: unlink non-empty dd succeeded!\n", s);
    3cb0:	85ca                	mv	a1,s2
    3cb2:	00004517          	auipc	a0,0x4
    3cb6:	be650513          	add	a0,a0,-1050 # 7898 <malloc+0x18c2>
    3cba:	00002097          	auipc	ra,0x2
    3cbe:	264080e7          	jalr	612(ra) # 5f1e <printf>
    exit(1);
    3cc2:	4505                	li	a0,1
    3cc4:	00002097          	auipc	ra,0x2
    3cc8:	eca080e7          	jalr	-310(ra) # 5b8e <exit>
    printf("%s: unlink dd/dd failed\n", s);
    3ccc:	85ca                	mv	a1,s2
    3cce:	00004517          	auipc	a0,0x4
    3cd2:	bfa50513          	add	a0,a0,-1030 # 78c8 <malloc+0x18f2>
    3cd6:	00002097          	auipc	ra,0x2
    3cda:	248080e7          	jalr	584(ra) # 5f1e <printf>
    exit(1);
    3cde:	4505                	li	a0,1
    3ce0:	00002097          	auipc	ra,0x2
    3ce4:	eae080e7          	jalr	-338(ra) # 5b8e <exit>
    printf("%s: unlink dd failed\n", s);
    3ce8:	85ca                	mv	a1,s2
    3cea:	00004517          	auipc	a0,0x4
    3cee:	bfe50513          	add	a0,a0,-1026 # 78e8 <malloc+0x1912>
    3cf2:	00002097          	auipc	ra,0x2
    3cf6:	22c080e7          	jalr	556(ra) # 5f1e <printf>
    exit(1);
    3cfa:	4505                	li	a0,1
    3cfc:	00002097          	auipc	ra,0x2
    3d00:	e92080e7          	jalr	-366(ra) # 5b8e <exit>

0000000000003d04 <rmdot>:
{
    3d04:	1101                	add	sp,sp,-32
    3d06:	ec06                	sd	ra,24(sp)
    3d08:	e822                	sd	s0,16(sp)
    3d0a:	e426                	sd	s1,8(sp)
    3d0c:	1000                	add	s0,sp,32
    3d0e:	84aa                	mv	s1,a0
  if(mkdir("dots") != 0){
    3d10:	00004517          	auipc	a0,0x4
    3d14:	bf050513          	add	a0,a0,-1040 # 7900 <malloc+0x192a>
    3d18:	00002097          	auipc	ra,0x2
    3d1c:	ede080e7          	jalr	-290(ra) # 5bf6 <mkdir>
    3d20:	e549                	bnez	a0,3daa <rmdot+0xa6>
  if(chdir("dots") != 0){
    3d22:	00004517          	auipc	a0,0x4
    3d26:	bde50513          	add	a0,a0,-1058 # 7900 <malloc+0x192a>
    3d2a:	00002097          	auipc	ra,0x2
    3d2e:	ed4080e7          	jalr	-300(ra) # 5bfe <chdir>
    3d32:	e951                	bnez	a0,3dc6 <rmdot+0xc2>
  if(unlink(".") == 0){
    3d34:	00003517          	auipc	a0,0x3
    3d38:	aac50513          	add	a0,a0,-1364 # 67e0 <malloc+0x80a>
    3d3c:	00002097          	auipc	ra,0x2
    3d40:	ea2080e7          	jalr	-350(ra) # 5bde <unlink>
    3d44:	cd59                	beqz	a0,3de2 <rmdot+0xde>
  if(unlink("..") == 0){
    3d46:	00003517          	auipc	a0,0x3
    3d4a:	61250513          	add	a0,a0,1554 # 7358 <malloc+0x1382>
    3d4e:	00002097          	auipc	ra,0x2
    3d52:	e90080e7          	jalr	-368(ra) # 5bde <unlink>
    3d56:	c545                	beqz	a0,3dfe <rmdot+0xfa>
  if(chdir("/") != 0){
    3d58:	00003517          	auipc	a0,0x3
    3d5c:	5a850513          	add	a0,a0,1448 # 7300 <malloc+0x132a>
    3d60:	00002097          	auipc	ra,0x2
    3d64:	e9e080e7          	jalr	-354(ra) # 5bfe <chdir>
    3d68:	e94d                	bnez	a0,3e1a <rmdot+0x116>
  if(unlink("dots/.") == 0){
    3d6a:	00004517          	auipc	a0,0x4
    3d6e:	bfe50513          	add	a0,a0,-1026 # 7968 <malloc+0x1992>
    3d72:	00002097          	auipc	ra,0x2
    3d76:	e6c080e7          	jalr	-404(ra) # 5bde <unlink>
    3d7a:	cd55                	beqz	a0,3e36 <rmdot+0x132>
  if(unlink("dots/..") == 0){
    3d7c:	00004517          	auipc	a0,0x4
    3d80:	c1450513          	add	a0,a0,-1004 # 7990 <malloc+0x19ba>
    3d84:	00002097          	auipc	ra,0x2
    3d88:	e5a080e7          	jalr	-422(ra) # 5bde <unlink>
    3d8c:	c179                	beqz	a0,3e52 <rmdot+0x14e>
  if(unlink("dots") != 0){
    3d8e:	00004517          	auipc	a0,0x4
    3d92:	b7250513          	add	a0,a0,-1166 # 7900 <malloc+0x192a>
    3d96:	00002097          	auipc	ra,0x2
    3d9a:	e48080e7          	jalr	-440(ra) # 5bde <unlink>
    3d9e:	e961                	bnez	a0,3e6e <rmdot+0x16a>
}
    3da0:	60e2                	ld	ra,24(sp)
    3da2:	6442                	ld	s0,16(sp)
    3da4:	64a2                	ld	s1,8(sp)
    3da6:	6105                	add	sp,sp,32
    3da8:	8082                	ret
    printf("%s: mkdir dots failed\n", s);
    3daa:	85a6                	mv	a1,s1
    3dac:	00004517          	auipc	a0,0x4
    3db0:	b5c50513          	add	a0,a0,-1188 # 7908 <malloc+0x1932>
    3db4:	00002097          	auipc	ra,0x2
    3db8:	16a080e7          	jalr	362(ra) # 5f1e <printf>
    exit(1);
    3dbc:	4505                	li	a0,1
    3dbe:	00002097          	auipc	ra,0x2
    3dc2:	dd0080e7          	jalr	-560(ra) # 5b8e <exit>
    printf("%s: chdir dots failed\n", s);
    3dc6:	85a6                	mv	a1,s1
    3dc8:	00004517          	auipc	a0,0x4
    3dcc:	b5850513          	add	a0,a0,-1192 # 7920 <malloc+0x194a>
    3dd0:	00002097          	auipc	ra,0x2
    3dd4:	14e080e7          	jalr	334(ra) # 5f1e <printf>
    exit(1);
    3dd8:	4505                	li	a0,1
    3dda:	00002097          	auipc	ra,0x2
    3dde:	db4080e7          	jalr	-588(ra) # 5b8e <exit>
    printf("%s: rm . worked!\n", s);
    3de2:	85a6                	mv	a1,s1
    3de4:	00004517          	auipc	a0,0x4
    3de8:	b5450513          	add	a0,a0,-1196 # 7938 <malloc+0x1962>
    3dec:	00002097          	auipc	ra,0x2
    3df0:	132080e7          	jalr	306(ra) # 5f1e <printf>
    exit(1);
    3df4:	4505                	li	a0,1
    3df6:	00002097          	auipc	ra,0x2
    3dfa:	d98080e7          	jalr	-616(ra) # 5b8e <exit>
    printf("%s: rm .. worked!\n", s);
    3dfe:	85a6                	mv	a1,s1
    3e00:	00004517          	auipc	a0,0x4
    3e04:	b5050513          	add	a0,a0,-1200 # 7950 <malloc+0x197a>
    3e08:	00002097          	auipc	ra,0x2
    3e0c:	116080e7          	jalr	278(ra) # 5f1e <printf>
    exit(1);
    3e10:	4505                	li	a0,1
    3e12:	00002097          	auipc	ra,0x2
    3e16:	d7c080e7          	jalr	-644(ra) # 5b8e <exit>
    printf("%s: chdir / failed\n", s);
    3e1a:	85a6                	mv	a1,s1
    3e1c:	00003517          	auipc	a0,0x3
    3e20:	4ec50513          	add	a0,a0,1260 # 7308 <malloc+0x1332>
    3e24:	00002097          	auipc	ra,0x2
    3e28:	0fa080e7          	jalr	250(ra) # 5f1e <printf>
    exit(1);
    3e2c:	4505                	li	a0,1
    3e2e:	00002097          	auipc	ra,0x2
    3e32:	d60080e7          	jalr	-672(ra) # 5b8e <exit>
    printf("%s: unlink dots/. worked!\n", s);
    3e36:	85a6                	mv	a1,s1
    3e38:	00004517          	auipc	a0,0x4
    3e3c:	b3850513          	add	a0,a0,-1224 # 7970 <malloc+0x199a>
    3e40:	00002097          	auipc	ra,0x2
    3e44:	0de080e7          	jalr	222(ra) # 5f1e <printf>
    exit(1);
    3e48:	4505                	li	a0,1
    3e4a:	00002097          	auipc	ra,0x2
    3e4e:	d44080e7          	jalr	-700(ra) # 5b8e <exit>
    printf("%s: unlink dots/.. worked!\n", s);
    3e52:	85a6                	mv	a1,s1
    3e54:	00004517          	auipc	a0,0x4
    3e58:	b4450513          	add	a0,a0,-1212 # 7998 <malloc+0x19c2>
    3e5c:	00002097          	auipc	ra,0x2
    3e60:	0c2080e7          	jalr	194(ra) # 5f1e <printf>
    exit(1);
    3e64:	4505                	li	a0,1
    3e66:	00002097          	auipc	ra,0x2
    3e6a:	d28080e7          	jalr	-728(ra) # 5b8e <exit>
    printf("%s: unlink dots failed!\n", s);
    3e6e:	85a6                	mv	a1,s1
    3e70:	00004517          	auipc	a0,0x4
    3e74:	b4850513          	add	a0,a0,-1208 # 79b8 <malloc+0x19e2>
    3e78:	00002097          	auipc	ra,0x2
    3e7c:	0a6080e7          	jalr	166(ra) # 5f1e <printf>
    exit(1);
    3e80:	4505                	li	a0,1
    3e82:	00002097          	auipc	ra,0x2
    3e86:	d0c080e7          	jalr	-756(ra) # 5b8e <exit>

0000000000003e8a <dirfile>:
{
    3e8a:	1101                	add	sp,sp,-32
    3e8c:	ec06                	sd	ra,24(sp)
    3e8e:	e822                	sd	s0,16(sp)
    3e90:	e426                	sd	s1,8(sp)
    3e92:	e04a                	sd	s2,0(sp)
    3e94:	1000                	add	s0,sp,32
    3e96:	892a                	mv	s2,a0
  fd = open("dirfile", O_CREATE);
    3e98:	20000593          	li	a1,512
    3e9c:	00004517          	auipc	a0,0x4
    3ea0:	b3c50513          	add	a0,a0,-1220 # 79d8 <malloc+0x1a02>
    3ea4:	00002097          	auipc	ra,0x2
    3ea8:	d2a080e7          	jalr	-726(ra) # 5bce <open>
  if(fd < 0){
    3eac:	0e054d63          	bltz	a0,3fa6 <dirfile+0x11c>
  close(fd);
    3eb0:	00002097          	auipc	ra,0x2
    3eb4:	d06080e7          	jalr	-762(ra) # 5bb6 <close>
  if(chdir("dirfile") == 0){
    3eb8:	00004517          	auipc	a0,0x4
    3ebc:	b2050513          	add	a0,a0,-1248 # 79d8 <malloc+0x1a02>
    3ec0:	00002097          	auipc	ra,0x2
    3ec4:	d3e080e7          	jalr	-706(ra) # 5bfe <chdir>
    3ec8:	cd6d                	beqz	a0,3fc2 <dirfile+0x138>
  fd = open("dirfile/xx", 0);
    3eca:	4581                	li	a1,0
    3ecc:	00004517          	auipc	a0,0x4
    3ed0:	b5450513          	add	a0,a0,-1196 # 7a20 <malloc+0x1a4a>
    3ed4:	00002097          	auipc	ra,0x2
    3ed8:	cfa080e7          	jalr	-774(ra) # 5bce <open>
  if(fd >= 0){
    3edc:	10055163          	bgez	a0,3fde <dirfile+0x154>
  fd = open("dirfile/xx", O_CREATE);
    3ee0:	20000593          	li	a1,512
    3ee4:	00004517          	auipc	a0,0x4
    3ee8:	b3c50513          	add	a0,a0,-1220 # 7a20 <malloc+0x1a4a>
    3eec:	00002097          	auipc	ra,0x2
    3ef0:	ce2080e7          	jalr	-798(ra) # 5bce <open>
  if(fd >= 0){
    3ef4:	10055363          	bgez	a0,3ffa <dirfile+0x170>
  if(mkdir("dirfile/xx") == 0){
    3ef8:	00004517          	auipc	a0,0x4
    3efc:	b2850513          	add	a0,a0,-1240 # 7a20 <malloc+0x1a4a>
    3f00:	00002097          	auipc	ra,0x2
    3f04:	cf6080e7          	jalr	-778(ra) # 5bf6 <mkdir>
    3f08:	10050763          	beqz	a0,4016 <dirfile+0x18c>
  if(unlink("dirfile/xx") == 0){
    3f0c:	00004517          	auipc	a0,0x4
    3f10:	b1450513          	add	a0,a0,-1260 # 7a20 <malloc+0x1a4a>
    3f14:	00002097          	auipc	ra,0x2
    3f18:	cca080e7          	jalr	-822(ra) # 5bde <unlink>
    3f1c:	10050b63          	beqz	a0,4032 <dirfile+0x1a8>
  if(link("README", "dirfile/xx") == 0){
    3f20:	00004597          	auipc	a1,0x4
    3f24:	b0058593          	add	a1,a1,-1280 # 7a20 <malloc+0x1a4a>
    3f28:	00002517          	auipc	a0,0x2
    3f2c:	3a850513          	add	a0,a0,936 # 62d0 <malloc+0x2fa>
    3f30:	00002097          	auipc	ra,0x2
    3f34:	cbe080e7          	jalr	-834(ra) # 5bee <link>
    3f38:	10050b63          	beqz	a0,404e <dirfile+0x1c4>
  if(unlink("dirfile") != 0){
    3f3c:	00004517          	auipc	a0,0x4
    3f40:	a9c50513          	add	a0,a0,-1380 # 79d8 <malloc+0x1a02>
    3f44:	00002097          	auipc	ra,0x2
    3f48:	c9a080e7          	jalr	-870(ra) # 5bde <unlink>
    3f4c:	10051f63          	bnez	a0,406a <dirfile+0x1e0>
  fd = open(".", O_RDWR);
    3f50:	4589                	li	a1,2
    3f52:	00003517          	auipc	a0,0x3
    3f56:	88e50513          	add	a0,a0,-1906 # 67e0 <malloc+0x80a>
    3f5a:	00002097          	auipc	ra,0x2
    3f5e:	c74080e7          	jalr	-908(ra) # 5bce <open>
  if(fd >= 0){
    3f62:	12055263          	bgez	a0,4086 <dirfile+0x1fc>
  fd = open(".", 0);
    3f66:	4581                	li	a1,0
    3f68:	00003517          	auipc	a0,0x3
    3f6c:	87850513          	add	a0,a0,-1928 # 67e0 <malloc+0x80a>
    3f70:	00002097          	auipc	ra,0x2
    3f74:	c5e080e7          	jalr	-930(ra) # 5bce <open>
    3f78:	84aa                	mv	s1,a0
  if(write(fd, "x", 1) > 0){
    3f7a:	4605                	li	a2,1
    3f7c:	00002597          	auipc	a1,0x2
    3f80:	1ec58593          	add	a1,a1,492 # 6168 <malloc+0x192>
    3f84:	00002097          	auipc	ra,0x2
    3f88:	c2a080e7          	jalr	-982(ra) # 5bae <write>
    3f8c:	10a04b63          	bgtz	a0,40a2 <dirfile+0x218>
  close(fd);
    3f90:	8526                	mv	a0,s1
    3f92:	00002097          	auipc	ra,0x2
    3f96:	c24080e7          	jalr	-988(ra) # 5bb6 <close>
}
    3f9a:	60e2                	ld	ra,24(sp)
    3f9c:	6442                	ld	s0,16(sp)
    3f9e:	64a2                	ld	s1,8(sp)
    3fa0:	6902                	ld	s2,0(sp)
    3fa2:	6105                	add	sp,sp,32
    3fa4:	8082                	ret
    printf("%s: create dirfile failed\n", s);
    3fa6:	85ca                	mv	a1,s2
    3fa8:	00004517          	auipc	a0,0x4
    3fac:	a3850513          	add	a0,a0,-1480 # 79e0 <malloc+0x1a0a>
    3fb0:	00002097          	auipc	ra,0x2
    3fb4:	f6e080e7          	jalr	-146(ra) # 5f1e <printf>
    exit(1);
    3fb8:	4505                	li	a0,1
    3fba:	00002097          	auipc	ra,0x2
    3fbe:	bd4080e7          	jalr	-1068(ra) # 5b8e <exit>
    printf("%s: chdir dirfile succeeded!\n", s);
    3fc2:	85ca                	mv	a1,s2
    3fc4:	00004517          	auipc	a0,0x4
    3fc8:	a3c50513          	add	a0,a0,-1476 # 7a00 <malloc+0x1a2a>
    3fcc:	00002097          	auipc	ra,0x2
    3fd0:	f52080e7          	jalr	-174(ra) # 5f1e <printf>
    exit(1);
    3fd4:	4505                	li	a0,1
    3fd6:	00002097          	auipc	ra,0x2
    3fda:	bb8080e7          	jalr	-1096(ra) # 5b8e <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    3fde:	85ca                	mv	a1,s2
    3fe0:	00004517          	auipc	a0,0x4
    3fe4:	a5050513          	add	a0,a0,-1456 # 7a30 <malloc+0x1a5a>
    3fe8:	00002097          	auipc	ra,0x2
    3fec:	f36080e7          	jalr	-202(ra) # 5f1e <printf>
    exit(1);
    3ff0:	4505                	li	a0,1
    3ff2:	00002097          	auipc	ra,0x2
    3ff6:	b9c080e7          	jalr	-1124(ra) # 5b8e <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    3ffa:	85ca                	mv	a1,s2
    3ffc:	00004517          	auipc	a0,0x4
    4000:	a3450513          	add	a0,a0,-1484 # 7a30 <malloc+0x1a5a>
    4004:	00002097          	auipc	ra,0x2
    4008:	f1a080e7          	jalr	-230(ra) # 5f1e <printf>
    exit(1);
    400c:	4505                	li	a0,1
    400e:	00002097          	auipc	ra,0x2
    4012:	b80080e7          	jalr	-1152(ra) # 5b8e <exit>
    printf("%s: mkdir dirfile/xx succeeded!\n", s);
    4016:	85ca                	mv	a1,s2
    4018:	00004517          	auipc	a0,0x4
    401c:	a4050513          	add	a0,a0,-1472 # 7a58 <malloc+0x1a82>
    4020:	00002097          	auipc	ra,0x2
    4024:	efe080e7          	jalr	-258(ra) # 5f1e <printf>
    exit(1);
    4028:	4505                	li	a0,1
    402a:	00002097          	auipc	ra,0x2
    402e:	b64080e7          	jalr	-1180(ra) # 5b8e <exit>
    printf("%s: unlink dirfile/xx succeeded!\n", s);
    4032:	85ca                	mv	a1,s2
    4034:	00004517          	auipc	a0,0x4
    4038:	a4c50513          	add	a0,a0,-1460 # 7a80 <malloc+0x1aaa>
    403c:	00002097          	auipc	ra,0x2
    4040:	ee2080e7          	jalr	-286(ra) # 5f1e <printf>
    exit(1);
    4044:	4505                	li	a0,1
    4046:	00002097          	auipc	ra,0x2
    404a:	b48080e7          	jalr	-1208(ra) # 5b8e <exit>
    printf("%s: link to dirfile/xx succeeded!\n", s);
    404e:	85ca                	mv	a1,s2
    4050:	00004517          	auipc	a0,0x4
    4054:	a5850513          	add	a0,a0,-1448 # 7aa8 <malloc+0x1ad2>
    4058:	00002097          	auipc	ra,0x2
    405c:	ec6080e7          	jalr	-314(ra) # 5f1e <printf>
    exit(1);
    4060:	4505                	li	a0,1
    4062:	00002097          	auipc	ra,0x2
    4066:	b2c080e7          	jalr	-1236(ra) # 5b8e <exit>
    printf("%s: unlink dirfile failed!\n", s);
    406a:	85ca                	mv	a1,s2
    406c:	00004517          	auipc	a0,0x4
    4070:	a6450513          	add	a0,a0,-1436 # 7ad0 <malloc+0x1afa>
    4074:	00002097          	auipc	ra,0x2
    4078:	eaa080e7          	jalr	-342(ra) # 5f1e <printf>
    exit(1);
    407c:	4505                	li	a0,1
    407e:	00002097          	auipc	ra,0x2
    4082:	b10080e7          	jalr	-1264(ra) # 5b8e <exit>
    printf("%s: open . for writing succeeded!\n", s);
    4086:	85ca                	mv	a1,s2
    4088:	00004517          	auipc	a0,0x4
    408c:	a6850513          	add	a0,a0,-1432 # 7af0 <malloc+0x1b1a>
    4090:	00002097          	auipc	ra,0x2
    4094:	e8e080e7          	jalr	-370(ra) # 5f1e <printf>
    exit(1);
    4098:	4505                	li	a0,1
    409a:	00002097          	auipc	ra,0x2
    409e:	af4080e7          	jalr	-1292(ra) # 5b8e <exit>
    printf("%s: write . succeeded!\n", s);
    40a2:	85ca                	mv	a1,s2
    40a4:	00004517          	auipc	a0,0x4
    40a8:	a7450513          	add	a0,a0,-1420 # 7b18 <malloc+0x1b42>
    40ac:	00002097          	auipc	ra,0x2
    40b0:	e72080e7          	jalr	-398(ra) # 5f1e <printf>
    exit(1);
    40b4:	4505                	li	a0,1
    40b6:	00002097          	auipc	ra,0x2
    40ba:	ad8080e7          	jalr	-1320(ra) # 5b8e <exit>

00000000000040be <iref>:
{
    40be:	7139                	add	sp,sp,-64
    40c0:	fc06                	sd	ra,56(sp)
    40c2:	f822                	sd	s0,48(sp)
    40c4:	f426                	sd	s1,40(sp)
    40c6:	f04a                	sd	s2,32(sp)
    40c8:	ec4e                	sd	s3,24(sp)
    40ca:	e852                	sd	s4,16(sp)
    40cc:	e456                	sd	s5,8(sp)
    40ce:	e05a                	sd	s6,0(sp)
    40d0:	0080                	add	s0,sp,64
    40d2:	8b2a                	mv	s6,a0
    40d4:	03300913          	li	s2,51
    if(mkdir("irefd") != 0){
    40d8:	00004a17          	auipc	s4,0x4
    40dc:	a58a0a13          	add	s4,s4,-1448 # 7b30 <malloc+0x1b5a>
    mkdir("");
    40e0:	00003497          	auipc	s1,0x3
    40e4:	55848493          	add	s1,s1,1368 # 7638 <malloc+0x1662>
    link("README", "");
    40e8:	00002a97          	auipc	s5,0x2
    40ec:	1e8a8a93          	add	s5,s5,488 # 62d0 <malloc+0x2fa>
    fd = open("xx", O_CREATE);
    40f0:	00004997          	auipc	s3,0x4
    40f4:	93898993          	add	s3,s3,-1736 # 7a28 <malloc+0x1a52>
    40f8:	a891                	j	414c <iref+0x8e>
      printf("%s: mkdir irefd failed\n", s);
    40fa:	85da                	mv	a1,s6
    40fc:	00004517          	auipc	a0,0x4
    4100:	a3c50513          	add	a0,a0,-1476 # 7b38 <malloc+0x1b62>
    4104:	00002097          	auipc	ra,0x2
    4108:	e1a080e7          	jalr	-486(ra) # 5f1e <printf>
      exit(1);
    410c:	4505                	li	a0,1
    410e:	00002097          	auipc	ra,0x2
    4112:	a80080e7          	jalr	-1408(ra) # 5b8e <exit>
      printf("%s: chdir irefd failed\n", s);
    4116:	85da                	mv	a1,s6
    4118:	00004517          	auipc	a0,0x4
    411c:	a3850513          	add	a0,a0,-1480 # 7b50 <malloc+0x1b7a>
    4120:	00002097          	auipc	ra,0x2
    4124:	dfe080e7          	jalr	-514(ra) # 5f1e <printf>
      exit(1);
    4128:	4505                	li	a0,1
    412a:	00002097          	auipc	ra,0x2
    412e:	a64080e7          	jalr	-1436(ra) # 5b8e <exit>
      close(fd);
    4132:	00002097          	auipc	ra,0x2
    4136:	a84080e7          	jalr	-1404(ra) # 5bb6 <close>
    413a:	a889                	j	418c <iref+0xce>
    unlink("xx");
    413c:	854e                	mv	a0,s3
    413e:	00002097          	auipc	ra,0x2
    4142:	aa0080e7          	jalr	-1376(ra) # 5bde <unlink>
  for(i = 0; i < NINODE + 1; i++){
    4146:	397d                	addw	s2,s2,-1
    4148:	06090063          	beqz	s2,41a8 <iref+0xea>
    if(mkdir("irefd") != 0){
    414c:	8552                	mv	a0,s4
    414e:	00002097          	auipc	ra,0x2
    4152:	aa8080e7          	jalr	-1368(ra) # 5bf6 <mkdir>
    4156:	f155                	bnez	a0,40fa <iref+0x3c>
    if(chdir("irefd") != 0){
    4158:	8552                	mv	a0,s4
    415a:	00002097          	auipc	ra,0x2
    415e:	aa4080e7          	jalr	-1372(ra) # 5bfe <chdir>
    4162:	f955                	bnez	a0,4116 <iref+0x58>
    mkdir("");
    4164:	8526                	mv	a0,s1
    4166:	00002097          	auipc	ra,0x2
    416a:	a90080e7          	jalr	-1392(ra) # 5bf6 <mkdir>
    link("README", "");
    416e:	85a6                	mv	a1,s1
    4170:	8556                	mv	a0,s5
    4172:	00002097          	auipc	ra,0x2
    4176:	a7c080e7          	jalr	-1412(ra) # 5bee <link>
    fd = open("", O_CREATE);
    417a:	20000593          	li	a1,512
    417e:	8526                	mv	a0,s1
    4180:	00002097          	auipc	ra,0x2
    4184:	a4e080e7          	jalr	-1458(ra) # 5bce <open>
    if(fd >= 0)
    4188:	fa0555e3          	bgez	a0,4132 <iref+0x74>
    fd = open("xx", O_CREATE);
    418c:	20000593          	li	a1,512
    4190:	854e                	mv	a0,s3
    4192:	00002097          	auipc	ra,0x2
    4196:	a3c080e7          	jalr	-1476(ra) # 5bce <open>
    if(fd >= 0)
    419a:	fa0541e3          	bltz	a0,413c <iref+0x7e>
      close(fd);
    419e:	00002097          	auipc	ra,0x2
    41a2:	a18080e7          	jalr	-1512(ra) # 5bb6 <close>
    41a6:	bf59                	j	413c <iref+0x7e>
    41a8:	03300493          	li	s1,51
    chdir("..");
    41ac:	00003997          	auipc	s3,0x3
    41b0:	1ac98993          	add	s3,s3,428 # 7358 <malloc+0x1382>
    unlink("irefd");
    41b4:	00004917          	auipc	s2,0x4
    41b8:	97c90913          	add	s2,s2,-1668 # 7b30 <malloc+0x1b5a>
    chdir("..");
    41bc:	854e                	mv	a0,s3
    41be:	00002097          	auipc	ra,0x2
    41c2:	a40080e7          	jalr	-1472(ra) # 5bfe <chdir>
    unlink("irefd");
    41c6:	854a                	mv	a0,s2
    41c8:	00002097          	auipc	ra,0x2
    41cc:	a16080e7          	jalr	-1514(ra) # 5bde <unlink>
  for(i = 0; i < NINODE + 1; i++){
    41d0:	34fd                	addw	s1,s1,-1
    41d2:	f4ed                	bnez	s1,41bc <iref+0xfe>
  chdir("/");
    41d4:	00003517          	auipc	a0,0x3
    41d8:	12c50513          	add	a0,a0,300 # 7300 <malloc+0x132a>
    41dc:	00002097          	auipc	ra,0x2
    41e0:	a22080e7          	jalr	-1502(ra) # 5bfe <chdir>
}
    41e4:	70e2                	ld	ra,56(sp)
    41e6:	7442                	ld	s0,48(sp)
    41e8:	74a2                	ld	s1,40(sp)
    41ea:	7902                	ld	s2,32(sp)
    41ec:	69e2                	ld	s3,24(sp)
    41ee:	6a42                	ld	s4,16(sp)
    41f0:	6aa2                	ld	s5,8(sp)
    41f2:	6b02                	ld	s6,0(sp)
    41f4:	6121                	add	sp,sp,64
    41f6:	8082                	ret

00000000000041f8 <openiputtest>:
{
    41f8:	7179                	add	sp,sp,-48
    41fa:	f406                	sd	ra,40(sp)
    41fc:	f022                	sd	s0,32(sp)
    41fe:	ec26                	sd	s1,24(sp)
    4200:	1800                	add	s0,sp,48
    4202:	84aa                	mv	s1,a0
  if(mkdir("oidir") < 0){
    4204:	00004517          	auipc	a0,0x4
    4208:	96450513          	add	a0,a0,-1692 # 7b68 <malloc+0x1b92>
    420c:	00002097          	auipc	ra,0x2
    4210:	9ea080e7          	jalr	-1558(ra) # 5bf6 <mkdir>
    4214:	04054263          	bltz	a0,4258 <openiputtest+0x60>
  pid = fork();
    4218:	00002097          	auipc	ra,0x2
    421c:	96e080e7          	jalr	-1682(ra) # 5b86 <fork>
  if(pid < 0){
    4220:	04054a63          	bltz	a0,4274 <openiputtest+0x7c>
  if(pid == 0){
    4224:	e93d                	bnez	a0,429a <openiputtest+0xa2>
    int fd = open("oidir", O_RDWR);
    4226:	4589                	li	a1,2
    4228:	00004517          	auipc	a0,0x4
    422c:	94050513          	add	a0,a0,-1728 # 7b68 <malloc+0x1b92>
    4230:	00002097          	auipc	ra,0x2
    4234:	99e080e7          	jalr	-1634(ra) # 5bce <open>
    if(fd >= 0){
    4238:	04054c63          	bltz	a0,4290 <openiputtest+0x98>
      printf("%s: open directory for write succeeded\n", s);
    423c:	85a6                	mv	a1,s1
    423e:	00004517          	auipc	a0,0x4
    4242:	94a50513          	add	a0,a0,-1718 # 7b88 <malloc+0x1bb2>
    4246:	00002097          	auipc	ra,0x2
    424a:	cd8080e7          	jalr	-808(ra) # 5f1e <printf>
      exit(1);
    424e:	4505                	li	a0,1
    4250:	00002097          	auipc	ra,0x2
    4254:	93e080e7          	jalr	-1730(ra) # 5b8e <exit>
    printf("%s: mkdir oidir failed\n", s);
    4258:	85a6                	mv	a1,s1
    425a:	00004517          	auipc	a0,0x4
    425e:	91650513          	add	a0,a0,-1770 # 7b70 <malloc+0x1b9a>
    4262:	00002097          	auipc	ra,0x2
    4266:	cbc080e7          	jalr	-836(ra) # 5f1e <printf>
    exit(1);
    426a:	4505                	li	a0,1
    426c:	00002097          	auipc	ra,0x2
    4270:	922080e7          	jalr	-1758(ra) # 5b8e <exit>
    printf("%s: fork failed\n", s);
    4274:	85a6                	mv	a1,s1
    4276:	00002517          	auipc	a0,0x2
    427a:	70a50513          	add	a0,a0,1802 # 6980 <malloc+0x9aa>
    427e:	00002097          	auipc	ra,0x2
    4282:	ca0080e7          	jalr	-864(ra) # 5f1e <printf>
    exit(1);
    4286:	4505                	li	a0,1
    4288:	00002097          	auipc	ra,0x2
    428c:	906080e7          	jalr	-1786(ra) # 5b8e <exit>
    exit(0);
    4290:	4501                	li	a0,0
    4292:	00002097          	auipc	ra,0x2
    4296:	8fc080e7          	jalr	-1796(ra) # 5b8e <exit>
  sleep(1);
    429a:	4505                	li	a0,1
    429c:	00002097          	auipc	ra,0x2
    42a0:	982080e7          	jalr	-1662(ra) # 5c1e <sleep>
  if(unlink("oidir") != 0){
    42a4:	00004517          	auipc	a0,0x4
    42a8:	8c450513          	add	a0,a0,-1852 # 7b68 <malloc+0x1b92>
    42ac:	00002097          	auipc	ra,0x2
    42b0:	932080e7          	jalr	-1742(ra) # 5bde <unlink>
    42b4:	cd19                	beqz	a0,42d2 <openiputtest+0xda>
    printf("%s: unlink failed\n", s);
    42b6:	85a6                	mv	a1,s1
    42b8:	00003517          	auipc	a0,0x3
    42bc:	8b850513          	add	a0,a0,-1864 # 6b70 <malloc+0xb9a>
    42c0:	00002097          	auipc	ra,0x2
    42c4:	c5e080e7          	jalr	-930(ra) # 5f1e <printf>
    exit(1);
    42c8:	4505                	li	a0,1
    42ca:	00002097          	auipc	ra,0x2
    42ce:	8c4080e7          	jalr	-1852(ra) # 5b8e <exit>
  wait(&xstatus);
    42d2:	fdc40513          	add	a0,s0,-36
    42d6:	00002097          	auipc	ra,0x2
    42da:	8c0080e7          	jalr	-1856(ra) # 5b96 <wait>
  exit(xstatus);
    42de:	fdc42503          	lw	a0,-36(s0)
    42e2:	00002097          	auipc	ra,0x2
    42e6:	8ac080e7          	jalr	-1876(ra) # 5b8e <exit>

00000000000042ea <forkforkfork>:
{
    42ea:	1101                	add	sp,sp,-32
    42ec:	ec06                	sd	ra,24(sp)
    42ee:	e822                	sd	s0,16(sp)
    42f0:	e426                	sd	s1,8(sp)
    42f2:	1000                	add	s0,sp,32
    42f4:	84aa                	mv	s1,a0
  unlink("stopforking");
    42f6:	00004517          	auipc	a0,0x4
    42fa:	8ba50513          	add	a0,a0,-1862 # 7bb0 <malloc+0x1bda>
    42fe:	00002097          	auipc	ra,0x2
    4302:	8e0080e7          	jalr	-1824(ra) # 5bde <unlink>
  int pid = fork();
    4306:	00002097          	auipc	ra,0x2
    430a:	880080e7          	jalr	-1920(ra) # 5b86 <fork>
  if(pid < 0){
    430e:	04054563          	bltz	a0,4358 <forkforkfork+0x6e>
  if(pid == 0){
    4312:	c12d                	beqz	a0,4374 <forkforkfork+0x8a>
  sleep(20); // two seconds
    4314:	4551                	li	a0,20
    4316:	00002097          	auipc	ra,0x2
    431a:	908080e7          	jalr	-1784(ra) # 5c1e <sleep>
  close(open("stopforking", O_CREATE|O_RDWR));
    431e:	20200593          	li	a1,514
    4322:	00004517          	auipc	a0,0x4
    4326:	88e50513          	add	a0,a0,-1906 # 7bb0 <malloc+0x1bda>
    432a:	00002097          	auipc	ra,0x2
    432e:	8a4080e7          	jalr	-1884(ra) # 5bce <open>
    4332:	00002097          	auipc	ra,0x2
    4336:	884080e7          	jalr	-1916(ra) # 5bb6 <close>
  wait(0);
    433a:	4501                	li	a0,0
    433c:	00002097          	auipc	ra,0x2
    4340:	85a080e7          	jalr	-1958(ra) # 5b96 <wait>
  sleep(10); // one second
    4344:	4529                	li	a0,10
    4346:	00002097          	auipc	ra,0x2
    434a:	8d8080e7          	jalr	-1832(ra) # 5c1e <sleep>
}
    434e:	60e2                	ld	ra,24(sp)
    4350:	6442                	ld	s0,16(sp)
    4352:	64a2                	ld	s1,8(sp)
    4354:	6105                	add	sp,sp,32
    4356:	8082                	ret
    printf("%s: fork failed", s);
    4358:	85a6                	mv	a1,s1
    435a:	00002517          	auipc	a0,0x2
    435e:	7e650513          	add	a0,a0,2022 # 6b40 <malloc+0xb6a>
    4362:	00002097          	auipc	ra,0x2
    4366:	bbc080e7          	jalr	-1092(ra) # 5f1e <printf>
    exit(1);
    436a:	4505                	li	a0,1
    436c:	00002097          	auipc	ra,0x2
    4370:	822080e7          	jalr	-2014(ra) # 5b8e <exit>
      int fd = open("stopforking", 0);
    4374:	00004497          	auipc	s1,0x4
    4378:	83c48493          	add	s1,s1,-1988 # 7bb0 <malloc+0x1bda>
    437c:	4581                	li	a1,0
    437e:	8526                	mv	a0,s1
    4380:	00002097          	auipc	ra,0x2
    4384:	84e080e7          	jalr	-1970(ra) # 5bce <open>
      if(fd >= 0){
    4388:	02055763          	bgez	a0,43b6 <forkforkfork+0xcc>
      if(fork() < 0){
    438c:	00001097          	auipc	ra,0x1
    4390:	7fa080e7          	jalr	2042(ra) # 5b86 <fork>
    4394:	fe0554e3          	bgez	a0,437c <forkforkfork+0x92>
        close(open("stopforking", O_CREATE|O_RDWR));
    4398:	20200593          	li	a1,514
    439c:	00004517          	auipc	a0,0x4
    43a0:	81450513          	add	a0,a0,-2028 # 7bb0 <malloc+0x1bda>
    43a4:	00002097          	auipc	ra,0x2
    43a8:	82a080e7          	jalr	-2006(ra) # 5bce <open>
    43ac:	00002097          	auipc	ra,0x2
    43b0:	80a080e7          	jalr	-2038(ra) # 5bb6 <close>
    43b4:	b7e1                	j	437c <forkforkfork+0x92>
        exit(0);
    43b6:	4501                	li	a0,0
    43b8:	00001097          	auipc	ra,0x1
    43bc:	7d6080e7          	jalr	2006(ra) # 5b8e <exit>

00000000000043c0 <killstatus>:
{
    43c0:	7139                	add	sp,sp,-64
    43c2:	fc06                	sd	ra,56(sp)
    43c4:	f822                	sd	s0,48(sp)
    43c6:	f426                	sd	s1,40(sp)
    43c8:	f04a                	sd	s2,32(sp)
    43ca:	ec4e                	sd	s3,24(sp)
    43cc:	e852                	sd	s4,16(sp)
    43ce:	0080                	add	s0,sp,64
    43d0:	8a2a                	mv	s4,a0
    43d2:	06400913          	li	s2,100
    if(xst != -1) {
    43d6:	59fd                	li	s3,-1
    int pid1 = fork();
    43d8:	00001097          	auipc	ra,0x1
    43dc:	7ae080e7          	jalr	1966(ra) # 5b86 <fork>
    43e0:	84aa                	mv	s1,a0
    if(pid1 < 0){
    43e2:	02054f63          	bltz	a0,4420 <killstatus+0x60>
    if(pid1 == 0){
    43e6:	c939                	beqz	a0,443c <killstatus+0x7c>
    sleep(1);
    43e8:	4505                	li	a0,1
    43ea:	00002097          	auipc	ra,0x2
    43ee:	834080e7          	jalr	-1996(ra) # 5c1e <sleep>
    kill(pid1);
    43f2:	8526                	mv	a0,s1
    43f4:	00001097          	auipc	ra,0x1
    43f8:	7ca080e7          	jalr	1994(ra) # 5bbe <kill>
    wait(&xst);
    43fc:	fcc40513          	add	a0,s0,-52
    4400:	00001097          	auipc	ra,0x1
    4404:	796080e7          	jalr	1942(ra) # 5b96 <wait>
    if(xst != -1) {
    4408:	fcc42783          	lw	a5,-52(s0)
    440c:	03379d63          	bne	a5,s3,4446 <killstatus+0x86>
  for(int i = 0; i < 100; i++){
    4410:	397d                	addw	s2,s2,-1
    4412:	fc0913e3          	bnez	s2,43d8 <killstatus+0x18>
  exit(0);
    4416:	4501                	li	a0,0
    4418:	00001097          	auipc	ra,0x1
    441c:	776080e7          	jalr	1910(ra) # 5b8e <exit>
      printf("%s: fork failed\n", s);
    4420:	85d2                	mv	a1,s4
    4422:	00002517          	auipc	a0,0x2
    4426:	55e50513          	add	a0,a0,1374 # 6980 <malloc+0x9aa>
    442a:	00002097          	auipc	ra,0x2
    442e:	af4080e7          	jalr	-1292(ra) # 5f1e <printf>
      exit(1);
    4432:	4505                	li	a0,1
    4434:	00001097          	auipc	ra,0x1
    4438:	75a080e7          	jalr	1882(ra) # 5b8e <exit>
        getpid();
    443c:	00001097          	auipc	ra,0x1
    4440:	7d2080e7          	jalr	2002(ra) # 5c0e <getpid>
      while(1) {
    4444:	bfe5                	j	443c <killstatus+0x7c>
       printf("%s: status should be -1\n", s);
    4446:	85d2                	mv	a1,s4
    4448:	00003517          	auipc	a0,0x3
    444c:	77850513          	add	a0,a0,1912 # 7bc0 <malloc+0x1bea>
    4450:	00002097          	auipc	ra,0x2
    4454:	ace080e7          	jalr	-1330(ra) # 5f1e <printf>
       exit(1);
    4458:	4505                	li	a0,1
    445a:	00001097          	auipc	ra,0x1
    445e:	734080e7          	jalr	1844(ra) # 5b8e <exit>

0000000000004462 <preempt>:
{
    4462:	7139                	add	sp,sp,-64
    4464:	fc06                	sd	ra,56(sp)
    4466:	f822                	sd	s0,48(sp)
    4468:	f426                	sd	s1,40(sp)
    446a:	f04a                	sd	s2,32(sp)
    446c:	ec4e                	sd	s3,24(sp)
    446e:	e852                	sd	s4,16(sp)
    4470:	0080                	add	s0,sp,64
    4472:	892a                	mv	s2,a0
  pid1 = fork();
    4474:	00001097          	auipc	ra,0x1
    4478:	712080e7          	jalr	1810(ra) # 5b86 <fork>
  if(pid1 < 0) {
    447c:	00054563          	bltz	a0,4486 <preempt+0x24>
    4480:	84aa                	mv	s1,a0
  if(pid1 == 0)
    4482:	e105                	bnez	a0,44a2 <preempt+0x40>
    for(;;)
    4484:	a001                	j	4484 <preempt+0x22>
    printf("%s: fork failed", s);
    4486:	85ca                	mv	a1,s2
    4488:	00002517          	auipc	a0,0x2
    448c:	6b850513          	add	a0,a0,1720 # 6b40 <malloc+0xb6a>
    4490:	00002097          	auipc	ra,0x2
    4494:	a8e080e7          	jalr	-1394(ra) # 5f1e <printf>
    exit(1);
    4498:	4505                	li	a0,1
    449a:	00001097          	auipc	ra,0x1
    449e:	6f4080e7          	jalr	1780(ra) # 5b8e <exit>
  pid2 = fork();
    44a2:	00001097          	auipc	ra,0x1
    44a6:	6e4080e7          	jalr	1764(ra) # 5b86 <fork>
    44aa:	89aa                	mv	s3,a0
  if(pid2 < 0) {
    44ac:	00054463          	bltz	a0,44b4 <preempt+0x52>
  if(pid2 == 0)
    44b0:	e105                	bnez	a0,44d0 <preempt+0x6e>
    for(;;)
    44b2:	a001                	j	44b2 <preempt+0x50>
    printf("%s: fork failed\n", s);
    44b4:	85ca                	mv	a1,s2
    44b6:	00002517          	auipc	a0,0x2
    44ba:	4ca50513          	add	a0,a0,1226 # 6980 <malloc+0x9aa>
    44be:	00002097          	auipc	ra,0x2
    44c2:	a60080e7          	jalr	-1440(ra) # 5f1e <printf>
    exit(1);
    44c6:	4505                	li	a0,1
    44c8:	00001097          	auipc	ra,0x1
    44cc:	6c6080e7          	jalr	1734(ra) # 5b8e <exit>
  pipe(pfds);
    44d0:	fc840513          	add	a0,s0,-56
    44d4:	00001097          	auipc	ra,0x1
    44d8:	6ca080e7          	jalr	1738(ra) # 5b9e <pipe>
  pid3 = fork();
    44dc:	00001097          	auipc	ra,0x1
    44e0:	6aa080e7          	jalr	1706(ra) # 5b86 <fork>
    44e4:	8a2a                	mv	s4,a0
  if(pid3 < 0) {
    44e6:	02054e63          	bltz	a0,4522 <preempt+0xc0>
  if(pid3 == 0){
    44ea:	e525                	bnez	a0,4552 <preempt+0xf0>
    close(pfds[0]);
    44ec:	fc842503          	lw	a0,-56(s0)
    44f0:	00001097          	auipc	ra,0x1
    44f4:	6c6080e7          	jalr	1734(ra) # 5bb6 <close>
    if(write(pfds[1], "x", 1) != 1)
    44f8:	4605                	li	a2,1
    44fa:	00002597          	auipc	a1,0x2
    44fe:	c6e58593          	add	a1,a1,-914 # 6168 <malloc+0x192>
    4502:	fcc42503          	lw	a0,-52(s0)
    4506:	00001097          	auipc	ra,0x1
    450a:	6a8080e7          	jalr	1704(ra) # 5bae <write>
    450e:	4785                	li	a5,1
    4510:	02f51763          	bne	a0,a5,453e <preempt+0xdc>
    close(pfds[1]);
    4514:	fcc42503          	lw	a0,-52(s0)
    4518:	00001097          	auipc	ra,0x1
    451c:	69e080e7          	jalr	1694(ra) # 5bb6 <close>
    for(;;)
    4520:	a001                	j	4520 <preempt+0xbe>
     printf("%s: fork failed\n", s);
    4522:	85ca                	mv	a1,s2
    4524:	00002517          	auipc	a0,0x2
    4528:	45c50513          	add	a0,a0,1116 # 6980 <malloc+0x9aa>
    452c:	00002097          	auipc	ra,0x2
    4530:	9f2080e7          	jalr	-1550(ra) # 5f1e <printf>
     exit(1);
    4534:	4505                	li	a0,1
    4536:	00001097          	auipc	ra,0x1
    453a:	658080e7          	jalr	1624(ra) # 5b8e <exit>
      printf("%s: preempt write error", s);
    453e:	85ca                	mv	a1,s2
    4540:	00003517          	auipc	a0,0x3
    4544:	6a050513          	add	a0,a0,1696 # 7be0 <malloc+0x1c0a>
    4548:	00002097          	auipc	ra,0x2
    454c:	9d6080e7          	jalr	-1578(ra) # 5f1e <printf>
    4550:	b7d1                	j	4514 <preempt+0xb2>
  close(pfds[1]);
    4552:	fcc42503          	lw	a0,-52(s0)
    4556:	00001097          	auipc	ra,0x1
    455a:	660080e7          	jalr	1632(ra) # 5bb6 <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
    455e:	660d                	lui	a2,0x3
    4560:	00008597          	auipc	a1,0x8
    4564:	70858593          	add	a1,a1,1800 # cc68 <buf>
    4568:	fc842503          	lw	a0,-56(s0)
    456c:	00001097          	auipc	ra,0x1
    4570:	63a080e7          	jalr	1594(ra) # 5ba6 <read>
    4574:	4785                	li	a5,1
    4576:	02f50363          	beq	a0,a5,459c <preempt+0x13a>
    printf("%s: preempt read error", s);
    457a:	85ca                	mv	a1,s2
    457c:	00003517          	auipc	a0,0x3
    4580:	67c50513          	add	a0,a0,1660 # 7bf8 <malloc+0x1c22>
    4584:	00002097          	auipc	ra,0x2
    4588:	99a080e7          	jalr	-1638(ra) # 5f1e <printf>
}
    458c:	70e2                	ld	ra,56(sp)
    458e:	7442                	ld	s0,48(sp)
    4590:	74a2                	ld	s1,40(sp)
    4592:	7902                	ld	s2,32(sp)
    4594:	69e2                	ld	s3,24(sp)
    4596:	6a42                	ld	s4,16(sp)
    4598:	6121                	add	sp,sp,64
    459a:	8082                	ret
  close(pfds[0]);
    459c:	fc842503          	lw	a0,-56(s0)
    45a0:	00001097          	auipc	ra,0x1
    45a4:	616080e7          	jalr	1558(ra) # 5bb6 <close>
  printf("kill... ");
    45a8:	00003517          	auipc	a0,0x3
    45ac:	66850513          	add	a0,a0,1640 # 7c10 <malloc+0x1c3a>
    45b0:	00002097          	auipc	ra,0x2
    45b4:	96e080e7          	jalr	-1682(ra) # 5f1e <printf>
  kill(pid1);
    45b8:	8526                	mv	a0,s1
    45ba:	00001097          	auipc	ra,0x1
    45be:	604080e7          	jalr	1540(ra) # 5bbe <kill>
  kill(pid2);
    45c2:	854e                	mv	a0,s3
    45c4:	00001097          	auipc	ra,0x1
    45c8:	5fa080e7          	jalr	1530(ra) # 5bbe <kill>
  kill(pid3);
    45cc:	8552                	mv	a0,s4
    45ce:	00001097          	auipc	ra,0x1
    45d2:	5f0080e7          	jalr	1520(ra) # 5bbe <kill>
  printf("wait... ");
    45d6:	00003517          	auipc	a0,0x3
    45da:	64a50513          	add	a0,a0,1610 # 7c20 <malloc+0x1c4a>
    45de:	00002097          	auipc	ra,0x2
    45e2:	940080e7          	jalr	-1728(ra) # 5f1e <printf>
  wait(0);
    45e6:	4501                	li	a0,0
    45e8:	00001097          	auipc	ra,0x1
    45ec:	5ae080e7          	jalr	1454(ra) # 5b96 <wait>
  wait(0);
    45f0:	4501                	li	a0,0
    45f2:	00001097          	auipc	ra,0x1
    45f6:	5a4080e7          	jalr	1444(ra) # 5b96 <wait>
  wait(0);
    45fa:	4501                	li	a0,0
    45fc:	00001097          	auipc	ra,0x1
    4600:	59a080e7          	jalr	1434(ra) # 5b96 <wait>
    4604:	b761                	j	458c <preempt+0x12a>

0000000000004606 <reparent>:
{
    4606:	7179                	add	sp,sp,-48
    4608:	f406                	sd	ra,40(sp)
    460a:	f022                	sd	s0,32(sp)
    460c:	ec26                	sd	s1,24(sp)
    460e:	e84a                	sd	s2,16(sp)
    4610:	e44e                	sd	s3,8(sp)
    4612:	e052                	sd	s4,0(sp)
    4614:	1800                	add	s0,sp,48
    4616:	89aa                	mv	s3,a0
  int master_pid = getpid();
    4618:	00001097          	auipc	ra,0x1
    461c:	5f6080e7          	jalr	1526(ra) # 5c0e <getpid>
    4620:	8a2a                	mv	s4,a0
    4622:	0c800913          	li	s2,200
    int pid = fork();
    4626:	00001097          	auipc	ra,0x1
    462a:	560080e7          	jalr	1376(ra) # 5b86 <fork>
    462e:	84aa                	mv	s1,a0
    if(pid < 0){
    4630:	02054263          	bltz	a0,4654 <reparent+0x4e>
    if(pid){
    4634:	cd21                	beqz	a0,468c <reparent+0x86>
      if(wait(0) != pid){
    4636:	4501                	li	a0,0
    4638:	00001097          	auipc	ra,0x1
    463c:	55e080e7          	jalr	1374(ra) # 5b96 <wait>
    4640:	02951863          	bne	a0,s1,4670 <reparent+0x6a>
  for(int i = 0; i < 200; i++){
    4644:	397d                	addw	s2,s2,-1
    4646:	fe0910e3          	bnez	s2,4626 <reparent+0x20>
  exit(0);
    464a:	4501                	li	a0,0
    464c:	00001097          	auipc	ra,0x1
    4650:	542080e7          	jalr	1346(ra) # 5b8e <exit>
      printf("%s: fork failed\n", s);
    4654:	85ce                	mv	a1,s3
    4656:	00002517          	auipc	a0,0x2
    465a:	32a50513          	add	a0,a0,810 # 6980 <malloc+0x9aa>
    465e:	00002097          	auipc	ra,0x2
    4662:	8c0080e7          	jalr	-1856(ra) # 5f1e <printf>
      exit(1);
    4666:	4505                	li	a0,1
    4668:	00001097          	auipc	ra,0x1
    466c:	526080e7          	jalr	1318(ra) # 5b8e <exit>
        printf("%s: wait wrong pid\n", s);
    4670:	85ce                	mv	a1,s3
    4672:	00002517          	auipc	a0,0x2
    4676:	49650513          	add	a0,a0,1174 # 6b08 <malloc+0xb32>
    467a:	00002097          	auipc	ra,0x2
    467e:	8a4080e7          	jalr	-1884(ra) # 5f1e <printf>
        exit(1);
    4682:	4505                	li	a0,1
    4684:	00001097          	auipc	ra,0x1
    4688:	50a080e7          	jalr	1290(ra) # 5b8e <exit>
      int pid2 = fork();
    468c:	00001097          	auipc	ra,0x1
    4690:	4fa080e7          	jalr	1274(ra) # 5b86 <fork>
      if(pid2 < 0){
    4694:	00054763          	bltz	a0,46a2 <reparent+0x9c>
      exit(0);
    4698:	4501                	li	a0,0
    469a:	00001097          	auipc	ra,0x1
    469e:	4f4080e7          	jalr	1268(ra) # 5b8e <exit>
        kill(master_pid);
    46a2:	8552                	mv	a0,s4
    46a4:	00001097          	auipc	ra,0x1
    46a8:	51a080e7          	jalr	1306(ra) # 5bbe <kill>
        exit(1);
    46ac:	4505                	li	a0,1
    46ae:	00001097          	auipc	ra,0x1
    46b2:	4e0080e7          	jalr	1248(ra) # 5b8e <exit>

00000000000046b6 <sbrkfail>:
{
    46b6:	7119                	add	sp,sp,-128
    46b8:	fc86                	sd	ra,120(sp)
    46ba:	f8a2                	sd	s0,112(sp)
    46bc:	f4a6                	sd	s1,104(sp)
    46be:	f0ca                	sd	s2,96(sp)
    46c0:	ecce                	sd	s3,88(sp)
    46c2:	e8d2                	sd	s4,80(sp)
    46c4:	e4d6                	sd	s5,72(sp)
    46c6:	0100                	add	s0,sp,128
    46c8:	8aaa                	mv	s5,a0
  if(pipe(fds) != 0){
    46ca:	fb040513          	add	a0,s0,-80
    46ce:	00001097          	auipc	ra,0x1
    46d2:	4d0080e7          	jalr	1232(ra) # 5b9e <pipe>
    46d6:	e901                	bnez	a0,46e6 <sbrkfail+0x30>
    46d8:	f8040493          	add	s1,s0,-128
    46dc:	fa840993          	add	s3,s0,-88
    46e0:	8926                	mv	s2,s1
    if(pids[i] != -1)
    46e2:	5a7d                	li	s4,-1
    46e4:	a085                	j	4744 <sbrkfail+0x8e>
    printf("%s: pipe() failed\n", s);
    46e6:	85d6                	mv	a1,s5
    46e8:	00002517          	auipc	a0,0x2
    46ec:	3a050513          	add	a0,a0,928 # 6a88 <malloc+0xab2>
    46f0:	00002097          	auipc	ra,0x2
    46f4:	82e080e7          	jalr	-2002(ra) # 5f1e <printf>
    exit(1);
    46f8:	4505                	li	a0,1
    46fa:	00001097          	auipc	ra,0x1
    46fe:	494080e7          	jalr	1172(ra) # 5b8e <exit>
      sbrk(BIG - (uint64)sbrk(0));
    4702:	00001097          	auipc	ra,0x1
    4706:	514080e7          	jalr	1300(ra) # 5c16 <sbrk>
    470a:	064007b7          	lui	a5,0x6400
    470e:	40a7853b          	subw	a0,a5,a0
    4712:	00001097          	auipc	ra,0x1
    4716:	504080e7          	jalr	1284(ra) # 5c16 <sbrk>
      write(fds[1], "x", 1);
    471a:	4605                	li	a2,1
    471c:	00002597          	auipc	a1,0x2
    4720:	a4c58593          	add	a1,a1,-1460 # 6168 <malloc+0x192>
    4724:	fb442503          	lw	a0,-76(s0)
    4728:	00001097          	auipc	ra,0x1
    472c:	486080e7          	jalr	1158(ra) # 5bae <write>
      for(;;) sleep(1000);
    4730:	3e800513          	li	a0,1000
    4734:	00001097          	auipc	ra,0x1
    4738:	4ea080e7          	jalr	1258(ra) # 5c1e <sleep>
    473c:	bfd5                	j	4730 <sbrkfail+0x7a>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    473e:	0911                	add	s2,s2,4
    4740:	03390563          	beq	s2,s3,476a <sbrkfail+0xb4>
    if((pids[i] = fork()) == 0){
    4744:	00001097          	auipc	ra,0x1
    4748:	442080e7          	jalr	1090(ra) # 5b86 <fork>
    474c:	00a92023          	sw	a0,0(s2)
    4750:	d94d                	beqz	a0,4702 <sbrkfail+0x4c>
    if(pids[i] != -1)
    4752:	ff4506e3          	beq	a0,s4,473e <sbrkfail+0x88>
      read(fds[0], &scratch, 1);
    4756:	4605                	li	a2,1
    4758:	faf40593          	add	a1,s0,-81
    475c:	fb042503          	lw	a0,-80(s0)
    4760:	00001097          	auipc	ra,0x1
    4764:	446080e7          	jalr	1094(ra) # 5ba6 <read>
    4768:	bfd9                	j	473e <sbrkfail+0x88>
  c = sbrk(PGSIZE);
    476a:	6505                	lui	a0,0x1
    476c:	00001097          	auipc	ra,0x1
    4770:	4aa080e7          	jalr	1194(ra) # 5c16 <sbrk>
    4774:	8a2a                	mv	s4,a0
    if(pids[i] == -1)
    4776:	597d                	li	s2,-1
    4778:	a021                	j	4780 <sbrkfail+0xca>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    477a:	0491                	add	s1,s1,4
    477c:	01348f63          	beq	s1,s3,479a <sbrkfail+0xe4>
    if(pids[i] == -1)
    4780:	4088                	lw	a0,0(s1)
    4782:	ff250ce3          	beq	a0,s2,477a <sbrkfail+0xc4>
    kill(pids[i]);
    4786:	00001097          	auipc	ra,0x1
    478a:	438080e7          	jalr	1080(ra) # 5bbe <kill>
    wait(0);
    478e:	4501                	li	a0,0
    4790:	00001097          	auipc	ra,0x1
    4794:	406080e7          	jalr	1030(ra) # 5b96 <wait>
    4798:	b7cd                	j	477a <sbrkfail+0xc4>
  if(c == (char*)0xffffffffffffffffL){
    479a:	57fd                	li	a5,-1
    479c:	04fa0163          	beq	s4,a5,47de <sbrkfail+0x128>
  pid = fork();
    47a0:	00001097          	auipc	ra,0x1
    47a4:	3e6080e7          	jalr	998(ra) # 5b86 <fork>
    47a8:	84aa                	mv	s1,a0
  if(pid < 0){
    47aa:	04054863          	bltz	a0,47fa <sbrkfail+0x144>
  if(pid == 0){
    47ae:	c525                	beqz	a0,4816 <sbrkfail+0x160>
  wait(&xstatus);
    47b0:	fbc40513          	add	a0,s0,-68
    47b4:	00001097          	auipc	ra,0x1
    47b8:	3e2080e7          	jalr	994(ra) # 5b96 <wait>
  if(xstatus != -1 && xstatus != 2)
    47bc:	fbc42783          	lw	a5,-68(s0)
    47c0:	577d                	li	a4,-1
    47c2:	00e78563          	beq	a5,a4,47cc <sbrkfail+0x116>
    47c6:	4709                	li	a4,2
    47c8:	08e79d63          	bne	a5,a4,4862 <sbrkfail+0x1ac>
}
    47cc:	70e6                	ld	ra,120(sp)
    47ce:	7446                	ld	s0,112(sp)
    47d0:	74a6                	ld	s1,104(sp)
    47d2:	7906                	ld	s2,96(sp)
    47d4:	69e6                	ld	s3,88(sp)
    47d6:	6a46                	ld	s4,80(sp)
    47d8:	6aa6                	ld	s5,72(sp)
    47da:	6109                	add	sp,sp,128
    47dc:	8082                	ret
    printf("%s: failed sbrk leaked memory\n", s);
    47de:	85d6                	mv	a1,s5
    47e0:	00003517          	auipc	a0,0x3
    47e4:	45050513          	add	a0,a0,1104 # 7c30 <malloc+0x1c5a>
    47e8:	00001097          	auipc	ra,0x1
    47ec:	736080e7          	jalr	1846(ra) # 5f1e <printf>
    exit(1);
    47f0:	4505                	li	a0,1
    47f2:	00001097          	auipc	ra,0x1
    47f6:	39c080e7          	jalr	924(ra) # 5b8e <exit>
    printf("%s: fork failed\n", s);
    47fa:	85d6                	mv	a1,s5
    47fc:	00002517          	auipc	a0,0x2
    4800:	18450513          	add	a0,a0,388 # 6980 <malloc+0x9aa>
    4804:	00001097          	auipc	ra,0x1
    4808:	71a080e7          	jalr	1818(ra) # 5f1e <printf>
    exit(1);
    480c:	4505                	li	a0,1
    480e:	00001097          	auipc	ra,0x1
    4812:	380080e7          	jalr	896(ra) # 5b8e <exit>
    a = sbrk(0);
    4816:	4501                	li	a0,0
    4818:	00001097          	auipc	ra,0x1
    481c:	3fe080e7          	jalr	1022(ra) # 5c16 <sbrk>
    4820:	892a                	mv	s2,a0
    sbrk(10*BIG);
    4822:	3e800537          	lui	a0,0x3e800
    4826:	00001097          	auipc	ra,0x1
    482a:	3f0080e7          	jalr	1008(ra) # 5c16 <sbrk>
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    482e:	87ca                	mv	a5,s2
    4830:	3e800737          	lui	a4,0x3e800
    4834:	993a                	add	s2,s2,a4
    4836:	6705                	lui	a4,0x1
      n += *(a+i);
    4838:	0007c683          	lbu	a3,0(a5) # 6400000 <base+0x63f0398>
    483c:	9cb5                	addw	s1,s1,a3
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    483e:	97ba                	add	a5,a5,a4
    4840:	ff279ce3          	bne	a5,s2,4838 <sbrkfail+0x182>
    printf("%s: allocate a lot of memory succeeded %d\n", s, n);
    4844:	8626                	mv	a2,s1
    4846:	85d6                	mv	a1,s5
    4848:	00003517          	auipc	a0,0x3
    484c:	40850513          	add	a0,a0,1032 # 7c50 <malloc+0x1c7a>
    4850:	00001097          	auipc	ra,0x1
    4854:	6ce080e7          	jalr	1742(ra) # 5f1e <printf>
    exit(1);
    4858:	4505                	li	a0,1
    485a:	00001097          	auipc	ra,0x1
    485e:	334080e7          	jalr	820(ra) # 5b8e <exit>
    exit(1);
    4862:	4505                	li	a0,1
    4864:	00001097          	auipc	ra,0x1
    4868:	32a080e7          	jalr	810(ra) # 5b8e <exit>

000000000000486c <mem>:
{
    486c:	7139                	add	sp,sp,-64
    486e:	fc06                	sd	ra,56(sp)
    4870:	f822                	sd	s0,48(sp)
    4872:	f426                	sd	s1,40(sp)
    4874:	f04a                	sd	s2,32(sp)
    4876:	ec4e                	sd	s3,24(sp)
    4878:	0080                	add	s0,sp,64
    487a:	89aa                	mv	s3,a0
  if((pid = fork()) == 0){
    487c:	00001097          	auipc	ra,0x1
    4880:	30a080e7          	jalr	778(ra) # 5b86 <fork>
    m1 = 0;
    4884:	4481                	li	s1,0
    while((m2 = malloc(10001)) != 0){
    4886:	6909                	lui	s2,0x2
    4888:	71190913          	add	s2,s2,1809 # 2711 <copyinstr3+0x107>
  if((pid = fork()) == 0){
    488c:	c115                	beqz	a0,48b0 <mem+0x44>
    wait(&xstatus);
    488e:	fcc40513          	add	a0,s0,-52
    4892:	00001097          	auipc	ra,0x1
    4896:	304080e7          	jalr	772(ra) # 5b96 <wait>
    if(xstatus == -1){
    489a:	fcc42503          	lw	a0,-52(s0)
    489e:	57fd                	li	a5,-1
    48a0:	06f50363          	beq	a0,a5,4906 <mem+0x9a>
    exit(xstatus);
    48a4:	00001097          	auipc	ra,0x1
    48a8:	2ea080e7          	jalr	746(ra) # 5b8e <exit>
      *(char**)m2 = m1;
    48ac:	e104                	sd	s1,0(a0)
      m1 = m2;
    48ae:	84aa                	mv	s1,a0
    while((m2 = malloc(10001)) != 0){
    48b0:	854a                	mv	a0,s2
    48b2:	00001097          	auipc	ra,0x1
    48b6:	724080e7          	jalr	1828(ra) # 5fd6 <malloc>
    48ba:	f96d                	bnez	a0,48ac <mem+0x40>
    while(m1){
    48bc:	c881                	beqz	s1,48cc <mem+0x60>
      m2 = *(char**)m1;
    48be:	8526                	mv	a0,s1
    48c0:	6084                	ld	s1,0(s1)
      free(m1);
    48c2:	00001097          	auipc	ra,0x1
    48c6:	692080e7          	jalr	1682(ra) # 5f54 <free>
    while(m1){
    48ca:	f8f5                	bnez	s1,48be <mem+0x52>
    m1 = malloc(1024*20);
    48cc:	6515                	lui	a0,0x5
    48ce:	00001097          	auipc	ra,0x1
    48d2:	708080e7          	jalr	1800(ra) # 5fd6 <malloc>
    if(m1 == 0){
    48d6:	c911                	beqz	a0,48ea <mem+0x7e>
    free(m1);
    48d8:	00001097          	auipc	ra,0x1
    48dc:	67c080e7          	jalr	1660(ra) # 5f54 <free>
    exit(0);
    48e0:	4501                	li	a0,0
    48e2:	00001097          	auipc	ra,0x1
    48e6:	2ac080e7          	jalr	684(ra) # 5b8e <exit>
      printf("couldn't allocate mem?!!\n", s);
    48ea:	85ce                	mv	a1,s3
    48ec:	00003517          	auipc	a0,0x3
    48f0:	39450513          	add	a0,a0,916 # 7c80 <malloc+0x1caa>
    48f4:	00001097          	auipc	ra,0x1
    48f8:	62a080e7          	jalr	1578(ra) # 5f1e <printf>
      exit(1);
    48fc:	4505                	li	a0,1
    48fe:	00001097          	auipc	ra,0x1
    4902:	290080e7          	jalr	656(ra) # 5b8e <exit>
      exit(0);
    4906:	4501                	li	a0,0
    4908:	00001097          	auipc	ra,0x1
    490c:	286080e7          	jalr	646(ra) # 5b8e <exit>

0000000000004910 <sharedfd>:
{
    4910:	7159                	add	sp,sp,-112
    4912:	f486                	sd	ra,104(sp)
    4914:	f0a2                	sd	s0,96(sp)
    4916:	eca6                	sd	s1,88(sp)
    4918:	e8ca                	sd	s2,80(sp)
    491a:	e4ce                	sd	s3,72(sp)
    491c:	e0d2                	sd	s4,64(sp)
    491e:	fc56                	sd	s5,56(sp)
    4920:	f85a                	sd	s6,48(sp)
    4922:	f45e                	sd	s7,40(sp)
    4924:	1880                	add	s0,sp,112
    4926:	8a2a                	mv	s4,a0
  unlink("sharedfd");
    4928:	00003517          	auipc	a0,0x3
    492c:	37850513          	add	a0,a0,888 # 7ca0 <malloc+0x1cca>
    4930:	00001097          	auipc	ra,0x1
    4934:	2ae080e7          	jalr	686(ra) # 5bde <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
    4938:	20200593          	li	a1,514
    493c:	00003517          	auipc	a0,0x3
    4940:	36450513          	add	a0,a0,868 # 7ca0 <malloc+0x1cca>
    4944:	00001097          	auipc	ra,0x1
    4948:	28a080e7          	jalr	650(ra) # 5bce <open>
  if(fd < 0){
    494c:	04054a63          	bltz	a0,49a0 <sharedfd+0x90>
    4950:	892a                	mv	s2,a0
  pid = fork();
    4952:	00001097          	auipc	ra,0x1
    4956:	234080e7          	jalr	564(ra) # 5b86 <fork>
    495a:	89aa                	mv	s3,a0
  memset(buf, pid==0?'c':'p', sizeof(buf));
    495c:	07000593          	li	a1,112
    4960:	e119                	bnez	a0,4966 <sharedfd+0x56>
    4962:	06300593          	li	a1,99
    4966:	4629                	li	a2,10
    4968:	fa040513          	add	a0,s0,-96
    496c:	00001097          	auipc	ra,0x1
    4970:	028080e7          	jalr	40(ra) # 5994 <memset>
    4974:	3e800493          	li	s1,1000
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
    4978:	4629                	li	a2,10
    497a:	fa040593          	add	a1,s0,-96
    497e:	854a                	mv	a0,s2
    4980:	00001097          	auipc	ra,0x1
    4984:	22e080e7          	jalr	558(ra) # 5bae <write>
    4988:	47a9                	li	a5,10
    498a:	02f51963          	bne	a0,a5,49bc <sharedfd+0xac>
  for(i = 0; i < N; i++){
    498e:	34fd                	addw	s1,s1,-1
    4990:	f4e5                	bnez	s1,4978 <sharedfd+0x68>
  if(pid == 0) {
    4992:	04099363          	bnez	s3,49d8 <sharedfd+0xc8>
    exit(0);
    4996:	4501                	li	a0,0
    4998:	00001097          	auipc	ra,0x1
    499c:	1f6080e7          	jalr	502(ra) # 5b8e <exit>
    printf("%s: cannot open sharedfd for writing", s);
    49a0:	85d2                	mv	a1,s4
    49a2:	00003517          	auipc	a0,0x3
    49a6:	30e50513          	add	a0,a0,782 # 7cb0 <malloc+0x1cda>
    49aa:	00001097          	auipc	ra,0x1
    49ae:	574080e7          	jalr	1396(ra) # 5f1e <printf>
    exit(1);
    49b2:	4505                	li	a0,1
    49b4:	00001097          	auipc	ra,0x1
    49b8:	1da080e7          	jalr	474(ra) # 5b8e <exit>
      printf("%s: write sharedfd failed\n", s);
    49bc:	85d2                	mv	a1,s4
    49be:	00003517          	auipc	a0,0x3
    49c2:	31a50513          	add	a0,a0,794 # 7cd8 <malloc+0x1d02>
    49c6:	00001097          	auipc	ra,0x1
    49ca:	558080e7          	jalr	1368(ra) # 5f1e <printf>
      exit(1);
    49ce:	4505                	li	a0,1
    49d0:	00001097          	auipc	ra,0x1
    49d4:	1be080e7          	jalr	446(ra) # 5b8e <exit>
    wait(&xstatus);
    49d8:	f9c40513          	add	a0,s0,-100
    49dc:	00001097          	auipc	ra,0x1
    49e0:	1ba080e7          	jalr	442(ra) # 5b96 <wait>
    if(xstatus != 0)
    49e4:	f9c42983          	lw	s3,-100(s0)
    49e8:	00098763          	beqz	s3,49f6 <sharedfd+0xe6>
      exit(xstatus);
    49ec:	854e                	mv	a0,s3
    49ee:	00001097          	auipc	ra,0x1
    49f2:	1a0080e7          	jalr	416(ra) # 5b8e <exit>
  close(fd);
    49f6:	854a                	mv	a0,s2
    49f8:	00001097          	auipc	ra,0x1
    49fc:	1be080e7          	jalr	446(ra) # 5bb6 <close>
  fd = open("sharedfd", 0);
    4a00:	4581                	li	a1,0
    4a02:	00003517          	auipc	a0,0x3
    4a06:	29e50513          	add	a0,a0,670 # 7ca0 <malloc+0x1cca>
    4a0a:	00001097          	auipc	ra,0x1
    4a0e:	1c4080e7          	jalr	452(ra) # 5bce <open>
    4a12:	8baa                	mv	s7,a0
  nc = np = 0;
    4a14:	8ace                	mv	s5,s3
  if(fd < 0){
    4a16:	02054563          	bltz	a0,4a40 <sharedfd+0x130>
    4a1a:	faa40913          	add	s2,s0,-86
      if(buf[i] == 'c')
    4a1e:	06300493          	li	s1,99
      if(buf[i] == 'p')
    4a22:	07000b13          	li	s6,112
  while((n = read(fd, buf, sizeof(buf))) > 0){
    4a26:	4629                	li	a2,10
    4a28:	fa040593          	add	a1,s0,-96
    4a2c:	855e                	mv	a0,s7
    4a2e:	00001097          	auipc	ra,0x1
    4a32:	178080e7          	jalr	376(ra) # 5ba6 <read>
    4a36:	02a05f63          	blez	a0,4a74 <sharedfd+0x164>
    4a3a:	fa040793          	add	a5,s0,-96
    4a3e:	a01d                	j	4a64 <sharedfd+0x154>
    printf("%s: cannot open sharedfd for reading\n", s);
    4a40:	85d2                	mv	a1,s4
    4a42:	00003517          	auipc	a0,0x3
    4a46:	2b650513          	add	a0,a0,694 # 7cf8 <malloc+0x1d22>
    4a4a:	00001097          	auipc	ra,0x1
    4a4e:	4d4080e7          	jalr	1236(ra) # 5f1e <printf>
    exit(1);
    4a52:	4505                	li	a0,1
    4a54:	00001097          	auipc	ra,0x1
    4a58:	13a080e7          	jalr	314(ra) # 5b8e <exit>
        nc++;
    4a5c:	2985                	addw	s3,s3,1
    for(i = 0; i < sizeof(buf); i++){
    4a5e:	0785                	add	a5,a5,1
    4a60:	fd2783e3          	beq	a5,s2,4a26 <sharedfd+0x116>
      if(buf[i] == 'c')
    4a64:	0007c703          	lbu	a4,0(a5)
    4a68:	fe970ae3          	beq	a4,s1,4a5c <sharedfd+0x14c>
      if(buf[i] == 'p')
    4a6c:	ff6719e3          	bne	a4,s6,4a5e <sharedfd+0x14e>
        np++;
    4a70:	2a85                	addw	s5,s5,1
    4a72:	b7f5                	j	4a5e <sharedfd+0x14e>
  close(fd);
    4a74:	855e                	mv	a0,s7
    4a76:	00001097          	auipc	ra,0x1
    4a7a:	140080e7          	jalr	320(ra) # 5bb6 <close>
  unlink("sharedfd");
    4a7e:	00003517          	auipc	a0,0x3
    4a82:	22250513          	add	a0,a0,546 # 7ca0 <malloc+0x1cca>
    4a86:	00001097          	auipc	ra,0x1
    4a8a:	158080e7          	jalr	344(ra) # 5bde <unlink>
  if(nc == N*SZ && np == N*SZ){
    4a8e:	6789                	lui	a5,0x2
    4a90:	71078793          	add	a5,a5,1808 # 2710 <copyinstr3+0x106>
    4a94:	00f99763          	bne	s3,a5,4aa2 <sharedfd+0x192>
    4a98:	6789                	lui	a5,0x2
    4a9a:	71078793          	add	a5,a5,1808 # 2710 <copyinstr3+0x106>
    4a9e:	02fa8063          	beq	s5,a5,4abe <sharedfd+0x1ae>
    printf("%s: nc/np test fails\n", s);
    4aa2:	85d2                	mv	a1,s4
    4aa4:	00003517          	auipc	a0,0x3
    4aa8:	27c50513          	add	a0,a0,636 # 7d20 <malloc+0x1d4a>
    4aac:	00001097          	auipc	ra,0x1
    4ab0:	472080e7          	jalr	1138(ra) # 5f1e <printf>
    exit(1);
    4ab4:	4505                	li	a0,1
    4ab6:	00001097          	auipc	ra,0x1
    4aba:	0d8080e7          	jalr	216(ra) # 5b8e <exit>
    exit(0);
    4abe:	4501                	li	a0,0
    4ac0:	00001097          	auipc	ra,0x1
    4ac4:	0ce080e7          	jalr	206(ra) # 5b8e <exit>

0000000000004ac8 <fourfiles>:
{
    4ac8:	7135                	add	sp,sp,-160
    4aca:	ed06                	sd	ra,152(sp)
    4acc:	e922                	sd	s0,144(sp)
    4ace:	e526                	sd	s1,136(sp)
    4ad0:	e14a                	sd	s2,128(sp)
    4ad2:	fcce                	sd	s3,120(sp)
    4ad4:	f8d2                	sd	s4,112(sp)
    4ad6:	f4d6                	sd	s5,104(sp)
    4ad8:	f0da                	sd	s6,96(sp)
    4ada:	ecde                	sd	s7,88(sp)
    4adc:	e8e2                	sd	s8,80(sp)
    4ade:	e4e6                	sd	s9,72(sp)
    4ae0:	e0ea                	sd	s10,64(sp)
    4ae2:	fc6e                	sd	s11,56(sp)
    4ae4:	1100                	add	s0,sp,160
    4ae6:	8caa                	mv	s9,a0
  char *names[] = { "f0", "f1", "f2", "f3" };
    4ae8:	00003797          	auipc	a5,0x3
    4aec:	25078793          	add	a5,a5,592 # 7d38 <malloc+0x1d62>
    4af0:	f6f43823          	sd	a5,-144(s0)
    4af4:	00003797          	auipc	a5,0x3
    4af8:	24c78793          	add	a5,a5,588 # 7d40 <malloc+0x1d6a>
    4afc:	f6f43c23          	sd	a5,-136(s0)
    4b00:	00003797          	auipc	a5,0x3
    4b04:	24878793          	add	a5,a5,584 # 7d48 <malloc+0x1d72>
    4b08:	f8f43023          	sd	a5,-128(s0)
    4b0c:	00003797          	auipc	a5,0x3
    4b10:	24478793          	add	a5,a5,580 # 7d50 <malloc+0x1d7a>
    4b14:	f8f43423          	sd	a5,-120(s0)
  for(pi = 0; pi < NCHILD; pi++){
    4b18:	f7040b93          	add	s7,s0,-144
  char *names[] = { "f0", "f1", "f2", "f3" };
    4b1c:	895e                	mv	s2,s7
  for(pi = 0; pi < NCHILD; pi++){
    4b1e:	4481                	li	s1,0
    4b20:	4a11                	li	s4,4
    fname = names[pi];
    4b22:	00093983          	ld	s3,0(s2)
    unlink(fname);
    4b26:	854e                	mv	a0,s3
    4b28:	00001097          	auipc	ra,0x1
    4b2c:	0b6080e7          	jalr	182(ra) # 5bde <unlink>
    pid = fork();
    4b30:	00001097          	auipc	ra,0x1
    4b34:	056080e7          	jalr	86(ra) # 5b86 <fork>
    if(pid < 0){
    4b38:	04054063          	bltz	a0,4b78 <fourfiles+0xb0>
    if(pid == 0){
    4b3c:	cd21                	beqz	a0,4b94 <fourfiles+0xcc>
  for(pi = 0; pi < NCHILD; pi++){
    4b3e:	2485                	addw	s1,s1,1
    4b40:	0921                	add	s2,s2,8
    4b42:	ff4490e3          	bne	s1,s4,4b22 <fourfiles+0x5a>
    4b46:	4491                	li	s1,4
    wait(&xstatus);
    4b48:	f6c40513          	add	a0,s0,-148
    4b4c:	00001097          	auipc	ra,0x1
    4b50:	04a080e7          	jalr	74(ra) # 5b96 <wait>
    if(xstatus != 0)
    4b54:	f6c42a83          	lw	s5,-148(s0)
    4b58:	0c0a9863          	bnez	s5,4c28 <fourfiles+0x160>
  for(pi = 0; pi < NCHILD; pi++){
    4b5c:	34fd                	addw	s1,s1,-1
    4b5e:	f4ed                	bnez	s1,4b48 <fourfiles+0x80>
    4b60:	03000b13          	li	s6,48
    while((n = read(fd, buf, sizeof(buf))) > 0){
    4b64:	00008a17          	auipc	s4,0x8
    4b68:	104a0a13          	add	s4,s4,260 # cc68 <buf>
    if(total != N*SZ){
    4b6c:	6d05                	lui	s10,0x1
    4b6e:	770d0d13          	add	s10,s10,1904 # 1770 <exectest+0x30>
  for(i = 0; i < NCHILD; i++){
    4b72:	03400d93          	li	s11,52
    4b76:	a22d                	j	4ca0 <fourfiles+0x1d8>
      printf("fork failed\n", s);
    4b78:	85e6                	mv	a1,s9
    4b7a:	00002517          	auipc	a0,0x2
    4b7e:	20e50513          	add	a0,a0,526 # 6d88 <malloc+0xdb2>
    4b82:	00001097          	auipc	ra,0x1
    4b86:	39c080e7          	jalr	924(ra) # 5f1e <printf>
      exit(1);
    4b8a:	4505                	li	a0,1
    4b8c:	00001097          	auipc	ra,0x1
    4b90:	002080e7          	jalr	2(ra) # 5b8e <exit>
      fd = open(fname, O_CREATE | O_RDWR);
    4b94:	20200593          	li	a1,514
    4b98:	854e                	mv	a0,s3
    4b9a:	00001097          	auipc	ra,0x1
    4b9e:	034080e7          	jalr	52(ra) # 5bce <open>
    4ba2:	892a                	mv	s2,a0
      if(fd < 0){
    4ba4:	04054763          	bltz	a0,4bf2 <fourfiles+0x12a>
      memset(buf, '0'+pi, SZ);
    4ba8:	1f400613          	li	a2,500
    4bac:	0304859b          	addw	a1,s1,48
    4bb0:	00008517          	auipc	a0,0x8
    4bb4:	0b850513          	add	a0,a0,184 # cc68 <buf>
    4bb8:	00001097          	auipc	ra,0x1
    4bbc:	ddc080e7          	jalr	-548(ra) # 5994 <memset>
    4bc0:	44b1                	li	s1,12
        if((n = write(fd, buf, SZ)) != SZ){
    4bc2:	00008997          	auipc	s3,0x8
    4bc6:	0a698993          	add	s3,s3,166 # cc68 <buf>
    4bca:	1f400613          	li	a2,500
    4bce:	85ce                	mv	a1,s3
    4bd0:	854a                	mv	a0,s2
    4bd2:	00001097          	auipc	ra,0x1
    4bd6:	fdc080e7          	jalr	-36(ra) # 5bae <write>
    4bda:	85aa                	mv	a1,a0
    4bdc:	1f400793          	li	a5,500
    4be0:	02f51763          	bne	a0,a5,4c0e <fourfiles+0x146>
      for(i = 0; i < N; i++){
    4be4:	34fd                	addw	s1,s1,-1
    4be6:	f0f5                	bnez	s1,4bca <fourfiles+0x102>
      exit(0);
    4be8:	4501                	li	a0,0
    4bea:	00001097          	auipc	ra,0x1
    4bee:	fa4080e7          	jalr	-92(ra) # 5b8e <exit>
        printf("create failed\n", s);
    4bf2:	85e6                	mv	a1,s9
    4bf4:	00003517          	auipc	a0,0x3
    4bf8:	16450513          	add	a0,a0,356 # 7d58 <malloc+0x1d82>
    4bfc:	00001097          	auipc	ra,0x1
    4c00:	322080e7          	jalr	802(ra) # 5f1e <printf>
        exit(1);
    4c04:	4505                	li	a0,1
    4c06:	00001097          	auipc	ra,0x1
    4c0a:	f88080e7          	jalr	-120(ra) # 5b8e <exit>
          printf("write failed %d\n", n);
    4c0e:	00003517          	auipc	a0,0x3
    4c12:	15a50513          	add	a0,a0,346 # 7d68 <malloc+0x1d92>
    4c16:	00001097          	auipc	ra,0x1
    4c1a:	308080e7          	jalr	776(ra) # 5f1e <printf>
          exit(1);
    4c1e:	4505                	li	a0,1
    4c20:	00001097          	auipc	ra,0x1
    4c24:	f6e080e7          	jalr	-146(ra) # 5b8e <exit>
      exit(xstatus);
    4c28:	8556                	mv	a0,s5
    4c2a:	00001097          	auipc	ra,0x1
    4c2e:	f64080e7          	jalr	-156(ra) # 5b8e <exit>
          printf("wrong char\n", s);
    4c32:	85e6                	mv	a1,s9
    4c34:	00003517          	auipc	a0,0x3
    4c38:	14c50513          	add	a0,a0,332 # 7d80 <malloc+0x1daa>
    4c3c:	00001097          	auipc	ra,0x1
    4c40:	2e2080e7          	jalr	738(ra) # 5f1e <printf>
          exit(1);
    4c44:	4505                	li	a0,1
    4c46:	00001097          	auipc	ra,0x1
    4c4a:	f48080e7          	jalr	-184(ra) # 5b8e <exit>
      total += n;
    4c4e:	00a9093b          	addw	s2,s2,a0
    while((n = read(fd, buf, sizeof(buf))) > 0){
    4c52:	660d                	lui	a2,0x3
    4c54:	85d2                	mv	a1,s4
    4c56:	854e                	mv	a0,s3
    4c58:	00001097          	auipc	ra,0x1
    4c5c:	f4e080e7          	jalr	-178(ra) # 5ba6 <read>
    4c60:	02a05063          	blez	a0,4c80 <fourfiles+0x1b8>
    4c64:	00008797          	auipc	a5,0x8
    4c68:	00478793          	add	a5,a5,4 # cc68 <buf>
    4c6c:	00f506b3          	add	a3,a0,a5
        if(buf[j] != '0'+i){
    4c70:	0007c703          	lbu	a4,0(a5)
    4c74:	fa971fe3          	bne	a4,s1,4c32 <fourfiles+0x16a>
      for(j = 0; j < n; j++){
    4c78:	0785                	add	a5,a5,1
    4c7a:	fed79be3          	bne	a5,a3,4c70 <fourfiles+0x1a8>
    4c7e:	bfc1                	j	4c4e <fourfiles+0x186>
    close(fd);
    4c80:	854e                	mv	a0,s3
    4c82:	00001097          	auipc	ra,0x1
    4c86:	f34080e7          	jalr	-204(ra) # 5bb6 <close>
    if(total != N*SZ){
    4c8a:	03a91863          	bne	s2,s10,4cba <fourfiles+0x1f2>
    unlink(fname);
    4c8e:	8562                	mv	a0,s8
    4c90:	00001097          	auipc	ra,0x1
    4c94:	f4e080e7          	jalr	-178(ra) # 5bde <unlink>
  for(i = 0; i < NCHILD; i++){
    4c98:	0ba1                	add	s7,s7,8
    4c9a:	2b05                	addw	s6,s6,1
    4c9c:	03bb0d63          	beq	s6,s11,4cd6 <fourfiles+0x20e>
    fname = names[i];
    4ca0:	000bbc03          	ld	s8,0(s7)
    fd = open(fname, 0);
    4ca4:	4581                	li	a1,0
    4ca6:	8562                	mv	a0,s8
    4ca8:	00001097          	auipc	ra,0x1
    4cac:	f26080e7          	jalr	-218(ra) # 5bce <open>
    4cb0:	89aa                	mv	s3,a0
    total = 0;
    4cb2:	8956                	mv	s2,s5
        if(buf[j] != '0'+i){
    4cb4:	000b049b          	sext.w	s1,s6
    while((n = read(fd, buf, sizeof(buf))) > 0){
    4cb8:	bf69                	j	4c52 <fourfiles+0x18a>
      printf("wrong length %d\n", total);
    4cba:	85ca                	mv	a1,s2
    4cbc:	00003517          	auipc	a0,0x3
    4cc0:	0d450513          	add	a0,a0,212 # 7d90 <malloc+0x1dba>
    4cc4:	00001097          	auipc	ra,0x1
    4cc8:	25a080e7          	jalr	602(ra) # 5f1e <printf>
      exit(1);
    4ccc:	4505                	li	a0,1
    4cce:	00001097          	auipc	ra,0x1
    4cd2:	ec0080e7          	jalr	-320(ra) # 5b8e <exit>
}
    4cd6:	60ea                	ld	ra,152(sp)
    4cd8:	644a                	ld	s0,144(sp)
    4cda:	64aa                	ld	s1,136(sp)
    4cdc:	690a                	ld	s2,128(sp)
    4cde:	79e6                	ld	s3,120(sp)
    4ce0:	7a46                	ld	s4,112(sp)
    4ce2:	7aa6                	ld	s5,104(sp)
    4ce4:	7b06                	ld	s6,96(sp)
    4ce6:	6be6                	ld	s7,88(sp)
    4ce8:	6c46                	ld	s8,80(sp)
    4cea:	6ca6                	ld	s9,72(sp)
    4cec:	6d06                	ld	s10,64(sp)
    4cee:	7de2                	ld	s11,56(sp)
    4cf0:	610d                	add	sp,sp,160
    4cf2:	8082                	ret

0000000000004cf4 <concreate>:
{
    4cf4:	7135                	add	sp,sp,-160
    4cf6:	ed06                	sd	ra,152(sp)
    4cf8:	e922                	sd	s0,144(sp)
    4cfa:	e526                	sd	s1,136(sp)
    4cfc:	e14a                	sd	s2,128(sp)
    4cfe:	fcce                	sd	s3,120(sp)
    4d00:	f8d2                	sd	s4,112(sp)
    4d02:	f4d6                	sd	s5,104(sp)
    4d04:	f0da                	sd	s6,96(sp)
    4d06:	ecde                	sd	s7,88(sp)
    4d08:	1100                	add	s0,sp,160
    4d0a:	89aa                	mv	s3,a0
  file[0] = 'C';
    4d0c:	04300793          	li	a5,67
    4d10:	faf40423          	sb	a5,-88(s0)
  file[2] = '\0';
    4d14:	fa040523          	sb	zero,-86(s0)
  for(i = 0; i < N; i++){
    4d18:	4901                	li	s2,0
    if(pid && (i % 3) == 1){
    4d1a:	4b0d                	li	s6,3
    4d1c:	4a85                	li	s5,1
      link("C0", file);
    4d1e:	00003b97          	auipc	s7,0x3
    4d22:	08ab8b93          	add	s7,s7,138 # 7da8 <malloc+0x1dd2>
  for(i = 0; i < N; i++){
    4d26:	02800a13          	li	s4,40
    4d2a:	acc9                	j	4ffc <concreate+0x308>
      link("C0", file);
    4d2c:	fa840593          	add	a1,s0,-88
    4d30:	855e                	mv	a0,s7
    4d32:	00001097          	auipc	ra,0x1
    4d36:	ebc080e7          	jalr	-324(ra) # 5bee <link>
    if(pid == 0) {
    4d3a:	a465                	j	4fe2 <concreate+0x2ee>
    } else if(pid == 0 && (i % 5) == 1){
    4d3c:	4795                	li	a5,5
    4d3e:	02f9693b          	remw	s2,s2,a5
    4d42:	4785                	li	a5,1
    4d44:	02f90b63          	beq	s2,a5,4d7a <concreate+0x86>
      fd = open(file, O_CREATE | O_RDWR);
    4d48:	20200593          	li	a1,514
    4d4c:	fa840513          	add	a0,s0,-88
    4d50:	00001097          	auipc	ra,0x1
    4d54:	e7e080e7          	jalr	-386(ra) # 5bce <open>
      if(fd < 0){
    4d58:	26055c63          	bgez	a0,4fd0 <concreate+0x2dc>
        printf("concreate create %s failed\n", file);
    4d5c:	fa840593          	add	a1,s0,-88
    4d60:	00003517          	auipc	a0,0x3
    4d64:	05050513          	add	a0,a0,80 # 7db0 <malloc+0x1dda>
    4d68:	00001097          	auipc	ra,0x1
    4d6c:	1b6080e7          	jalr	438(ra) # 5f1e <printf>
        exit(1);
    4d70:	4505                	li	a0,1
    4d72:	00001097          	auipc	ra,0x1
    4d76:	e1c080e7          	jalr	-484(ra) # 5b8e <exit>
      link("C0", file);
    4d7a:	fa840593          	add	a1,s0,-88
    4d7e:	00003517          	auipc	a0,0x3
    4d82:	02a50513          	add	a0,a0,42 # 7da8 <malloc+0x1dd2>
    4d86:	00001097          	auipc	ra,0x1
    4d8a:	e68080e7          	jalr	-408(ra) # 5bee <link>
      exit(0);
    4d8e:	4501                	li	a0,0
    4d90:	00001097          	auipc	ra,0x1
    4d94:	dfe080e7          	jalr	-514(ra) # 5b8e <exit>
        exit(1);
    4d98:	4505                	li	a0,1
    4d9a:	00001097          	auipc	ra,0x1
    4d9e:	df4080e7          	jalr	-524(ra) # 5b8e <exit>
  memset(fa, 0, sizeof(fa));
    4da2:	02800613          	li	a2,40
    4da6:	4581                	li	a1,0
    4da8:	f8040513          	add	a0,s0,-128
    4dac:	00001097          	auipc	ra,0x1
    4db0:	be8080e7          	jalr	-1048(ra) # 5994 <memset>
  fd = open(".", 0);
    4db4:	4581                	li	a1,0
    4db6:	00002517          	auipc	a0,0x2
    4dba:	a2a50513          	add	a0,a0,-1494 # 67e0 <malloc+0x80a>
    4dbe:	00001097          	auipc	ra,0x1
    4dc2:	e10080e7          	jalr	-496(ra) # 5bce <open>
    4dc6:	892a                	mv	s2,a0
  n = 0;
    4dc8:	8aa6                	mv	s5,s1
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    4dca:	04300a13          	li	s4,67
      if(i < 0 || i >= sizeof(fa)){
    4dce:	02700b13          	li	s6,39
      fa[i] = 1;
    4dd2:	4b85                	li	s7,1
  while(read(fd, &de, sizeof(de)) > 0){
    4dd4:	4641                	li	a2,16
    4dd6:	f7040593          	add	a1,s0,-144
    4dda:	854a                	mv	a0,s2
    4ddc:	00001097          	auipc	ra,0x1
    4de0:	dca080e7          	jalr	-566(ra) # 5ba6 <read>
    4de4:	08a05263          	blez	a0,4e68 <concreate+0x174>
    if(de.inum == 0)
    4de8:	f7045783          	lhu	a5,-144(s0)
    4dec:	d7e5                	beqz	a5,4dd4 <concreate+0xe0>
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    4dee:	f7244783          	lbu	a5,-142(s0)
    4df2:	ff4791e3          	bne	a5,s4,4dd4 <concreate+0xe0>
    4df6:	f7444783          	lbu	a5,-140(s0)
    4dfa:	ffe9                	bnez	a5,4dd4 <concreate+0xe0>
      i = de.name[1] - '0';
    4dfc:	f7344783          	lbu	a5,-141(s0)
    4e00:	fd07879b          	addw	a5,a5,-48
    4e04:	0007871b          	sext.w	a4,a5
      if(i < 0 || i >= sizeof(fa)){
    4e08:	02eb6063          	bltu	s6,a4,4e28 <concreate+0x134>
      if(fa[i]){
    4e0c:	fb070793          	add	a5,a4,-80 # fb0 <linktest+0xbc>
    4e10:	97a2                	add	a5,a5,s0
    4e12:	fd07c783          	lbu	a5,-48(a5)
    4e16:	eb8d                	bnez	a5,4e48 <concreate+0x154>
      fa[i] = 1;
    4e18:	fb070793          	add	a5,a4,-80
    4e1c:	00878733          	add	a4,a5,s0
    4e20:	fd770823          	sb	s7,-48(a4)
      n++;
    4e24:	2a85                	addw	s5,s5,1
    4e26:	b77d                	j	4dd4 <concreate+0xe0>
        printf("%s: concreate weird file %s\n", s, de.name);
    4e28:	f7240613          	add	a2,s0,-142
    4e2c:	85ce                	mv	a1,s3
    4e2e:	00003517          	auipc	a0,0x3
    4e32:	fa250513          	add	a0,a0,-94 # 7dd0 <malloc+0x1dfa>
    4e36:	00001097          	auipc	ra,0x1
    4e3a:	0e8080e7          	jalr	232(ra) # 5f1e <printf>
        exit(1);
    4e3e:	4505                	li	a0,1
    4e40:	00001097          	auipc	ra,0x1
    4e44:	d4e080e7          	jalr	-690(ra) # 5b8e <exit>
        printf("%s: concreate duplicate file %s\n", s, de.name);
    4e48:	f7240613          	add	a2,s0,-142
    4e4c:	85ce                	mv	a1,s3
    4e4e:	00003517          	auipc	a0,0x3
    4e52:	fa250513          	add	a0,a0,-94 # 7df0 <malloc+0x1e1a>
    4e56:	00001097          	auipc	ra,0x1
    4e5a:	0c8080e7          	jalr	200(ra) # 5f1e <printf>
        exit(1);
    4e5e:	4505                	li	a0,1
    4e60:	00001097          	auipc	ra,0x1
    4e64:	d2e080e7          	jalr	-722(ra) # 5b8e <exit>
  close(fd);
    4e68:	854a                	mv	a0,s2
    4e6a:	00001097          	auipc	ra,0x1
    4e6e:	d4c080e7          	jalr	-692(ra) # 5bb6 <close>
  if(n != N){
    4e72:	02800793          	li	a5,40
    4e76:	00fa9763          	bne	s5,a5,4e84 <concreate+0x190>
    if(((i % 3) == 0 && pid == 0) ||
    4e7a:	4a8d                	li	s5,3
    4e7c:	4b05                	li	s6,1
  for(i = 0; i < N; i++){
    4e7e:	02800a13          	li	s4,40
    4e82:	a8c9                	j	4f54 <concreate+0x260>
    printf("%s: concreate not enough files in directory listing\n", s);
    4e84:	85ce                	mv	a1,s3
    4e86:	00003517          	auipc	a0,0x3
    4e8a:	f9250513          	add	a0,a0,-110 # 7e18 <malloc+0x1e42>
    4e8e:	00001097          	auipc	ra,0x1
    4e92:	090080e7          	jalr	144(ra) # 5f1e <printf>
    exit(1);
    4e96:	4505                	li	a0,1
    4e98:	00001097          	auipc	ra,0x1
    4e9c:	cf6080e7          	jalr	-778(ra) # 5b8e <exit>
      printf("%s: fork failed\n", s);
    4ea0:	85ce                	mv	a1,s3
    4ea2:	00002517          	auipc	a0,0x2
    4ea6:	ade50513          	add	a0,a0,-1314 # 6980 <malloc+0x9aa>
    4eaa:	00001097          	auipc	ra,0x1
    4eae:	074080e7          	jalr	116(ra) # 5f1e <printf>
      exit(1);
    4eb2:	4505                	li	a0,1
    4eb4:	00001097          	auipc	ra,0x1
    4eb8:	cda080e7          	jalr	-806(ra) # 5b8e <exit>
      close(open(file, 0));
    4ebc:	4581                	li	a1,0
    4ebe:	fa840513          	add	a0,s0,-88
    4ec2:	00001097          	auipc	ra,0x1
    4ec6:	d0c080e7          	jalr	-756(ra) # 5bce <open>
    4eca:	00001097          	auipc	ra,0x1
    4ece:	cec080e7          	jalr	-788(ra) # 5bb6 <close>
      close(open(file, 0));
    4ed2:	4581                	li	a1,0
    4ed4:	fa840513          	add	a0,s0,-88
    4ed8:	00001097          	auipc	ra,0x1
    4edc:	cf6080e7          	jalr	-778(ra) # 5bce <open>
    4ee0:	00001097          	auipc	ra,0x1
    4ee4:	cd6080e7          	jalr	-810(ra) # 5bb6 <close>
      close(open(file, 0));
    4ee8:	4581                	li	a1,0
    4eea:	fa840513          	add	a0,s0,-88
    4eee:	00001097          	auipc	ra,0x1
    4ef2:	ce0080e7          	jalr	-800(ra) # 5bce <open>
    4ef6:	00001097          	auipc	ra,0x1
    4efa:	cc0080e7          	jalr	-832(ra) # 5bb6 <close>
      close(open(file, 0));
    4efe:	4581                	li	a1,0
    4f00:	fa840513          	add	a0,s0,-88
    4f04:	00001097          	auipc	ra,0x1
    4f08:	cca080e7          	jalr	-822(ra) # 5bce <open>
    4f0c:	00001097          	auipc	ra,0x1
    4f10:	caa080e7          	jalr	-854(ra) # 5bb6 <close>
      close(open(file, 0));
    4f14:	4581                	li	a1,0
    4f16:	fa840513          	add	a0,s0,-88
    4f1a:	00001097          	auipc	ra,0x1
    4f1e:	cb4080e7          	jalr	-844(ra) # 5bce <open>
    4f22:	00001097          	auipc	ra,0x1
    4f26:	c94080e7          	jalr	-876(ra) # 5bb6 <close>
      close(open(file, 0));
    4f2a:	4581                	li	a1,0
    4f2c:	fa840513          	add	a0,s0,-88
    4f30:	00001097          	auipc	ra,0x1
    4f34:	c9e080e7          	jalr	-866(ra) # 5bce <open>
    4f38:	00001097          	auipc	ra,0x1
    4f3c:	c7e080e7          	jalr	-898(ra) # 5bb6 <close>
    if(pid == 0)
    4f40:	08090363          	beqz	s2,4fc6 <concreate+0x2d2>
      wait(0);
    4f44:	4501                	li	a0,0
    4f46:	00001097          	auipc	ra,0x1
    4f4a:	c50080e7          	jalr	-944(ra) # 5b96 <wait>
  for(i = 0; i < N; i++){
    4f4e:	2485                	addw	s1,s1,1
    4f50:	0f448563          	beq	s1,s4,503a <concreate+0x346>
    file[1] = '0' + i;
    4f54:	0304879b          	addw	a5,s1,48
    4f58:	faf404a3          	sb	a5,-87(s0)
    pid = fork();
    4f5c:	00001097          	auipc	ra,0x1
    4f60:	c2a080e7          	jalr	-982(ra) # 5b86 <fork>
    4f64:	892a                	mv	s2,a0
    if(pid < 0){
    4f66:	f2054de3          	bltz	a0,4ea0 <concreate+0x1ac>
    if(((i % 3) == 0 && pid == 0) ||
    4f6a:	0354e73b          	remw	a4,s1,s5
    4f6e:	00a767b3          	or	a5,a4,a0
    4f72:	2781                	sext.w	a5,a5
    4f74:	d7a1                	beqz	a5,4ebc <concreate+0x1c8>
    4f76:	01671363          	bne	a4,s6,4f7c <concreate+0x288>
       ((i % 3) == 1 && pid != 0)){
    4f7a:	f129                	bnez	a0,4ebc <concreate+0x1c8>
      unlink(file);
    4f7c:	fa840513          	add	a0,s0,-88
    4f80:	00001097          	auipc	ra,0x1
    4f84:	c5e080e7          	jalr	-930(ra) # 5bde <unlink>
      unlink(file);
    4f88:	fa840513          	add	a0,s0,-88
    4f8c:	00001097          	auipc	ra,0x1
    4f90:	c52080e7          	jalr	-942(ra) # 5bde <unlink>
      unlink(file);
    4f94:	fa840513          	add	a0,s0,-88
    4f98:	00001097          	auipc	ra,0x1
    4f9c:	c46080e7          	jalr	-954(ra) # 5bde <unlink>
      unlink(file);
    4fa0:	fa840513          	add	a0,s0,-88
    4fa4:	00001097          	auipc	ra,0x1
    4fa8:	c3a080e7          	jalr	-966(ra) # 5bde <unlink>
      unlink(file);
    4fac:	fa840513          	add	a0,s0,-88
    4fb0:	00001097          	auipc	ra,0x1
    4fb4:	c2e080e7          	jalr	-978(ra) # 5bde <unlink>
      unlink(file);
    4fb8:	fa840513          	add	a0,s0,-88
    4fbc:	00001097          	auipc	ra,0x1
    4fc0:	c22080e7          	jalr	-990(ra) # 5bde <unlink>
    4fc4:	bfb5                	j	4f40 <concreate+0x24c>
      exit(0);
    4fc6:	4501                	li	a0,0
    4fc8:	00001097          	auipc	ra,0x1
    4fcc:	bc6080e7          	jalr	-1082(ra) # 5b8e <exit>
      close(fd);
    4fd0:	00001097          	auipc	ra,0x1
    4fd4:	be6080e7          	jalr	-1050(ra) # 5bb6 <close>
    if(pid == 0) {
    4fd8:	bb5d                	j	4d8e <concreate+0x9a>
      close(fd);
    4fda:	00001097          	auipc	ra,0x1
    4fde:	bdc080e7          	jalr	-1060(ra) # 5bb6 <close>
      wait(&xstatus);
    4fe2:	f6c40513          	add	a0,s0,-148
    4fe6:	00001097          	auipc	ra,0x1
    4fea:	bb0080e7          	jalr	-1104(ra) # 5b96 <wait>
      if(xstatus != 0)
    4fee:	f6c42483          	lw	s1,-148(s0)
    4ff2:	da0493e3          	bnez	s1,4d98 <concreate+0xa4>
  for(i = 0; i < N; i++){
    4ff6:	2905                	addw	s2,s2,1
    4ff8:	db4905e3          	beq	s2,s4,4da2 <concreate+0xae>
    file[1] = '0' + i;
    4ffc:	0309079b          	addw	a5,s2,48
    5000:	faf404a3          	sb	a5,-87(s0)
    unlink(file);
    5004:	fa840513          	add	a0,s0,-88
    5008:	00001097          	auipc	ra,0x1
    500c:	bd6080e7          	jalr	-1066(ra) # 5bde <unlink>
    pid = fork();
    5010:	00001097          	auipc	ra,0x1
    5014:	b76080e7          	jalr	-1162(ra) # 5b86 <fork>
    if(pid && (i % 3) == 1){
    5018:	d20502e3          	beqz	a0,4d3c <concreate+0x48>
    501c:	036967bb          	remw	a5,s2,s6
    5020:	d15786e3          	beq	a5,s5,4d2c <concreate+0x38>
      fd = open(file, O_CREATE | O_RDWR);
    5024:	20200593          	li	a1,514
    5028:	fa840513          	add	a0,s0,-88
    502c:	00001097          	auipc	ra,0x1
    5030:	ba2080e7          	jalr	-1118(ra) # 5bce <open>
      if(fd < 0){
    5034:	fa0553e3          	bgez	a0,4fda <concreate+0x2e6>
    5038:	b315                	j	4d5c <concreate+0x68>
}
    503a:	60ea                	ld	ra,152(sp)
    503c:	644a                	ld	s0,144(sp)
    503e:	64aa                	ld	s1,136(sp)
    5040:	690a                	ld	s2,128(sp)
    5042:	79e6                	ld	s3,120(sp)
    5044:	7a46                	ld	s4,112(sp)
    5046:	7aa6                	ld	s5,104(sp)
    5048:	7b06                	ld	s6,96(sp)
    504a:	6be6                	ld	s7,88(sp)
    504c:	610d                	add	sp,sp,160
    504e:	8082                	ret

0000000000005050 <bigfile>:
{
    5050:	7139                	add	sp,sp,-64
    5052:	fc06                	sd	ra,56(sp)
    5054:	f822                	sd	s0,48(sp)
    5056:	f426                	sd	s1,40(sp)
    5058:	f04a                	sd	s2,32(sp)
    505a:	ec4e                	sd	s3,24(sp)
    505c:	e852                	sd	s4,16(sp)
    505e:	e456                	sd	s5,8(sp)
    5060:	0080                	add	s0,sp,64
    5062:	8aaa                	mv	s5,a0
  unlink("bigfile.dat");
    5064:	00003517          	auipc	a0,0x3
    5068:	dec50513          	add	a0,a0,-532 # 7e50 <malloc+0x1e7a>
    506c:	00001097          	auipc	ra,0x1
    5070:	b72080e7          	jalr	-1166(ra) # 5bde <unlink>
  fd = open("bigfile.dat", O_CREATE | O_RDWR);
    5074:	20200593          	li	a1,514
    5078:	00003517          	auipc	a0,0x3
    507c:	dd850513          	add	a0,a0,-552 # 7e50 <malloc+0x1e7a>
    5080:	00001097          	auipc	ra,0x1
    5084:	b4e080e7          	jalr	-1202(ra) # 5bce <open>
    5088:	89aa                	mv	s3,a0
  for(i = 0; i < N; i++){
    508a:	4481                	li	s1,0
    memset(buf, i, SZ);
    508c:	00008917          	auipc	s2,0x8
    5090:	bdc90913          	add	s2,s2,-1060 # cc68 <buf>
  for(i = 0; i < N; i++){
    5094:	4a51                	li	s4,20
  if(fd < 0){
    5096:	0a054063          	bltz	a0,5136 <bigfile+0xe6>
    memset(buf, i, SZ);
    509a:	25800613          	li	a2,600
    509e:	85a6                	mv	a1,s1
    50a0:	854a                	mv	a0,s2
    50a2:	00001097          	auipc	ra,0x1
    50a6:	8f2080e7          	jalr	-1806(ra) # 5994 <memset>
    if(write(fd, buf, SZ) != SZ){
    50aa:	25800613          	li	a2,600
    50ae:	85ca                	mv	a1,s2
    50b0:	854e                	mv	a0,s3
    50b2:	00001097          	auipc	ra,0x1
    50b6:	afc080e7          	jalr	-1284(ra) # 5bae <write>
    50ba:	25800793          	li	a5,600
    50be:	08f51a63          	bne	a0,a5,5152 <bigfile+0x102>
  for(i = 0; i < N; i++){
    50c2:	2485                	addw	s1,s1,1
    50c4:	fd449be3          	bne	s1,s4,509a <bigfile+0x4a>
  close(fd);
    50c8:	854e                	mv	a0,s3
    50ca:	00001097          	auipc	ra,0x1
    50ce:	aec080e7          	jalr	-1300(ra) # 5bb6 <close>
  fd = open("bigfile.dat", 0);
    50d2:	4581                	li	a1,0
    50d4:	00003517          	auipc	a0,0x3
    50d8:	d7c50513          	add	a0,a0,-644 # 7e50 <malloc+0x1e7a>
    50dc:	00001097          	auipc	ra,0x1
    50e0:	af2080e7          	jalr	-1294(ra) # 5bce <open>
    50e4:	8a2a                	mv	s4,a0
  total = 0;
    50e6:	4981                	li	s3,0
  for(i = 0; ; i++){
    50e8:	4481                	li	s1,0
    cc = read(fd, buf, SZ/2);
    50ea:	00008917          	auipc	s2,0x8
    50ee:	b7e90913          	add	s2,s2,-1154 # cc68 <buf>
  if(fd < 0){
    50f2:	06054e63          	bltz	a0,516e <bigfile+0x11e>
    cc = read(fd, buf, SZ/2);
    50f6:	12c00613          	li	a2,300
    50fa:	85ca                	mv	a1,s2
    50fc:	8552                	mv	a0,s4
    50fe:	00001097          	auipc	ra,0x1
    5102:	aa8080e7          	jalr	-1368(ra) # 5ba6 <read>
    if(cc < 0){
    5106:	08054263          	bltz	a0,518a <bigfile+0x13a>
    if(cc == 0)
    510a:	c971                	beqz	a0,51de <bigfile+0x18e>
    if(cc != SZ/2){
    510c:	12c00793          	li	a5,300
    5110:	08f51b63          	bne	a0,a5,51a6 <bigfile+0x156>
    if(buf[0] != i/2 || buf[SZ/2-1] != i/2){
    5114:	01f4d79b          	srlw	a5,s1,0x1f
    5118:	9fa5                	addw	a5,a5,s1
    511a:	4017d79b          	sraw	a5,a5,0x1
    511e:	00094703          	lbu	a4,0(s2)
    5122:	0af71063          	bne	a4,a5,51c2 <bigfile+0x172>
    5126:	12b94703          	lbu	a4,299(s2)
    512a:	08f71c63          	bne	a4,a5,51c2 <bigfile+0x172>
    total += cc;
    512e:	12c9899b          	addw	s3,s3,300
  for(i = 0; ; i++){
    5132:	2485                	addw	s1,s1,1
    cc = read(fd, buf, SZ/2);
    5134:	b7c9                	j	50f6 <bigfile+0xa6>
    printf("%s: cannot create bigfile", s);
    5136:	85d6                	mv	a1,s5
    5138:	00003517          	auipc	a0,0x3
    513c:	d2850513          	add	a0,a0,-728 # 7e60 <malloc+0x1e8a>
    5140:	00001097          	auipc	ra,0x1
    5144:	dde080e7          	jalr	-546(ra) # 5f1e <printf>
    exit(1);
    5148:	4505                	li	a0,1
    514a:	00001097          	auipc	ra,0x1
    514e:	a44080e7          	jalr	-1468(ra) # 5b8e <exit>
      printf("%s: write bigfile failed\n", s);
    5152:	85d6                	mv	a1,s5
    5154:	00003517          	auipc	a0,0x3
    5158:	d2c50513          	add	a0,a0,-724 # 7e80 <malloc+0x1eaa>
    515c:	00001097          	auipc	ra,0x1
    5160:	dc2080e7          	jalr	-574(ra) # 5f1e <printf>
      exit(1);
    5164:	4505                	li	a0,1
    5166:	00001097          	auipc	ra,0x1
    516a:	a28080e7          	jalr	-1496(ra) # 5b8e <exit>
    printf("%s: cannot open bigfile\n", s);
    516e:	85d6                	mv	a1,s5
    5170:	00003517          	auipc	a0,0x3
    5174:	d3050513          	add	a0,a0,-720 # 7ea0 <malloc+0x1eca>
    5178:	00001097          	auipc	ra,0x1
    517c:	da6080e7          	jalr	-602(ra) # 5f1e <printf>
    exit(1);
    5180:	4505                	li	a0,1
    5182:	00001097          	auipc	ra,0x1
    5186:	a0c080e7          	jalr	-1524(ra) # 5b8e <exit>
      printf("%s: read bigfile failed\n", s);
    518a:	85d6                	mv	a1,s5
    518c:	00003517          	auipc	a0,0x3
    5190:	d3450513          	add	a0,a0,-716 # 7ec0 <malloc+0x1eea>
    5194:	00001097          	auipc	ra,0x1
    5198:	d8a080e7          	jalr	-630(ra) # 5f1e <printf>
      exit(1);
    519c:	4505                	li	a0,1
    519e:	00001097          	auipc	ra,0x1
    51a2:	9f0080e7          	jalr	-1552(ra) # 5b8e <exit>
      printf("%s: short read bigfile\n", s);
    51a6:	85d6                	mv	a1,s5
    51a8:	00003517          	auipc	a0,0x3
    51ac:	d3850513          	add	a0,a0,-712 # 7ee0 <malloc+0x1f0a>
    51b0:	00001097          	auipc	ra,0x1
    51b4:	d6e080e7          	jalr	-658(ra) # 5f1e <printf>
      exit(1);
    51b8:	4505                	li	a0,1
    51ba:	00001097          	auipc	ra,0x1
    51be:	9d4080e7          	jalr	-1580(ra) # 5b8e <exit>
      printf("%s: read bigfile wrong data\n", s);
    51c2:	85d6                	mv	a1,s5
    51c4:	00003517          	auipc	a0,0x3
    51c8:	d3450513          	add	a0,a0,-716 # 7ef8 <malloc+0x1f22>
    51cc:	00001097          	auipc	ra,0x1
    51d0:	d52080e7          	jalr	-686(ra) # 5f1e <printf>
      exit(1);
    51d4:	4505                	li	a0,1
    51d6:	00001097          	auipc	ra,0x1
    51da:	9b8080e7          	jalr	-1608(ra) # 5b8e <exit>
  close(fd);
    51de:	8552                	mv	a0,s4
    51e0:	00001097          	auipc	ra,0x1
    51e4:	9d6080e7          	jalr	-1578(ra) # 5bb6 <close>
  if(total != N*SZ){
    51e8:	678d                	lui	a5,0x3
    51ea:	ee078793          	add	a5,a5,-288 # 2ee0 <fourteen+0x1a>
    51ee:	02f99363          	bne	s3,a5,5214 <bigfile+0x1c4>
  unlink("bigfile.dat");
    51f2:	00003517          	auipc	a0,0x3
    51f6:	c5e50513          	add	a0,a0,-930 # 7e50 <malloc+0x1e7a>
    51fa:	00001097          	auipc	ra,0x1
    51fe:	9e4080e7          	jalr	-1564(ra) # 5bde <unlink>
}
    5202:	70e2                	ld	ra,56(sp)
    5204:	7442                	ld	s0,48(sp)
    5206:	74a2                	ld	s1,40(sp)
    5208:	7902                	ld	s2,32(sp)
    520a:	69e2                	ld	s3,24(sp)
    520c:	6a42                	ld	s4,16(sp)
    520e:	6aa2                	ld	s5,8(sp)
    5210:	6121                	add	sp,sp,64
    5212:	8082                	ret
    printf("%s: read bigfile wrong total\n", s);
    5214:	85d6                	mv	a1,s5
    5216:	00003517          	auipc	a0,0x3
    521a:	d0250513          	add	a0,a0,-766 # 7f18 <malloc+0x1f42>
    521e:	00001097          	auipc	ra,0x1
    5222:	d00080e7          	jalr	-768(ra) # 5f1e <printf>
    exit(1);
    5226:	4505                	li	a0,1
    5228:	00001097          	auipc	ra,0x1
    522c:	966080e7          	jalr	-1690(ra) # 5b8e <exit>

0000000000005230 <rwsbrk>:
{
    5230:	1101                	add	sp,sp,-32
    5232:	ec06                	sd	ra,24(sp)
    5234:	e822                	sd	s0,16(sp)
    5236:	e426                	sd	s1,8(sp)
    5238:	e04a                	sd	s2,0(sp)
    523a:	1000                	add	s0,sp,32
  uint64 a = (uint64) sbrk(8192);
    523c:	6509                	lui	a0,0x2
    523e:	00001097          	auipc	ra,0x1
    5242:	9d8080e7          	jalr	-1576(ra) # 5c16 <sbrk>
  if(a == 0xffffffffffffffffLL) {
    5246:	57fd                	li	a5,-1
    5248:	06f50263          	beq	a0,a5,52ac <rwsbrk+0x7c>
    524c:	84aa                	mv	s1,a0
  if ((uint64) sbrk(-8192) ==  0xffffffffffffffffLL) {
    524e:	7579                	lui	a0,0xffffe
    5250:	00001097          	auipc	ra,0x1
    5254:	9c6080e7          	jalr	-1594(ra) # 5c16 <sbrk>
    5258:	57fd                	li	a5,-1
    525a:	06f50663          	beq	a0,a5,52c6 <rwsbrk+0x96>
  fd = open("rwsbrk", O_CREATE|O_WRONLY);
    525e:	20100593          	li	a1,513
    5262:	00003517          	auipc	a0,0x3
    5266:	d0e50513          	add	a0,a0,-754 # 7f70 <malloc+0x1f9a>
    526a:	00001097          	auipc	ra,0x1
    526e:	964080e7          	jalr	-1692(ra) # 5bce <open>
    5272:	892a                	mv	s2,a0
  if(fd < 0){
    5274:	06054663          	bltz	a0,52e0 <rwsbrk+0xb0>
  n = write(fd, (void*)(a+4096), 1024);
    5278:	6785                	lui	a5,0x1
    527a:	94be                	add	s1,s1,a5
    527c:	40000613          	li	a2,1024
    5280:	85a6                	mv	a1,s1
    5282:	00001097          	auipc	ra,0x1
    5286:	92c080e7          	jalr	-1748(ra) # 5bae <write>
    528a:	862a                	mv	a2,a0
  if(n >= 0){
    528c:	06054763          	bltz	a0,52fa <rwsbrk+0xca>
    printf("write(fd, %p, 1024) returned %d, not -1\n", a+4096, n);
    5290:	85a6                	mv	a1,s1
    5292:	00003517          	auipc	a0,0x3
    5296:	cfe50513          	add	a0,a0,-770 # 7f90 <malloc+0x1fba>
    529a:	00001097          	auipc	ra,0x1
    529e:	c84080e7          	jalr	-892(ra) # 5f1e <printf>
    exit(1);
    52a2:	4505                	li	a0,1
    52a4:	00001097          	auipc	ra,0x1
    52a8:	8ea080e7          	jalr	-1814(ra) # 5b8e <exit>
    printf("sbrk(rwsbrk) failed\n");
    52ac:	00003517          	auipc	a0,0x3
    52b0:	c8c50513          	add	a0,a0,-884 # 7f38 <malloc+0x1f62>
    52b4:	00001097          	auipc	ra,0x1
    52b8:	c6a080e7          	jalr	-918(ra) # 5f1e <printf>
    exit(1);
    52bc:	4505                	li	a0,1
    52be:	00001097          	auipc	ra,0x1
    52c2:	8d0080e7          	jalr	-1840(ra) # 5b8e <exit>
    printf("sbrk(rwsbrk) shrink failed\n");
    52c6:	00003517          	auipc	a0,0x3
    52ca:	c8a50513          	add	a0,a0,-886 # 7f50 <malloc+0x1f7a>
    52ce:	00001097          	auipc	ra,0x1
    52d2:	c50080e7          	jalr	-944(ra) # 5f1e <printf>
    exit(1);
    52d6:	4505                	li	a0,1
    52d8:	00001097          	auipc	ra,0x1
    52dc:	8b6080e7          	jalr	-1866(ra) # 5b8e <exit>
    printf("open(rwsbrk) failed\n");
    52e0:	00003517          	auipc	a0,0x3
    52e4:	c9850513          	add	a0,a0,-872 # 7f78 <malloc+0x1fa2>
    52e8:	00001097          	auipc	ra,0x1
    52ec:	c36080e7          	jalr	-970(ra) # 5f1e <printf>
    exit(1);
    52f0:	4505                	li	a0,1
    52f2:	00001097          	auipc	ra,0x1
    52f6:	89c080e7          	jalr	-1892(ra) # 5b8e <exit>
  close(fd);
    52fa:	854a                	mv	a0,s2
    52fc:	00001097          	auipc	ra,0x1
    5300:	8ba080e7          	jalr	-1862(ra) # 5bb6 <close>
  unlink("rwsbrk");
    5304:	00003517          	auipc	a0,0x3
    5308:	c6c50513          	add	a0,a0,-916 # 7f70 <malloc+0x1f9a>
    530c:	00001097          	auipc	ra,0x1
    5310:	8d2080e7          	jalr	-1838(ra) # 5bde <unlink>
  fd = open("README", O_RDONLY);
    5314:	4581                	li	a1,0
    5316:	00001517          	auipc	a0,0x1
    531a:	fba50513          	add	a0,a0,-70 # 62d0 <malloc+0x2fa>
    531e:	00001097          	auipc	ra,0x1
    5322:	8b0080e7          	jalr	-1872(ra) # 5bce <open>
    5326:	892a                	mv	s2,a0
  if(fd < 0){
    5328:	02054963          	bltz	a0,535a <rwsbrk+0x12a>
  n = read(fd, (void*)(a+4096), 10);
    532c:	4629                	li	a2,10
    532e:	85a6                	mv	a1,s1
    5330:	00001097          	auipc	ra,0x1
    5334:	876080e7          	jalr	-1930(ra) # 5ba6 <read>
    5338:	862a                	mv	a2,a0
  if(n >= 0){
    533a:	02054d63          	bltz	a0,5374 <rwsbrk+0x144>
    printf("read(fd, %p, 10) returned %d, not -1\n", a+4096, n);
    533e:	85a6                	mv	a1,s1
    5340:	00003517          	auipc	a0,0x3
    5344:	c8050513          	add	a0,a0,-896 # 7fc0 <malloc+0x1fea>
    5348:	00001097          	auipc	ra,0x1
    534c:	bd6080e7          	jalr	-1066(ra) # 5f1e <printf>
    exit(1);
    5350:	4505                	li	a0,1
    5352:	00001097          	auipc	ra,0x1
    5356:	83c080e7          	jalr	-1988(ra) # 5b8e <exit>
    printf("open(rwsbrk) failed\n");
    535a:	00003517          	auipc	a0,0x3
    535e:	c1e50513          	add	a0,a0,-994 # 7f78 <malloc+0x1fa2>
    5362:	00001097          	auipc	ra,0x1
    5366:	bbc080e7          	jalr	-1092(ra) # 5f1e <printf>
    exit(1);
    536a:	4505                	li	a0,1
    536c:	00001097          	auipc	ra,0x1
    5370:	822080e7          	jalr	-2014(ra) # 5b8e <exit>
  close(fd);
    5374:	854a                	mv	a0,s2
    5376:	00001097          	auipc	ra,0x1
    537a:	840080e7          	jalr	-1984(ra) # 5bb6 <close>
  exit(0);
    537e:	4501                	li	a0,0
    5380:	00001097          	auipc	ra,0x1
    5384:	80e080e7          	jalr	-2034(ra) # 5b8e <exit>

0000000000005388 <fsfull>:
{
    5388:	7135                	add	sp,sp,-160
    538a:	ed06                	sd	ra,152(sp)
    538c:	e922                	sd	s0,144(sp)
    538e:	e526                	sd	s1,136(sp)
    5390:	e14a                	sd	s2,128(sp)
    5392:	fcce                	sd	s3,120(sp)
    5394:	f8d2                	sd	s4,112(sp)
    5396:	f4d6                	sd	s5,104(sp)
    5398:	f0da                	sd	s6,96(sp)
    539a:	ecde                	sd	s7,88(sp)
    539c:	e8e2                	sd	s8,80(sp)
    539e:	e4e6                	sd	s9,72(sp)
    53a0:	e0ea                	sd	s10,64(sp)
    53a2:	1100                	add	s0,sp,160
  printf("fsfull test\n");
    53a4:	00003517          	auipc	a0,0x3
    53a8:	c4450513          	add	a0,a0,-956 # 7fe8 <malloc+0x2012>
    53ac:	00001097          	auipc	ra,0x1
    53b0:	b72080e7          	jalr	-1166(ra) # 5f1e <printf>
  for(nfiles = 0; ; nfiles++){
    53b4:	4481                	li	s1,0
    name[0] = 'f';
    53b6:	06600d13          	li	s10,102
    name[1] = '0' + nfiles / 1000;
    53ba:	3e800c13          	li	s8,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    53be:	06400b93          	li	s7,100
    name[3] = '0' + (nfiles % 100) / 10;
    53c2:	4b29                	li	s6,10
    printf("writing %s\n", name);
    53c4:	00003c97          	auipc	s9,0x3
    53c8:	c34c8c93          	add	s9,s9,-972 # 7ff8 <malloc+0x2022>
    name[0] = 'f';
    53cc:	f7a40023          	sb	s10,-160(s0)
    name[1] = '0' + nfiles / 1000;
    53d0:	0384c7bb          	divw	a5,s1,s8
    53d4:	0307879b          	addw	a5,a5,48 # 1030 <linktest+0x13c>
    53d8:	f6f400a3          	sb	a5,-159(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    53dc:	0384e7bb          	remw	a5,s1,s8
    53e0:	0377c7bb          	divw	a5,a5,s7
    53e4:	0307879b          	addw	a5,a5,48
    53e8:	f6f40123          	sb	a5,-158(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    53ec:	0374e7bb          	remw	a5,s1,s7
    53f0:	0367c7bb          	divw	a5,a5,s6
    53f4:	0307879b          	addw	a5,a5,48
    53f8:	f6f401a3          	sb	a5,-157(s0)
    name[4] = '0' + (nfiles % 10);
    53fc:	0364e7bb          	remw	a5,s1,s6
    5400:	0307879b          	addw	a5,a5,48
    5404:	f6f40223          	sb	a5,-156(s0)
    name[5] = '\0';
    5408:	f60402a3          	sb	zero,-155(s0)
    printf("writing %s\n", name);
    540c:	f6040593          	add	a1,s0,-160
    5410:	8566                	mv	a0,s9
    5412:	00001097          	auipc	ra,0x1
    5416:	b0c080e7          	jalr	-1268(ra) # 5f1e <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    541a:	20200593          	li	a1,514
    541e:	f6040513          	add	a0,s0,-160
    5422:	00000097          	auipc	ra,0x0
    5426:	7ac080e7          	jalr	1964(ra) # 5bce <open>
    542a:	892a                	mv	s2,a0
    if(fd < 0){
    542c:	0a055563          	bgez	a0,54d6 <fsfull+0x14e>
      printf("open %s failed\n", name);
    5430:	f6040593          	add	a1,s0,-160
    5434:	00003517          	auipc	a0,0x3
    5438:	bd450513          	add	a0,a0,-1068 # 8008 <malloc+0x2032>
    543c:	00001097          	auipc	ra,0x1
    5440:	ae2080e7          	jalr	-1310(ra) # 5f1e <printf>
  while(nfiles >= 0){
    5444:	0604c363          	bltz	s1,54aa <fsfull+0x122>
    name[0] = 'f';
    5448:	06600b13          	li	s6,102
    name[1] = '0' + nfiles / 1000;
    544c:	3e800a13          	li	s4,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    5450:	06400993          	li	s3,100
    name[3] = '0' + (nfiles % 100) / 10;
    5454:	4929                	li	s2,10
  while(nfiles >= 0){
    5456:	5afd                	li	s5,-1
    name[0] = 'f';
    5458:	f7640023          	sb	s6,-160(s0)
    name[1] = '0' + nfiles / 1000;
    545c:	0344c7bb          	divw	a5,s1,s4
    5460:	0307879b          	addw	a5,a5,48
    5464:	f6f400a3          	sb	a5,-159(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    5468:	0344e7bb          	remw	a5,s1,s4
    546c:	0337c7bb          	divw	a5,a5,s3
    5470:	0307879b          	addw	a5,a5,48
    5474:	f6f40123          	sb	a5,-158(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    5478:	0334e7bb          	remw	a5,s1,s3
    547c:	0327c7bb          	divw	a5,a5,s2
    5480:	0307879b          	addw	a5,a5,48
    5484:	f6f401a3          	sb	a5,-157(s0)
    name[4] = '0' + (nfiles % 10);
    5488:	0324e7bb          	remw	a5,s1,s2
    548c:	0307879b          	addw	a5,a5,48
    5490:	f6f40223          	sb	a5,-156(s0)
    name[5] = '\0';
    5494:	f60402a3          	sb	zero,-155(s0)
    unlink(name);
    5498:	f6040513          	add	a0,s0,-160
    549c:	00000097          	auipc	ra,0x0
    54a0:	742080e7          	jalr	1858(ra) # 5bde <unlink>
    nfiles--;
    54a4:	34fd                	addw	s1,s1,-1
  while(nfiles >= 0){
    54a6:	fb5499e3          	bne	s1,s5,5458 <fsfull+0xd0>
  printf("fsfull test finished\n");
    54aa:	00003517          	auipc	a0,0x3
    54ae:	b7e50513          	add	a0,a0,-1154 # 8028 <malloc+0x2052>
    54b2:	00001097          	auipc	ra,0x1
    54b6:	a6c080e7          	jalr	-1428(ra) # 5f1e <printf>
}
    54ba:	60ea                	ld	ra,152(sp)
    54bc:	644a                	ld	s0,144(sp)
    54be:	64aa                	ld	s1,136(sp)
    54c0:	690a                	ld	s2,128(sp)
    54c2:	79e6                	ld	s3,120(sp)
    54c4:	7a46                	ld	s4,112(sp)
    54c6:	7aa6                	ld	s5,104(sp)
    54c8:	7b06                	ld	s6,96(sp)
    54ca:	6be6                	ld	s7,88(sp)
    54cc:	6c46                	ld	s8,80(sp)
    54ce:	6ca6                	ld	s9,72(sp)
    54d0:	6d06                	ld	s10,64(sp)
    54d2:	610d                	add	sp,sp,160
    54d4:	8082                	ret
    int total = 0;
    54d6:	4981                	li	s3,0
      int cc = write(fd, buf, BSIZE);
    54d8:	00007a97          	auipc	s5,0x7
    54dc:	790a8a93          	add	s5,s5,1936 # cc68 <buf>
      if(cc < BSIZE)
    54e0:	3ff00a13          	li	s4,1023
      int cc = write(fd, buf, BSIZE);
    54e4:	40000613          	li	a2,1024
    54e8:	85d6                	mv	a1,s5
    54ea:	854a                	mv	a0,s2
    54ec:	00000097          	auipc	ra,0x0
    54f0:	6c2080e7          	jalr	1730(ra) # 5bae <write>
      if(cc < BSIZE)
    54f4:	00aa5563          	bge	s4,a0,54fe <fsfull+0x176>
      total += cc;
    54f8:	00a989bb          	addw	s3,s3,a0
    while(1){
    54fc:	b7e5                	j	54e4 <fsfull+0x15c>
    printf("wrote %d bytes\n", total);
    54fe:	85ce                	mv	a1,s3
    5500:	00003517          	auipc	a0,0x3
    5504:	b1850513          	add	a0,a0,-1256 # 8018 <malloc+0x2042>
    5508:	00001097          	auipc	ra,0x1
    550c:	a16080e7          	jalr	-1514(ra) # 5f1e <printf>
    close(fd);
    5510:	854a                	mv	a0,s2
    5512:	00000097          	auipc	ra,0x0
    5516:	6a4080e7          	jalr	1700(ra) # 5bb6 <close>
    if(total == 0)
    551a:	f20985e3          	beqz	s3,5444 <fsfull+0xbc>
  for(nfiles = 0; ; nfiles++){
    551e:	2485                	addw	s1,s1,1
    5520:	b575                	j	53cc <fsfull+0x44>

0000000000005522 <run>:
//

// run each test in its own process. run returns 1 if child's exit()
// indicates success.
int
run(void f(char *), char *s) {
    5522:	7179                	add	sp,sp,-48
    5524:	f406                	sd	ra,40(sp)
    5526:	f022                	sd	s0,32(sp)
    5528:	ec26                	sd	s1,24(sp)
    552a:	e84a                	sd	s2,16(sp)
    552c:	1800                	add	s0,sp,48
    552e:	84aa                	mv	s1,a0
    5530:	892e                	mv	s2,a1
  int pid;
  int xstatus;

  printf("test %s: ", s);
    5532:	00003517          	auipc	a0,0x3
    5536:	b0e50513          	add	a0,a0,-1266 # 8040 <malloc+0x206a>
    553a:	00001097          	auipc	ra,0x1
    553e:	9e4080e7          	jalr	-1564(ra) # 5f1e <printf>
  if((pid = fork()) < 0) {
    5542:	00000097          	auipc	ra,0x0
    5546:	644080e7          	jalr	1604(ra) # 5b86 <fork>
    554a:	02054e63          	bltz	a0,5586 <run+0x64>
    printf("runtest: fork error\n");
    exit(1);
  }
  if(pid == 0) {
    554e:	c929                	beqz	a0,55a0 <run+0x7e>
    f(s);
    exit(0);
  } else {
    wait(&xstatus);
    5550:	fdc40513          	add	a0,s0,-36
    5554:	00000097          	auipc	ra,0x0
    5558:	642080e7          	jalr	1602(ra) # 5b96 <wait>
    if(xstatus != 0) 
    555c:	fdc42783          	lw	a5,-36(s0)
    5560:	c7b9                	beqz	a5,55ae <run+0x8c>
      printf("FAILED\n");
    5562:	00003517          	auipc	a0,0x3
    5566:	b0650513          	add	a0,a0,-1274 # 8068 <malloc+0x2092>
    556a:	00001097          	auipc	ra,0x1
    556e:	9b4080e7          	jalr	-1612(ra) # 5f1e <printf>
    else
      printf("OK\n");
    return xstatus == 0;
    5572:	fdc42503          	lw	a0,-36(s0)
  }
}
    5576:	00153513          	seqz	a0,a0
    557a:	70a2                	ld	ra,40(sp)
    557c:	7402                	ld	s0,32(sp)
    557e:	64e2                	ld	s1,24(sp)
    5580:	6942                	ld	s2,16(sp)
    5582:	6145                	add	sp,sp,48
    5584:	8082                	ret
    printf("runtest: fork error\n");
    5586:	00003517          	auipc	a0,0x3
    558a:	aca50513          	add	a0,a0,-1334 # 8050 <malloc+0x207a>
    558e:	00001097          	auipc	ra,0x1
    5592:	990080e7          	jalr	-1648(ra) # 5f1e <printf>
    exit(1);
    5596:	4505                	li	a0,1
    5598:	00000097          	auipc	ra,0x0
    559c:	5f6080e7          	jalr	1526(ra) # 5b8e <exit>
    f(s);
    55a0:	854a                	mv	a0,s2
    55a2:	9482                	jalr	s1
    exit(0);
    55a4:	4501                	li	a0,0
    55a6:	00000097          	auipc	ra,0x0
    55aa:	5e8080e7          	jalr	1512(ra) # 5b8e <exit>
      printf("OK\n");
    55ae:	00003517          	auipc	a0,0x3
    55b2:	ac250513          	add	a0,a0,-1342 # 8070 <malloc+0x209a>
    55b6:	00001097          	auipc	ra,0x1
    55ba:	968080e7          	jalr	-1688(ra) # 5f1e <printf>
    55be:	bf55                	j	5572 <run+0x50>

00000000000055c0 <runtests>:

int
runtests(struct test *tests, char *justone) {
    55c0:	1101                	add	sp,sp,-32
    55c2:	ec06                	sd	ra,24(sp)
    55c4:	e822                	sd	s0,16(sp)
    55c6:	e426                	sd	s1,8(sp)
    55c8:	e04a                	sd	s2,0(sp)
    55ca:	1000                	add	s0,sp,32
    55cc:	84aa                	mv	s1,a0
    55ce:	892e                	mv	s2,a1
  for (struct test *t = tests; t->s != 0; t++) {
    55d0:	6508                	ld	a0,8(a0)
    55d2:	ed09                	bnez	a0,55ec <runtests+0x2c>
        printf("SOME TESTS FAILED\n");
        return 1;
      }
    }
  }
  return 0;
    55d4:	4501                	li	a0,0
    55d6:	a82d                	j	5610 <runtests+0x50>
      if(!run(t->f, t->s)){
    55d8:	648c                	ld	a1,8(s1)
    55da:	6088                	ld	a0,0(s1)
    55dc:	00000097          	auipc	ra,0x0
    55e0:	f46080e7          	jalr	-186(ra) # 5522 <run>
    55e4:	cd09                	beqz	a0,55fe <runtests+0x3e>
  for (struct test *t = tests; t->s != 0; t++) {
    55e6:	04c1                	add	s1,s1,16
    55e8:	6488                	ld	a0,8(s1)
    55ea:	c11d                	beqz	a0,5610 <runtests+0x50>
    if((justone == 0) || strcmp(t->s, justone) == 0) {
    55ec:	fe0906e3          	beqz	s2,55d8 <runtests+0x18>
    55f0:	85ca                	mv	a1,s2
    55f2:	00000097          	auipc	ra,0x0
    55f6:	34c080e7          	jalr	844(ra) # 593e <strcmp>
    55fa:	f575                	bnez	a0,55e6 <runtests+0x26>
    55fc:	bff1                	j	55d8 <runtests+0x18>
        printf("SOME TESTS FAILED\n");
    55fe:	00003517          	auipc	a0,0x3
    5602:	a7a50513          	add	a0,a0,-1414 # 8078 <malloc+0x20a2>
    5606:	00001097          	auipc	ra,0x1
    560a:	918080e7          	jalr	-1768(ra) # 5f1e <printf>
        return 1;
    560e:	4505                	li	a0,1
}
    5610:	60e2                	ld	ra,24(sp)
    5612:	6442                	ld	s0,16(sp)
    5614:	64a2                	ld	s1,8(sp)
    5616:	6902                	ld	s2,0(sp)
    5618:	6105                	add	sp,sp,32
    561a:	8082                	ret

000000000000561c <countfree>:
// because out of memory with lazy allocation results in the process
// taking a fault and being killed, fork and report back.
//
int
countfree()
{
    561c:	7139                	add	sp,sp,-64
    561e:	fc06                	sd	ra,56(sp)
    5620:	f822                	sd	s0,48(sp)
    5622:	f426                	sd	s1,40(sp)
    5624:	f04a                	sd	s2,32(sp)
    5626:	ec4e                	sd	s3,24(sp)
    5628:	0080                	add	s0,sp,64
  int fds[2];

  if(pipe(fds) < 0){
    562a:	fc840513          	add	a0,s0,-56
    562e:	00000097          	auipc	ra,0x0
    5632:	570080e7          	jalr	1392(ra) # 5b9e <pipe>
    5636:	06054763          	bltz	a0,56a4 <countfree+0x88>
    printf("pipe() failed in countfree()\n");
    exit(1);
  }
  
  int pid = fork();
    563a:	00000097          	auipc	ra,0x0
    563e:	54c080e7          	jalr	1356(ra) # 5b86 <fork>

  if(pid < 0){
    5642:	06054e63          	bltz	a0,56be <countfree+0xa2>
    printf("fork failed in countfree()\n");
    exit(1);
  }

  if(pid == 0){
    5646:	ed51                	bnez	a0,56e2 <countfree+0xc6>
    close(fds[0]);
    5648:	fc842503          	lw	a0,-56(s0)
    564c:	00000097          	auipc	ra,0x0
    5650:	56a080e7          	jalr	1386(ra) # 5bb6 <close>
    
    while(1){
      uint64 a = (uint64) sbrk(4096);
      if(a == 0xffffffffffffffff){
    5654:	597d                	li	s2,-1
        break;
      }

      // modify the memory to make sure it's really allocated.
      *(char *)(a + 4096 - 1) = 1;
    5656:	4485                	li	s1,1

      // report back one more page.
      if(write(fds[1], "x", 1) != 1){
    5658:	00001997          	auipc	s3,0x1
    565c:	b1098993          	add	s3,s3,-1264 # 6168 <malloc+0x192>
      uint64 a = (uint64) sbrk(4096);
    5660:	6505                	lui	a0,0x1
    5662:	00000097          	auipc	ra,0x0
    5666:	5b4080e7          	jalr	1460(ra) # 5c16 <sbrk>
      if(a == 0xffffffffffffffff){
    566a:	07250763          	beq	a0,s2,56d8 <countfree+0xbc>
      *(char *)(a + 4096 - 1) = 1;
    566e:	6785                	lui	a5,0x1
    5670:	97aa                	add	a5,a5,a0
    5672:	fe978fa3          	sb	s1,-1(a5) # fff <linktest+0x10b>
      if(write(fds[1], "x", 1) != 1){
    5676:	8626                	mv	a2,s1
    5678:	85ce                	mv	a1,s3
    567a:	fcc42503          	lw	a0,-52(s0)
    567e:	00000097          	auipc	ra,0x0
    5682:	530080e7          	jalr	1328(ra) # 5bae <write>
    5686:	fc950de3          	beq	a0,s1,5660 <countfree+0x44>
        printf("write() failed in countfree()\n");
    568a:	00003517          	auipc	a0,0x3
    568e:	a4650513          	add	a0,a0,-1466 # 80d0 <malloc+0x20fa>
    5692:	00001097          	auipc	ra,0x1
    5696:	88c080e7          	jalr	-1908(ra) # 5f1e <printf>
        exit(1);
    569a:	4505                	li	a0,1
    569c:	00000097          	auipc	ra,0x0
    56a0:	4f2080e7          	jalr	1266(ra) # 5b8e <exit>
    printf("pipe() failed in countfree()\n");
    56a4:	00003517          	auipc	a0,0x3
    56a8:	9ec50513          	add	a0,a0,-1556 # 8090 <malloc+0x20ba>
    56ac:	00001097          	auipc	ra,0x1
    56b0:	872080e7          	jalr	-1934(ra) # 5f1e <printf>
    exit(1);
    56b4:	4505                	li	a0,1
    56b6:	00000097          	auipc	ra,0x0
    56ba:	4d8080e7          	jalr	1240(ra) # 5b8e <exit>
    printf("fork failed in countfree()\n");
    56be:	00003517          	auipc	a0,0x3
    56c2:	9f250513          	add	a0,a0,-1550 # 80b0 <malloc+0x20da>
    56c6:	00001097          	auipc	ra,0x1
    56ca:	858080e7          	jalr	-1960(ra) # 5f1e <printf>
    exit(1);
    56ce:	4505                	li	a0,1
    56d0:	00000097          	auipc	ra,0x0
    56d4:	4be080e7          	jalr	1214(ra) # 5b8e <exit>
      }
    }

    exit(0);
    56d8:	4501                	li	a0,0
    56da:	00000097          	auipc	ra,0x0
    56de:	4b4080e7          	jalr	1204(ra) # 5b8e <exit>
  }

  close(fds[1]);
    56e2:	fcc42503          	lw	a0,-52(s0)
    56e6:	00000097          	auipc	ra,0x0
    56ea:	4d0080e7          	jalr	1232(ra) # 5bb6 <close>

  int n = 0;
    56ee:	4481                	li	s1,0
  while(1){
    char c;
    int cc = read(fds[0], &c, 1);
    56f0:	4605                	li	a2,1
    56f2:	fc740593          	add	a1,s0,-57
    56f6:	fc842503          	lw	a0,-56(s0)
    56fa:	00000097          	auipc	ra,0x0
    56fe:	4ac080e7          	jalr	1196(ra) # 5ba6 <read>
    if(cc < 0){
    5702:	00054563          	bltz	a0,570c <countfree+0xf0>
      printf("read() failed in countfree()\n");
      exit(1);
    }
    if(cc == 0)
    5706:	c105                	beqz	a0,5726 <countfree+0x10a>
      break;
    n += 1;
    5708:	2485                	addw	s1,s1,1
  while(1){
    570a:	b7dd                	j	56f0 <countfree+0xd4>
      printf("read() failed in countfree()\n");
    570c:	00003517          	auipc	a0,0x3
    5710:	9e450513          	add	a0,a0,-1564 # 80f0 <malloc+0x211a>
    5714:	00001097          	auipc	ra,0x1
    5718:	80a080e7          	jalr	-2038(ra) # 5f1e <printf>
      exit(1);
    571c:	4505                	li	a0,1
    571e:	00000097          	auipc	ra,0x0
    5722:	470080e7          	jalr	1136(ra) # 5b8e <exit>
  }

  close(fds[0]);
    5726:	fc842503          	lw	a0,-56(s0)
    572a:	00000097          	auipc	ra,0x0
    572e:	48c080e7          	jalr	1164(ra) # 5bb6 <close>
  wait((int*)0);
    5732:	4501                	li	a0,0
    5734:	00000097          	auipc	ra,0x0
    5738:	462080e7          	jalr	1122(ra) # 5b96 <wait>
  
  return n;
}
    573c:	8526                	mv	a0,s1
    573e:	70e2                	ld	ra,56(sp)
    5740:	7442                	ld	s0,48(sp)
    5742:	74a2                	ld	s1,40(sp)
    5744:	7902                	ld	s2,32(sp)
    5746:	69e2                	ld	s3,24(sp)
    5748:	6121                	add	sp,sp,64
    574a:	8082                	ret

000000000000574c <drivetests>:

int
drivetests(int quick, int continuous, char *justone) {
    574c:	711d                	add	sp,sp,-96
    574e:	ec86                	sd	ra,88(sp)
    5750:	e8a2                	sd	s0,80(sp)
    5752:	e4a6                	sd	s1,72(sp)
    5754:	e0ca                	sd	s2,64(sp)
    5756:	fc4e                	sd	s3,56(sp)
    5758:	f852                	sd	s4,48(sp)
    575a:	f456                	sd	s5,40(sp)
    575c:	f05a                	sd	s6,32(sp)
    575e:	ec5e                	sd	s7,24(sp)
    5760:	e862                	sd	s8,16(sp)
    5762:	e466                	sd	s9,8(sp)
    5764:	e06a                	sd	s10,0(sp)
    5766:	1080                	add	s0,sp,96
    5768:	8aaa                	mv	s5,a0
    576a:	89ae                	mv	s3,a1
    576c:	8932                	mv	s2,a2
  do {
    printf("usertests starting\n");
    576e:	00003b97          	auipc	s7,0x3
    5772:	9a2b8b93          	add	s7,s7,-1630 # 8110 <malloc+0x213a>
    int free0 = countfree();
    int free1 = 0;
    if (runtests(quicktests, justone)) {
    5776:	00004b17          	auipc	s6,0x4
    577a:	89ab0b13          	add	s6,s6,-1894 # 9010 <quicktests>
      if(continuous != 2) {
    577e:	4a09                	li	s4,2
      }
    }
    if(!quick) {
      if (justone == 0)
        printf("usertests slow tests starting\n");
      if (runtests(slowtests, justone)) {
    5780:	00004c17          	auipc	s8,0x4
    5784:	c50c0c13          	add	s8,s8,-944 # 93d0 <slowtests>
        printf("usertests slow tests starting\n");
    5788:	00003d17          	auipc	s10,0x3
    578c:	9a0d0d13          	add	s10,s10,-1632 # 8128 <malloc+0x2152>
          return 1;
        }
      }
    }
    if((free1 = countfree()) < free0) {
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    5790:	00003c97          	auipc	s9,0x3
    5794:	9b8c8c93          	add	s9,s9,-1608 # 8148 <malloc+0x2172>
    5798:	a839                	j	57b6 <drivetests+0x6a>
        printf("usertests slow tests starting\n");
    579a:	856a                	mv	a0,s10
    579c:	00000097          	auipc	ra,0x0
    57a0:	782080e7          	jalr	1922(ra) # 5f1e <printf>
    57a4:	a081                	j	57e4 <drivetests+0x98>
    if((free1 = countfree()) < free0) {
    57a6:	00000097          	auipc	ra,0x0
    57aa:	e76080e7          	jalr	-394(ra) # 561c <countfree>
    57ae:	04954663          	blt	a0,s1,57fa <drivetests+0xae>
      if(continuous != 2) {
        return 1;
      }
    }
  } while(continuous);
    57b2:	06098163          	beqz	s3,5814 <drivetests+0xc8>
    printf("usertests starting\n");
    57b6:	855e                	mv	a0,s7
    57b8:	00000097          	auipc	ra,0x0
    57bc:	766080e7          	jalr	1894(ra) # 5f1e <printf>
    int free0 = countfree();
    57c0:	00000097          	auipc	ra,0x0
    57c4:	e5c080e7          	jalr	-420(ra) # 561c <countfree>
    57c8:	84aa                	mv	s1,a0
    if (runtests(quicktests, justone)) {
    57ca:	85ca                	mv	a1,s2
    57cc:	855a                	mv	a0,s6
    57ce:	00000097          	auipc	ra,0x0
    57d2:	df2080e7          	jalr	-526(ra) # 55c0 <runtests>
    57d6:	c119                	beqz	a0,57dc <drivetests+0x90>
      if(continuous != 2) {
    57d8:	03499c63          	bne	s3,s4,5810 <drivetests+0xc4>
    if(!quick) {
    57dc:	fc0a95e3          	bnez	s5,57a6 <drivetests+0x5a>
      if (justone == 0)
    57e0:	fa090de3          	beqz	s2,579a <drivetests+0x4e>
      if (runtests(slowtests, justone)) {
    57e4:	85ca                	mv	a1,s2
    57e6:	8562                	mv	a0,s8
    57e8:	00000097          	auipc	ra,0x0
    57ec:	dd8080e7          	jalr	-552(ra) # 55c0 <runtests>
    57f0:	d95d                	beqz	a0,57a6 <drivetests+0x5a>
        if(continuous != 2) {
    57f2:	fb498ae3          	beq	s3,s4,57a6 <drivetests+0x5a>
          return 1;
    57f6:	4505                	li	a0,1
    57f8:	a839                	j	5816 <drivetests+0xca>
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    57fa:	8626                	mv	a2,s1
    57fc:	85aa                	mv	a1,a0
    57fe:	8566                	mv	a0,s9
    5800:	00000097          	auipc	ra,0x0
    5804:	71e080e7          	jalr	1822(ra) # 5f1e <printf>
      if(continuous != 2) {
    5808:	fb4987e3          	beq	s3,s4,57b6 <drivetests+0x6a>
        return 1;
    580c:	4505                	li	a0,1
    580e:	a021                	j	5816 <drivetests+0xca>
        return 1;
    5810:	4505                	li	a0,1
    5812:	a011                	j	5816 <drivetests+0xca>
  return 0;
    5814:	854e                	mv	a0,s3
}
    5816:	60e6                	ld	ra,88(sp)
    5818:	6446                	ld	s0,80(sp)
    581a:	64a6                	ld	s1,72(sp)
    581c:	6906                	ld	s2,64(sp)
    581e:	79e2                	ld	s3,56(sp)
    5820:	7a42                	ld	s4,48(sp)
    5822:	7aa2                	ld	s5,40(sp)
    5824:	7b02                	ld	s6,32(sp)
    5826:	6be2                	ld	s7,24(sp)
    5828:	6c42                	ld	s8,16(sp)
    582a:	6ca2                	ld	s9,8(sp)
    582c:	6d02                	ld	s10,0(sp)
    582e:	6125                	add	sp,sp,96
    5830:	8082                	ret

0000000000005832 <main>:

int
main(int argc, char *argv[])
{
    5832:	1101                	add	sp,sp,-32
    5834:	ec06                	sd	ra,24(sp)
    5836:	e822                	sd	s0,16(sp)
    5838:	e426                	sd	s1,8(sp)
    583a:	e04a                	sd	s2,0(sp)
    583c:	1000                	add	s0,sp,32
    583e:	84aa                	mv	s1,a0
  int continuous = 0;
  int quick = 0;
  char *justone = 0;

  if(argc == 2 && strcmp(argv[1], "-q") == 0){
    5840:	4789                	li	a5,2
    5842:	02f50263          	beq	a0,a5,5866 <main+0x34>
    continuous = 1;
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    continuous = 2;
  } else if(argc == 2 && argv[1][0] != '-'){
    justone = argv[1];
  } else if(argc > 1){
    5846:	4785                	li	a5,1
    5848:	08a7c063          	blt	a5,a0,58c8 <main+0x96>
  char *justone = 0;
    584c:	4601                	li	a2,0
  int quick = 0;
    584e:	4501                	li	a0,0
  int continuous = 0;
    5850:	4581                	li	a1,0
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    exit(1);
  }
  if (drivetests(quick, continuous, justone)) {
    5852:	00000097          	auipc	ra,0x0
    5856:	efa080e7          	jalr	-262(ra) # 574c <drivetests>
    585a:	c951                	beqz	a0,58ee <main+0xbc>
    exit(1);
    585c:	4505                	li	a0,1
    585e:	00000097          	auipc	ra,0x0
    5862:	330080e7          	jalr	816(ra) # 5b8e <exit>
    5866:	892e                	mv	s2,a1
  if(argc == 2 && strcmp(argv[1], "-q") == 0){
    5868:	00003597          	auipc	a1,0x3
    586c:	91058593          	add	a1,a1,-1776 # 8178 <malloc+0x21a2>
    5870:	00893503          	ld	a0,8(s2)
    5874:	00000097          	auipc	ra,0x0
    5878:	0ca080e7          	jalr	202(ra) # 593e <strcmp>
    587c:	85aa                	mv	a1,a0
    587e:	e501                	bnez	a0,5886 <main+0x54>
  char *justone = 0;
    5880:	4601                	li	a2,0
    quick = 1;
    5882:	4505                	li	a0,1
    5884:	b7f9                	j	5852 <main+0x20>
  } else if(argc == 2 && strcmp(argv[1], "-c") == 0){
    5886:	00003597          	auipc	a1,0x3
    588a:	8fa58593          	add	a1,a1,-1798 # 8180 <malloc+0x21aa>
    588e:	00893503          	ld	a0,8(s2)
    5892:	00000097          	auipc	ra,0x0
    5896:	0ac080e7          	jalr	172(ra) # 593e <strcmp>
    589a:	c521                	beqz	a0,58e2 <main+0xb0>
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    589c:	00003597          	auipc	a1,0x3
    58a0:	93458593          	add	a1,a1,-1740 # 81d0 <malloc+0x21fa>
    58a4:	00893503          	ld	a0,8(s2)
    58a8:	00000097          	auipc	ra,0x0
    58ac:	096080e7          	jalr	150(ra) # 593e <strcmp>
    58b0:	cd05                	beqz	a0,58e8 <main+0xb6>
  } else if(argc == 2 && argv[1][0] != '-'){
    58b2:	00893603          	ld	a2,8(s2)
    58b6:	00064703          	lbu	a4,0(a2) # 3000 <fourteen+0x13a>
    58ba:	02d00793          	li	a5,45
    58be:	00f70563          	beq	a4,a5,58c8 <main+0x96>
  int quick = 0;
    58c2:	4501                	li	a0,0
  int continuous = 0;
    58c4:	4581                	li	a1,0
    58c6:	b771                	j	5852 <main+0x20>
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    58c8:	00003517          	auipc	a0,0x3
    58cc:	8c050513          	add	a0,a0,-1856 # 8188 <malloc+0x21b2>
    58d0:	00000097          	auipc	ra,0x0
    58d4:	64e080e7          	jalr	1614(ra) # 5f1e <printf>
    exit(1);
    58d8:	4505                	li	a0,1
    58da:	00000097          	auipc	ra,0x0
    58de:	2b4080e7          	jalr	692(ra) # 5b8e <exit>
  char *justone = 0;
    58e2:	4601                	li	a2,0
    continuous = 1;
    58e4:	4585                	li	a1,1
    58e6:	b7b5                	j	5852 <main+0x20>
    continuous = 2;
    58e8:	85a6                	mv	a1,s1
  char *justone = 0;
    58ea:	4601                	li	a2,0
    58ec:	b79d                	j	5852 <main+0x20>
  }
  printf("ALL TESTS PASSED\n");
    58ee:	00003517          	auipc	a0,0x3
    58f2:	8ca50513          	add	a0,a0,-1846 # 81b8 <malloc+0x21e2>
    58f6:	00000097          	auipc	ra,0x0
    58fa:	628080e7          	jalr	1576(ra) # 5f1e <printf>
  exit(0);
    58fe:	4501                	li	a0,0
    5900:	00000097          	auipc	ra,0x0
    5904:	28e080e7          	jalr	654(ra) # 5b8e <exit>

0000000000005908 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
    5908:	1141                	add	sp,sp,-16
    590a:	e406                	sd	ra,8(sp)
    590c:	e022                	sd	s0,0(sp)
    590e:	0800                	add	s0,sp,16
  extern int main();
  main();
    5910:	00000097          	auipc	ra,0x0
    5914:	f22080e7          	jalr	-222(ra) # 5832 <main>
  exit(0);
    5918:	4501                	li	a0,0
    591a:	00000097          	auipc	ra,0x0
    591e:	274080e7          	jalr	628(ra) # 5b8e <exit>

0000000000005922 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
    5922:	1141                	add	sp,sp,-16
    5924:	e422                	sd	s0,8(sp)
    5926:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    5928:	87aa                	mv	a5,a0
    592a:	0585                	add	a1,a1,1
    592c:	0785                	add	a5,a5,1
    592e:	fff5c703          	lbu	a4,-1(a1)
    5932:	fee78fa3          	sb	a4,-1(a5)
    5936:	fb75                	bnez	a4,592a <strcpy+0x8>
    ;
  return os;
}
    5938:	6422                	ld	s0,8(sp)
    593a:	0141                	add	sp,sp,16
    593c:	8082                	ret

000000000000593e <strcmp>:

int
strcmp(const char *p, const char *q)
{
    593e:	1141                	add	sp,sp,-16
    5940:	e422                	sd	s0,8(sp)
    5942:	0800                	add	s0,sp,16
  while(*p && *p == *q)
    5944:	00054783          	lbu	a5,0(a0)
    5948:	cb91                	beqz	a5,595c <strcmp+0x1e>
    594a:	0005c703          	lbu	a4,0(a1)
    594e:	00f71763          	bne	a4,a5,595c <strcmp+0x1e>
    p++, q++;
    5952:	0505                	add	a0,a0,1
    5954:	0585                	add	a1,a1,1
  while(*p && *p == *q)
    5956:	00054783          	lbu	a5,0(a0)
    595a:	fbe5                	bnez	a5,594a <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
    595c:	0005c503          	lbu	a0,0(a1)
}
    5960:	40a7853b          	subw	a0,a5,a0
    5964:	6422                	ld	s0,8(sp)
    5966:	0141                	add	sp,sp,16
    5968:	8082                	ret

000000000000596a <strlen>:

uint
strlen(const char *s)
{
    596a:	1141                	add	sp,sp,-16
    596c:	e422                	sd	s0,8(sp)
    596e:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    5970:	00054783          	lbu	a5,0(a0)
    5974:	cf91                	beqz	a5,5990 <strlen+0x26>
    5976:	0505                	add	a0,a0,1
    5978:	87aa                	mv	a5,a0
    597a:	86be                	mv	a3,a5
    597c:	0785                	add	a5,a5,1
    597e:	fff7c703          	lbu	a4,-1(a5)
    5982:	ff65                	bnez	a4,597a <strlen+0x10>
    5984:	40a6853b          	subw	a0,a3,a0
    5988:	2505                	addw	a0,a0,1
    ;
  return n;
}
    598a:	6422                	ld	s0,8(sp)
    598c:	0141                	add	sp,sp,16
    598e:	8082                	ret
  for(n = 0; s[n]; n++)
    5990:	4501                	li	a0,0
    5992:	bfe5                	j	598a <strlen+0x20>

0000000000005994 <memset>:

void*
memset(void *dst, int c, uint n)
{
    5994:	1141                	add	sp,sp,-16
    5996:	e422                	sd	s0,8(sp)
    5998:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    599a:	ca19                	beqz	a2,59b0 <memset+0x1c>
    599c:	87aa                	mv	a5,a0
    599e:	1602                	sll	a2,a2,0x20
    59a0:	9201                	srl	a2,a2,0x20
    59a2:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    59a6:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    59aa:	0785                	add	a5,a5,1
    59ac:	fee79de3          	bne	a5,a4,59a6 <memset+0x12>
  }
  return dst;
}
    59b0:	6422                	ld	s0,8(sp)
    59b2:	0141                	add	sp,sp,16
    59b4:	8082                	ret

00000000000059b6 <strchr>:

char*
strchr(const char *s, char c)
{
    59b6:	1141                	add	sp,sp,-16
    59b8:	e422                	sd	s0,8(sp)
    59ba:	0800                	add	s0,sp,16
  for(; *s; s++)
    59bc:	00054783          	lbu	a5,0(a0)
    59c0:	cb99                	beqz	a5,59d6 <strchr+0x20>
    if(*s == c)
    59c2:	00f58763          	beq	a1,a5,59d0 <strchr+0x1a>
  for(; *s; s++)
    59c6:	0505                	add	a0,a0,1
    59c8:	00054783          	lbu	a5,0(a0)
    59cc:	fbfd                	bnez	a5,59c2 <strchr+0xc>
      return (char*)s;
  return 0;
    59ce:	4501                	li	a0,0
}
    59d0:	6422                	ld	s0,8(sp)
    59d2:	0141                	add	sp,sp,16
    59d4:	8082                	ret
  return 0;
    59d6:	4501                	li	a0,0
    59d8:	bfe5                	j	59d0 <strchr+0x1a>

00000000000059da <gets>:

char*
gets(char *buf, int max)
{
    59da:	711d                	add	sp,sp,-96
    59dc:	ec86                	sd	ra,88(sp)
    59de:	e8a2                	sd	s0,80(sp)
    59e0:	e4a6                	sd	s1,72(sp)
    59e2:	e0ca                	sd	s2,64(sp)
    59e4:	fc4e                	sd	s3,56(sp)
    59e6:	f852                	sd	s4,48(sp)
    59e8:	f456                	sd	s5,40(sp)
    59ea:	f05a                	sd	s6,32(sp)
    59ec:	ec5e                	sd	s7,24(sp)
    59ee:	1080                	add	s0,sp,96
    59f0:	8baa                	mv	s7,a0
    59f2:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    59f4:	892a                	mv	s2,a0
    59f6:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    59f8:	4aa9                	li	s5,10
    59fa:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
    59fc:	89a6                	mv	s3,s1
    59fe:	2485                	addw	s1,s1,1
    5a00:	0344d863          	bge	s1,s4,5a30 <gets+0x56>
    cc = read(0, &c, 1);
    5a04:	4605                	li	a2,1
    5a06:	faf40593          	add	a1,s0,-81
    5a0a:	4501                	li	a0,0
    5a0c:	00000097          	auipc	ra,0x0
    5a10:	19a080e7          	jalr	410(ra) # 5ba6 <read>
    if(cc < 1)
    5a14:	00a05e63          	blez	a0,5a30 <gets+0x56>
    buf[i++] = c;
    5a18:	faf44783          	lbu	a5,-81(s0)
    5a1c:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
    5a20:	01578763          	beq	a5,s5,5a2e <gets+0x54>
    5a24:	0905                	add	s2,s2,1
    5a26:	fd679be3          	bne	a5,s6,59fc <gets+0x22>
  for(i=0; i+1 < max; ){
    5a2a:	89a6                	mv	s3,s1
    5a2c:	a011                	j	5a30 <gets+0x56>
    5a2e:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
    5a30:	99de                	add	s3,s3,s7
    5a32:	00098023          	sb	zero,0(s3)
  return buf;
}
    5a36:	855e                	mv	a0,s7
    5a38:	60e6                	ld	ra,88(sp)
    5a3a:	6446                	ld	s0,80(sp)
    5a3c:	64a6                	ld	s1,72(sp)
    5a3e:	6906                	ld	s2,64(sp)
    5a40:	79e2                	ld	s3,56(sp)
    5a42:	7a42                	ld	s4,48(sp)
    5a44:	7aa2                	ld	s5,40(sp)
    5a46:	7b02                	ld	s6,32(sp)
    5a48:	6be2                	ld	s7,24(sp)
    5a4a:	6125                	add	sp,sp,96
    5a4c:	8082                	ret

0000000000005a4e <stat>:

int
stat(const char *n, struct stat *st)
{
    5a4e:	1101                	add	sp,sp,-32
    5a50:	ec06                	sd	ra,24(sp)
    5a52:	e822                	sd	s0,16(sp)
    5a54:	e426                	sd	s1,8(sp)
    5a56:	e04a                	sd	s2,0(sp)
    5a58:	1000                	add	s0,sp,32
    5a5a:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    5a5c:	4581                	li	a1,0
    5a5e:	00000097          	auipc	ra,0x0
    5a62:	170080e7          	jalr	368(ra) # 5bce <open>
  if(fd < 0)
    5a66:	02054563          	bltz	a0,5a90 <stat+0x42>
    5a6a:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    5a6c:	85ca                	mv	a1,s2
    5a6e:	00000097          	auipc	ra,0x0
    5a72:	178080e7          	jalr	376(ra) # 5be6 <fstat>
    5a76:	892a                	mv	s2,a0
  close(fd);
    5a78:	8526                	mv	a0,s1
    5a7a:	00000097          	auipc	ra,0x0
    5a7e:	13c080e7          	jalr	316(ra) # 5bb6 <close>
  return r;
}
    5a82:	854a                	mv	a0,s2
    5a84:	60e2                	ld	ra,24(sp)
    5a86:	6442                	ld	s0,16(sp)
    5a88:	64a2                	ld	s1,8(sp)
    5a8a:	6902                	ld	s2,0(sp)
    5a8c:	6105                	add	sp,sp,32
    5a8e:	8082                	ret
    return -1;
    5a90:	597d                	li	s2,-1
    5a92:	bfc5                	j	5a82 <stat+0x34>

0000000000005a94 <atoi>:

int
atoi(const char *s)
{
    5a94:	1141                	add	sp,sp,-16
    5a96:	e422                	sd	s0,8(sp)
    5a98:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    5a9a:	00054683          	lbu	a3,0(a0)
    5a9e:	fd06879b          	addw	a5,a3,-48
    5aa2:	0ff7f793          	zext.b	a5,a5
    5aa6:	4625                	li	a2,9
    5aa8:	02f66863          	bltu	a2,a5,5ad8 <atoi+0x44>
    5aac:	872a                	mv	a4,a0
  n = 0;
    5aae:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
    5ab0:	0705                	add	a4,a4,1
    5ab2:	0025179b          	sllw	a5,a0,0x2
    5ab6:	9fa9                	addw	a5,a5,a0
    5ab8:	0017979b          	sllw	a5,a5,0x1
    5abc:	9fb5                	addw	a5,a5,a3
    5abe:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    5ac2:	00074683          	lbu	a3,0(a4)
    5ac6:	fd06879b          	addw	a5,a3,-48
    5aca:	0ff7f793          	zext.b	a5,a5
    5ace:	fef671e3          	bgeu	a2,a5,5ab0 <atoi+0x1c>
  return n;
}
    5ad2:	6422                	ld	s0,8(sp)
    5ad4:	0141                	add	sp,sp,16
    5ad6:	8082                	ret
  n = 0;
    5ad8:	4501                	li	a0,0
    5ada:	bfe5                	j	5ad2 <atoi+0x3e>

0000000000005adc <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    5adc:	1141                	add	sp,sp,-16
    5ade:	e422                	sd	s0,8(sp)
    5ae0:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    5ae2:	02b57463          	bgeu	a0,a1,5b0a <memmove+0x2e>
    while(n-- > 0)
    5ae6:	00c05f63          	blez	a2,5b04 <memmove+0x28>
    5aea:	1602                	sll	a2,a2,0x20
    5aec:	9201                	srl	a2,a2,0x20
    5aee:	00c507b3          	add	a5,a0,a2
  dst = vdst;
    5af2:	872a                	mv	a4,a0
      *dst++ = *src++;
    5af4:	0585                	add	a1,a1,1
    5af6:	0705                	add	a4,a4,1
    5af8:	fff5c683          	lbu	a3,-1(a1)
    5afc:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    5b00:	fee79ae3          	bne	a5,a4,5af4 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
    5b04:	6422                	ld	s0,8(sp)
    5b06:	0141                	add	sp,sp,16
    5b08:	8082                	ret
    dst += n;
    5b0a:	00c50733          	add	a4,a0,a2
    src += n;
    5b0e:	95b2                	add	a1,a1,a2
    while(n-- > 0)
    5b10:	fec05ae3          	blez	a2,5b04 <memmove+0x28>
    5b14:	fff6079b          	addw	a5,a2,-1
    5b18:	1782                	sll	a5,a5,0x20
    5b1a:	9381                	srl	a5,a5,0x20
    5b1c:	fff7c793          	not	a5,a5
    5b20:	97ba                	add	a5,a5,a4
      *--dst = *--src;
    5b22:	15fd                	add	a1,a1,-1
    5b24:	177d                	add	a4,a4,-1
    5b26:	0005c683          	lbu	a3,0(a1)
    5b2a:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    5b2e:	fee79ae3          	bne	a5,a4,5b22 <memmove+0x46>
    5b32:	bfc9                	j	5b04 <memmove+0x28>

0000000000005b34 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
    5b34:	1141                	add	sp,sp,-16
    5b36:	e422                	sd	s0,8(sp)
    5b38:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    5b3a:	ca05                	beqz	a2,5b6a <memcmp+0x36>
    5b3c:	fff6069b          	addw	a3,a2,-1
    5b40:	1682                	sll	a3,a3,0x20
    5b42:	9281                	srl	a3,a3,0x20
    5b44:	0685                	add	a3,a3,1
    5b46:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
    5b48:	00054783          	lbu	a5,0(a0)
    5b4c:	0005c703          	lbu	a4,0(a1)
    5b50:	00e79863          	bne	a5,a4,5b60 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
    5b54:	0505                	add	a0,a0,1
    p2++;
    5b56:	0585                	add	a1,a1,1
  while (n-- > 0) {
    5b58:	fed518e3          	bne	a0,a3,5b48 <memcmp+0x14>
  }
  return 0;
    5b5c:	4501                	li	a0,0
    5b5e:	a019                	j	5b64 <memcmp+0x30>
      return *p1 - *p2;
    5b60:	40e7853b          	subw	a0,a5,a4
}
    5b64:	6422                	ld	s0,8(sp)
    5b66:	0141                	add	sp,sp,16
    5b68:	8082                	ret
  return 0;
    5b6a:	4501                	li	a0,0
    5b6c:	bfe5                	j	5b64 <memcmp+0x30>

0000000000005b6e <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    5b6e:	1141                	add	sp,sp,-16
    5b70:	e406                	sd	ra,8(sp)
    5b72:	e022                	sd	s0,0(sp)
    5b74:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
    5b76:	00000097          	auipc	ra,0x0
    5b7a:	f66080e7          	jalr	-154(ra) # 5adc <memmove>
}
    5b7e:	60a2                	ld	ra,8(sp)
    5b80:	6402                	ld	s0,0(sp)
    5b82:	0141                	add	sp,sp,16
    5b84:	8082                	ret

0000000000005b86 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    5b86:	4885                	li	a7,1
 ecall
    5b88:	00000073          	ecall
 ret
    5b8c:	8082                	ret

0000000000005b8e <exit>:
.global exit
exit:
 li a7, SYS_exit
    5b8e:	4889                	li	a7,2
 ecall
    5b90:	00000073          	ecall
 ret
    5b94:	8082                	ret

0000000000005b96 <wait>:
.global wait
wait:
 li a7, SYS_wait
    5b96:	488d                	li	a7,3
 ecall
    5b98:	00000073          	ecall
 ret
    5b9c:	8082                	ret

0000000000005b9e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    5b9e:	4891                	li	a7,4
 ecall
    5ba0:	00000073          	ecall
 ret
    5ba4:	8082                	ret

0000000000005ba6 <read>:
.global read
read:
 li a7, SYS_read
    5ba6:	4895                	li	a7,5
 ecall
    5ba8:	00000073          	ecall
 ret
    5bac:	8082                	ret

0000000000005bae <write>:
.global write
write:
 li a7, SYS_write
    5bae:	48c1                	li	a7,16
 ecall
    5bb0:	00000073          	ecall
 ret
    5bb4:	8082                	ret

0000000000005bb6 <close>:
.global close
close:
 li a7, SYS_close
    5bb6:	48d5                	li	a7,21
 ecall
    5bb8:	00000073          	ecall
 ret
    5bbc:	8082                	ret

0000000000005bbe <kill>:
.global kill
kill:
 li a7, SYS_kill
    5bbe:	4899                	li	a7,6
 ecall
    5bc0:	00000073          	ecall
 ret
    5bc4:	8082                	ret

0000000000005bc6 <exec>:
.global exec
exec:
 li a7, SYS_exec
    5bc6:	489d                	li	a7,7
 ecall
    5bc8:	00000073          	ecall
 ret
    5bcc:	8082                	ret

0000000000005bce <open>:
.global open
open:
 li a7, SYS_open
    5bce:	48bd                	li	a7,15
 ecall
    5bd0:	00000073          	ecall
 ret
    5bd4:	8082                	ret

0000000000005bd6 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    5bd6:	48c5                	li	a7,17
 ecall
    5bd8:	00000073          	ecall
 ret
    5bdc:	8082                	ret

0000000000005bde <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    5bde:	48c9                	li	a7,18
 ecall
    5be0:	00000073          	ecall
 ret
    5be4:	8082                	ret

0000000000005be6 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    5be6:	48a1                	li	a7,8
 ecall
    5be8:	00000073          	ecall
 ret
    5bec:	8082                	ret

0000000000005bee <link>:
.global link
link:
 li a7, SYS_link
    5bee:	48cd                	li	a7,19
 ecall
    5bf0:	00000073          	ecall
 ret
    5bf4:	8082                	ret

0000000000005bf6 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    5bf6:	48d1                	li	a7,20
 ecall
    5bf8:	00000073          	ecall
 ret
    5bfc:	8082                	ret

0000000000005bfe <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    5bfe:	48a5                	li	a7,9
 ecall
    5c00:	00000073          	ecall
 ret
    5c04:	8082                	ret

0000000000005c06 <dup>:
.global dup
dup:
 li a7, SYS_dup
    5c06:	48a9                	li	a7,10
 ecall
    5c08:	00000073          	ecall
 ret
    5c0c:	8082                	ret

0000000000005c0e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    5c0e:	48ad                	li	a7,11
 ecall
    5c10:	00000073          	ecall
 ret
    5c14:	8082                	ret

0000000000005c16 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    5c16:	48b1                	li	a7,12
 ecall
    5c18:	00000073          	ecall
 ret
    5c1c:	8082                	ret

0000000000005c1e <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    5c1e:	48b5                	li	a7,13
 ecall
    5c20:	00000073          	ecall
 ret
    5c24:	8082                	ret

0000000000005c26 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    5c26:	48b9                	li	a7,14
 ecall
    5c28:	00000073          	ecall
 ret
    5c2c:	8082                	ret

0000000000005c2e <waitx>:
.global waitx
waitx:
 li a7, SYS_waitx
    5c2e:	48d9                	li	a7,22
 ecall
    5c30:	00000073          	ecall
 ret
    5c34:	8082                	ret

0000000000005c36 <getreadcount>:
.global getreadcount
getreadcount:
 li a7, SYS_getreadcount
    5c36:	48dd                	li	a7,23
 ecall
    5c38:	00000073          	ecall
 ret
    5c3c:	8082                	ret

0000000000005c3e <sigalarm>:
.global sigalarm
sigalarm:
 li a7, SYS_sigalarm
    5c3e:	48e1                	li	a7,24
 ecall
    5c40:	00000073          	ecall
 ret
    5c44:	8082                	ret

0000000000005c46 <sigreturn>:
.global sigreturn
sigreturn:
 li a7, SYS_sigreturn
    5c46:	48e5                	li	a7,25
 ecall
    5c48:	00000073          	ecall
 ret
    5c4c:	8082                	ret

0000000000005c4e <set_priority>:
.global set_priority
set_priority:
 li a7, SYS_set_priority
    5c4e:	48e9                	li	a7,26
 ecall
    5c50:	00000073          	ecall
 ret
    5c54:	8082                	ret

0000000000005c56 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    5c56:	1101                	add	sp,sp,-32
    5c58:	ec06                	sd	ra,24(sp)
    5c5a:	e822                	sd	s0,16(sp)
    5c5c:	1000                	add	s0,sp,32
    5c5e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    5c62:	4605                	li	a2,1
    5c64:	fef40593          	add	a1,s0,-17
    5c68:	00000097          	auipc	ra,0x0
    5c6c:	f46080e7          	jalr	-186(ra) # 5bae <write>
}
    5c70:	60e2                	ld	ra,24(sp)
    5c72:	6442                	ld	s0,16(sp)
    5c74:	6105                	add	sp,sp,32
    5c76:	8082                	ret

0000000000005c78 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    5c78:	7139                	add	sp,sp,-64
    5c7a:	fc06                	sd	ra,56(sp)
    5c7c:	f822                	sd	s0,48(sp)
    5c7e:	f426                	sd	s1,40(sp)
    5c80:	f04a                	sd	s2,32(sp)
    5c82:	ec4e                	sd	s3,24(sp)
    5c84:	0080                	add	s0,sp,64
    5c86:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    5c88:	c299                	beqz	a3,5c8e <printint+0x16>
    5c8a:	0805c963          	bltz	a1,5d1c <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    5c8e:	2581                	sext.w	a1,a1
  neg = 0;
    5c90:	4881                	li	a7,0
    5c92:	fc040693          	add	a3,s0,-64
  }

  i = 0;
    5c96:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    5c98:	2601                	sext.w	a2,a2
    5c9a:	00003517          	auipc	a0,0x3
    5c9e:	8fe50513          	add	a0,a0,-1794 # 8598 <digits>
    5ca2:	883a                	mv	a6,a4
    5ca4:	2705                	addw	a4,a4,1
    5ca6:	02c5f7bb          	remuw	a5,a1,a2
    5caa:	1782                	sll	a5,a5,0x20
    5cac:	9381                	srl	a5,a5,0x20
    5cae:	97aa                	add	a5,a5,a0
    5cb0:	0007c783          	lbu	a5,0(a5)
    5cb4:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    5cb8:	0005879b          	sext.w	a5,a1
    5cbc:	02c5d5bb          	divuw	a1,a1,a2
    5cc0:	0685                	add	a3,a3,1
    5cc2:	fec7f0e3          	bgeu	a5,a2,5ca2 <printint+0x2a>
  if(neg)
    5cc6:	00088c63          	beqz	a7,5cde <printint+0x66>
    buf[i++] = '-';
    5cca:	fd070793          	add	a5,a4,-48
    5cce:	00878733          	add	a4,a5,s0
    5cd2:	02d00793          	li	a5,45
    5cd6:	fef70823          	sb	a5,-16(a4)
    5cda:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
    5cde:	02e05863          	blez	a4,5d0e <printint+0x96>
    5ce2:	fc040793          	add	a5,s0,-64
    5ce6:	00e78933          	add	s2,a5,a4
    5cea:	fff78993          	add	s3,a5,-1
    5cee:	99ba                	add	s3,s3,a4
    5cf0:	377d                	addw	a4,a4,-1
    5cf2:	1702                	sll	a4,a4,0x20
    5cf4:	9301                	srl	a4,a4,0x20
    5cf6:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    5cfa:	fff94583          	lbu	a1,-1(s2)
    5cfe:	8526                	mv	a0,s1
    5d00:	00000097          	auipc	ra,0x0
    5d04:	f56080e7          	jalr	-170(ra) # 5c56 <putc>
  while(--i >= 0)
    5d08:	197d                	add	s2,s2,-1
    5d0a:	ff3918e3          	bne	s2,s3,5cfa <printint+0x82>
}
    5d0e:	70e2                	ld	ra,56(sp)
    5d10:	7442                	ld	s0,48(sp)
    5d12:	74a2                	ld	s1,40(sp)
    5d14:	7902                	ld	s2,32(sp)
    5d16:	69e2                	ld	s3,24(sp)
    5d18:	6121                	add	sp,sp,64
    5d1a:	8082                	ret
    x = -xx;
    5d1c:	40b005bb          	negw	a1,a1
    neg = 1;
    5d20:	4885                	li	a7,1
    x = -xx;
    5d22:	bf85                	j	5c92 <printint+0x1a>

0000000000005d24 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    5d24:	715d                	add	sp,sp,-80
    5d26:	e486                	sd	ra,72(sp)
    5d28:	e0a2                	sd	s0,64(sp)
    5d2a:	fc26                	sd	s1,56(sp)
    5d2c:	f84a                	sd	s2,48(sp)
    5d2e:	f44e                	sd	s3,40(sp)
    5d30:	f052                	sd	s4,32(sp)
    5d32:	ec56                	sd	s5,24(sp)
    5d34:	e85a                	sd	s6,16(sp)
    5d36:	e45e                	sd	s7,8(sp)
    5d38:	e062                	sd	s8,0(sp)
    5d3a:	0880                	add	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    5d3c:	0005c903          	lbu	s2,0(a1)
    5d40:	18090c63          	beqz	s2,5ed8 <vprintf+0x1b4>
    5d44:	8aaa                	mv	s5,a0
    5d46:	8bb2                	mv	s7,a2
    5d48:	00158493          	add	s1,a1,1
  state = 0;
    5d4c:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    5d4e:	02500a13          	li	s4,37
    5d52:	4b55                	li	s6,21
    5d54:	a839                	j	5d72 <vprintf+0x4e>
        putc(fd, c);
    5d56:	85ca                	mv	a1,s2
    5d58:	8556                	mv	a0,s5
    5d5a:	00000097          	auipc	ra,0x0
    5d5e:	efc080e7          	jalr	-260(ra) # 5c56 <putc>
    5d62:	a019                	j	5d68 <vprintf+0x44>
    } else if(state == '%'){
    5d64:	01498d63          	beq	s3,s4,5d7e <vprintf+0x5a>
  for(i = 0; fmt[i]; i++){
    5d68:	0485                	add	s1,s1,1
    5d6a:	fff4c903          	lbu	s2,-1(s1)
    5d6e:	16090563          	beqz	s2,5ed8 <vprintf+0x1b4>
    if(state == 0){
    5d72:	fe0999e3          	bnez	s3,5d64 <vprintf+0x40>
      if(c == '%'){
    5d76:	ff4910e3          	bne	s2,s4,5d56 <vprintf+0x32>
        state = '%';
    5d7a:	89d2                	mv	s3,s4
    5d7c:	b7f5                	j	5d68 <vprintf+0x44>
      if(c == 'd'){
    5d7e:	13490263          	beq	s2,s4,5ea2 <vprintf+0x17e>
    5d82:	f9d9079b          	addw	a5,s2,-99
    5d86:	0ff7f793          	zext.b	a5,a5
    5d8a:	12fb6563          	bltu	s6,a5,5eb4 <vprintf+0x190>
    5d8e:	f9d9079b          	addw	a5,s2,-99
    5d92:	0ff7f713          	zext.b	a4,a5
    5d96:	10eb6f63          	bltu	s6,a4,5eb4 <vprintf+0x190>
    5d9a:	00271793          	sll	a5,a4,0x2
    5d9e:	00002717          	auipc	a4,0x2
    5da2:	7a270713          	add	a4,a4,1954 # 8540 <malloc+0x256a>
    5da6:	97ba                	add	a5,a5,a4
    5da8:	439c                	lw	a5,0(a5)
    5daa:	97ba                	add	a5,a5,a4
    5dac:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
    5dae:	008b8913          	add	s2,s7,8
    5db2:	4685                	li	a3,1
    5db4:	4629                	li	a2,10
    5db6:	000ba583          	lw	a1,0(s7)
    5dba:	8556                	mv	a0,s5
    5dbc:	00000097          	auipc	ra,0x0
    5dc0:	ebc080e7          	jalr	-324(ra) # 5c78 <printint>
    5dc4:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    5dc6:	4981                	li	s3,0
    5dc8:	b745                	j	5d68 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
    5dca:	008b8913          	add	s2,s7,8
    5dce:	4681                	li	a3,0
    5dd0:	4629                	li	a2,10
    5dd2:	000ba583          	lw	a1,0(s7)
    5dd6:	8556                	mv	a0,s5
    5dd8:	00000097          	auipc	ra,0x0
    5ddc:	ea0080e7          	jalr	-352(ra) # 5c78 <printint>
    5de0:	8bca                	mv	s7,s2
      state = 0;
    5de2:	4981                	li	s3,0
    5de4:	b751                	j	5d68 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 16, 0);
    5de6:	008b8913          	add	s2,s7,8
    5dea:	4681                	li	a3,0
    5dec:	4641                	li	a2,16
    5dee:	000ba583          	lw	a1,0(s7)
    5df2:	8556                	mv	a0,s5
    5df4:	00000097          	auipc	ra,0x0
    5df8:	e84080e7          	jalr	-380(ra) # 5c78 <printint>
    5dfc:	8bca                	mv	s7,s2
      state = 0;
    5dfe:	4981                	li	s3,0
    5e00:	b7a5                	j	5d68 <vprintf+0x44>
        printptr(fd, va_arg(ap, uint64));
    5e02:	008b8c13          	add	s8,s7,8
    5e06:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
    5e0a:	03000593          	li	a1,48
    5e0e:	8556                	mv	a0,s5
    5e10:	00000097          	auipc	ra,0x0
    5e14:	e46080e7          	jalr	-442(ra) # 5c56 <putc>
  putc(fd, 'x');
    5e18:	07800593          	li	a1,120
    5e1c:	8556                	mv	a0,s5
    5e1e:	00000097          	auipc	ra,0x0
    5e22:	e38080e7          	jalr	-456(ra) # 5c56 <putc>
    5e26:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    5e28:	00002b97          	auipc	s7,0x2
    5e2c:	770b8b93          	add	s7,s7,1904 # 8598 <digits>
    5e30:	03c9d793          	srl	a5,s3,0x3c
    5e34:	97de                	add	a5,a5,s7
    5e36:	0007c583          	lbu	a1,0(a5)
    5e3a:	8556                	mv	a0,s5
    5e3c:	00000097          	auipc	ra,0x0
    5e40:	e1a080e7          	jalr	-486(ra) # 5c56 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    5e44:	0992                	sll	s3,s3,0x4
    5e46:	397d                	addw	s2,s2,-1
    5e48:	fe0914e3          	bnez	s2,5e30 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
    5e4c:	8be2                	mv	s7,s8
      state = 0;
    5e4e:	4981                	li	s3,0
    5e50:	bf21                	j	5d68 <vprintf+0x44>
        s = va_arg(ap, char*);
    5e52:	008b8993          	add	s3,s7,8
    5e56:	000bb903          	ld	s2,0(s7)
        if(s == 0)
    5e5a:	02090163          	beqz	s2,5e7c <vprintf+0x158>
        while(*s != 0){
    5e5e:	00094583          	lbu	a1,0(s2)
    5e62:	c9a5                	beqz	a1,5ed2 <vprintf+0x1ae>
          putc(fd, *s);
    5e64:	8556                	mv	a0,s5
    5e66:	00000097          	auipc	ra,0x0
    5e6a:	df0080e7          	jalr	-528(ra) # 5c56 <putc>
          s++;
    5e6e:	0905                	add	s2,s2,1
        while(*s != 0){
    5e70:	00094583          	lbu	a1,0(s2)
    5e74:	f9e5                	bnez	a1,5e64 <vprintf+0x140>
        s = va_arg(ap, char*);
    5e76:	8bce                	mv	s7,s3
      state = 0;
    5e78:	4981                	li	s3,0
    5e7a:	b5fd                	j	5d68 <vprintf+0x44>
          s = "(null)";
    5e7c:	00002917          	auipc	s2,0x2
    5e80:	69c90913          	add	s2,s2,1692 # 8518 <malloc+0x2542>
        while(*s != 0){
    5e84:	02800593          	li	a1,40
    5e88:	bff1                	j	5e64 <vprintf+0x140>
        putc(fd, va_arg(ap, uint));
    5e8a:	008b8913          	add	s2,s7,8
    5e8e:	000bc583          	lbu	a1,0(s7)
    5e92:	8556                	mv	a0,s5
    5e94:	00000097          	auipc	ra,0x0
    5e98:	dc2080e7          	jalr	-574(ra) # 5c56 <putc>
    5e9c:	8bca                	mv	s7,s2
      state = 0;
    5e9e:	4981                	li	s3,0
    5ea0:	b5e1                	j	5d68 <vprintf+0x44>
        putc(fd, c);
    5ea2:	02500593          	li	a1,37
    5ea6:	8556                	mv	a0,s5
    5ea8:	00000097          	auipc	ra,0x0
    5eac:	dae080e7          	jalr	-594(ra) # 5c56 <putc>
      state = 0;
    5eb0:	4981                	li	s3,0
    5eb2:	bd5d                	j	5d68 <vprintf+0x44>
        putc(fd, '%');
    5eb4:	02500593          	li	a1,37
    5eb8:	8556                	mv	a0,s5
    5eba:	00000097          	auipc	ra,0x0
    5ebe:	d9c080e7          	jalr	-612(ra) # 5c56 <putc>
        putc(fd, c);
    5ec2:	85ca                	mv	a1,s2
    5ec4:	8556                	mv	a0,s5
    5ec6:	00000097          	auipc	ra,0x0
    5eca:	d90080e7          	jalr	-624(ra) # 5c56 <putc>
      state = 0;
    5ece:	4981                	li	s3,0
    5ed0:	bd61                	j	5d68 <vprintf+0x44>
        s = va_arg(ap, char*);
    5ed2:	8bce                	mv	s7,s3
      state = 0;
    5ed4:	4981                	li	s3,0
    5ed6:	bd49                	j	5d68 <vprintf+0x44>
    }
  }
}
    5ed8:	60a6                	ld	ra,72(sp)
    5eda:	6406                	ld	s0,64(sp)
    5edc:	74e2                	ld	s1,56(sp)
    5ede:	7942                	ld	s2,48(sp)
    5ee0:	79a2                	ld	s3,40(sp)
    5ee2:	7a02                	ld	s4,32(sp)
    5ee4:	6ae2                	ld	s5,24(sp)
    5ee6:	6b42                	ld	s6,16(sp)
    5ee8:	6ba2                	ld	s7,8(sp)
    5eea:	6c02                	ld	s8,0(sp)
    5eec:	6161                	add	sp,sp,80
    5eee:	8082                	ret

0000000000005ef0 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    5ef0:	715d                	add	sp,sp,-80
    5ef2:	ec06                	sd	ra,24(sp)
    5ef4:	e822                	sd	s0,16(sp)
    5ef6:	1000                	add	s0,sp,32
    5ef8:	e010                	sd	a2,0(s0)
    5efa:	e414                	sd	a3,8(s0)
    5efc:	e818                	sd	a4,16(s0)
    5efe:	ec1c                	sd	a5,24(s0)
    5f00:	03043023          	sd	a6,32(s0)
    5f04:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    5f08:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    5f0c:	8622                	mv	a2,s0
    5f0e:	00000097          	auipc	ra,0x0
    5f12:	e16080e7          	jalr	-490(ra) # 5d24 <vprintf>
}
    5f16:	60e2                	ld	ra,24(sp)
    5f18:	6442                	ld	s0,16(sp)
    5f1a:	6161                	add	sp,sp,80
    5f1c:	8082                	ret

0000000000005f1e <printf>:

void
printf(const char *fmt, ...)
{
    5f1e:	711d                	add	sp,sp,-96
    5f20:	ec06                	sd	ra,24(sp)
    5f22:	e822                	sd	s0,16(sp)
    5f24:	1000                	add	s0,sp,32
    5f26:	e40c                	sd	a1,8(s0)
    5f28:	e810                	sd	a2,16(s0)
    5f2a:	ec14                	sd	a3,24(s0)
    5f2c:	f018                	sd	a4,32(s0)
    5f2e:	f41c                	sd	a5,40(s0)
    5f30:	03043823          	sd	a6,48(s0)
    5f34:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    5f38:	00840613          	add	a2,s0,8
    5f3c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    5f40:	85aa                	mv	a1,a0
    5f42:	4505                	li	a0,1
    5f44:	00000097          	auipc	ra,0x0
    5f48:	de0080e7          	jalr	-544(ra) # 5d24 <vprintf>
}
    5f4c:	60e2                	ld	ra,24(sp)
    5f4e:	6442                	ld	s0,16(sp)
    5f50:	6125                	add	sp,sp,96
    5f52:	8082                	ret

0000000000005f54 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    5f54:	1141                	add	sp,sp,-16
    5f56:	e422                	sd	s0,8(sp)
    5f58:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    5f5a:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5f5e:	00003797          	auipc	a5,0x3
    5f62:	4e27b783          	ld	a5,1250(a5) # 9440 <freep>
    5f66:	a02d                	j	5f90 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    5f68:	4618                	lw	a4,8(a2)
    5f6a:	9f2d                	addw	a4,a4,a1
    5f6c:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    5f70:	6398                	ld	a4,0(a5)
    5f72:	6310                	ld	a2,0(a4)
    5f74:	a83d                	j	5fb2 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    5f76:	ff852703          	lw	a4,-8(a0)
    5f7a:	9f31                	addw	a4,a4,a2
    5f7c:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    5f7e:	ff053683          	ld	a3,-16(a0)
    5f82:	a091                	j	5fc6 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    5f84:	6398                	ld	a4,0(a5)
    5f86:	00e7e463          	bltu	a5,a4,5f8e <free+0x3a>
    5f8a:	00e6ea63          	bltu	a3,a4,5f9e <free+0x4a>
{
    5f8e:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5f90:	fed7fae3          	bgeu	a5,a3,5f84 <free+0x30>
    5f94:	6398                	ld	a4,0(a5)
    5f96:	00e6e463          	bltu	a3,a4,5f9e <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    5f9a:	fee7eae3          	bltu	a5,a4,5f8e <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
    5f9e:	ff852583          	lw	a1,-8(a0)
    5fa2:	6390                	ld	a2,0(a5)
    5fa4:	02059813          	sll	a6,a1,0x20
    5fa8:	01c85713          	srl	a4,a6,0x1c
    5fac:	9736                	add	a4,a4,a3
    5fae:	fae60de3          	beq	a2,a4,5f68 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
    5fb2:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    5fb6:	4790                	lw	a2,8(a5)
    5fb8:	02061593          	sll	a1,a2,0x20
    5fbc:	01c5d713          	srl	a4,a1,0x1c
    5fc0:	973e                	add	a4,a4,a5
    5fc2:	fae68ae3          	beq	a3,a4,5f76 <free+0x22>
    p->s.ptr = bp->s.ptr;
    5fc6:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    5fc8:	00003717          	auipc	a4,0x3
    5fcc:	46f73c23          	sd	a5,1144(a4) # 9440 <freep>
}
    5fd0:	6422                	ld	s0,8(sp)
    5fd2:	0141                	add	sp,sp,16
    5fd4:	8082                	ret

0000000000005fd6 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    5fd6:	7139                	add	sp,sp,-64
    5fd8:	fc06                	sd	ra,56(sp)
    5fda:	f822                	sd	s0,48(sp)
    5fdc:	f426                	sd	s1,40(sp)
    5fde:	f04a                	sd	s2,32(sp)
    5fe0:	ec4e                	sd	s3,24(sp)
    5fe2:	e852                	sd	s4,16(sp)
    5fe4:	e456                	sd	s5,8(sp)
    5fe6:	e05a                	sd	s6,0(sp)
    5fe8:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    5fea:	02051493          	sll	s1,a0,0x20
    5fee:	9081                	srl	s1,s1,0x20
    5ff0:	04bd                	add	s1,s1,15
    5ff2:	8091                	srl	s1,s1,0x4
    5ff4:	0014899b          	addw	s3,s1,1
    5ff8:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
    5ffa:	00003517          	auipc	a0,0x3
    5ffe:	44653503          	ld	a0,1094(a0) # 9440 <freep>
    6002:	c515                	beqz	a0,602e <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    6004:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    6006:	4798                	lw	a4,8(a5)
    6008:	02977f63          	bgeu	a4,s1,6046 <malloc+0x70>
  if(nu < 4096)
    600c:	8a4e                	mv	s4,s3
    600e:	0009871b          	sext.w	a4,s3
    6012:	6685                	lui	a3,0x1
    6014:	00d77363          	bgeu	a4,a3,601a <malloc+0x44>
    6018:	6a05                	lui	s4,0x1
    601a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    601e:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    6022:	00003917          	auipc	s2,0x3
    6026:	41e90913          	add	s2,s2,1054 # 9440 <freep>
  if(p == (char*)-1)
    602a:	5afd                	li	s5,-1
    602c:	a895                	j	60a0 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
    602e:	0000a797          	auipc	a5,0xa
    6032:	c3a78793          	add	a5,a5,-966 # fc68 <base>
    6036:	00003717          	auipc	a4,0x3
    603a:	40f73523          	sd	a5,1034(a4) # 9440 <freep>
    603e:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    6040:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    6044:	b7e1                	j	600c <malloc+0x36>
      if(p->s.size == nunits)
    6046:	02e48c63          	beq	s1,a4,607e <malloc+0xa8>
        p->s.size -= nunits;
    604a:	4137073b          	subw	a4,a4,s3
    604e:	c798                	sw	a4,8(a5)
        p += p->s.size;
    6050:	02071693          	sll	a3,a4,0x20
    6054:	01c6d713          	srl	a4,a3,0x1c
    6058:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    605a:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    605e:	00003717          	auipc	a4,0x3
    6062:	3ea73123          	sd	a0,994(a4) # 9440 <freep>
      return (void*)(p + 1);
    6066:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    606a:	70e2                	ld	ra,56(sp)
    606c:	7442                	ld	s0,48(sp)
    606e:	74a2                	ld	s1,40(sp)
    6070:	7902                	ld	s2,32(sp)
    6072:	69e2                	ld	s3,24(sp)
    6074:	6a42                	ld	s4,16(sp)
    6076:	6aa2                	ld	s5,8(sp)
    6078:	6b02                	ld	s6,0(sp)
    607a:	6121                	add	sp,sp,64
    607c:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    607e:	6398                	ld	a4,0(a5)
    6080:	e118                	sd	a4,0(a0)
    6082:	bff1                	j	605e <malloc+0x88>
  hp->s.size = nu;
    6084:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    6088:	0541                	add	a0,a0,16
    608a:	00000097          	auipc	ra,0x0
    608e:	eca080e7          	jalr	-310(ra) # 5f54 <free>
  return freep;
    6092:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    6096:	d971                	beqz	a0,606a <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    6098:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    609a:	4798                	lw	a4,8(a5)
    609c:	fa9775e3          	bgeu	a4,s1,6046 <malloc+0x70>
    if(p == freep)
    60a0:	00093703          	ld	a4,0(s2)
    60a4:	853e                	mv	a0,a5
    60a6:	fef719e3          	bne	a4,a5,6098 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
    60aa:	8552                	mv	a0,s4
    60ac:	00000097          	auipc	ra,0x0
    60b0:	b6a080e7          	jalr	-1174(ra) # 5c16 <sbrk>
  if(p == (char*)-1)
    60b4:	fd5518e3          	bne	a0,s5,6084 <malloc+0xae>
        return 0;
    60b8:	4501                	li	a0,0
    60ba:	bf45                	j	606a <malloc+0x94>
