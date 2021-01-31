
; Tests the data movement instructions

; Note, we attempt to verify the behavior of the load instructions
; by writing registers out with STS-
; the load tests assume STS is functional.




;PREPROCESS TestLDI

; do a few simple LDIs
    LDI     r16    ,$00     ;
    STS     $0000  ,r16     ;W $00 $0000 r16 should be 0
    LDI     r17    ,$FF     ;
    STS     $0000  ,r17     ;W $FF $0000 r17 should be 255
    LDI     r18    ,$0F     ;
    STS     $0000  ,r18     ;W $0F $0000 r18 should be 15

; do a fixed LDI into all 16 upper registers
    LDI     r16    ,$EC     ;
    LDI     r17    ,$EC     ;
    LDI     r18    ,$EC     ;
    LDI     r19    ,$EC     ;
    LDI     r20    ,$EC     ;
    LDI     r21    ,$EC     ;
    LDI     r22    ,$EC     ;
    LDI     r23    ,$EC     ;
    LDI     r24    ,$EC     ;
    LDI     r25    ,$EC     ;
    LDI     r26    ,$EC     ;
    LDI     r27    ,$EC     ;
    LDI     r28    ,$EC     ;
    LDI     r29    ,$EC     ;
    LDI     r30    ,$EC     ;
    LDI     r31    ,$EC     ;
    STS     $0000  ,r16     ;W $EC $0000 r16 should be 236
    STS     $0000  ,r17     ;W $EC $0000 r17 should be 236
    STS     $0000  ,r18     ;W $EC $0000 r18 should be 236
    STS     $0000  ,r19     ;W $EC $0000 r19 should be 236
    STS     $0000  ,r20     ;W $EC $0000 r20 should be 236
    STS     $0000  ,r21     ;W $EC $0000 r21 should be 236
    STS     $0000  ,r22     ;W $EC $0000 r22 should be 236
    STS     $0000  ,r23     ;W $EC $0000 r23 should be 236
    STS     $0000  ,r24     ;W $EC $0000 r24 should be 236
    STS     $0000  ,r25     ;W $EC $0000 r25 should be 236
    STS     $0000  ,r26     ;W $EC $0000 r26 should be 236
    STS     $0000  ,r27     ;W $EC $0000 r27 should be 236
    STS     $0000  ,r28     ;W $EC $0000 r28 should be 236
    STS     $0000  ,r29     ;W $EC $0000 r29 should be 236
    STS     $0000  ,r30     ;W $EC $0000 r30 should be 236
    STS     $0000  ,r31     ;W $EC $0000 r31 should be 236

; do some random LDIs
    LDI     r30    ,$79     ;
    LDI     r26    ,$EF     ;
    LDI     r20    ,$EE     ;
    LDI     r27    ,$15     ;
    LDI     r22    ,$87     ;
    LDI     r24    ,$96     ;
    LDI     r23    ,$B5     ;
    LDI     r25    ,$4F     ;
    LDI     r29    ,$D9     ;
    LDI     r31    ,$C6     ;
    STS     $0000  ,r30     ;W $79 $0000 r30 should be 121
    STS     $0000  ,r26     ;W $EF $0000 r26 should be 239
    STS     $0000  ,r20     ;W $EE $0000 r20 should be 238
    STS     $0000  ,r27     ;W $15 $0000 r27 should be 21
    STS     $0000  ,r22     ;W $87 $0000 r22 should be 135
    STS     $0000  ,r24     ;W $96 $0000 r24 should be 150
    STS     $0000  ,r23     ;W $B5 $0000 r23 should be 181
    STS     $0000  ,r25     ;W $4F $0000 r25 should be 79
    STS     $0000  ,r29     ;W $D9 $0000 r29 should be 217
    STS     $0000  ,r31     ;W $C6 $0000 r31 should be 198



;PREPROCESS TestLD


; do a few simple LDs from X register
    LDI     r26    ,$04     ;            set X to $0004
    LDI     r27    ,$00     ;
    LD      r0     ,X       ;R $EC $0004
    STS     $0000  ,r0      ;W $EC $0000 r0 should be 236
    LD      r8     ,X       ;R $EC $0004
    STS     $0000  ,r8      ;W $EC $0000 r8 should be 236
    LD      r31    ,X       ;R $EC $0004
    STS     $0000  ,r31     ;W $EC $0000 r31 should be 236

; load with pre decrement through 0x0000
    LD      r20    ,-X      ;R $4F $0003
    LD      r25    ,-X      ;R $2C $0002
    LD      r29    ,-X      ;R $3A $0001
    LD      r16    ,-X      ;R $6F $0000
    LD      r24    ,-X      ;R $A7 $FFFF
    LD      r10    ,-X      ;R $38 $FFFE
    LD      r11    ,-X      ;R $BD $FFFD
    LD      r22    ,-X      ;R $87 $FFFC
    STS     $0000  ,r20     ;W $4F $0000 r20 should be 79
    STS     $0000  ,r25     ;W $2C $0000 r25 should be 44
    STS     $0000  ,r29     ;W $3A $0000 r29 should be 58
    STS     $0000  ,r16     ;W $6F $0000 r16 should be 111
    STS     $0000  ,r24     ;W $A7 $0000 r24 should be 167
    STS     $0000  ,r10     ;W $38 $0000 r10 should be 56
    STS     $0000  ,r11     ;W $BD $0000 r11 should be 189
    STS     $0000  ,r22     ;W $87 $0000 r22 should be 135

; load with post increment through 0xFFFF
    LD      r24    ,X+      ;R $BF $FFFC
    LD      r21    ,X+      ;R $6B $FFFD
    LD      r1     ,X+      ;R $09 $FFFE
    LD      r28    ,X+      ;R $06 $FFFF
    LD      r8     ,X+      ;R $B7 $0000
    LD      r2     ,X+      ;R $B6 $0001
    LD      r11    ,X+      ;R $7E $0002
    LD      r29    ,X+      ;R $41 $0003
    STS     $0000  ,r24     ;W $BF $0000 r24 should be 191
    STS     $0000  ,r21     ;W $6B $0000 r21 should be 107
    STS     $0000  ,r1      ;W $09 $0000 r1 should be 9
    STS     $0000  ,r28     ;W $06 $0000 r28 should be 6
    STS     $0000  ,r8      ;W $B7 $0000 r8 should be 183
    STS     $0000  ,r2      ;W $B6 $0000 r2 should be 182
    STS     $0000  ,r11     ;W $7E $0000 r11 should be 126
    STS     $0000  ,r29     ;W $41 $0000 r29 should be 65

; do a few simple LDs from Y register
    LDI     r28    ,$04     ;            set Y to $0004
    LDI     r29    ,$00     ;
    LD      r0     ,Y       ;R $EC $0004
    STS     $0000  ,r0      ;W $EC $0000 r0 should be 236
    LD      r8     ,Y       ;R $EC $0004
    STS     $0000  ,r8      ;W $EC $0000 r8 should be 236
    LD      r31    ,Y       ;R $EC $0004
    STS     $0000  ,r31     ;W $EC $0000 r31 should be 236

; load with pre decrement through 0x0000
    LD      r20    ,-Y      ;R $2D $0003
    LD      r19    ,-Y      ;R $1B $0002
    LD      r9     ,-Y      ;R $EC $0001
    LD      r21    ,-Y      ;R $A7 $0000
    LD      r17    ,-Y      ;R $14 $FFFF
    LD      r31    ,-Y      ;R $6A $FFFE
    LD      r4     ,-Y      ;R $ED $FFFD
    LD      r10    ,-Y      ;R $58 $FFFC
    STS     $0000  ,r20     ;W $2D $0000 r20 should be 45
    STS     $0000  ,r19     ;W $1B $0000 r19 should be 27
    STS     $0000  ,r9      ;W $EC $0000 r9 should be 236
    STS     $0000  ,r21     ;W $A7 $0000 r21 should be 167
    STS     $0000  ,r17     ;W $14 $0000 r17 should be 20
    STS     $0000  ,r31     ;W $6A $0000 r31 should be 106
    STS     $0000  ,r4      ;W $ED $0000 r4 should be 237
    STS     $0000  ,r10     ;W $58 $0000 r10 should be 88

; load with post increment through 0xFFFF
    LD      r21    ,Y+      ;R $A0 $FFFC
    LD      r18    ,Y+      ;R $61 $FFFD
    LD      r25    ,Y+      ;R $51 $FFFE
    LD      r17    ,Y+      ;R $06 $FFFF
    LD      r7     ,Y+      ;R $3A $0000
    LD      r11    ,Y+      ;R $67 $0001
    LD      r12    ,Y+      ;R $D2 $0002
    LD      r14    ,Y+      ;R $BA $0003
    STS     $0000  ,r21     ;W $A0 $0000 r21 should be 160
    STS     $0000  ,r18     ;W $61 $0000 r18 should be 97
    STS     $0000  ,r25     ;W $51 $0000 r25 should be 81
    STS     $0000  ,r17     ;W $06 $0000 r17 should be 6
    STS     $0000  ,r7      ;W $3A $0000 r7 should be 58
    STS     $0000  ,r11     ;W $67 $0000 r11 should be 103
    STS     $0000  ,r12     ;W $D2 $0000 r12 should be 210
    STS     $0000  ,r14     ;W $BA $0000 r14 should be 186

; do a few simple LDs from Z register
    LDI     r30    ,$04     ;            set Z to $0004
    LDI     r31    ,$00     ;
    LD      r0     ,Z       ;R $EC $0004
    STS     $0000  ,r0      ;W $EC $0000 r0 should be 236
    LD      r8     ,Z       ;R $EC $0004
    STS     $0000  ,r8      ;W $EC $0000 r8 should be 236
    LD      r31    ,Z       ;R $EC $0004
    STS     $0000  ,r31     ;W $EC $0000 r31 should be 236

; load with pre decrement through 0x0000
    LD      r9     ,-Z      ;R $F8 $0003
    LD      r10    ,-Z      ;R $9A $0002
    LD      r27    ,-Z      ;R $0C $0001
    LD      r19    ,-Z      ;R $B5 $0000
    LD      r14    ,-Z      ;R $CA $FFFF
    LD      r12    ,-Z      ;R $18 $FFFE
    LD      r26    ,-Z      ;R $C0 $FFFD
    LD      r11    ,-Z      ;R $5C $FFFC
    STS     $0000  ,r9      ;W $F8 $0000 r9 should be 248
    STS     $0000  ,r10     ;W $9A $0000 r10 should be 154
    STS     $0000  ,r27     ;W $0C $0000 r27 should be 12
    STS     $0000  ,r19     ;W $B5 $0000 r19 should be 181
    STS     $0000  ,r14     ;W $CA $0000 r14 should be 202
    STS     $0000  ,r12     ;W $18 $0000 r12 should be 24
    STS     $0000  ,r26     ;W $C0 $0000 r26 should be 192
    STS     $0000  ,r11     ;W $5C $0000 r11 should be 92

; load with post increment through 0xFFFF
    LD      r23    ,Z+      ;R $32 $FFFC
    LD      r12    ,Z+      ;R $5D $FFFD
    LD      r29    ,Z+      ;R $85 $FFFE
    LD      r26    ,Z+      ;R $3F $FFFF
    LD      r7     ,Z+      ;R $BA $0000
    LD      r16    ,Z+      ;R $04 $0001
    LD      r11    ,Z+      ;R $7C $0002
    LD      r22    ,Z+      ;R $55 $0003
    STS     $0000  ,r23     ;W $32 $0000 r23 should be 50
    STS     $0000  ,r12     ;W $5D $0000 r12 should be 93
    STS     $0000  ,r29     ;W $85 $0000 r29 should be 133
    STS     $0000  ,r26     ;W $3F $0000 r26 should be 63
    STS     $0000  ,r7      ;W $BA $0000 r7 should be 186
    STS     $0000  ,r16     ;W $04 $0000 r16 should be 4
    STS     $0000  ,r11     ;W $7C $0000 r11 should be 124
    STS     $0000  ,r22     ;W $55 $0000 r22 should be 85



;PREPROCESS TestLDD

    LDI     r28    ,$E0     ;            set Y to $FFE0
    LDI     r29    ,$FF     ;
    LDD     r16    ,Y+0     ;R $FE $FFE0
    LDD     r24    ,Y+48    ;R $07 $0010
    LDD     r7     ,Y+14    ;R $04 $FFEE
    LDD     r16    ,Y+49    ;R $F7 $0011
    LDD     r9     ,Y+47    ;R $06 $000F
    LDD     r17    ,Y+27    ;R $1D $FFFB
    LDD     r5     ,Y+39    ;R $43 $0007
    LDD     r23    ,Y+63    ;R $1D $001F
    STS     $0000  ,r16     ;W $FE $0000 r16 should be 254
    STS     $0000  ,r24     ;W $07 $0000 r24 should be 7
    STS     $0000  ,r7      ;W $04 $0000 r7 should be 4
    STS     $0000  ,r16     ;W $F7 $0000 r16 should be 247
    STS     $0000  ,r9      ;W $06 $0000 r9 should be 6
    STS     $0000  ,r17     ;W $1D $0000 r17 should be 29
    STS     $0000  ,r5      ;W $43 $0000 r5 should be 67
    STS     $0000  ,r23     ;W $1D $0000 r23 should be 29
    LDI     r30    ,$E0     ;            set Z to $FFE0
    LDI     r31    ,$FF     ;
    LDD     r5     ,Z+0     ;R $0D $FFE0
    LDD     r1     ,Z+60    ;R $49 $001C
    LDD     r21    ,Z+54    ;R $0E $0016
    LDD     r9     ,Z+2     ;R $B4 $FFE2
    LDD     r28    ,Z+33    ;R $3E $0001
    LDD     r15    ,Z+17    ;R $3A $FFF1
    LDD     r4     ,Z+61    ;R $69 $001D
    LDD     r19    ,Z+63    ;R $40 $001F
    STS     $0000  ,r5      ;W $0D $0000 r5 should be 13
    STS     $0000  ,r1      ;W $49 $0000 r1 should be 73
    STS     $0000  ,r21     ;W $0E $0000 r21 should be 14
    STS     $0000  ,r9      ;W $B4 $0000 r9 should be 180
    STS     $0000  ,r28     ;W $3E $0000 r28 should be 62
    STS     $0000  ,r15     ;W $3A $0000 r15 should be 58
    STS     $0000  ,r4      ;W $69 $0000 r4 should be 105
    STS     $0000  ,r19     ;W $40 $0000 r19 should be 64



;PREPROCESS TestLDS


; do a few simple LDSs
    LDS     r0     ,$0000   ;R $EC $0000
    STS     $0000  ,r0      ;W $EC $0000 r0 should be 236
    LDS     r15    ,$FF00   ;R $EC $FF00
    STS     $0000  ,r15     ;W $EC $0000 r15 should be 236
    LDS     r30    ,$FFFF   ;R $EC $FFFF
    STS     $0000  ,r30     ;W $EC $0000 r30 should be 236

; do some random LDSs
    LDS     r26    ,$B2E9   ;R $50 $B2E9
    LDS     r4     ,$804A   ;R $7C $804A
    LDS     r12    ,$F661   ;R $DF $F661
    LDS     r28    ,$259D   ;R $82 $259D
    LDS     r17    ,$4682   ;R $D4 $4682
    LDS     r29    ,$A5FB   ;R $EC $A5FB
    LDS     r8     ,$5FE1   ;R $3C $5FE1
    LDS     r30    ,$FDC3   ;R $F5 $FDC3
    LDS     r14    ,$194E   ;R $EC $194E
    LDS     r13    ,$BA78   ;R $32 $BA78
    STS     $0000  ,r26     ;W $50 $0000 r26 should be 80
    STS     $0000  ,r4      ;W $7C $0000 r4 should be 124
    STS     $0000  ,r12     ;W $DF $0000 r12 should be 223
    STS     $0000  ,r28     ;W $82 $0000 r28 should be 130
    STS     $0000  ,r17     ;W $D4 $0000 r17 should be 212
    STS     $0000  ,r29     ;W $EC $0000 r29 should be 236
    STS     $0000  ,r8      ;W $3C $0000 r8 should be 60
    STS     $0000  ,r30     ;W $F5 $0000 r30 should be 245
    STS     $0000  ,r14     ;W $EC $0000 r14 should be 236
    STS     $0000  ,r13     ;W $32 $0000 r13 should be 50



;PREPROCESS TestMOV


; do a few simple MOVs
    LDS     r0     ,$0000   ;R $D2 $0000
    MOV     r0     ,r1      ;
    STS     $0000  ,r1      ;W $D2 $0000 r1 should be 210
    LDS     r31    ,$0000   ;R $99 $0000
    MOV     r31    ,r30     ;
    STS     $0000  ,r30     ;W $99 $0000 r30 should be 153

; do a random move through all registers
    LDS     r13    ,$0000   ;R $AB $0000
    MOV     r13    ,r17     ;
    MOV     r17    ,r21     ;
    MOV     r21    ,r20     ;
    MOV     r20    ,r16     ;
    MOV     r16    ,r12     ;
    MOV     r12    ,r11     ;
    MOV     r11    ,r5      ;
    MOV     r5     ,r6      ;
    MOV     r6     ,r4      ;
    MOV     r4     ,r31     ;
    MOV     r31    ,r1      ;
    MOV     r1     ,r28     ;
    MOV     r28    ,r30     ;
    MOV     r30    ,r23     ;
    MOV     r23    ,r24     ;
    MOV     r24    ,r22     ;
    MOV     r22    ,r15     ;
    MOV     r15    ,r0      ;
    MOV     r0     ,r27     ;
    MOV     r27    ,r14     ;
    MOV     r14    ,r8      ;
    MOV     r8     ,r7      ;
    MOV     r7     ,r29     ;
    MOV     r29    ,r10     ;
    MOV     r10    ,r26     ;
    MOV     r26    ,r19     ;
    MOV     r19    ,r18     ;
    MOV     r18    ,r9      ;
    MOV     r9     ,r25     ;
    MOV     r25    ,r2      ;
    MOV     r2     ,r3      ;
    STS     $0000  ,r3      ;W $AB $0000 r3 should be 171



;PREPROCESS TestST

    LDI     r26    ,$04     ;            set X to $0004
    LDI     r27    ,$00     ;
    LDS     r0     ,$0000   ;R $EC $0000 set r0 to 236
    ST      X      ,r0      ;W $EC $0004
    LDS     r8     ,$0000   ;R $EC $0000 set r8 to 236
    ST      X      ,r8      ;W $EC $0004
    LDS     r31    ,$0000   ;R $EC $0000 set r31 to 236
    ST      X      ,r31     ;W $EC $0004

; store with pre decrement through 0x0000
    LDS     r25    ,$0000   ;R $CA $0000 set r25 to 202
    LDS     r13    ,$0000   ;R $00 $0000 set r13 to 0
    LDS     r17    ,$0000   ;R $FD $0000 set r17 to 253
    LDS     r14    ,$0000   ;R $A9 $0000 set r14 to 169
    LDS     r20    ,$0000   ;R $EE $0000 set r20 to 238
    LDS     r11    ,$0000   ;R $34 $0000 set r11 to 52
    LDS     r15    ,$0000   ;R $29 $0000 set r15 to 41
    LDS     r24    ,$0000   ;R $BB $0000 set r24 to 187
    ST      -X     ,r25     ;W $CA $0003
    ST      -X     ,r13     ;W $00 $0002
    ST      -X     ,r17     ;W $FD $0001
    ST      -X     ,r14     ;W $A9 $0000
    ST      -X     ,r20     ;W $EE $FFFF
    ST      -X     ,r11     ;W $34 $FFFE
    ST      -X     ,r15     ;W $29 $FFFD
    ST      -X     ,r24     ;W $BB $FFFC

; store with post increment through 0xFFFF
    LDS     r6     ,$0000   ;R $81 $0000 set r6 to 129
    LDS     r15    ,$0000   ;R $84 $0000 set r15 to 132
    LDS     r9     ,$0000   ;R $13 $0000 set r9 to 19
    LDS     r11    ,$0000   ;R $BB $0000 set r11 to 187
    LDS     r7     ,$0000   ;R $0D $0000 set r7 to 13
    LDS     r28    ,$0000   ;R $66 $0000 set r28 to 102
    LDS     r4     ,$0000   ;R $B5 $0000 set r4 to 181
    LDS     r24    ,$0000   ;R $9A $0000 set r24 to 154
    ST      X+     ,r6      ;W $81 $FFFC
    ST      X+     ,r15     ;W $84 $FFFD
    ST      X+     ,r9      ;W $13 $FFFE
    ST      X+     ,r11     ;W $BB $FFFF
    ST      X+     ,r7      ;W $0D $0000
    ST      X+     ,r28     ;W $66 $0001
    ST      X+     ,r4      ;W $B5 $0002
    ST      X+     ,r24     ;W $9A $0003
    LDI     r28    ,$04     ;            set Y to $0004
    LDI     r29    ,$00     ;
    LDS     r0     ,$0000   ;R $EC $0000 set r0 to 236
    ST      Y      ,r0      ;W $EC $0004
    LDS     r8     ,$0000   ;R $EC $0000 set r8 to 236
    ST      Y      ,r8      ;W $EC $0004
    LDS     r31    ,$0000   ;R $EC $0000 set r31 to 236
    ST      Y      ,r31     ;W $EC $0004

; store with pre decrement through 0x0000
    LDS     r4     ,$0000   ;R $F7 $0000 set r4 to 247
    LDS     r0     ,$0000   ;R $BF $0000 set r0 to 191
    LDS     r15    ,$0000   ;R $29 $0000 set r15 to 41
    LDS     r1     ,$0000   ;R $4E $0000 set r1 to 78
    LDS     r27    ,$0000   ;R $58 $0000 set r27 to 88
    LDS     r7     ,$0000   ;R $85 $0000 set r7 to 133
    LDS     r23    ,$0000   ;R $2E $0000 set r23 to 46
    LDS     r10    ,$0000   ;R $9C $0000 set r10 to 156
    ST      -Y     ,r4      ;W $F7 $0003
    ST      -Y     ,r0      ;W $BF $0002
    ST      -Y     ,r15     ;W $29 $0001
    ST      -Y     ,r1      ;W $4E $0000
    ST      -Y     ,r27     ;W $58 $FFFF
    ST      -Y     ,r7      ;W $85 $FFFE
    ST      -Y     ,r23     ;W $2E $FFFD
    ST      -Y     ,r10     ;W $9C $FFFC

; store with post increment through 0xFFFF
    LDS     r1     ,$0000   ;R $05 $0000 set r1 to 5
    LDS     r31    ,$0000   ;R $D6 $0000 set r31 to 214
    LDS     r18    ,$0000   ;R $9F $0000 set r18 to 159
    LDS     r2     ,$0000   ;R $9A $0000 set r2 to 154
    LDS     r19    ,$0000   ;R $CB $0000 set r19 to 203
    LDS     r3     ,$0000   ;R $F5 $0000 set r3 to 245
    LDS     r7     ,$0000   ;R $AD $0000 set r7 to 173
    LDS     r14    ,$0000   ;R $2A $0000 set r14 to 42
    ST      Y+     ,r1      ;W $05 $FFFC
    ST      Y+     ,r31     ;W $D6 $FFFD
    ST      Y+     ,r18     ;W $9F $FFFE
    ST      Y+     ,r2      ;W $9A $FFFF
    ST      Y+     ,r19     ;W $CB $0000
    ST      Y+     ,r3      ;W $F5 $0001
    ST      Y+     ,r7      ;W $AD $0002
    ST      Y+     ,r14     ;W $2A $0003
    LDI     r30    ,$04     ;            set Z to $0004
    LDI     r31    ,$00     ;
    LDS     r0     ,$0000   ;R $EC $0000 set r0 to 236
    ST      Z      ,r0      ;W $EC $0004
    LDS     r8     ,$0000   ;R $EC $0000 set r8 to 236
    ST      Z      ,r8      ;W $EC $0004
    LDS     r31    ,$0000   ;R $EC $0000 set r31 to 236
    ST      Z      ,r31     ;W $EC $0004

; store with pre decrement through 0x0000
    LDS     r12    ,$0000   ;R $51 $0000 set r12 to 81
    LDS     r8     ,$0000   ;R $DF $0000 set r8 to 223
    LDS     r10    ,$0000   ;R $CC $0000 set r10 to 204
    LDS     r2     ,$0000   ;R $C2 $0000 set r2 to 194
    LDS     r5     ,$0000   ;R $91 $0000 set r5 to 145
    LDS     r13    ,$0000   ;R $9B $0000 set r13 to 155
    LDS     r28    ,$0000   ;R $A3 $0000 set r28 to 163
    LDS     r22    ,$0000   ;R $55 $0000 set r22 to 85
    ST      -Z     ,r12     ;W $51 $0003
    ST      -Z     ,r8      ;W $DF $0002
    ST      -Z     ,r10     ;W $CC $0001
    ST      -Z     ,r2      ;W $C2 $0000
    ST      -Z     ,r5      ;W $91 $FFFF
    ST      -Z     ,r13     ;W $9B $FFFE
    ST      -Z     ,r28     ;W $A3 $FFFD
    ST      -Z     ,r22     ;W $55 $FFFC

; store with post increment through 0xFFFF
    LDS     r28    ,$0000   ;R $9E $0000 set r28 to 158
    LDS     r1     ,$0000   ;R $1D $0000 set r1 to 29
    LDS     r6     ,$0000   ;R $C3 $0000 set r6 to 195
    LDS     r14    ,$0000   ;R $F0 $0000 set r14 to 240
    LDS     r9     ,$0000   ;R $51 $0000 set r9 to 81
    LDS     r19    ,$0000   ;R $6A $0000 set r19 to 106
    LDS     r12    ,$0000   ;R $17 $0000 set r12 to 23
    LDS     r23    ,$0000   ;R $99 $0000 set r23 to 153
    ST      Z+     ,r28     ;W $9E $FFFC
    ST      Z+     ,r1      ;W $1D $FFFD
    ST      Z+     ,r6      ;W $C3 $FFFE
    ST      Z+     ,r14     ;W $F0 $FFFF
    ST      Z+     ,r9      ;W $51 $0000
    ST      Z+     ,r19     ;W $6A $0001
    ST      Z+     ,r12     ;W $17 $0002
    ST      Z+     ,r23     ;W $99 $0003



;PREPROCESS TestSTD

    LDI     r28    ,$E0     ;            set Y to $FFE0
    LDI     r29    ,$FF     ;
    LDS     rr1    ,$0000   ;R $5F $0000 set rr1 to 95
    LDS     rr11   ,$0000   ;R $88 $0000 set rr11 to 136
    LDS     rr22   ,$0000   ;R $AF $0000 set rr22 to 175
    LDS     rr23   ,$0000   ;R $4D $0000 set rr23 to 77
    LDS     rr6    ,$0000   ;R $AA $0000 set rr6 to 170
    LDS     rr23   ,$0000   ;R $DB $0000 set rr23 to 219
    LDS     rr27   ,$0000   ;R $DC $0000 set rr27 to 220
    LDS     rr3    ,$0000   ;R $65 $0000 set rr3 to 101
    STD     Y+0    ,r1      ;W $5F $FFE0
    STD     Y+27   ,r11     ;W $88 $FFFB
    STD     Y+30   ,r22     ;W $AF $FFFE
    STD     Y+5    ,r23     ;W $4D $FFE5
    STD     Y+14   ,r6      ;W $AA $FFEE
    STD     Y+28   ,r23     ;W $DB $FFFC
    STD     Y+50   ,r27     ;W $DC $0012
    STD     Y+63   ,r3      ;W $65 $001F
    LDI     r30    ,$E0     ;            set Z to $FFE0
    LDI     r31    ,$FF     ;
    LDS     rr23   ,$0000   ;R $A3 $0000 set rr23 to 163
    LDS     rr5    ,$0000   ;R $C8 $0000 set rr5 to 200
    LDS     rr11   ,$0000   ;R $2C $0000 set rr11 to 44
    LDS     rr16   ,$0000   ;R $B9 $0000 set rr16 to 185
    LDS     rr0    ,$0000   ;R $09 $0000 set rr0 to 9
    LDS     rr22   ,$0000   ;R $F6 $0000 set rr22 to 246
    LDS     rr2    ,$0000   ;R $B6 $0000 set rr2 to 182
    LDS     rr7    ,$0000   ;R $46 $0000 set rr7 to 70
    STD     Z+0    ,r23     ;W $A3 $FFE0
    STD     Z+60   ,r5      ;W $C8 $001C
    STD     Z+36   ,r11     ;W $2C $0004
    STD     Z+26   ,r16     ;W $B9 $FFFA
    STD     Z+56   ,r0      ;W $09 $0018
    STD     Z+33   ,r22     ;W $F6 $0001
    STD     Z+44   ,r2      ;W $B6 $000C
    STD     Z+63   ,r7      ;W $46 $001F



;PREPROCESS TestSTS


; do a few simple STSs
    LDS     r0     ,$0000   ;R $EC $0000 set r0 to 236
    STS     $0000  ,r0      ;W $EC $0000
    LDS     r15    ,$0000   ;R $EC $0000 set r15 to 236
    STS     $FF00  ,r15     ;W $EC $FF00
    LDS     r30    ,$0000   ;R $EC $0000 set r30 to 236
    STS     $FFFF  ,r30     ;W $EC $FFFF

; do some random STSs
    LDS     r29    ,$0000   ;R $54 $0000 set r29 to 84
    LDS     r4     ,$0000   ;R $30 $0000 set r4 to 48
    LDS     r22    ,$0000   ;R $36 $0000 set r22 to 54
    LDS     r2     ,$0000   ;R $9C $0000 set r2 to 156
    LDS     r1     ,$0000   ;R $BC $0000 set r1 to 188
    LDS     r14    ,$0000   ;R $D3 $0000 set r14 to 211
    LDS     r5     ,$0000   ;R $42 $0000 set r5 to 66
    LDS     r30    ,$0000   ;R $D1 $0000 set r30 to 209
    LDS     r6     ,$0000   ;R $F3 $0000 set r6 to 243
    LDS     r12    ,$0000   ;R $C2 $0000 set r12 to 194
    STS     $D8A7  ,r29     ;W $54 $D8A7
    STS     $DFED  ,r4      ;W $30 $DFED
    STS     $405C  ,r22     ;W $36 $405C
    STS     $FB75  ,r2      ;W $9C $FB75
    STS     $B2EF  ,r1      ;W $BC $B2EF
    STS     $32A0  ,r14     ;W $D3 $32A0
    STS     $FC71  ,r5      ;W $42 $FC71
    STS     $1A69  ,r30     ;W $D1 $1A69
    STS     $0E9F  ,r6      ;W $F3 $0E9F
    STS     $EC87  ,r12     ;W $C2 $EC87

;PREPROCESS TestPOP

;PREPROCESS TestPOP

; load some random values into registers
    LDS     r21    ,$0000   ;R $EC $0000 set r21 to 236
    LDS     r2     ,$0000   ;R $54 $0000 set r2 to 84
    LDS     r25    ,$0000   ;R $EE $0000 set r25 to 238
    LDS     r31    ,$0000   ;R $71 $0000 set r31 to 113
    LDS     r3     ,$0000   ;R $B4 $0000 set r3 to 180
    LDS     r10    ,$0000   ;R $D3 $0000 set r10 to 211
    LDS     r28    ,$0000   ;R $70 $0000 set r28 to 112
    LDS     r6     ,$0000   ;R $8C $0000 set r6 to 140
    LDS     r11    ,$0000   ;R $16 $0000 set r11 to 22
    LDS     r17    ,$0000   ;R $46 $0000 set r17 to 70
    LDS     r14    ,$0000   ;R $47 $0000 set r14 to 71
    LDS     r20    ,$0000   ;R $26 $0000 set r20 to 38
    LDS     r18    ,$0000   ;R $43 $0000 set r18 to 67
    LDS     r7     ,$0000   ;R $4B $0000 set r7 to 75
    LDS     r27    ,$0000   ;R $D0 $0000 set r27 to 208
    LDS     r30    ,$0000   ;R $F2 $0000 set r30 to 242
    LDS     r9     ,$0000   ;R $5E $0000 set r9 to 94
    LDS     r22    ,$0000   ;R $E1 $0000 set r22 to 225
    LDS     r24    ,$0000   ;R $A9 $0000 set r24 to 169
    LDS     r0     ,$0000   ;R $6B $0000 set r0 to 107
    LDS     r15    ,$0000   ;R $E4 $0000 set r15 to 228
    LDS     r16    ,$0000   ;R $BA $0000 set r16 to 186
    LDS     r12    ,$0000   ;R $E2 $0000 set r12 to 226
    LDS     r23    ,$0000   ;R $09 $0000 set r23 to 9
    LDS     r13    ,$0000   ;R $C8 $0000 set r13 to 200
    LDS     r29    ,$0000   ;R $C6 $0000 set r29 to 198
    LDS     r26    ,$0000   ;R $DF $0000 set r26 to 223
    LDS     r5     ,$0000   ;R $A9 $0000 set r5 to 169
    LDS     r1     ,$0000   ;R $19 $0000 set r1 to 25
    LDS     r4     ,$0000   ;R $65 $0000 set r4 to 101
    LDS     r19    ,$0000   ;R $31 $0000 set r19 to 49
    LDS     r8     ,$0000   ;R $E8 $0000 set r8 to 232

; push all the registers
    PUSH    r21             ;W $EC $0000
    PUSH    r2              ;W $54 $FFFF
    PUSH    r25             ;W $EE $FFFE
    PUSH    r31             ;W $71 $FFFD
    PUSH    r3              ;W $B4 $FFFC
    PUSH    r10             ;W $D3 $FFFB
    PUSH    r28             ;W $70 $FFFA
    PUSH    r6              ;W $8C $FFF9
    PUSH    r11             ;W $16 $FFF8
    PUSH    r17             ;W $46 $FFF7
    PUSH    r14             ;W $47 $FFF6
    PUSH    r20             ;W $26 $FFF5
    PUSH    r18             ;W $43 $FFF4
    PUSH    r7              ;W $4B $FFF3
    PUSH    r27             ;W $D0 $FFF2
    PUSH    r30             ;W $F2 $FFF1
    PUSH    r9              ;W $5E $FFF0
    PUSH    r22             ;W $E1 $FFEF
    PUSH    r24             ;W $A9 $FFEE
    PUSH    r0              ;W $6B $FFED
    PUSH    r15             ;W $E4 $FFEC
    PUSH    r16             ;W $BA $FFEB
    PUSH    r12             ;W $E2 $FFEA
    PUSH    r23             ;W $09 $FFE9
    PUSH    r13             ;W $C8 $FFE8
    PUSH    r29             ;W $C6 $FFE7
    PUSH    r26             ;W $DF $FFE6
    PUSH    r5              ;W $A9 $FFE5
    PUSH    r1              ;W $19 $FFE4
    PUSH    r4              ;W $65 $FFE3
    PUSH    r19             ;W $31 $FFE2
    PUSH    r8              ;W $E8 $FFE1

; pop all the registers
    POP     r8              ;R $E8 $FFE1
    POP     r19             ;R $31 $FFE2
    POP     r4              ;R $65 $FFE3
    POP     r1              ;R $19 $FFE4
    POP     r5              ;R $A9 $FFE5
    POP     r26             ;R $DF $FFE6
    POP     r29             ;R $C6 $FFE7
    POP     r13             ;R $C8 $FFE8
    POP     r23             ;R $09 $FFE9
    POP     r12             ;R $E2 $FFEA
    POP     r16             ;R $BA $FFEB
    POP     r15             ;R $E4 $FFEC
    POP     r0              ;R $6B $FFED
    POP     r24             ;R $A9 $FFEE
    POP     r22             ;R $E1 $FFEF
    POP     r9              ;R $5E $FFF0
    POP     r30             ;R $F2 $FFF1
    POP     r27             ;R $D0 $FFF2
    POP     r7              ;R $4B $FFF3
    POP     r18             ;R $43 $FFF4
    POP     r20             ;R $26 $FFF5
    POP     r14             ;R $47 $FFF6
    POP     r17             ;R $46 $FFF7
    POP     r11             ;R $16 $FFF8
    POP     r6              ;R $8C $FFF9
    POP     r28             ;R $70 $FFFA
    POP     r10             ;R $D3 $FFFB
    POP     r3              ;R $B4 $FFFC
    POP     r31             ;R $71 $FFFD
    POP     r25             ;R $EE $FFFE
    POP     r2              ;R $54 $FFFF
    POP     r21             ;R $EC $0000

; check all the values are unchanged
    STS     $0000  ,r21     ;W $EC $0000 r21 should be 236
    STS     $0000  ,r2      ;W $54 $0000 r2 should be 84
    STS     $0000  ,r25     ;W $EE $0000 r25 should be 238
    STS     $0000  ,r31     ;W $71 $0000 r31 should be 113
    STS     $0000  ,r3      ;W $B4 $0000 r3 should be 180
    STS     $0000  ,r10     ;W $D3 $0000 r10 should be 211
    STS     $0000  ,r28     ;W $70 $0000 r28 should be 112
    STS     $0000  ,r6      ;W $8C $0000 r6 should be 140
    STS     $0000  ,r11     ;W $16 $0000 r11 should be 22
    STS     $0000  ,r17     ;W $46 $0000 r17 should be 70
    STS     $0000  ,r14     ;W $47 $0000 r14 should be 71
    STS     $0000  ,r20     ;W $26 $0000 r20 should be 38
    STS     $0000  ,r18     ;W $43 $0000 r18 should be 67
    STS     $0000  ,r7      ;W $4B $0000 r7 should be 75
    STS     $0000  ,r27     ;W $D0 $0000 r27 should be 208
    STS     $0000  ,r30     ;W $F2 $0000 r30 should be 242
    STS     $0000  ,r9      ;W $5E $0000 r9 should be 94
    STS     $0000  ,r22     ;W $E1 $0000 r22 should be 225
    STS     $0000  ,r24     ;W $A9 $0000 r24 should be 169
    STS     $0000  ,r0      ;W $6B $0000 r0 should be 107
    STS     $0000  ,r15     ;W $E4 $0000 r15 should be 228
    STS     $0000  ,r16     ;W $BA $0000 r16 should be 186
    STS     $0000  ,r12     ;W $E2 $0000 r12 should be 226
    STS     $0000  ,r23     ;W $09 $0000 r23 should be 9
    STS     $0000  ,r13     ;W $C8 $0000 r13 should be 200
    STS     $0000  ,r29     ;W $C6 $0000 r29 should be 198
    STS     $0000  ,r26     ;W $DF $0000 r26 should be 223
    STS     $0000  ,r5      ;W $A9 $0000 r5 should be 169
    STS     $0000  ,r1      ;W $19 $0000 r1 should be 25
    STS     $0000  ,r4      ;W $65 $0000 r4 should be 101
    STS     $0000  ,r19     ;W $31 $0000 r19 should be 49
    STS     $0000  ,r8      ;W $E8 $0000 r8 should be 232