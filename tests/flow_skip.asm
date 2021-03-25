
; Tests the flow control skip instructions and NOP
THIS FILE IS GENERATED
for explanations or modifications, see notebook flowskip.ipynb



;PREPROCESS TestCPSE
    LDI     r31    ,$00     ;
    LDI     r30    ,$00     ;

; skip a LD (1 word) instruction
    LDS     r26    ,$0000   ;R 00 0000   set r26 to 0
    LDS     r5     ,$0000   ;R 00 0000   set r5 to 0
    CPSE    r26    ,r5      ;
    LD      r0     ,Z       ;S           0 == 0

; don't skip a LD instruction
    LDS     r15    ,$0000   ;R 00 0000   set r15 to 0
    LDS     r6     ,$0000   ;R 64 0000   set r6 to 100
    CPSE    r15    ,r6      ;
    LD      r0     ,Z       ;R 00 0000   0 != 100

; skip a STS (2 word) instruction
    LDS     r16    ,$0000   ;R 00 0000   set r16 to 0
    LDS     r22    ,$0000   ;R 00 0000   set r22 to 0
    CPSE    r16    ,r22     ;
    STS     $0000  ,r0      ;S           0 == 0

; don't skip a STS instruction
    LDS     r22    ,$0000   ;R 82 0000   set r22 to 130
    LDS     r17    ,$0000   ;R FF 0000   set r17 to 255
    CPSE    r22    ,r17     ;
    STS     $0000  ,r0      ;W FF 0000   130 != 255


;PREPROCESS TestSBRC
    LDI     r31    ,$00     ;
    LDI     r30    ,$00     ;

; skip a LD (1 word) instruction
    LDS     r18    ,$0000   ;R F0 0000   set r18 to 240
    SBRC    r18    ,0       ;
    LD      r0     ,Z       ;S           bit 0 of 11110000 is clear

; don't skip a LD instruction
    LDS     r21    ,$0000   ;R 0F 0000   set r21 to 15
    SBRC    r21    ,3       ;
    LD      r0     ,Z       ;R 00 0000   bit 3 of 00001111 is set

; skip a STS (2 word) instruction
    LDS     r26    ,$0000   ;R F0 0000   set r26 to 240
    SBRC    r26    ,1       ;
    STS     $0000  ,r0      ;S           bit 1 of 11110000 is clear

; don't skip a STS instruction
    LDS     r3     ,$0000   ;R 0F 0000   set r3 to 15
    SBRC    r3     ,2       ;
    STS     $0000  ,r0      ;W FF 0000   bit 2 of 00001111 is set


;PREPROCESS TestSBRS
    LDI     r31    ,$00     ;
    LDI     r30    ,$00     ;

; don't skip a LD (1 word) instruction
    LDS     r0     ,$0000   ;R F0 0000   set r0 to 240
    SBRC    r0     ,4       ;
    LD      r0     ,Z       ;S           bit 4 of 11110000 is set

; skip a LD instruction
    LDS     r24    ,$0000   ;R 0F 0000   set r24 to 15
    SBRC    r24    ,7       ;
    LD      r0     ,Z       ;R 00 0000   bit 7 of 00001111 is clear

; don't skip a STS (2 word) instruction
    LDS     r26    ,$0000   ;R F0 0000   set r26 to 240
    SBRC    r26    ,5       ;
    STS     $0000  ,r0      ;S           bit 5 of 11110000 is set

; skip a STS instruction
    LDS     r31    ,$0000   ;R 0F 0000   set r31 to 15
    SBRC    r31    ,6       ;
    STS     $0000  ,r0      ;W FF 0000   bit 6 of 00001111 is clear


;PREPROCESS TestNOP

; set some random values in registers
    BSET    0               ;
    BCLR    1               ;
    BSET    2               ;
    BSET    3               ;
    BSET    4               ;
    BSET    5               ;
    BCLR    6               ;
    BSET    7               ;
    LDS     r0     ,$0000   ;R 6E 0000   set r0 to 110
    LDS     r1     ,$0000   ;R 2C 0000   set r1 to 44
    LDS     r2     ,$0000   ;R 42 0000   set r2 to 66
    LDS     r3     ,$0000   ;R 23 0000   set r3 to 35
    LDS     r4     ,$0000   ;R 08 0000   set r4 to 8
    LDS     r5     ,$0000   ;R 14 0000   set r5 to 20
    LDS     r6     ,$0000   ;R D0 0000   set r6 to 208
    LDS     r7     ,$0000   ;R 79 0000   set r7 to 121
    LDS     r8     ,$0000   ;R 9C 0000   set r8 to 156
    LDS     r9     ,$0000   ;R 0A 0000   set r9 to 10
    LDS     r10    ,$0000   ;R BA 0000   set r10 to 186
    LDS     r11    ,$0000   ;R 62 0000   set r11 to 98
    LDS     r12    ,$0000   ;R FD 0000   set r12 to 253
    LDS     r13    ,$0000   ;R 7E 0000   set r13 to 126
    LDS     r14    ,$0000   ;R DC 0000   set r14 to 220
    LDS     r15    ,$0000   ;R 0B 0000   set r15 to 11
    LDS     r16    ,$0000   ;R B0 0000   set r16 to 176
    LDS     r17    ,$0000   ;R 58 0000   set r17 to 88
    LDS     r18    ,$0000   ;R 7E 0000   set r18 to 126
    LDS     r19    ,$0000   ;R AE 0000   set r19 to 174
    LDS     r20    ,$0000   ;R C9 0000   set r20 to 201
    LDS     r21    ,$0000   ;R 9C 0000   set r21 to 156
    LDS     r22    ,$0000   ;R 28 0000   set r22 to 40
    LDS     r23    ,$0000   ;R 38 0000   set r23 to 56
    LDS     r24    ,$0000   ;R C8 0000   set r24 to 200
    LDS     r25    ,$0000   ;R AD 0000   set r25 to 173
    LDS     r26    ,$0000   ;R E1 0000   set r26 to 225
    LDS     r27    ,$0000   ;R 4B 0000   set r27 to 75
    LDS     r28    ,$0000   ;R 52 0000   set r28 to 82
    LDS     r29    ,$0000   ;R 0D 0000   set r29 to 13
    LDS     r30    ,$0000   ;R 90 0000   set r30 to 144
    LDS     r31    ,$0000   ;R EA 0000   set r31 to 234

; do a whole lot of nothing
    NOP                     ;
    NOP                     ;
    NOP                     ;

; check that indeed nothing happened
    STS     $0000  ,r0      ;W 6E 0000   r0 should be 110
    STS     $0000  ,r1      ;W 2C 0000   r1 should be 44
    STS     $0000  ,r2      ;W 42 0000   r2 should be 66
    STS     $0000  ,r3      ;W 23 0000   r3 should be 35
    STS     $0000  ,r4      ;W 08 0000   r4 should be 8
    STS     $0000  ,r5      ;W 14 0000   r5 should be 20
    STS     $0000  ,r6      ;W D0 0000   r6 should be 208
    STS     $0000  ,r7      ;W 79 0000   r7 should be 121
    STS     $0000  ,r8      ;W 9C 0000   r8 should be 156
    STS     $0000  ,r9      ;W 0A 0000   r9 should be 10
    STS     $0000  ,r10     ;W BA 0000   r10 should be 186
    STS     $0000  ,r11     ;W 62 0000   r11 should be 98
    STS     $0000  ,r12     ;W FD 0000   r12 should be 253
    STS     $0000  ,r13     ;W 7E 0000   r13 should be 126
    STS     $0000  ,r14     ;W DC 0000   r14 should be 220
    STS     $0000  ,r15     ;W 0B 0000   r15 should be 11
    STS     $0000  ,r16     ;W B0 0000   r16 should be 176
    STS     $0000  ,r17     ;W 58 0000   r17 should be 88
    STS     $0000  ,r18     ;W 7E 0000   r18 should be 126
    STS     $0000  ,r19     ;W AE 0000   r19 should be 174
    STS     $0000  ,r20     ;W C9 0000   r20 should be 201
    STS     $0000  ,r21     ;W 9C 0000   r21 should be 156
    STS     $0000  ,r22     ;W 28 0000   r22 should be 40
    STS     $0000  ,r23     ;W 38 0000   r23 should be 56
    STS     $0000  ,r24     ;W C8 0000   r24 should be 200
    STS     $0000  ,r25     ;W AD 0000   r25 should be 173
    STS     $0000  ,r26     ;W E1 0000   r26 should be 225
    STS     $0000  ,r27     ;W 4B 0000   r27 should be 75
    STS     $0000  ,r28     ;W 52 0000   r28 should be 82
    STS     $0000  ,r29     ;W 0D 0000   r29 should be 13
    STS     $0000  ,r30     ;W 90 0000   r30 should be 144
    STS     $0000  ,r31     ;W EA 0000   r31 should be 234
    BRBC    0      ,done    ;            bit 0 of status should be set
    BRBS    1      ,done    ;            bit 1 of status should be clear
    BRBC    2      ,done    ;            bit 2 of status should be set
    BRBC    3      ,done    ;            bit 3 of status should be set
    BRBC    4      ,done    ;            bit 4 of status should be set
    BRBC    5      ,done    ;            bit 5 of status should be set
    BRBS    6      ,done    ;            bit 6 of status should be clear
    BRBC    7      ,done    ;            bit 7 of status should be set
done:
    NOP                     ;