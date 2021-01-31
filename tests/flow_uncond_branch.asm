; Tests the flow control unconditional branch instructions


; Notes:
;


;PREPROCESS TestJMP
; do some jumping forward and backward
NOP;
JMP jmptest1;

.ORG 0x0010;
jmptest2:
NOP;
JMP jmptestdone;

.ORG 0x0020;
jmptest1:
NOP;
JMP jmptest2;

.ORG 0x0030;
jmptestdone: NOP;


;PREPROCESS TestRJMP
; do same set of jumps
NOP;
RJMP rjmptest1;

.ORG 0x0040;
rjmptest2:
NOP;
RJMP rjmptestdone;

.ORG 0x0050;
rjmptest1:
NOP;
RJMP rjmptest2;

.ORG 0x0060;
rjmptestdone: NOP;

;PREPROCESS TestIJMP
; do more jumps
NOP;
LDI r31, HIGH($0080);
LDI r30, LOW($0080);
IJMP;

.ORG 0x0070;
NOP;
LDI r31, HIGH($0090);
LDI r30, LOW($0090);
IJMP;

.ORG 0x0080;
NOP;
LDI r31, HIGH($0070);
LDI r30, LOW($0070);
IJMP;

.ORG 0x0090;
NOP;

;PREPROCESS TestCALL
NOP;
CALL calltest1;

.ORG 0x00A0;
calltest2:
NOP;
CALL calltestdone;

.ORG 0x00B0;
calltest1:
NOP;
CALL calltest2;

.ORG 0x00C0;
calltestdone: NOP;

;PREPROCESS TestRCALL
NOP;
RCALL rcalltest1;

.ORG 0x00D0;
rcalltest2:
NOP;
RCALL rcalltestdone;

.ORG 0x00E0;
rcalltest1:
NOP;
RCALL rcalltest2;

.ORG 0x00F0;
rcalltestdone: NOP;

;PREPROCESS TestICALL
NOP;
LDI r31, HIGH($0110);
LDI r30, LOW($0110);
ICALL;

.ORG 0x0100;
NOP;
LDI r31, HIGH($0120);
LDI r30, LOW($0120);
ICALL;

.ORG 0x0110;
NOP;
LDI r31, HIGH($0100);
LDI r30, LOW($0100);
ICALL;

.ORG 0x0120;
NOP;

;PREPROCESS TestRET
NOP;
CALL rettest1;
JMP rettestdone;

.ORG 0x0130;
rettest2:
RET;

.ORG 0x0140;
rettest1:
NOP;
CALL rettest2;
RET;

.ORG 0x0150;
rettestdone: NOP;
;PREPROCESS TestRETI
NOP;
BCLR 7;
CALL retitest1;
BRBC 7, retitestfail1;
BCLR 7;
JMP retitestdone;
retitestfail1: JMP retitestdone;


.ORG 0x0160;
retitest2:
; Second level call
RETI;

.ORG 0x0170;
retitest1:
; First level call
NOP;
CALL retitest2;
BRBC 7, retitestfail2;
BCLR 7;
RETI;
retitestfail2: JMP retitestdone;


.ORG 0x0180;
retitestdone: NOP;

done:
    NOP;


