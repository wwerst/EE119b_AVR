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

.ORG 0x1000;
jmptest1:
NOP;
JMP jmptest2;

.ORG 0x2000;
jmptestdone: NOP;


;PREPROCESS TestRJMP
; do same set of jumps
NOP;
RJMP rjmptest1;

.ORG 0x2010;
rjmptest2:
NOP;
RJMP rjmptestdone;

.ORG 0x2100;
rjmptest1:
NOP;
RJMP rjmptest2;

.ORG 0x2200;
rjmptestdone: NOP;

;PREPROCESS TestIJMP
; do more jumps
NOP;
LDI r31, HIGH($5000);
LDI r30, LOW($5000);
IJMP;

.ORG 0x4010;
NOP;
LDI r31, HIGH($6000);
LDI r30, LOW($6000);
IJMP;

.ORG 0x5000;
NOP;
LDI r31, HIGH($4010);
LDI r30, LOW($4010);
IJMP;

.ORG 0x6000;
NOP;

;PREPROCESS TestCALL
NOP;
CALL calltest1;

.ORG 0x6010;
calltest2:
NOP;
CALL calltestdone;

.ORG 0x7000;
calltest1:
NOP;
CALL calltest2;

.ORG 0x8000;
calltestdone: NOP;

;PREPROCESS TestRCALL
NOP;
RCALL rcalltest1;

.ORG 0x8010;
rcalltest2:
NOP;
RCALL rcalltestdone;

.ORG 0x8100;
rcalltest1:
NOP;
RCALL rcalltest2;

.ORG 0x8200;
rcalltestdone: NOP;

;PREPROCESS TestICALL
NOP;
LDI r31, HIGH($B000);
LDI r30, LOW($B000);
ICALL;

.ORG 0xA010;
NOP;
LDI r31, HIGH($C000);
LDI r30, LOW($C000);
ICALL;

.ORG 0xB000;
NOP;
LDI r31, HIGH($A010);
LDI r30, LOW($A010);
ICALL;

.ORG 0xC000;
NOP;

;PREPROCESS TestRET
NOP;
CALL rettest1;
JMP rettestdone;

.ORG 0xC010;
rettest2:
RET;

.ORG 0xD000;
rettest1:
NOP;
CALL rettest2;
RET;

.ORG 0xE000;
rettestdone: NOP;
;PREPROCESS TestRETI
NOP;
BCLR 7;
CALL retitest1;
BRBC 7, retitestfail1;
BCLR 7;
retitestfail1: JMP retitestdone;
JMP retitestdone;

.ORG 0xE010;
retitest2:
RETI;

.ORG 0xE1000;
retitest1:
NOP;
CALL retitest2;
BRBC 7, retitestfail2;
BCLR 7;
retitestfail2: JMP retitestdone;
RETI;

.ORG 0xE200;
retitestdone: NOP;

done:
    NOP;


