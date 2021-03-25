
; Tests the flow control skip instructions and NOP
THIS FILE IS GENERATED
for explanations or modifications, see notebook flowskip.ipynb



;PREPROCESS TestCPSE
    LDI     r31    ,$00     ;
    LDI     r30    ,$00     ;

; skip a LD (1 word) instruction
    PUSH    r16             ;
    LDI     r16    ,$00     ;
    STS     $0000  ,r16     ;
    POP     r16             ;
    LDS     r23    ,$0000   ;R 00 0000   set r23 to 0
    PUSH    r16             ;
    LDI     r16    ,$00     ;
    STS     $0000  ,r16     ;
    POP     r16             ;
    LDS     r16    ,$0000   ;R 00 0000   set r16 to 0
    CPSE    r23    ,r16     ;
    LD      r0     ,Z       ;S           0 == 0

; don't skip a LD instruction
    PUSH    r16             ;
    LDI     r16    ,$00     ;
    STS     $0000  ,r16     ;
    POP     r16             ;
    LDS     r0     ,$0000   ;R 00 0000   set r0 to 0
    PUSH    r16             ;
    LDI     r16    ,$A6     ;
    STS     $0000  ,r16     ;
    POP     r16             ;
    LDS     r9     ,$0000   ;R A6 0000   set r9 to 166
    CPSE    r0     ,r9      ;
    LD      r0     ,Z       ;R 00 0000   0 != 166

; skip a STS (2 word) instruction
    PUSH    r16             ;
    LDI     r16    ,$00     ;
    STS     $0000  ,r16     ;
    POP     r16             ;
    LDS     r27    ,$0000   ;R 00 0000   set r27 to 0
    PUSH    r16             ;
    LDI     r16    ,$00     ;
    STS     $0000  ,r16     ;
    POP     r16             ;
    LDS     r9     ,$0000   ;R 00 0000   set r9 to 0
    CPSE    r27    ,r9      ;
    STS     $0000  ,r0      ;S           0 == 0

; don't skip a STS instruction
    PUSH    r16             ;
    LDI     r16    ,$6A     ;
    STS     $0000  ,r16     ;
    POP     r16             ;
    LDS     r6     ,$0000   ;R 6A 0000   set r6 to 106
    PUSH    r16             ;
    LDI     r16    ,$FF     ;
    STS     $0000  ,r16     ;
    POP     r16             ;
    LDS     r12    ,$0000   ;R FF 0000   set r12 to 255
    CPSE    r6     ,r12     ;
    STS     $0000  ,r0      ;W FF 0000   106 != 255


;PREPROCESS TestSBRC
    LDI     r31    ,$00     ;
    LDI     r30    ,$00     ;

; skip a LD (1 word) instruction
    PUSH    r16             ;
    LDI     r16    ,$F0     ;
    STS     $0000  ,r16     ;
    POP     r16             ;
    LDS     r20    ,$0000   ;R F0 0000   set r20 to 240
    SBRC    r20    ,0       ;
    LD      r0     ,Z       ;S           bit 0 of 11110000 is clear

; don't skip a LD instruction
    PUSH    r16             ;
    LDI     r16    ,$0F     ;
    STS     $0000  ,r16     ;
    POP     r16             ;
    LDS     r14    ,$0000   ;R 0F 0000   set r14 to 15
    SBRC    r14    ,3       ;
    LD      r0     ,Z       ;R 00 0000   bit 3 of 00001111 is set

; skip a STS (2 word) instruction
    PUSH    r16             ;
    LDI     r16    ,$F0     ;
    STS     $0000  ,r16     ;
    POP     r16             ;
    LDS     r28    ,$0000   ;R F0 0000   set r28 to 240
    SBRC    r28    ,1       ;
    STS     $0000  ,r0      ;S           bit 1 of 11110000 is clear

; don't skip a STS instruction
    PUSH    r16             ;
    LDI     r16    ,$0F     ;
    STS     $0000  ,r16     ;
    POP     r16             ;
    LDS     r4     ,$0000   ;R 0F 0000   set r4 to 15
    SBRC    r4     ,2       ;
    STS     $0000  ,r0      ;W FF 0000   bit 2 of 00001111 is set


;PREPROCESS TestSBRS
    LDI     r31    ,$00     ;
    LDI     r30    ,$00     ;

; don't skip a LD (1 word) instruction
    PUSH    r16             ;
    LDI     r16    ,$F0     ;
    STS     $0000  ,r16     ;
    POP     r16             ;
    LDS     r14    ,$0000   ;R F0 0000   set r14 to 240
    SBRC    r14    ,4       ;
    LD      r0     ,Z       ;S           bit 4 of 11110000 is set

; skip a LD instruction
    PUSH    r16             ;
    LDI     r16    ,$0F     ;
    STS     $0000  ,r16     ;
    POP     r16             ;
    LDS     r5     ,$0000   ;R 0F 0000   set r5 to 15
    SBRC    r5     ,7       ;
    LD      r0     ,Z       ;R 00 0000   bit 7 of 00001111 is clear

; don't skip a STS (2 word) instruction
    PUSH    r16             ;
    LDI     r16    ,$F0     ;
    STS     $0000  ,r16     ;
    POP     r16             ;
    LDS     r4     ,$0000   ;R F0 0000   set r4 to 240
    SBRC    r4     ,5       ;
    STS     $0000  ,r0      ;S           bit 5 of 11110000 is set

; skip a STS instruction
    PUSH    r16             ;
    LDI     r16    ,$0F     ;
    STS     $0000  ,r16     ;
    POP     r16             ;
    LDS     r21    ,$0000   ;R 0F 0000   set r21 to 15
    SBRC    r21    ,6       ;
    STS     $0000  ,r0      ;W FF 0000   bit 6 of 00001111 is clear


;PREPROCESS TestNOP

; set some random values in registers
    BSET    0               ;
    BCLR    1               ;
    BSET    2               ;
    BSET    3               ;
    BSET    4               ;
    BSET    5               ;
    BSET    6               ;
    BCLR    7               ;
    PUSH    r16             ;
    LDI     r16    ,$B2     ;
    STS     $0000  ,r16     ;
    POP     r16             ;
    LDS     r0     ,$0000   ;R B2 0000   set r0 to 178
    PUSH    r16             ;
    LDI     r16    ,$79     ;
    STS     $0000  ,r16     ;
    POP     r16             ;
    LDS     r1     ,$0000   ;R 79 0000   set r1 to 121
    PUSH    r16             ;
    LDI     r16    ,$24     ;
    STS     $0000  ,r16     ;
    POP     r16             ;
    LDS     r2     ,$0000   ;R 24 0000   set r2 to 36
    PUSH    r16             ;
    LDI     r16    ,$38     ;
    STS     $0000  ,r16     ;
    POP     r16             ;
    LDS     r3     ,$0000   ;R 38 0000   set r3 to 56
    PUSH    r16             ;
    LDI     r16    ,$DD     ;
    STS     $0000  ,r16     ;
    POP     r16             ;
    LDS     r4     ,$0000   ;R DD 0000   set r4 to 221
    PUSH    r16             ;
    LDI     r16    ,$F0     ;
    STS     $0000  ,r16     ;
    POP     r16             ;
    LDS     r5     ,$0000   ;R F0 0000   set r5 to 240
    PUSH    r16             ;
    LDI     r16    ,$B8     ;
    STS     $0000  ,r16     ;
    POP     r16             ;
    LDS     r6     ,$0000   ;R B8 0000   set r6 to 184
    PUSH    r16             ;
    LDI     r16    ,$B6     ;
    STS     $0000  ,r16     ;
    POP     r16             ;
    LDS     r7     ,$0000   ;R B6 0000   set r7 to 182
    PUSH    r16             ;
    LDI     r16    ,$03     ;
    STS     $0000  ,r16     ;
    POP     r16             ;
    LDS     r8     ,$0000   ;R 03 0000   set r8 to 3
    PUSH    r16             ;
    LDI     r16    ,$7B     ;
    STS     $0000  ,r16     ;
    POP     r16             ;
    LDS     r9     ,$0000   ;R 7B 0000   set r9 to 123
    PUSH    r16             ;
    LDI     r16    ,$54     ;
    STS     $0000  ,r16     ;
    POP     r16             ;
    LDS     r10    ,$0000   ;R 54 0000   set r10 to 84
    PUSH    r16             ;
    LDI     r16    ,$12     ;
    STS     $0000  ,r16     ;
    POP     r16             ;
    LDS     r11    ,$0000   ;R 12 0000   set r11 to 18
    PUSH    r16             ;
    LDI     r16    ,$D2     ;
    STS     $0000  ,r16     ;
    POP     r16             ;
    LDS     r12    ,$0000   ;R D2 0000   set r12 to 210
    PUSH    r16             ;
    LDI     r16    ,$6F     ;
    STS     $0000  ,r16     ;
    POP     r16             ;
    LDS     r13    ,$0000   ;R 6F 0000   set r13 to 111
    PUSH    r16             ;
    LDI     r16    ,$07     ;
    STS     $0000  ,r16     ;
    POP     r16             ;
    LDS     r14    ,$0000   ;R 07 0000   set r14 to 7
    PUSH    r16             ;
    LDI     r16    ,$2F     ;
    STS     $0000  ,r16     ;
    POP     r16             ;
    LDS     r15    ,$0000   ;R 2F 0000   set r15 to 47
    PUSH    r16             ;
    LDI     r16    ,$93     ;
    STS     $0000  ,r16     ;
    POP     r16             ;
    LDS     r16    ,$0000   ;R 93 0000   set r16 to 147
    PUSH    r16             ;
    LDI     r16    ,$6F     ;
    STS     $0000  ,r16     ;
    POP     r16             ;
    LDS     r17    ,$0000   ;R 6F 0000   set r17 to 111
    PUSH    r16             ;
    LDI     r16    ,$98     ;
    STS     $0000  ,r16     ;
    POP     r16             ;
    LDS     r18    ,$0000   ;R 98 0000   set r18 to 152
    PUSH    r16             ;
    LDI     r16    ,$AB     ;
    STS     $0000  ,r16     ;
    POP     r16             ;
    LDS     r19    ,$0000   ;R AB 0000   set r19 to 171
    PUSH    r16             ;
    LDI     r16    ,$FF     ;
    STS     $0000  ,r16     ;
    POP     r16             ;
    LDS     r20    ,$0000   ;R FF 0000   set r20 to 255
    PUSH    r16             ;
    LDI     r16    ,$A4     ;
    STS     $0000  ,r16     ;
    POP     r16             ;
    LDS     r21    ,$0000   ;R A4 0000   set r21 to 164
    PUSH    r16             ;
    LDI     r16    ,$A7     ;
    STS     $0000  ,r16     ;
    POP     r16             ;
    LDS     r22    ,$0000   ;R A7 0000   set r22 to 167
    PUSH    r16             ;
    LDI     r16    ,$98     ;
    STS     $0000  ,r16     ;
    POP     r16             ;
    LDS     r23    ,$0000   ;R 98 0000   set r23 to 152
    PUSH    r16             ;
    LDI     r16    ,$C5     ;
    STS     $0000  ,r16     ;
    POP     r16             ;
    LDS     r24    ,$0000   ;R C5 0000   set r24 to 197
    PUSH    r16             ;
    LDI     r16    ,$68     ;
    STS     $0000  ,r16     ;
    POP     r16             ;
    LDS     r25    ,$0000   ;R 68 0000   set r25 to 104
    PUSH    r16             ;
    LDI     r16    ,$88     ;
    STS     $0000  ,r16     ;
    POP     r16             ;
    LDS     r26    ,$0000   ;R 88 0000   set r26 to 136
    PUSH    r16             ;
    LDI     r16    ,$3D     ;
    STS     $0000  ,r16     ;
    POP     r16             ;
    LDS     r27    ,$0000   ;R 3D 0000   set r27 to 61
    PUSH    r16             ;
    LDI     r16    ,$8B     ;
    STS     $0000  ,r16     ;
    POP     r16             ;
    LDS     r28    ,$0000   ;R 8B 0000   set r28 to 139
    PUSH    r16             ;
    LDI     r16    ,$34     ;
    STS     $0000  ,r16     ;
    POP     r16             ;
    LDS     r29    ,$0000   ;R 34 0000   set r29 to 52
    PUSH    r16             ;
    LDI     r16    ,$82     ;
    STS     $0000  ,r16     ;
    POP     r16             ;
    LDS     r30    ,$0000   ;R 82 0000   set r30 to 130
    PUSH    r16             ;
    LDI     r16    ,$C7     ;
    STS     $0000  ,r16     ;
    POP     r16             ;
    LDS     r31    ,$0000   ;R C7 0000   set r31 to 199

; do a whole lot of nothing
    NOP                     ;
    NOP                     ;
    NOP                     ;

; check that indeed nothing happened
    STS     $0000  ,r0      ;W B2 0000   r0 should be 178
    STS     $0000  ,r1      ;W 79 0000   r1 should be 121
    STS     $0000  ,r2      ;W 24 0000   r2 should be 36
    STS     $0000  ,r3      ;W 38 0000   r3 should be 56
    STS     $0000  ,r4      ;W DD 0000   r4 should be 221
    STS     $0000  ,r5      ;W F0 0000   r5 should be 240
    STS     $0000  ,r6      ;W B8 0000   r6 should be 184
    STS     $0000  ,r7      ;W B6 0000   r7 should be 182
    STS     $0000  ,r8      ;W 03 0000   r8 should be 3
    STS     $0000  ,r9      ;W 7B 0000   r9 should be 123
    STS     $0000  ,r10     ;W 54 0000   r10 should be 84
    STS     $0000  ,r11     ;W 12 0000   r11 should be 18
    STS     $0000  ,r12     ;W D2 0000   r12 should be 210
    STS     $0000  ,r13     ;W 6F 0000   r13 should be 111
    STS     $0000  ,r14     ;W 07 0000   r14 should be 7
    STS     $0000  ,r15     ;W 2F 0000   r15 should be 47
    STS     $0000  ,r16     ;W 93 0000   r16 should be 147
    STS     $0000  ,r17     ;W 6F 0000   r17 should be 111
    STS     $0000  ,r18     ;W 98 0000   r18 should be 152
    STS     $0000  ,r19     ;W AB 0000   r19 should be 171
    STS     $0000  ,r20     ;W FF 0000   r20 should be 255
    STS     $0000  ,r21     ;W A4 0000   r21 should be 164
    STS     $0000  ,r22     ;W A7 0000   r22 should be 167
    STS     $0000  ,r23     ;W 98 0000   r23 should be 152
    STS     $0000  ,r24     ;W C5 0000   r24 should be 197
    STS     $0000  ,r25     ;W 68 0000   r25 should be 104
    STS     $0000  ,r26     ;W 88 0000   r26 should be 136
    STS     $0000  ,r27     ;W 3D 0000   r27 should be 61
    STS     $0000  ,r28     ;W 8B 0000   r28 should be 139
    STS     $0000  ,r29     ;W 34 0000   r29 should be 52
    STS     $0000  ,r30     ;W 82 0000   r30 should be 130
    STS     $0000  ,r31     ;W C7 0000   r31 should be 199
    BRBC    0      ,done    ;            bit 0 of status should be set
    BRBS    1      ,done    ;            bit 1 of status should be clear
    BRBC    2      ,done    ;            bit 2 of status should be set
    BRBC    3      ,done    ;            bit 3 of status should be set
    BRBC    4      ,done    ;            bit 4 of status should be set
    BRBC    5      ,done    ;            bit 5 of status should be set
    BRBC    6      ,done    ;            bit 6 of status should be set
    BRBS    7      ,done    ;            bit 7 of status should be clear
done:
    NOP                     ;