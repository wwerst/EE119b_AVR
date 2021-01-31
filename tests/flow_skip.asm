
; Tests the flow control skip instructions and NOP



;PREPROCESS TestCPSE
    LDI     r31    ,$00     ;
    LDI     r30    ,$00     ;

; skip a LD (1 word) instruction
    PUSH    r16             ;
    LDI     r16    ,$00     ;
    STS     $0000  ,r16     ;
    POP     r16             ;
    LDS     r28    ,$0000   ;R $00 $0000 set r28 to 0
    PUSH    r16             ;
    LDI     r16    ,$00     ;
    STS     $0000  ,r16     ;
    POP     r16             ;
    LDS     r13    ,$0000   ;R $00 $0000 set r13 to 0
    CPSE    r28    ,r13     ;
    LD      r0     ,Z       ;S           0 == 0

; don't skip a LD instruction
    PUSH    r16             ;
    LDI     r16    ,$00     ;
    STS     $0000  ,r16     ;
    POP     r16             ;
    LDS     r23    ,$0000   ;R $00 $0000 set r23 to 0
    PUSH    r16             ;
    LDI     r16    ,$5A     ;
    STS     $0000  ,r16     ;
    POP     r16             ;
    LDS     r0     ,$0000   ;R $5A $0000 set r0 to 90
    CPSE    r23    ,r0      ;
    LD      r0     ,Z       ;R $00 $0000 0 != 90

; skip a STS (2 word) instruction
    PUSH    r16             ;
    LDI     r16    ,$00     ;
    STS     $0000  ,r16     ;
    POP     r16             ;
    LDS     r26    ,$0000   ;R $00 $0000 set r26 to 0
    PUSH    r16             ;
    LDI     r16    ,$00     ;
    STS     $0000  ,r16     ;
    POP     r16             ;
    LDS     r7     ,$0000   ;R $00 $0000 set r7 to 0
    CPSE    r26    ,r7      ;
    STS     $0000  ,r0      ;S           0 == 0

; don't skip a STS instruction
    PUSH    r16             ;
    LDI     r16    ,$C9     ;
    STS     $0000  ,r16     ;
    POP     r16             ;
    LDS     r31    ,$0000   ;R $C9 $0000 set r31 to 201
    PUSH    r16             ;
    LDI     r16    ,$FF     ;
    STS     $0000  ,r16     ;
    POP     r16             ;
    LDS     r16    ,$0000   ;R $FF $0000 set r16 to 255
    CPSE    r31    ,r16     ;
    STS     $0000  ,r0      ;W $FF $0000 201 != 255


;PREPROCESS TestSBRC
    LDI     r31    ,$00     ;
    LDI     r30    ,$00     ;

; skip a LD (1 word) instruction
    PUSH    r16             ;
    LDI     r16    ,$F0     ;
    STS     $0000  ,r16     ;
    POP     r16             ;
    LDS     r17    ,$0000   ;R $F0 $0000 set r17 to 240
    SBRC    r17    ,0       ;
    LD      r0     ,Z       ;S           bit 0 of 11110000 is clear

; don't skip a LD instruction
    PUSH    r16             ;
    LDI     r16    ,$0F     ;
    STS     $0000  ,r16     ;
    POP     r16             ;
    LDS     r3     ,$0000   ;R $0F $0000 set r3 to 15
    SBRC    r3     ,3       ;
    LD      r0     ,Z       ;R $00 $0000 bit 3 of 00001111 is set

; skip a STS (2 word) instruction
    PUSH    r16             ;
    LDI     r16    ,$F0     ;
    STS     $0000  ,r16     ;
    POP     r16             ;
    LDS     r25    ,$0000   ;R $F0 $0000 set r25 to 240
    SBRC    r25    ,1       ;
    STS     $0000  ,r0      ;S           bit 1 of 11110000 is clear

; don't skip a STS instruction
    PUSH    r16             ;
    LDI     r16    ,$0F     ;
    STS     $0000  ,r16     ;
    POP     r16             ;
    LDS     r30    ,$0000   ;R $0F $0000 set r30 to 15
    SBRC    r30    ,2       ;
    STS     $0000  ,r0      ;W $FF $0000 bit 2 of 00001111 is set


;PREPROCESS TestSBRS
    LDI     r31    ,$00     ;
    LDI     r30    ,$00     ;

; skip a LD (1 word) instruction
    PUSH    r16             ;
    LDI     r16    ,$F0     ;
    STS     $0000  ,r16     ;
    POP     r16             ;
    LDS     r5     ,$0000   ;R $F0 $0000 set r5 to 240
    SBRC    r5     ,4       ;
    LD      r0     ,Z       ;S           bit 4 of 11110000 is set

; don't skip a LD instruction
    PUSH    r16             ;
    LDI     r16    ,$0F     ;
    STS     $0000  ,r16     ;
    POP     r16             ;
    LDS     r6     ,$0000   ;R $0F $0000 set r6 to 15
    SBRC    r6     ,7       ;
    LD      r0     ,Z       ;R $00 $0000 bit 7 of 00001111 is clear

; skip a STS (2 word) instruction
    PUSH    r16             ;
    LDI     r16    ,$F0     ;
    STS     $0000  ,r16     ;
    POP     r16             ;
    LDS     r5     ,$0000   ;R $F0 $0000 set r5 to 240
    SBRC    r5     ,5       ;
    STS     $0000  ,r0      ;S           bit 5 of 11110000 is set

; don't skip a STS instruction
    PUSH    r16             ;
    LDI     r16    ,$0F     ;
    STS     $0000  ,r16     ;
    POP     r16             ;
    LDS     r16    ,$0000   ;R $0F $0000 set r16 to 15
    SBRC    r16    ,6       ;
    STS     $0000  ,r0      ;W $FF $0000 bit 6 of 00001111 is clear


;PREPROCESS TestNOP

; set some random values in registers
    BCLR    0               ;
    BCLR    1               ;
    BCLR    2               ;
    BCLR    3               ;
    BSET    4               ;
    BSET    5               ;
    BSET    6               ;
    BCLR    7               ;
    PUSH    r16             ;
    LDI     r16    ,$38     ;
    STS     $0000  ,r16     ;
    POP     r16             ;
    LDS     r0     ,$0000   ;R $38 $0000 set r0 to 56
    PUSH    r16             ;
    LDI     r16    ,$26     ;
    STS     $0000  ,r16     ;
    POP     r16             ;
    LDS     r1     ,$0000   ;R $26 $0000 set r1 to 38
    PUSH    r16             ;
    LDI     r16    ,$68     ;
    STS     $0000  ,r16     ;
    POP     r16             ;
    LDS     r2     ,$0000   ;R $68 $0000 set r2 to 104
    PUSH    r16             ;
    LDI     r16    ,$37     ;
    STS     $0000  ,r16     ;
    POP     r16             ;
    LDS     r3     ,$0000   ;R $37 $0000 set r3 to 55
    PUSH    r16             ;
    LDI     r16    ,$44     ;
    STS     $0000  ,r16     ;
    POP     r16             ;
    LDS     r4     ,$0000   ;R $44 $0000 set r4 to 68
    PUSH    r16             ;
    LDI     r16    ,$B2     ;
    STS     $0000  ,r16     ;
    POP     r16             ;
    LDS     r5     ,$0000   ;R $B2 $0000 set r5 to 178
    PUSH    r16             ;
    LDI     r16    ,$87     ;
    STS     $0000  ,r16     ;
    POP     r16             ;
    LDS     r6     ,$0000   ;R $87 $0000 set r6 to 135
    PUSH    r16             ;
    LDI     r16    ,$F5     ;
    STS     $0000  ,r16     ;
    POP     r16             ;
    LDS     r7     ,$0000   ;R $F5 $0000 set r7 to 245
    PUSH    r16             ;
    LDI     r16    ,$AF     ;
    STS     $0000  ,r16     ;
    POP     r16             ;
    LDS     r8     ,$0000   ;R $AF $0000 set r8 to 175
    PUSH    r16             ;
    LDI     r16    ,$FA     ;
    STS     $0000  ,r16     ;
    POP     r16             ;
    LDS     r9     ,$0000   ;R $FA $0000 set r9 to 250
    PUSH    r16             ;
    LDI     r16    ,$9B     ;
    STS     $0000  ,r16     ;
    POP     r16             ;
    LDS     r10    ,$0000   ;R $9B $0000 set r10 to 155
    PUSH    r16             ;
    LDI     r16    ,$1E     ;
    STS     $0000  ,r16     ;
    POP     r16             ;
    LDS     r11    ,$0000   ;R $1E $0000 set r11 to 30
    PUSH    r16             ;
    LDI     r16    ,$31     ;
    STS     $0000  ,r16     ;
    POP     r16             ;
    LDS     r12    ,$0000   ;R $31 $0000 set r12 to 49
    PUSH    r16             ;
    LDI     r16    ,$6C     ;
    STS     $0000  ,r16     ;
    POP     r16             ;
    LDS     r13    ,$0000   ;R $6C $0000 set r13 to 108
    PUSH    r16             ;
    LDI     r16    ,$71     ;
    STS     $0000  ,r16     ;
    POP     r16             ;
    LDS     r14    ,$0000   ;R $71 $0000 set r14 to 113
    PUSH    r16             ;
    LDI     r16    ,$17     ;
    STS     $0000  ,r16     ;
    POP     r16             ;
    LDS     r15    ,$0000   ;R $17 $0000 set r15 to 23
    PUSH    r16             ;
    LDI     r16    ,$BC     ;
    STS     $0000  ,r16     ;
    POP     r16             ;
    LDS     r16    ,$0000   ;R $BC $0000 set r16 to 188
    PUSH    r16             ;
    LDI     r16    ,$C4     ;
    STS     $0000  ,r16     ;
    POP     r16             ;
    LDS     r17    ,$0000   ;R $C4 $0000 set r17 to 196
    PUSH    r16             ;
    LDI     r16    ,$BE     ;
    STS     $0000  ,r16     ;
    POP     r16             ;
    LDS     r18    ,$0000   ;R $BE $0000 set r18 to 190
    PUSH    r16             ;
    LDI     r16    ,$DF     ;
    STS     $0000  ,r16     ;
    POP     r16             ;
    LDS     r19    ,$0000   ;R $DF $0000 set r19 to 223
    PUSH    r16             ;
    LDI     r16    ,$21     ;
    STS     $0000  ,r16     ;
    POP     r16             ;
    LDS     r20    ,$0000   ;R $21 $0000 set r20 to 33
    PUSH    r16             ;
    LDI     r16    ,$06     ;
    STS     $0000  ,r16     ;
    POP     r16             ;
    LDS     r21    ,$0000   ;R $06 $0000 set r21 to 6
    PUSH    r16             ;
    LDI     r16    ,$F6     ;
    STS     $0000  ,r16     ;
    POP     r16             ;
    LDS     r22    ,$0000   ;R $F6 $0000 set r22 to 246
    PUSH    r16             ;
    LDI     r16    ,$B3     ;
    STS     $0000  ,r16     ;
    POP     r16             ;
    LDS     r23    ,$0000   ;R $B3 $0000 set r23 to 179
    PUSH    r16             ;
    LDI     r16    ,$0D     ;
    STS     $0000  ,r16     ;
    POP     r16             ;
    LDS     r24    ,$0000   ;R $0D $0000 set r24 to 13
    PUSH    r16             ;
    LDI     r16    ,$4D     ;
    STS     $0000  ,r16     ;
    POP     r16             ;
    LDS     r25    ,$0000   ;R $4D $0000 set r25 to 77
    PUSH    r16             ;
    LDI     r16    ,$A9     ;
    STS     $0000  ,r16     ;
    POP     r16             ;
    LDS     r26    ,$0000   ;R $A9 $0000 set r26 to 169
    PUSH    r16             ;
    LDI     r16    ,$A9     ;
    STS     $0000  ,r16     ;
    POP     r16             ;
    LDS     r27    ,$0000   ;R $A9 $0000 set r27 to 169
    PUSH    r16             ;
    LDI     r16    ,$63     ;
    STS     $0000  ,r16     ;
    POP     r16             ;
    LDS     r28    ,$0000   ;R $63 $0000 set r28 to 99
    PUSH    r16             ;
    LDI     r16    ,$19     ;
    STS     $0000  ,r16     ;
    POP     r16             ;
    LDS     r29    ,$0000   ;R $19 $0000 set r29 to 25
    PUSH    r16             ;
    LDI     r16    ,$73     ;
    STS     $0000  ,r16     ;
    POP     r16             ;
    LDS     r30    ,$0000   ;R $73 $0000 set r30 to 115
    PUSH    r16             ;
    LDI     r16    ,$E0     ;
    STS     $0000  ,r16     ;
    POP     r16             ;
    LDS     r31    ,$0000   ;R $E0 $0000 set r31 to 224

; do a whole lot of nothing
    NOP                     ;
    NOP                     ;
    NOP                     ;

; check that indeed nothing happened
    STS     $0000  ,r0      ;W $38 $0000 r0 should be 56
    STS     $0000  ,r1      ;W $26 $0000 r1 should be 38
    STS     $0000  ,r2      ;W $68 $0000 r2 should be 104
    STS     $0000  ,r3      ;W $37 $0000 r3 should be 55
    STS     $0000  ,r4      ;W $44 $0000 r4 should be 68
    STS     $0000  ,r5      ;W $B2 $0000 r5 should be 178
    STS     $0000  ,r6      ;W $87 $0000 r6 should be 135
    STS     $0000  ,r7      ;W $F5 $0000 r7 should be 245
    STS     $0000  ,r8      ;W $AF $0000 r8 should be 175
    STS     $0000  ,r9      ;W $FA $0000 r9 should be 250
    STS     $0000  ,r10     ;W $9B $0000 r10 should be 155
    STS     $0000  ,r11     ;W $1E $0000 r11 should be 30
    STS     $0000  ,r12     ;W $31 $0000 r12 should be 49
    STS     $0000  ,r13     ;W $6C $0000 r13 should be 108
    STS     $0000  ,r14     ;W $71 $0000 r14 should be 113
    STS     $0000  ,r15     ;W $17 $0000 r15 should be 23
    STS     $0000  ,r16     ;W $BC $0000 r16 should be 188
    STS     $0000  ,r17     ;W $C4 $0000 r17 should be 196
    STS     $0000  ,r18     ;W $BE $0000 r18 should be 190
    STS     $0000  ,r19     ;W $DF $0000 r19 should be 223
    STS     $0000  ,r20     ;W $21 $0000 r20 should be 33
    STS     $0000  ,r21     ;W $06 $0000 r21 should be 6
    STS     $0000  ,r22     ;W $F6 $0000 r22 should be 246
    STS     $0000  ,r23     ;W $B3 $0000 r23 should be 179
    STS     $0000  ,r24     ;W $0D $0000 r24 should be 13
    STS     $0000  ,r25     ;W $4D $0000 r25 should be 77
    STS     $0000  ,r26     ;W $A9 $0000 r26 should be 169
    STS     $0000  ,r27     ;W $A9 $0000 r27 should be 169
    STS     $0000  ,r28     ;W $63 $0000 r28 should be 99
    STS     $0000  ,r29     ;W $19 $0000 r29 should be 25
    STS     $0000  ,r30     ;W $73 $0000 r30 should be 115
    STS     $0000  ,r31     ;W $E0 $0000 r31 should be 224
    BRBS    0      ,done    ;            bit 0 of status should be clear
    BRBS    1      ,done    ;            bit 1 of status should be clear
    BRBS    2      ,done    ;            bit 2 of status should be clear
    BRBS    3      ,done    ;            bit 3 of status should be clear
    BRBC    4      ,done    ;            bit 4 of status should be set
    BRBC    5      ,done    ;            bit 5 of status should be set
    BRBC    6      ,done    ;            bit 6 of status should be set
    BRBS    7      ,done    ;            bit 7 of status should be clear
done:
    NOP                     ;