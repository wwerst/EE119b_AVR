; Tests the flow control unconditional branch instructions


; Notes:
; uses LDI (to test icall/ijmp), BCLR and BRBC (to test RETI)
;

; The following tests consist of blocks that execute in the following order:
; [1]
; [3]
; [2]
; [4]

;PREPROCESS TestJMP
    NOP;              [1]
    JMP jmptest1;

    .ORG 0x0010;      [3]
    jmptest2:
    NOP;
    JMP jmptestdone;

    .ORG 0x0020;      [2]
    jmptest1:
    NOP;
    JMP jmptest2;

    .ORG 0x0030;      [4]
    jmptestdone: NOP;


;PREPROCESS TestRJMP
    NOP;              [1]
    RJMP rjmptest1;

    .ORG 0x0040;      [3]
    rjmptest2:
    NOP;
    RJMP rjmptestdone;

    .ORG 0x0050;      [2]
    rjmptest1:
    NOP;
    RJMP rjmptest2;

    .ORG 0x0060;      [4]
    rjmptestdone: NOP;

;PREPROCESS TestIJMP
    NOP;              [1]
    LDI r31, HIGH($0080);
    LDI r30, LOW($0080);
    IJMP;

    .ORG 0x0070;      [3]
    NOP;
    LDI r31, HIGH($0090);
    LDI r30, LOW($0090);
    IJMP;

    .ORG 0x0080;      [2]
    NOP;
    LDI r31, HIGH($0070);
    LDI r30, LOW($0070);
    IJMP;

    .ORG 0x0090;      [4]
    NOP;

;PREPROCESS TestCALL
    NOP;              [1]
    CALL calltest1;

    .ORG 0x00A0;      [3]
    calltest2:
    NOP;
    CALL calltestdone;

    .ORG 0x00B0;      [2]
    calltest1:
    NOP;
    CALL calltest2;

    .ORG 0x00C0;      [4]
    calltestdone: NOP;

;PREPROCESS TestRCALL
    NOP;              [1]
    RCALL rcalltest1;

    .ORG 0x00D0;      [3]
    rcalltest2:
    NOP;
    RCALL rcalltestdone;

    .ORG 0x00E0;      [2]
    rcalltest1:
    NOP;
    RCALL rcalltest2;

    .ORG 0x00F0;      [4]
    rcalltestdone: NOP;

;PREPROCESS TestICALL
    NOP;              [1]
    LDI r31, HIGH($0110);
    LDI r30, LOW($0110);
    ICALL;

    .ORG 0x0100;      [3]
    NOP;
    LDI r31, HIGH($0120);
    LDI r30, LOW($0120);
    ICALL;

    .ORG 0x0110;      [2]
    NOP;
    LDI r31, HIGH($0100);
    LDI r30, LOW($0100);
    ICALL;

    .ORG 0x0120;      [4]
    NOP;

;PREPROCESS TestRET
    NOP;              [1]
    CALL rettest1;
    JMP rettestdone;

    .ORG 0x0130;      [3]
    rettest2:
    RET;

    .ORG 0x0140;      [2]
    rettest1:
    NOP;
    CALL rettest2;
    RET;

    .ORG 0x0150;      [4]
    rettestdone: NOP;


;PREPROCESS TestRETI
    NOP;              [1]
    BCLR 7;
    CALL retitest1;
    BRBC 7, retitestfail1; check that I flag was set by RETI
    BCLR 7;
    JMP retitestdone;
    retitestfail1: JMP retitestdone;

    .ORG 0x0160;      [3]
    retitest2:
    RETI;

    .ORG 0x0170;      [2]
    retitest1:
    NOP;
    CALL retitest2;
    BRBC 7, retitestfail2;
    BCLR 7;
    RETI;
    retitestfail2: JMP retitestdone;

    .ORG 0x0180;      [4]
    retitestdone: NOP;


done:
    NOP;
