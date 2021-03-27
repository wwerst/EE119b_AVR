
; Tests the data movement instructions
; THIS FILE IS GENERATED
; for explanations or modifications, see notebook datamove.ipynb

; Note, we attempt to verify the behavior of the load instructions
; by writing registers out with STS-
; the load tests assume STS is functional.




;PREPROCESS TestLDI

; do a few simple LDIs
    LDI     r16    ,$00     ;
    STS     $0000  ,r16     ;W 00 0000   r16 should be 0
    LDI     r17    ,$FF     ;
    STS     $0000  ,r17     ;W FF 0000   r17 should be 255
    LDI     r18    ,$0F     ;
    STS     $0000  ,r18     ;W 0F 0000   r18 should be 15

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
    STS     $0000  ,r16     ;W EC 0000   r16 should be 236
    STS     $0000  ,r17     ;W EC 0000   r17 should be 236
    STS     $0000  ,r18     ;W EC 0000   r18 should be 236
    STS     $0000  ,r19     ;W EC 0000   r19 should be 236
    STS     $0000  ,r20     ;W EC 0000   r20 should be 236
    STS     $0000  ,r21     ;W EC 0000   r21 should be 236
    STS     $0000  ,r22     ;W EC 0000   r22 should be 236
    STS     $0000  ,r23     ;W EC 0000   r23 should be 236
    STS     $0000  ,r24     ;W EC 0000   r24 should be 236
    STS     $0000  ,r25     ;W EC 0000   r25 should be 236
    STS     $0000  ,r26     ;W EC 0000   r26 should be 236
    STS     $0000  ,r27     ;W EC 0000   r27 should be 236
    STS     $0000  ,r28     ;W EC 0000   r28 should be 236
    STS     $0000  ,r29     ;W EC 0000   r29 should be 236
    STS     $0000  ,r30     ;W EC 0000   r30 should be 236
    STS     $0000  ,r31     ;W EC 0000   r31 should be 236

; do some random LDIs
    LDI     r19    ,$D8     ;
    LDI     r16    ,$10     ;
    LDI     r27    ,$0F     ;
    LDI     r20    ,$2F     ;
    LDI     r31    ,$6F     ;
    LDI     r29    ,$77     ;
    LDI     r18    ,$0D     ;
    LDI     r17    ,$65     ;
    LDI     r24    ,$D6     ;
    LDI     r28    ,$70     ;
    STS     $0000  ,r19     ;W D8 0000   r19 should be 216
    STS     $0000  ,r16     ;W 10 0000   r16 should be 16
    STS     $0000  ,r27     ;W 0F 0000   r27 should be 15
    STS     $0000  ,r20     ;W 2F 0000   r20 should be 47
    STS     $0000  ,r31     ;W 6F 0000   r31 should be 111
    STS     $0000  ,r29     ;W 77 0000   r29 should be 119
    STS     $0000  ,r18     ;W 0D 0000   r18 should be 13
    STS     $0000  ,r17     ;W 65 0000   r17 should be 101
    STS     $0000  ,r24     ;W D6 0000   r24 should be 214
    STS     $0000  ,r28     ;W 70 0000   r28 should be 112



;PREPROCESS TestLD


; do a few simple LDs from X register
    LDI     r26    ,$04     ;            set X to $0004
    LDI     r27    ,$00     ;
    LD      r0     ,X       ;R EC 0004
    STS     $0000  ,r0      ;W EC 0000   r0 should be 236
    LD      r8     ,X       ;R EC 0004
    STS     $0000  ,r8      ;W EC 0000   r8 should be 236
    LD      r25    ,X       ;R EC 0004
    STS     $0000  ,r25     ;W EC 0000   r25 should be 236

; load with pre decrement through 0x0000
    LD      r14    ,-X      ;R D8 0003
    LD      r18    ,-X      ;R AE 0002
    LD      r8     ,-X      ;R 8E 0001
    LD      r25    ,-X      ;R 4F 0000
    LD      r0     ,-X      ;R 6E FFFF
    LD      r24    ,-X      ;R AC FFFE
    LD      r5     ,-X      ;R 34 FFFD
    LD      r22    ,-X      ;R 2F FFFC
    STS     $0000  ,r14     ;W D8 0000   r14 should be 216
    STS     $0000  ,r18     ;W AE 0000   r18 should be 174
    STS     $0000  ,r8      ;W 8E 0000   r8 should be 142
    STS     $0000  ,r25     ;W 4F 0000   r25 should be 79
    STS     $0000  ,r0      ;W 6E 0000   r0 should be 110
    STS     $0000  ,r24     ;W AC 0000   r24 should be 172
    STS     $0000  ,r5      ;W 34 0000   r5 should be 52
    STS     $0000  ,r22     ;W 2F 0000   r22 should be 47

; load with post increment through 0xFFFF
    LD      r12    ,X+      ;R 3F FFFC
    LD      r3     ,X+      ;R C1 FFFD
    LD      r11    ,X+      ;R 28 FFFE
    LD      r29    ,X+      ;R 96 FFFF
    LD      r19    ,X+      ;R B9 0000
    LD      r8     ,X+      ;R 62 0001
    LD      r1     ,X+      ;R 23 0002
    LD      r14    ,X+      ;R 17 0003
    STS     $0000  ,r12     ;W 3F 0000   r12 should be 63
    STS     $0000  ,r3      ;W C1 0000   r3 should be 193
    STS     $0000  ,r11     ;W 28 0000   r11 should be 40
    STS     $0000  ,r29     ;W 96 0000   r29 should be 150
    STS     $0000  ,r19     ;W B9 0000   r19 should be 185
    STS     $0000  ,r8      ;W 62 0000   r8 should be 98
    STS     $0000  ,r1      ;W 23 0000   r1 should be 35
    STS     $0000  ,r14     ;W 17 0000   r14 should be 23

; do a few simple LDs from Y register
    LDI     r28    ,$04     ;            set Y to $0004
    LDI     r29    ,$00     ;
    LD      r0     ,Y       ;R EC 0004
    STS     $0000  ,r0      ;W EC 0000   r0 should be 236
    LD      r8     ,Y       ;R EC 0004
    STS     $0000  ,r8      ;W EC 0000   r8 should be 236
    LD      r25    ,Y       ;R EC 0004
    STS     $0000  ,r25     ;W EC 0000   r25 should be 236

; load with pre decrement through 0x0000
    LD      r21    ,-Y      ;R 8E 0003
    LD      r7     ,-Y      ;R E8 0002
    LD      r24    ,-Y      ;R BA 0001
    LD      r9     ,-Y      ;R 53 0000
    LD      r2     ,-Y      ;R BD FFFF
    LD      r30    ,-Y      ;R B5 FFFE
    LD      r3     ,-Y      ;R 6B FFFD
    LD      r12    ,-Y      ;R 88 FFFC
    STS     $0000  ,r21     ;W 8E 0000   r21 should be 142
    STS     $0000  ,r7      ;W E8 0000   r7 should be 232
    STS     $0000  ,r24     ;W BA 0000   r24 should be 186
    STS     $0000  ,r9      ;W 53 0000   r9 should be 83
    STS     $0000  ,r2      ;W BD 0000   r2 should be 189
    STS     $0000  ,r30     ;W B5 0000   r30 should be 181
    STS     $0000  ,r3      ;W 6B 0000   r3 should be 107
    STS     $0000  ,r12     ;W 88 0000   r12 should be 136

; load with post increment through 0xFFFF
    LD      r22    ,Y+      ;R 7D FFFC
    LD      r21    ,Y+      ;R 53 FFFD
    LD      r20    ,Y+      ;R EC FFFE
    LD      r2     ,Y+      ;R C2 FFFF
    LD      r19    ,Y+      ;R 8A 0000
    LD      r27    ,Y+      ;R 70 0001
    LD      r5     ,Y+      ;R A6 0002
    LD      r17    ,Y+      ;R 1C 0003
    STS     $0000  ,r22     ;W 7D 0000   r22 should be 125
    STS     $0000  ,r21     ;W 53 0000   r21 should be 83
    STS     $0000  ,r20     ;W EC 0000   r20 should be 236
    STS     $0000  ,r2      ;W C2 0000   r2 should be 194
    STS     $0000  ,r19     ;W 8A 0000   r19 should be 138
    STS     $0000  ,r27     ;W 70 0000   r27 should be 112
    STS     $0000  ,r5      ;W A6 0000   r5 should be 166
    STS     $0000  ,r17     ;W 1C 0000   r17 should be 28

; do a few simple LDs from Z register
    LDI     r30    ,$04     ;            set Z to $0004
    LDI     r31    ,$00     ;
    LD      r0     ,Z       ;R EC 0004
    STS     $0000  ,r0      ;W EC 0000   r0 should be 236
    LD      r8     ,Z       ;R EC 0004
    STS     $0000  ,r8      ;W EC 0000   r8 should be 236
    LD      r25    ,Z       ;R EC 0004
    STS     $0000  ,r25     ;W EC 0000   r25 should be 236

; load with pre decrement through 0x0000
    LD      r7     ,-Z      ;R 6C 0003
    LD      r26    ,-Z      ;R A1 0002
    LD      r1     ,-Z      ;R 6C 0001
    LD      r25    ,-Z      ;R FF 0000
    LD      r10    ,-Z      ;R CA FFFF
    LD      r12    ,-Z      ;R EA FFFE
    LD      r8     ,-Z      ;R 49 FFFD
    LD      r2     ,-Z      ;R 87 FFFC
    STS     $0000  ,r7      ;W 6C 0000   r7 should be 108
    STS     $0000  ,r26     ;W A1 0000   r26 should be 161
    STS     $0000  ,r1      ;W 6C 0000   r1 should be 108
    STS     $0000  ,r25     ;W FF 0000   r25 should be 255
    STS     $0000  ,r10     ;W CA 0000   r10 should be 202
    STS     $0000  ,r12     ;W EA 0000   r12 should be 234
    STS     $0000  ,r8      ;W 49 0000   r8 should be 73
    STS     $0000  ,r2      ;W 87 0000   r2 should be 135

; load with post increment through 0xFFFF
    LD      r4     ,Z+      ;R DB FFFC
    LD      r7     ,Z+      ;R CC FFFD
    LD      r23    ,Z+      ;R B9 FFFE
    LD      r17    ,Z+      ;R 70 FFFF
    LD      r26    ,Z+      ;R 46 0000
    LD      r8     ,Z+      ;R FC 0001
    LD      r27    ,Z+      ;R 2E 0002
    LD      r18    ,Z+      ;R 18 0003
    STS     $0000  ,r4      ;W DB 0000   r4 should be 219
    STS     $0000  ,r7      ;W CC 0000   r7 should be 204
    STS     $0000  ,r23     ;W B9 0000   r23 should be 185
    STS     $0000  ,r17     ;W 70 0000   r17 should be 112
    STS     $0000  ,r26     ;W 46 0000   r26 should be 70
    STS     $0000  ,r8      ;W FC 0000   r8 should be 252
    STS     $0000  ,r27     ;W 2E 0000   r27 should be 46
    STS     $0000  ,r18     ;W 18 0000   r18 should be 24



;PREPROCESS TestLDD

    LDI     r28    ,$E0     ;            set Y to $FFE0
    LDI     r29    ,$FF     ;
    LDD     r12    ,Y+0     ;R 3A FFE0
    LDD     r19    ,Y+14    ;R 88 FFEE
    LDD     r14    ,Y+19    ;R AE FFF3
    LDD     r16    ,Y+20    ;R 39 FFF4
    LDD     r8     ,Y+54    ;R 96 0016
    LDD     r17    ,Y+8     ;R DE FFE8
    LDD     r0     ,Y+49    ;R 50 0011
    LDD     r21    ,Y+63    ;R E8 001F
    STS     $0000  ,r12     ;W 3A 0000   r12 should be 58
    STS     $0000  ,r19     ;W 88 0000   r19 should be 136
    STS     $0000  ,r14     ;W AE 0000   r14 should be 174
    STS     $0000  ,r16     ;W 39 0000   r16 should be 57
    STS     $0000  ,r8      ;W 96 0000   r8 should be 150
    STS     $0000  ,r17     ;W DE 0000   r17 should be 222
    STS     $0000  ,r0      ;W 50 0000   r0 should be 80
    STS     $0000  ,r21     ;W E8 0000   r21 should be 232
    LDI     r30    ,$E0     ;            set Z to $FFE0
    LDI     r31    ,$FF     ;
    LDD     r4     ,Z+0     ;R A5 FFE0
    LDD     r11    ,Z+0     ;R FA FFE0
    LDD     r24    ,Z+33    ;R 09 0001
    LDD     r5     ,Z+22    ;R 39 FFF6
    LDD     r17    ,Z+13    ;R B9 FFED
    LDD     r27    ,Z+38    ;R 9D 0006
    LDD     r16    ,Z+25    ;R 7A FFF9
    LDD     r0     ,Z+63    ;R 1D 001F
    STS     $0000  ,r4      ;W A5 0000   r4 should be 165
    STS     $0000  ,r11     ;W FA 0000   r11 should be 250
    STS     $0000  ,r24     ;W 09 0000   r24 should be 9
    STS     $0000  ,r5      ;W 39 0000   r5 should be 57
    STS     $0000  ,r17     ;W B9 0000   r17 should be 185
    STS     $0000  ,r27     ;W 9D 0000   r27 should be 157
    STS     $0000  ,r16     ;W 7A 0000   r16 should be 122
    STS     $0000  ,r0      ;W 1D 0000   r0 should be 29



;PREPROCESS TestLDS


; do a few simple LDSs
    LDS     r0     ,$0000   ;R EC 0000
    STS     $0000  ,r0      ;W EC 0000   r0 should be 236
    LDS     r15    ,$FF00   ;R EC FF00
    STS     $0000  ,r15     ;W EC 0000   r15 should be 236
    LDS     r30    ,$FFFF   ;R EC FFFF
    STS     $0000  ,r30     ;W EC 0000   r30 should be 236

; do some random LDSs
    LDS     r15    ,$F358   ;R 41 F358
    LDS     r28    ,$87B5   ;R 54 87B5
    LDS     r18    ,$6C70   ;R D8 6C70
    LDS     r2     ,$9F99   ;R 66 9F99
    LDS     r30    ,$BF30   ;R CC BF30
    LDS     r23    ,$E729   ;R E0 E729
    LDS     r31    ,$7EED   ;R 3D 7EED
    LDS     r27    ,$20C8   ;R 73 20C8
    LDS     r17    ,$0AC5   ;R AD 0AC5
    LDS     r4     ,$70C0   ;R 75 70C0
    STS     $0000  ,r15     ;W 41 0000   r15 should be 65
    STS     $0000  ,r28     ;W 54 0000   r28 should be 84
    STS     $0000  ,r18     ;W D8 0000   r18 should be 216
    STS     $0000  ,r2      ;W 66 0000   r2 should be 102
    STS     $0000  ,r30     ;W CC 0000   r30 should be 204
    STS     $0000  ,r23     ;W E0 0000   r23 should be 224
    STS     $0000  ,r31     ;W 3D 0000   r31 should be 61
    STS     $0000  ,r27     ;W 73 0000   r27 should be 115
    STS     $0000  ,r17     ;W AD 0000   r17 should be 173
    STS     $0000  ,r4      ;W 75 0000   r4 should be 117



;PREPROCESS TestMOV


; do a few simple MOVs
    LDS     r0     ,$0000   ;R 03 0000
    MOV     r1     ,r0      ;
    STS     $0000  ,r1      ;W 03 0000   r1 should be 3
    LDS     r31    ,$0000   ;R 24 0000
    MOV     r30    ,r31     ;
    STS     $0000  ,r30     ;W 24 0000   r30 should be 36

; do a random move through all registers
    LDS     r3     ,$0000   ;R 1F 0000
    MOV     r7     ,r3      ;
    MOV     r2     ,r7      ;
    MOV     r28    ,r2      ;
    MOV     r1     ,r28     ;
    MOV     r10    ,r1      ;
    MOV     r29    ,r10     ;
    MOV     r16    ,r29     ;
    MOV     r30    ,r16     ;
    MOV     r8     ,r30     ;
    MOV     r21    ,r8      ;
    MOV     r15    ,r21     ;
    MOV     r6     ,r15     ;
    MOV     r17    ,r6      ;
    MOV     r4     ,r17     ;
    MOV     r20    ,r4      ;
    MOV     r23    ,r20     ;
    MOV     r12    ,r23     ;
    MOV     r24    ,r12     ;
    MOV     r14    ,r24     ;
    MOV     r19    ,r14     ;
    MOV     r31    ,r19     ;
    MOV     r27    ,r31     ;
    MOV     r9     ,r27     ;
    MOV     r11    ,r9      ;
    MOV     r25    ,r11     ;
    MOV     r26    ,r25     ;
    MOV     r5     ,r26     ;
    MOV     r18    ,r5      ;
    MOV     r13    ,r18     ;
    MOV     r0     ,r13     ;
    MOV     r22    ,r0      ;
    STS     $0000  ,r22     ;W 1F 0000   r22 should be 31



;PREPROCESS TestST

    LDI     r26    ,$04     ;            set X to $0004
    LDI     r27    ,$00     ;
    LDS     r0     ,$0000   ;R EC 0000   set r0 to 236
    ST      X      ,r0      ;W EC 0004
    LDS     r8     ,$0000   ;R EC 0000   set r8 to 236
    ST      X      ,r8      ;W EC 0004
    LDS     r25    ,$0000   ;R EC 0000   set r25 to 236
    ST      X      ,r25     ;W EC 0004

; store with pre decrement through 0x0000
    LDS     r12    ,$0000   ;R E5 0000   set r12 to 229
    LDS     r23    ,$0000   ;R 47 0000   set r23 to 71
    LDS     r10    ,$0000   ;R D8 0000   set r10 to 216
    LDS     r25    ,$0000   ;R 5D 0000   set r25 to 93
    LDS     r3     ,$0000   ;R 8E 0000   set r3 to 142
    LDS     r7     ,$0000   ;R EC 0000   set r7 to 236
    LDS     r6     ,$0000   ;R 7F 0000   set r6 to 127
    LDS     r30    ,$0000   ;R 26 0000   set r30 to 38
    ST      -X     ,r12     ;W E5 0003
    ST      -X     ,r23     ;W 47 0002
    ST      -X     ,r10     ;W D8 0001
    ST      -X     ,r25     ;W 5D 0000
    ST      -X     ,r3      ;W 8E FFFF
    ST      -X     ,r7      ;W EC FFFE
    ST      -X     ,r6      ;W 7F FFFD
    ST      -X     ,r30     ;W 26 FFFC

; store with post increment through 0xFFFF
    LDS     r14    ,$0000   ;R 07 0000   set r14 to 7
    LDS     r25    ,$0000   ;R 2F 0000   set r25 to 47
    LDS     r29    ,$0000   ;R 79 0000   set r29 to 121
    LDS     r17    ,$0000   ;R 55 0000   set r17 to 85
    LDS     r3     ,$0000   ;R D0 0000   set r3 to 208
    LDS     r1     ,$0000   ;R F8 0000   set r1 to 248
    LDS     r20    ,$0000   ;R F6 0000   set r20 to 246
    LDS     r28    ,$0000   ;R 6D 0000   set r28 to 109
    ST      X+     ,r14     ;W 07 FFFC
    ST      X+     ,r25     ;W 2F FFFD
    ST      X+     ,r29     ;W 79 FFFE
    ST      X+     ,r17     ;W 55 FFFF
    ST      X+     ,r3      ;W D0 0000
    ST      X+     ,r1      ;W F8 0001
    ST      X+     ,r20     ;W F6 0002
    ST      X+     ,r28     ;W 6D 0003
    LDI     r28    ,$04     ;            set Y to $0004
    LDI     r29    ,$00     ;
    LDS     r0     ,$0000   ;R EC 0000   set r0 to 236
    ST      Y      ,r0      ;W EC 0004
    LDS     r8     ,$0000   ;R EC 0000   set r8 to 236
    ST      Y      ,r8      ;W EC 0004
    LDS     r25    ,$0000   ;R EC 0000   set r25 to 236
    ST      Y      ,r25     ;W EC 0004

; store with pre decrement through 0x0000
    LDS     r27    ,$0000   ;R E8 0000   set r27 to 232
    LDS     r12    ,$0000   ;R 92 0000   set r12 to 146
    LDS     r1     ,$0000   ;R D8 0000   set r1 to 216
    LDS     r5     ,$0000   ;R F9 0000   set r5 to 249
    LDS     r30    ,$0000   ;R 4F 0000   set r30 to 79
    LDS     r0     ,$0000   ;R 61 0000   set r0 to 97
    LDS     r25    ,$0000   ;R 97 0000   set r25 to 151
    LDS     r8     ,$0000   ;R 6F 0000   set r8 to 111
    ST      -Y     ,r27     ;W E8 0003
    ST      -Y     ,r12     ;W 92 0002
    ST      -Y     ,r1      ;W D8 0001
    ST      -Y     ,r5      ;W F9 0000
    ST      -Y     ,r30     ;W 4F FFFF
    ST      -Y     ,r0      ;W 61 FFFE
    ST      -Y     ,r25     ;W 97 FFFD
    ST      -Y     ,r8      ;W 6F FFFC

; store with post increment through 0xFFFF
    LDS     r1     ,$0000   ;R 19 0000   set r1 to 25
    LDS     r18    ,$0000   ;R F4 0000   set r18 to 244
    LDS     r23    ,$0000   ;R 50 0000   set r23 to 80
    LDS     r17    ,$0000   ;R 1D 0000   set r17 to 29
    LDS     r31    ,$0000   ;R 29 0000   set r31 to 41
    LDS     r27    ,$0000   ;R 5F 0000   set r27 to 95
    LDS     r10    ,$0000   ;R 23 0000   set r10 to 35
    LDS     r25    ,$0000   ;R 22 0000   set r25 to 34
    ST      Y+     ,r1      ;W 19 FFFC
    ST      Y+     ,r18     ;W F4 FFFD
    ST      Y+     ,r23     ;W 50 FFFE
    ST      Y+     ,r17     ;W 1D FFFF
    ST      Y+     ,r31     ;W 29 0000
    ST      Y+     ,r27     ;W 5F 0001
    ST      Y+     ,r10     ;W 23 0002
    ST      Y+     ,r25     ;W 22 0003
    LDI     r30    ,$04     ;            set Z to $0004
    LDI     r31    ,$00     ;
    LDS     r0     ,$0000   ;R EC 0000   set r0 to 236
    ST      Z      ,r0      ;W EC 0004
    LDS     r8     ,$0000   ;R EC 0000   set r8 to 236
    ST      Z      ,r8      ;W EC 0004
    LDS     r25    ,$0000   ;R EC 0000   set r25 to 236
    ST      Z      ,r25     ;W EC 0004

; store with pre decrement through 0x0000
    LDS     r21    ,$0000   ;R 14 0000   set r21 to 20
    LDS     r27    ,$0000   ;R 29 0000   set r27 to 41
    LDS     r7     ,$0000   ;R D6 0000   set r7 to 214
    LDS     r12    ,$0000   ;R A1 0000   set r12 to 161
    LDS     r3     ,$0000   ;R 85 0000   set r3 to 133
    LDS     r18    ,$0000   ;R 68 0000   set r18 to 104
    LDS     r28    ,$0000   ;R A0 0000   set r28 to 160
    LDS     r24    ,$0000   ;R 7A 0000   set r24 to 122
    ST      -Z     ,r21     ;W 14 0003
    ST      -Z     ,r27     ;W 29 0002
    ST      -Z     ,r7      ;W D6 0001
    ST      -Z     ,r12     ;W A1 0000
    ST      -Z     ,r3      ;W 85 FFFF
    ST      -Z     ,r18     ;W 68 FFFE
    ST      -Z     ,r28     ;W A0 FFFD
    ST      -Z     ,r24     ;W 7A FFFC

; store with post increment through 0xFFFF
    LDS     r8     ,$0000   ;R 25 0000   set r8 to 37
    LDS     r12    ,$0000   ;R 04 0000   set r12 to 4
    LDS     r4     ,$0000   ;R EA 0000   set r4 to 234
    LDS     r21    ,$0000   ;R 33 0000   set r21 to 51
    LDS     r20    ,$0000   ;R 25 0000   set r20 to 37
    LDS     r9     ,$0000   ;R 6D 0000   set r9 to 109
    LDS     r14    ,$0000   ;R 87 0000   set r14 to 135
    LDS     r10    ,$0000   ;R 43 0000   set r10 to 67
    ST      Z+     ,r8      ;W 25 FFFC
    ST      Z+     ,r12     ;W 04 FFFD
    ST      Z+     ,r4      ;W EA FFFE
    ST      Z+     ,r21     ;W 33 FFFF
    ST      Z+     ,r20     ;W 25 0000
    ST      Z+     ,r9      ;W 6D 0001
    ST      Z+     ,r14     ;W 87 0002
    ST      Z+     ,r10     ;W 43 0003



;PREPROCESS TestSTD

    LDI     r28    ,$E0     ;            set Y to $FFE0
    LDI     r29    ,$FF     ;
    LDS     r14    ,$0000   ;R 04 0000   set r14 to 4
    LDS     r26    ,$0000   ;R 99 0000   set r26 to 153
    LDS     r17    ,$0000   ;R 35 0000   set r17 to 53
    LDS     r22    ,$0000   ;R 44 0000   set r22 to 68
    LDS     r9     ,$0000   ;R 87 0000   set r9 to 135
    LDS     r19    ,$0000   ;R 3B 0000   set r19 to 59
    LDS     r20    ,$0000   ;R 36 0000   set r20 to 54
    LDS     r16    ,$0000   ;R 4F 0000   set r16 to 79
    STD     Y+0    ,r14     ;W 04 FFE0
    STD     Y+44   ,r26     ;W 99 000C
    STD     Y+8    ,r17     ;W 35 FFE8
    STD     Y+31   ,r22     ;W 44 FFFF
    STD     Y+47   ,r9      ;W 87 000F
    STD     Y+36   ,r19     ;W 3B 0004
    STD     Y+20   ,r20     ;W 36 FFF4
    STD     Y+63   ,r16     ;W 4F 001F
    LDI     r30    ,$E0     ;            set Z to $FFE0
    LDI     r31    ,$FF     ;
    LDS     r16    ,$0000   ;R 16 0000   set r16 to 22
    LDS     r15    ,$0000   ;R 01 0000   set r15 to 1
    LDS     r8     ,$0000   ;R AA 0000   set r8 to 170
    LDS     r1     ,$0000   ;R 42 0000   set r1 to 66
    LDS     r2     ,$0000   ;R 86 0000   set r2 to 134
    LDS     r20    ,$0000   ;R 52 0000   set r20 to 82
    LDS     r13    ,$0000   ;R E2 0000   set r13 to 226
    LDS     r27    ,$0000   ;R DA 0000   set r27 to 218
    STD     Z+0    ,r16     ;W 16 FFE0
    STD     Z+34   ,r15     ;W 01 0002
    STD     Z+36   ,r8      ;W AA 0004
    STD     Z+26   ,r1      ;W 42 FFFA
    STD     Z+43   ,r2      ;W 86 000B
    STD     Z+26   ,r20     ;W 52 FFFA
    STD     Z+33   ,r13     ;W E2 0001
    STD     Z+63   ,r27     ;W DA 001F



;PREPROCESS TestSTS


; do a few simple STSs
    LDS     r0     ,$0000   ;R EC 0000   set r0 to 236
    STS     $0000  ,r0      ;W EC 0000
    LDS     r15    ,$0000   ;R EC 0000   set r15 to 236
    STS     $FF00  ,r15     ;W EC FF00
    LDS     r30    ,$0000   ;R EC 0000   set r30 to 236
    STS     $FFFF  ,r30     ;W EC FFFF

; do some random STSs
    LDS     r0     ,$0000   ;R 4B 0000   set r0 to 75
    LDS     r3     ,$0000   ;R 41 0000   set r3 to 65
    LDS     r2     ,$0000   ;R 9D 0000   set r2 to 157
    LDS     r28    ,$0000   ;R 14 0000   set r28 to 20
    LDS     r22    ,$0000   ;R 6B 0000   set r22 to 107
    LDS     r4     ,$0000   ;R 34 0000   set r4 to 52
    LDS     r17    ,$0000   ;R D0 0000   set r17 to 208
    LDS     r1     ,$0000   ;R 79 0000   set r1 to 121
    LDS     r11    ,$0000   ;R 5A 0000   set r11 to 90
    LDS     r18    ,$0000   ;R 0C 0000   set r18 to 12
    STS     $DC0D  ,r0      ;W 4B DC0D
    STS     $156A  ,r3      ;W 41 156A
    STS     $BAB3  ,r2      ;W 9D BAB3
    STS     $B732  ,r28     ;W 14 B732
    STS     $7FC2  ,r22     ;W 6B 7FC2
    STS     $B515  ,r4      ;W 34 B515
    STS     $4F21  ,r17     ;W D0 4F21
    STS     $5333  ,r1      ;W 79 5333
    STS     $D318  ,r11     ;W 5A D318
    STS     $5BD5  ,r18     ;W 0C 5BD5

;PREPROCESS TestPUSH

;PREPROCESS TestPOP

; load some random values into registers
    LDS     r21    ,$0000   ;R 0E 0000   set r21 to 14
    LDS     r25    ,$0000   ;R 3B 0000   set r25 to 59
    LDS     r29    ,$0000   ;R 85 0000   set r29 to 133
    LDS     r13    ,$0000   ;R 5B 0000   set r13 to 91
    LDS     r30    ,$0000   ;R 87 0000   set r30 to 135
    LDS     r31    ,$0000   ;R 13 0000   set r31 to 19
    LDS     r23    ,$0000   ;R 37 0000   set r23 to 55
    LDS     r7     ,$0000   ;R DE 0000   set r7 to 222
    LDS     r8     ,$0000   ;R B0 0000   set r8 to 176
    LDS     r5     ,$0000   ;R A0 0000   set r5 to 160
    LDS     r3     ,$0000   ;R DF 0000   set r3 to 223
    LDS     r12    ,$0000   ;R 3B 0000   set r12 to 59
    LDS     r1     ,$0000   ;R C5 0000   set r1 to 197
    LDS     r15    ,$0000   ;R 61 0000   set r15 to 97
    LDS     r24    ,$0000   ;R 82 0000   set r24 to 130
    LDS     r6     ,$0000   ;R 16 0000   set r6 to 22
    LDS     r14    ,$0000   ;R DF 0000   set r14 to 223
    LDS     r22    ,$0000   ;R 00 0000   set r22 to 0
    LDS     r4     ,$0000   ;R 64 0000   set r4 to 100
    LDS     r20    ,$0000   ;R BA 0000   set r20 to 186
    LDS     r26    ,$0000   ;R DC 0000   set r26 to 220
    LDS     r11    ,$0000   ;R 23 0000   set r11 to 35
    LDS     r0     ,$0000   ;R A9 0000   set r0 to 169
    LDS     r10    ,$0000   ;R A0 0000   set r10 to 160
    LDS     r16    ,$0000   ;R 3F 0000   set r16 to 63
    LDS     r2     ,$0000   ;R 99 0000   set r2 to 153
    LDS     r17    ,$0000   ;R 9E 0000   set r17 to 158
    LDS     r9     ,$0000   ;R D1 0000   set r9 to 209
    LDS     r18    ,$0000   ;R A7 0000   set r18 to 167
    LDS     r19    ,$0000   ;R CE 0000   set r19 to 206
    LDS     r27    ,$0000   ;R 97 0000   set r27 to 151
    LDS     r28    ,$0000   ;R 41 0000   set r28 to 65

; push all the registers
    PUSH    r21             ;W 0E FFFF
    PUSH    r25             ;W 3B FFFE
    PUSH    r29             ;W 85 FFFD
    PUSH    r13             ;W 5B FFFC
    PUSH    r30             ;W 87 FFFB
    PUSH    r31             ;W 13 FFFA
    PUSH    r23             ;W 37 FFF9
    PUSH    r7              ;W DE FFF8
    PUSH    r8              ;W B0 FFF7
    PUSH    r5              ;W A0 FFF6
    PUSH    r3              ;W DF FFF5
    PUSH    r12             ;W 3B FFF4
    PUSH    r1              ;W C5 FFF3
    PUSH    r15             ;W 61 FFF2
    PUSH    r24             ;W 82 FFF1
    PUSH    r6              ;W 16 FFF0
    PUSH    r14             ;W DF FFEF
    PUSH    r22             ;W 00 FFEE
    PUSH    r4              ;W 64 FFED
    PUSH    r20             ;W BA FFEC
    PUSH    r26             ;W DC FFEB
    PUSH    r11             ;W 23 FFEA
    PUSH    r0              ;W A9 FFE9
    PUSH    r10             ;W A0 FFE8
    PUSH    r16             ;W 3F FFE7
    PUSH    r2              ;W 99 FFE6
    PUSH    r17             ;W 9E FFE5
    PUSH    r9              ;W D1 FFE4
    PUSH    r18             ;W A7 FFE3
    PUSH    r19             ;W CE FFE2
    PUSH    r27             ;W 97 FFE1
    PUSH    r28             ;W 41 FFE0

; pop all the registers
    POP     r28             ;R 41 FFE0
    POP     r27             ;R 97 FFE1
    POP     r19             ;R CE FFE2
    POP     r18             ;R A7 FFE3
    POP     r9              ;R D1 FFE4
    POP     r17             ;R 9E FFE5
    POP     r2              ;R 99 FFE6
    POP     r16             ;R 3F FFE7
    POP     r10             ;R A0 FFE8
    POP     r0              ;R A9 FFE9
    POP     r11             ;R 23 FFEA
    POP     r26             ;R DC FFEB
    POP     r20             ;R BA FFEC
    POP     r4              ;R 64 FFED
    POP     r22             ;R 00 FFEE
    POP     r14             ;R DF FFEF
    POP     r6              ;R 16 FFF0
    POP     r24             ;R 82 FFF1
    POP     r15             ;R 61 FFF2
    POP     r1              ;R C5 FFF3
    POP     r12             ;R 3B FFF4
    POP     r3              ;R DF FFF5
    POP     r5              ;R A0 FFF6
    POP     r8              ;R B0 FFF7
    POP     r7              ;R DE FFF8
    POP     r23             ;R 37 FFF9
    POP     r31             ;R 13 FFFA
    POP     r30             ;R 87 FFFB
    POP     r13             ;R 5B FFFC
    POP     r29             ;R 85 FFFD
    POP     r25             ;R 3B FFFE
    POP     r21             ;R 0E FFFF

; check all the values are unchanged
    STS     $0000  ,r21     ;W 0E 0000   r21 should be 14
    STS     $0000  ,r25     ;W 3B 0000   r25 should be 59
    STS     $0000  ,r29     ;W 85 0000   r29 should be 133
    STS     $0000  ,r13     ;W 5B 0000   r13 should be 91
    STS     $0000  ,r30     ;W 87 0000   r30 should be 135
    STS     $0000  ,r31     ;W 13 0000   r31 should be 19
    STS     $0000  ,r23     ;W 37 0000   r23 should be 55
    STS     $0000  ,r7      ;W DE 0000   r7 should be 222
    STS     $0000  ,r8      ;W B0 0000   r8 should be 176
    STS     $0000  ,r5      ;W A0 0000   r5 should be 160
    STS     $0000  ,r3      ;W DF 0000   r3 should be 223
    STS     $0000  ,r12     ;W 3B 0000   r12 should be 59
    STS     $0000  ,r1      ;W C5 0000   r1 should be 197
    STS     $0000  ,r15     ;W 61 0000   r15 should be 97
    STS     $0000  ,r24     ;W 82 0000   r24 should be 130
    STS     $0000  ,r6      ;W 16 0000   r6 should be 22
    STS     $0000  ,r14     ;W DF 0000   r14 should be 223
    STS     $0000  ,r22     ;W 00 0000   r22 should be 0
    STS     $0000  ,r4      ;W 64 0000   r4 should be 100
    STS     $0000  ,r20     ;W BA 0000   r20 should be 186
    STS     $0000  ,r26     ;W DC 0000   r26 should be 220
    STS     $0000  ,r11     ;W 23 0000   r11 should be 35
    STS     $0000  ,r0      ;W A9 0000   r0 should be 169
    STS     $0000  ,r10     ;W A0 0000   r10 should be 160
    STS     $0000  ,r16     ;W 3F 0000   r16 should be 63
    STS     $0000  ,r2      ;W 99 0000   r2 should be 153
    STS     $0000  ,r17     ;W 9E 0000   r17 should be 158
    STS     $0000  ,r9      ;W D1 0000   r9 should be 209
    STS     $0000  ,r18     ;W A7 0000   r18 should be 167
    STS     $0000  ,r19     ;W CE 0000   r19 should be 206
    STS     $0000  ,r27     ;W 97 0000   r27 should be 151
    STS     $0000  ,r28     ;W 41 0000   r28 should be 65