
; Tests the flow control skip instructions and NOP



;PREPROCESS TestCPSE
    LDI     r31    ,$00     ;
    LDI     r30    ,$00     ;

; skip a LD (1 word) instruction
    LDS     r16    ,$0000   ;R 00 0000   set r16 to 0
    LDS     r26    ,$0000   ;R 00 0000   set r26 to 0
    CPSE    r16    ,r26     ;
    LD      r0     ,Z       ;S           0 == 0

; don't skip a LD instruction
    LDS     r7     ,$0000   ;R 00 0000   set r7 to 0
    LDS     r12    ,$0000   ;R CC 0000   set r12 to 204
    CPSE    r7     ,r12     ;
    LD      r0     ,Z       ;R 00 0000   0 != 204

; skip a STS (2 word) instruction
    LDS     r19    ,$0000   ;R 00 0000   set r19 to 0
    LDS     r31    ,$0000   ;R 00 0000   set r31 to 0
    CPSE    r19    ,r31     ;
    STS     $0000  ,r0      ;S           0 == 0

; don't skip a STS instruction
    LDS     r3     ,$0000   ;R 2A 0000   set r3 to 42
    LDS     r10    ,$0000   ;R FF 0000   set r10 to 255
    CPSE    r3     ,r10     ;
    STS     $0000  ,r0      ;W FF 0000   42 != 255


;PREPROCESS TestSBRC
    LDI     r31    ,$00     ;
    LDI     r30    ,$00     ;

; skip a LD (1 word) instruction
    LDS     r2     ,$0000   ;R F0 0000   set r2 to 240
    SBRC    r2     ,0       ;
    LD      r0     ,Z       ;S           bit 0 of 11110000 is clear

; don't skip a LD instruction
    LDS     r8     ,$0000   ;R 0F 0000   set r8 to 15
    SBRC    r8     ,3       ;
    LD      r0     ,Z       ;R 00 0000   bit 3 of 00001111 is set

; skip a STS (2 word) instruction
    LDS     r12    ,$0000   ;R F0 0000   set r12 to 240
    SBRC    r12    ,1       ;
    STS     $0000  ,r0      ;S           bit 1 of 11110000 is clear

; don't skip a STS instruction
    LDS     r24    ,$0000   ;R 0F 0000   set r24 to 15
    SBRC    r24    ,2       ;
    STS     $0000  ,r0      ;W FF 0000   bit 2 of 00001111 is set


;PREPROCESS TestSBRS
    LDI     r31    ,$00     ;
    LDI     r30    ,$00     ;

; skip a LD (1 word) instruction
    LDS     r5     ,$0000   ;R F0 0000   set r5 to 240
    SBRC    r5     ,4       ;
    LD      r0     ,Z       ;R 00 0000   bit 4 of 11110000 is set

; don't skip a LD instruction
    LDS     r28    ,$0000   ;R 0F 0000   set r28 to 15
    SBRC    r28    ,7       ;
    LD      r0     ,Z       ;S           bit 7 of 00001111 is clear

; skip a STS (2 word) instruction
    LDS     r8     ,$0000   ;R F0 0000   set r8 to 240
    SBRC    r8     ,5       ;
    STS     $0000  ,r0      ;W FF 0000   bit 5 of 11110000 is set

; don't skip a STS instruction
    LDS     r16    ,$0000   ;R 0F 0000   set r16 to 15
    SBRC    r16    ,6       ;
    STS     $0000  ,r0      ;S           bit 6 of 00001111 is clear


;PREPROCESS TestNOP

; set some random values in registers
    BCLR          0         ;
    BSET          1         ;
    BSET          2         ;
    BSET          3         ;
    BSET          4         ;
    BSET          5         ;
    BCLR          6         ;
    BCLR          7         ;
    LDS     r0     ,$0000   ;R 6B 0000   set r0 to 107
    LDS     r1     ,$0000   ;R 46 0000   set r1 to 70
    LDS     r2     ,$0000   ;R 59 0000   set r2 to 89
    LDS     r3     ,$0000   ;R E9 0000   set r3 to 233
    LDS     r4     ,$0000   ;R 37 0000   set r4 to 55
    LDS     r5     ,$0000   ;R 5C 0000   set r5 to 92
    LDS     r6     ,$0000   ;R 8C 0000   set r6 to 140
    LDS     r7     ,$0000   ;R 40 0000   set r7 to 64
    LDS     r8     ,$0000   ;R 5F 0000   set r8 to 95
    LDS     r9     ,$0000   ;R 9F 0000   set r9 to 159
    LDS     r10    ,$0000   ;R A3 0000   set r10 to 163
    LDS     r11    ,$0000   ;R 59 0000   set r11 to 89
    LDS     r12    ,$0000   ;R 03 0000   set r12 to 3
    LDS     r13    ,$0000   ;R B3 0000   set r13 to 179
    LDS     r14    ,$0000   ;R 26 0000   set r14 to 38
    LDS     r15    ,$0000   ;R 65 0000   set r15 to 101
    LDS     r16    ,$0000   ;R A4 0000   set r16 to 164
    LDS     r17    ,$0000   ;R CE 0000   set r17 to 206
    LDS     r18    ,$0000   ;R 66 0000   set r18 to 102
    LDS     r19    ,$0000   ;R F0 0000   set r19 to 240
    LDS     r20    ,$0000   ;R D6 0000   set r20 to 214
    LDS     r21    ,$0000   ;R 45 0000   set r21 to 69
    LDS     r22    ,$0000   ;R 1E 0000   set r22 to 30
    LDS     r23    ,$0000   ;R 0B 0000   set r23 to 11
    LDS     r24    ,$0000   ;R EE 0000   set r24 to 238
    LDS     r25    ,$0000   ;R 40 0000   set r25 to 64
    LDS     r26    ,$0000   ;R 90 0000   set r26 to 144
    LDS     r27    ,$0000   ;R D0 0000   set r27 to 208
    LDS     r28    ,$0000   ;R 11 0000   set r28 to 17
    LDS     r29    ,$0000   ;R 40 0000   set r29 to 64
    LDS     r30    ,$0000   ;R 45 0000   set r30 to 69
    LDS     r31    ,$0000   ;R CC 0000   set r31 to 204

; do a whole lot of nothing
    NOP                     ;
    NOP                     ;
    NOP                     ;

; check that indeed nothing happened
    STS     $0000  ,r0      ;W 6B 0000   r0 should be 107
    STS     $0000  ,r1      ;W 46 0000   r1 should be 70
    STS     $0000  ,r2      ;W 59 0000   r2 should be 89
    STS     $0000  ,r3      ;W E9 0000   r3 should be 233
    STS     $0000  ,r4      ;W 37 0000   r4 should be 55
    STS     $0000  ,r5      ;W 5C 0000   r5 should be 92
    STS     $0000  ,r6      ;W 8C 0000   r6 should be 140
    STS     $0000  ,r7      ;W 40 0000   r7 should be 64
    STS     $0000  ,r8      ;W 5F 0000   r8 should be 95
    STS     $0000  ,r9      ;W 9F 0000   r9 should be 159
    STS     $0000  ,r10     ;W A3 0000   r10 should be 163
    STS     $0000  ,r11     ;W 59 0000   r11 should be 89
    STS     $0000  ,r12     ;W 03 0000   r12 should be 3
    STS     $0000  ,r13     ;W B3 0000   r13 should be 179
    STS     $0000  ,r14     ;W 26 0000   r14 should be 38
    STS     $0000  ,r15     ;W 65 0000   r15 should be 101
    STS     $0000  ,r16     ;W A4 0000   r16 should be 164
    STS     $0000  ,r17     ;W CE 0000   r17 should be 206
    STS     $0000  ,r18     ;W 66 0000   r18 should be 102
    STS     $0000  ,r19     ;W F0 0000   r19 should be 240
    STS     $0000  ,r20     ;W D6 0000   r20 should be 214
    STS     $0000  ,r21     ;W 45 0000   r21 should be 69
    STS     $0000  ,r22     ;W 1E 0000   r22 should be 30
    STS     $0000  ,r23     ;W 0B 0000   r23 should be 11
    STS     $0000  ,r24     ;W EE 0000   r24 should be 238
    STS     $0000  ,r25     ;W 40 0000   r25 should be 64
    STS     $0000  ,r26     ;W 90 0000   r26 should be 144
    STS     $0000  ,r27     ;W D0 0000   r27 should be 208
    STS     $0000  ,r28     ;W 11 0000   r28 should be 17
    STS     $0000  ,r29     ;W 40 0000   r29 should be 64
    STS     $0000  ,r30     ;W 45 0000   r30 should be 69
    STS     $0000  ,r31     ;W CC 0000   r31 should be 204
    BRBS          0,done    ;            bit 0 of status should be clear
    BRBC          1,done    ;            bit 1 of status should be set
    BRBC          2,done    ;            bit 2 of status should be set
    BRBC          3,done    ;            bit 3 of status should be set
    BRBC          4,done    ;            bit 4 of status should be set
    BRBC          5,done    ;            bit 5 of status should be set
    BRBS          6,done    ;            bit 6 of status should be clear
    BRBS          7,done    ;            bit 7 of status should be clear
done:
    NOP                     ;