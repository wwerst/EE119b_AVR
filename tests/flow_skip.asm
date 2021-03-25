
; Tests the flow control skip instructions and NOP
; THIS FILE IS GENERATED
; for explanations or modifications, see notebook flowskip.ipynb



;PREPROCESS TestCPSE
    LDI     r31    ,$00     ;
    LDI     r30    ,$00     ;

; skip a LD (1 word) instruction
    LDS     r21    ,$0000   ;R 00 0000   set r21 to 0
    LDS     r4     ,$0000   ;R 00 0000   set r4 to 0
    CPSE    r21    ,r4      ;
    LD      r0     ,Z       ;S           0 == 0

; don't skip a LD instruction
    LDS     r1     ,$0000   ;R 00 0000   set r1 to 0
    LDS     r24    ,$0000   ;R 8C 0000   set r24 to 140
    CPSE    r1     ,r24     ;
    LD      r0     ,Z       ;R 97 0000   0 != 140

; skip a STS (2 word) instruction
    LDS     r8     ,$0000   ;R 00 0000   set r8 to 0
    LDS     r5     ,$0000   ;R 00 0000   set r5 to 0
    CPSE    r8     ,r5      ;
    STS     $0000  ,r0      ;S           0 == 0

; don't skip a STS instruction
    LDS     r24    ,$0000   ;R AD 0000   set r24 to 173
    LDS     r4     ,$0000   ;R FF 0000   set r4 to 255
    CPSE    r24    ,r4      ;
    STS     $0000  ,r0      ;W 97 0000   173 != 255


;PREPROCESS TestSBRC
    LDI     r31    ,$00     ;
    LDI     r30    ,$00     ;

; skip a LD (1 word) instruction
    LDS     r24    ,$0000   ;R F0 0000   set r24 to 240
    SBRC    r24    ,0       ;
    LD      r0     ,Z       ;S           bit 0 of 11110000 is clear

; don't skip a LD instruction
    LDS     r29    ,$0000   ;R 0F 0000   set r29 to 15
    SBRC    r29    ,3       ;
    LD      r0     ,Z       ;R 73 0000   bit 3 of 00001111 is set

; skip a STS (2 word) instruction
    LDS     r18    ,$0000   ;R F0 0000   set r18 to 240
    SBRC    r18    ,1       ;
    STS     $0000  ,r0      ;S           bit 1 of 11110000 is clear

; don't skip a STS instruction
    LDS     r3     ,$0000   ;R 0F 0000   set r3 to 15
    SBRC    r3     ,2       ;
    STS     $0000  ,r0      ;W 73 0000   bit 2 of 00001111 is set


;PREPROCESS TestSBRS
    LDI     r31    ,$00     ;
    LDI     r30    ,$00     ;

; don't skip a LD (1 word) instruction
    LDS     r19    ,$0000   ;R F0 0000   set r19 to 240
    SBRS    r19    ,4       ;
    LD      r0     ,Z       ;S           bit 4 of 11110000 is set

; skip a LD instruction
    LDS     r14    ,$0000   ;R 0F 0000   set r14 to 15
    SBRS    r14    ,7       ;
    LD      r0     ,Z       ;R 2A 0000   bit 7 of 00001111 is clear

; don't skip a STS (2 word) instruction
    LDS     r2     ,$0000   ;R F0 0000   set r2 to 240
    SBRS    r2     ,5       ;
    STS     $0000  ,r0      ;S           bit 5 of 11110000 is set

; skip a STS instruction
    LDS     r1     ,$0000   ;R 0F 0000   set r1 to 15
    SBRS    r1     ,6       ;
    STS     $0000  ,r0      ;W 2A 0000   bit 6 of 00001111 is clear


;PREPROCESS TestNOP

; set some random values in registers
    BSET    0               ;
    BSET    1               ;
    BSET    2               ;
    BSET    3               ;
    BSET    4               ;
    BCLR    5               ;
    BSET    6               ;
    BCLR    7               ;
    LDS     r0     ,$0000   ;R 8E 0000   set r0 to 142
    LDS     r1     ,$0000   ;R 03 0000   set r1 to 3
    LDS     r2     ,$0000   ;R 51 0000   set r2 to 81
    LDS     r3     ,$0000   ;R D8 0000   set r3 to 216
    LDS     r4     ,$0000   ;R AE 0000   set r4 to 174
    LDS     r5     ,$0000   ;R 8E 0000   set r5 to 142
    LDS     r6     ,$0000   ;R 4F 0000   set r6 to 79
    LDS     r7     ,$0000   ;R 6E 0000   set r7 to 110
    LDS     r8     ,$0000   ;R AC 0000   set r8 to 172
    LDS     r9     ,$0000   ;R 34 0000   set r9 to 52
    LDS     r10    ,$0000   ;R 2F 0000   set r10 to 47
    LDS     r11    ,$0000   ;R C2 0000   set r11 to 194
    LDS     r12    ,$0000   ;R 31 0000   set r12 to 49
    LDS     r13    ,$0000   ;R B7 0000   set r13 to 183
    LDS     r14    ,$0000   ;R B0 0000   set r14 to 176
    LDS     r15    ,$0000   ;R 87 0000   set r15 to 135
    LDS     r16    ,$0000   ;R 16 0000   set r16 to 22
    LDS     r17    ,$0000   ;R EB 0000   set r17 to 235
    LDS     r18    ,$0000   ;R 3F 0000   set r18 to 63
    LDS     r19    ,$0000   ;R C1 0000   set r19 to 193
    LDS     r20    ,$0000   ;R 28 0000   set r20 to 40
    LDS     r21    ,$0000   ;R 96 0000   set r21 to 150
    LDS     r22    ,$0000   ;R B9 0000   set r22 to 185
    LDS     r23    ,$0000   ;R 62 0000   set r23 to 98
    LDS     r24    ,$0000   ;R 23 0000   set r24 to 35
    LDS     r25    ,$0000   ;R 17 0000   set r25 to 23
    LDS     r26    ,$0000   ;R 74 0000   set r26 to 116
    LDS     r27    ,$0000   ;R 94 0000   set r27 to 148
    LDS     r28    ,$0000   ;R 28 0000   set r28 to 40
    LDS     r29    ,$0000   ;R 77 0000   set r29 to 119
    LDS     r30    ,$0000   ;R 33 0000   set r30 to 51
    LDS     r31    ,$0000   ;R C2 0000   set r31 to 194

; do a whole lot of nothing
    NOP                     ;
    NOP                     ;
    NOP                     ;

; check that indeed nothing happened
    STS     $0000  ,r0      ;W 8E 0000   r0 should be 142
    STS     $0000  ,r1      ;W 03 0000   r1 should be 3
    STS     $0000  ,r2      ;W 51 0000   r2 should be 81
    STS     $0000  ,r3      ;W D8 0000   r3 should be 216
    STS     $0000  ,r4      ;W AE 0000   r4 should be 174
    STS     $0000  ,r5      ;W 8E 0000   r5 should be 142
    STS     $0000  ,r6      ;W 4F 0000   r6 should be 79
    STS     $0000  ,r7      ;W 6E 0000   r7 should be 110
    STS     $0000  ,r8      ;W AC 0000   r8 should be 172
    STS     $0000  ,r9      ;W 34 0000   r9 should be 52
    STS     $0000  ,r10     ;W 2F 0000   r10 should be 47
    STS     $0000  ,r11     ;W C2 0000   r11 should be 194
    STS     $0000  ,r12     ;W 31 0000   r12 should be 49
    STS     $0000  ,r13     ;W B7 0000   r13 should be 183
    STS     $0000  ,r14     ;W B0 0000   r14 should be 176
    STS     $0000  ,r15     ;W 87 0000   r15 should be 135
    STS     $0000  ,r16     ;W 16 0000   r16 should be 22
    STS     $0000  ,r17     ;W EB 0000   r17 should be 235
    STS     $0000  ,r18     ;W 3F 0000   r18 should be 63
    STS     $0000  ,r19     ;W C1 0000   r19 should be 193
    STS     $0000  ,r20     ;W 28 0000   r20 should be 40
    STS     $0000  ,r21     ;W 96 0000   r21 should be 150
    STS     $0000  ,r22     ;W B9 0000   r22 should be 185
    STS     $0000  ,r23     ;W 62 0000   r23 should be 98
    STS     $0000  ,r24     ;W 23 0000   r24 should be 35
    STS     $0000  ,r25     ;W 17 0000   r25 should be 23
    STS     $0000  ,r26     ;W 74 0000   r26 should be 116
    STS     $0000  ,r27     ;W 94 0000   r27 should be 148
    STS     $0000  ,r28     ;W 28 0000   r28 should be 40
    STS     $0000  ,r29     ;W 77 0000   r29 should be 119
    STS     $0000  ,r30     ;W 33 0000   r30 should be 51
    STS     $0000  ,r31     ;W C2 0000   r31 should be 194
    IN      r18    ,$3F     ; Read the Status register
    STS     $0000  ,r18     ;W 5F 0000   Status register should be 5F from earlier
done:
    NOP                     ;