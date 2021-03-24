
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
    LDI     r21    ,$9D     ;
    LDI     r31    ,$C2     ;
    LDI     r19    ,$7C     ;
    LDI     r29    ,$B9     ;
    LDI     r18    ,$53     ;
    LDI     r16    ,$57     ;
    LDI     r22    ,$A7     ;
    LDI     r24    ,$68     ;
    LDI     r30    ,$C9     ;
    LDI     r28    ,$36     ;
    STS     $0000  ,r21     ;W 9D 0000   r21 should be 157
    STS     $0000  ,r31     ;W C2 0000   r31 should be 194
    STS     $0000  ,r19     ;W 7C 0000   r19 should be 124
    STS     $0000  ,r29     ;W B9 0000   r29 should be 185
    STS     $0000  ,r18     ;W 53 0000   r18 should be 83
    STS     $0000  ,r16     ;W 57 0000   r16 should be 87
    STS     $0000  ,r22     ;W A7 0000   r22 should be 167
    STS     $0000  ,r24     ;W 68 0000   r24 should be 104
    STS     $0000  ,r30     ;W C9 0000   r30 should be 201
    STS     $0000  ,r28     ;W 36 0000   r28 should be 54



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
    LD      r10    ,-X      ;R 50 0003
    LD      r2     ,-X      ;R E6 0002
    LD      r12    ,-X      ;R 2D 0001
    LD      r13    ,-X      ;R D6 0000
    LD      r16    ,-X      ;R 8C FFFF
    LD      r8     ,-X      ;R 75 FFFE
    LD      r9     ,-X      ;R 9B FFFD
    LD      r0     ,-X      ;R BA FFFC
    STS     $0000  ,r10     ;W 50 0000   r10 should be 80
    STS     $0000  ,r2      ;W E6 0000   r2 should be 230
    STS     $0000  ,r12     ;W 2D 0000   r12 should be 45
    STS     $0000  ,r13     ;W D6 0000   r13 should be 214
    STS     $0000  ,r16     ;W 8C 0000   r16 should be 140
    STS     $0000  ,r8      ;W 75 0000   r8 should be 117
    STS     $0000  ,r9      ;W 9B 0000   r9 should be 155
    STS     $0000  ,r0      ;W BA 0000   r0 should be 186

; load with post increment through 0xFFFF
    LD      r20    ,X+      ;R 7A FFFC
    LD      r21    ,X+      ;R BD FFFD
    LD      r16    ,X+      ;R D0 FFFE
    LD      r11    ,X+      ;R DA FFFF
    LD      r1     ,X+      ;R 83 0000
    LD      r25    ,X+      ;R B7 0001
    LD      r17    ,X+      ;R 5A 0002
    LD      r7     ,X+      ;R 4C 0003
    STS     $0000  ,r20     ;W 7A 0000   r20 should be 122
    STS     $0000  ,r21     ;W BD 0000   r21 should be 189
    STS     $0000  ,r16     ;W D0 0000   r16 should be 208
    STS     $0000  ,r11     ;W DA 0000   r11 should be 218
    STS     $0000  ,r1      ;W 83 0000   r1 should be 131
    STS     $0000  ,r25     ;W B7 0000   r25 should be 183
    STS     $0000  ,r17     ;W 5A 0000   r17 should be 90
    STS     $0000  ,r7      ;W 4C 0000   r7 should be 76

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
    LD      r19    ,-Y      ;R C1 0003
    LD      r27    ,-Y      ;R 19 0002
    LD      r5     ,-Y      ;R 2E 0001
    LD      r10    ,-Y      ;R 62 0000
    LD      r21    ,-Y      ;R B5 FFFF
    LD      r26    ,-Y      ;R 0B FFFE
    LD      r31    ,-Y      ;R E5 FFFD
    LD      r24    ,-Y      ;R 8B FFFC
    STS     $0000  ,r19     ;W C1 0000   r19 should be 193
    STS     $0000  ,r27     ;W 19 0000   r27 should be 25
    STS     $0000  ,r5      ;W 2E 0000   r5 should be 46
    STS     $0000  ,r10     ;W 62 0000   r10 should be 98
    STS     $0000  ,r21     ;W B5 0000   r21 should be 181
    STS     $0000  ,r26     ;W 0B 0000   r26 should be 11
    STS     $0000  ,r31     ;W E5 0000   r31 should be 229
    STS     $0000  ,r24     ;W 8B 0000   r24 should be 139

; load with post increment through 0xFFFF
    LD      r23    ,Y+      ;R B1 FFFC
    LD      r15    ,Y+      ;R 52 FFFD
    LD      r3     ,Y+      ;R 0B FFFE
    LD      r7     ,Y+      ;R 7E FFFF
    LD      r27    ,Y+      ;R 64 0000
    LD      r14    ,Y+      ;R D2 0001
    LD      r8     ,Y+      ;R 67 0002
    LD      r13    ,Y+      ;R 5E 0003
    STS     $0000  ,r23     ;W B1 0000   r23 should be 177
    STS     $0000  ,r15     ;W 52 0000   r15 should be 82
    STS     $0000  ,r3      ;W 0B 0000   r3 should be 11
    STS     $0000  ,r7      ;W 7E 0000   r7 should be 126
    STS     $0000  ,r27     ;W 64 0000   r27 should be 100
    STS     $0000  ,r14     ;W D2 0000   r14 should be 210
    STS     $0000  ,r8      ;W 67 0000   r8 should be 103
    STS     $0000  ,r13     ;W 5E 0000   r13 should be 94

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
    LD      r19    ,-Z      ;R 6C 0003
    LD      r4     ,-Z      ;R CB 0002
    LD      r22    ,-Z      ;R B6 0001
    LD      r15    ,-Z      ;R 7D 0000
    LD      r7     ,-Z      ;R D4 FFFF
    LD      r8     ,-Z      ;R 02 FFFE
    LD      r14    ,-Z      ;R EC FFFD
    LD      r3     ,-Z      ;R 63 FFFC
    STS     $0000  ,r19     ;W 6C 0000   r19 should be 108
    STS     $0000  ,r4      ;W CB 0000   r4 should be 203
    STS     $0000  ,r22     ;W B6 0000   r22 should be 182
    STS     $0000  ,r15     ;W 7D 0000   r15 should be 125
    STS     $0000  ,r7      ;W D4 0000   r7 should be 212
    STS     $0000  ,r8      ;W 02 0000   r8 should be 2
    STS     $0000  ,r14     ;W EC 0000   r14 should be 236
    STS     $0000  ,r3      ;W 63 0000   r3 should be 99

; load with post increment through 0xFFFF
    LD      r5     ,Z+      ;R 5B FFFC
    LD      r10    ,Z+      ;R 5E FFFD
    LD      r15    ,Z+      ;R BE FFFE
    LD      r13    ,Z+      ;R 0B FFFF
    LD      r16    ,Z+      ;R 61 0000
    LD      r2     ,Z+      ;R 25 0001
    LD      r1     ,Z+      ;R 59 0002
    LD      r21    ,Z+      ;R 1B 0003
    STS     $0000  ,r5      ;W 5B 0000   r5 should be 91
    STS     $0000  ,r10     ;W 5E 0000   r10 should be 94
    STS     $0000  ,r15     ;W BE 0000   r15 should be 190
    STS     $0000  ,r13     ;W 0B 0000   r13 should be 11
    STS     $0000  ,r16     ;W 61 0000   r16 should be 97
    STS     $0000  ,r2      ;W 25 0000   r2 should be 37
    STS     $0000  ,r1      ;W 59 0000   r1 should be 89
    STS     $0000  ,r21     ;W 1B 0000   r21 should be 27



;PREPROCESS TestLDD

    LDI     r28    ,$E0     ;            set Y to $FFE0
    LDI     r29    ,$FF     ;
    LDD     r3     ,Y+0     ;R F5 FFE0
    LDD     r17    ,Y+45    ;R 49 000D
    LDD     r13    ,Y+10    ;R 55 FFEA
    LDD     r31    ,Y+55    ;R DB 0017
    LDD     r26    ,Y+11    ;R 3A FFEB
    LDD     r1     ,Y+32    ;R ED 0000
    LDD     r5     ,Y+2     ;R C0 FFE2
    LDD     r10    ,Y+63    ;R E4 001F
    STS     $0000  ,r3      ;W F5 0000   r3 should be 245
    STS     $0000  ,r17     ;W 49 0000   r17 should be 73
    STS     $0000  ,r13     ;W 55 0000   r13 should be 85
    STS     $0000  ,r31     ;W DB 0000   r31 should be 219
    STS     $0000  ,r26     ;W 3A 0000   r26 should be 58
    STS     $0000  ,r1      ;W ED 0000   r1 should be 237
    STS     $0000  ,r5      ;W C0 0000   r5 should be 192
    STS     $0000  ,r10     ;W E4 0000   r10 should be 228
    LDI     r30    ,$E0     ;            set Z to $FFE0
    LDI     r31    ,$FF     ;
    LDD     r9     ,Z+0     ;R B0 FFE0
    LDD     r28    ,Z+60    ;R 46 001C
    LDD     r8     ,Z+11    ;R D1 FFEB
    LDD     r25    ,Z+52    ;R AF 0014
    LDD     r5     ,Z+0     ;R EC FFE0
    LDD     r13    ,Z+1     ;R 7A FFE1
    LDD     r6     ,Z+17    ;R 83 FFF1
    LDD     r17    ,Z+63    ;R B2 001F
    STS     $0000  ,r9      ;W B0 0000   r9 should be 176
    STS     $0000  ,r28     ;W 46 0000   r28 should be 70
    STS     $0000  ,r8      ;W D1 0000   r8 should be 209
    STS     $0000  ,r25     ;W AF 0000   r25 should be 175
    STS     $0000  ,r5      ;W EC 0000   r5 should be 236
    STS     $0000  ,r13     ;W 7A 0000   r13 should be 122
    STS     $0000  ,r6      ;W 83 0000   r6 should be 131
    STS     $0000  ,r17     ;W B2 0000   r17 should be 178



;PREPROCESS TestLDS


; do a few simple LDSs
    LDS     r0     ,$0000   ;R EC 0000
    STS     $0000  ,r0      ;W EC 0000   r0 should be 236
    LDS     r15    ,$FF00   ;R EC FF00
    STS     $0000  ,r15     ;W EC 0000   r15 should be 236
    LDS     r30    ,$FFFF   ;R EC FFFF
    STS     $0000  ,r30     ;W EC 0000   r30 should be 236

; do some random LDSs
    LDS     r17    ,$A3CF   ;R 01 A3CF
    LDS     r25    ,$2F0C   ;R 38 2F0C
    LDS     r27    ,$1F5F   ;R FC 1F5F
    LDS     r30    ,$25FF   ;R B2 25FF
    LDS     r15    ,$190C   ;R E0 190C
    LDS     r23    ,$8EC0   ;R 0E 8EC0
    LDS     r7     ,$FF6A   ;R 15 FF6A
    LDS     r21    ,$5F0E   ;R 2F 5F0E
    LDS     r24    ,$2C58   ;R 7A 2C58
    LDS     r4     ,$5C1D   ;R DC 5C1D
    STS     $0000  ,r17     ;W 01 0000   r17 should be 1
    STS     $0000  ,r25     ;W 38 0000   r25 should be 56
    STS     $0000  ,r27     ;W FC 0000   r27 should be 252
    STS     $0000  ,r30     ;W B2 0000   r30 should be 178
    STS     $0000  ,r15     ;W E0 0000   r15 should be 224
    STS     $0000  ,r23     ;W 0E 0000   r23 should be 14
    STS     $0000  ,r7      ;W 15 0000   r7 should be 21
    STS     $0000  ,r21     ;W 2F 0000   r21 should be 47
    STS     $0000  ,r24     ;W 7A 0000   r24 should be 122
    STS     $0000  ,r4      ;W DC 0000   r4 should be 220



;PREPROCESS TestMOV


; do a few simple MOVs
    LDS     r0     ,$0000   ;R 7F 0000
    MOV     r0     ,r1      ;
    STS     $0000  ,r1      ;W 7F 0000   r1 should be 127
    LDS     r31    ,$0000   ;R B2 0000
    MOV     r31    ,r30     ;
    STS     $0000  ,r30     ;W B2 0000   r30 should be 178

; do a random move through all registers
    LDS     r1     ,$0000   ;R 92 0000
    MOV     r1     ,r21     ;
    MOV     r21    ,r0      ;
    MOV     r0     ,r8      ;
    MOV     r8     ,r3      ;
    MOV     r3     ,r6      ;
    MOV     r6     ,r13     ;
    MOV     r13    ,r16     ;
    MOV     r16    ,r2      ;
    MOV     r2     ,r7      ;
    MOV     r7     ,r24     ;
    MOV     r24    ,r4      ;
    MOV     r4     ,r31     ;
    MOV     r31    ,r22     ;
    MOV     r22    ,r23     ;
    MOV     r23    ,r5      ;
    MOV     r5     ,r12     ;
    MOV     r12    ,r25     ;
    MOV     r25    ,r19     ;
    MOV     r19    ,r30     ;
    MOV     r30    ,r26     ;
    MOV     r26    ,r27     ;
    MOV     r27    ,r20     ;
    MOV     r20    ,r17     ;
    MOV     r17    ,r10     ;
    MOV     r10    ,r9      ;
    MOV     r9     ,r15     ;
    MOV     r15    ,r14     ;
    MOV     r14    ,r11     ;
    MOV     r11    ,r28     ;
    MOV     r28    ,r29     ;
    MOV     r29    ,r18     ;
    STS     $0000  ,r18     ;W 92 0000   r18 should be 146



;PREPROCESS TestST

    LDI     r26    ,$04     ;            set X to $0004
    LDI     r27    ,$00     ;
    LDS     r0     ,$0000   ;R EC 0000   set r0 to 236
    ST      X      ,r0      ;W EC 0004
    LDS     r8     ,$0000   ;R EC 0000   set r8 to 236
    ST      X      ,r8      ;W EC 0004
    LDS     r31    ,$0000   ;R EC 0000   set r31 to 236
    ST      X      ,r31     ;W EC 0004

; store with pre decrement through 0x0000
    LDS     r1     ,$0000   ;R 6A 0000   set r1 to 106
    LDS     r11    ,$0000   ;R 6B 0000   set r11 to 107
    LDS     r23    ,$0000   ;R F0 0000   set r23 to 240
    LDS     r12    ,$0000   ;R 9D 0000   set r12 to 157
    LDS     r13    ,$0000   ;R 65 0000   set r13 to 101
    LDS     r4     ,$0000   ;R 14 0000   set r4 to 20
    LDS     r8     ,$0000   ;R B8 0000   set r8 to 184
    LDS     r30    ,$0000   ;R 38 0000   set r30 to 56
    ST      -X     ,r1      ;W 6A 0003
    ST      -X     ,r11     ;W 6B 0002
    ST      -X     ,r23     ;W F0 0001
    ST      -X     ,r12     ;W 9D 0000
    ST      -X     ,r13     ;W 65 FFFF
    ST      -X     ,r4      ;W 14 FFFE
    ST      -X     ,r8      ;W B8 FFFD
    ST      -X     ,r30     ;W 38 FFFC

; store with post increment through 0xFFFF
    LDS     r14    ,$0000   ;R E0 0000   set r14 to 224
    LDS     r13    ,$0000   ;R 5A 0000   set r13 to 90
    LDS     r23    ,$0000   ;R 9A 0000   set r23 to 154
    LDS     r31    ,$0000   ;R D4 0000   set r31 to 212
    LDS     r24    ,$0000   ;R 50 0000   set r24 to 80
    LDS     r22    ,$0000   ;R C7 0000   set r22 to 199
    LDS     r18    ,$0000   ;R A2 0000   set r18 to 162
    LDS     r12    ,$0000   ;R 01 0000   set r12 to 1
    ST      X+     ,r14     ;W E0 FFFC
    ST      X+     ,r13     ;W 5A FFFD
    ST      X+     ,r23     ;W 9A FFFE
    ST      X+     ,r31     ;W D4 FFFF
    ST      X+     ,r24     ;W 50 0000
    ST      X+     ,r22     ;W C7 0001
    ST      X+     ,r18     ;W A2 0002
    ST      X+     ,r12     ;W 01 0003
    LDI     r28    ,$04     ;            set Y to $0004
    LDI     r29    ,$00     ;
    LDS     r0     ,$0000   ;R EC 0000   set r0 to 236
    ST      Y      ,r0      ;W EC 0004
    LDS     r8     ,$0000   ;R EC 0000   set r8 to 236
    ST      Y      ,r8      ;W EC 0004
    LDS     r31    ,$0000   ;R EC 0000   set r31 to 236
    ST      Y      ,r31     ;W EC 0004

; store with pre decrement through 0x0000
    LDS     r0     ,$0000   ;R 3D 0000   set r0 to 61
    LDS     r24    ,$0000   ;R EC 0000   set r24 to 236
    LDS     r5     ,$0000   ;R 12 0000   set r5 to 18
    LDS     r15    ,$0000   ;R 87 0000   set r15 to 135
    LDS     r11    ,$0000   ;R 49 0000   set r11 to 73
    LDS     r30    ,$0000   ;R 86 0000   set r30 to 134
    LDS     r31    ,$0000   ;R 00 0000   set r31 to 0
    LDS     r6     ,$0000   ;R B6 0000   set r6 to 182
    ST      -Y     ,r0      ;W 3D 0003
    ST      -Y     ,r24     ;W EC 0002
    ST      -Y     ,r5      ;W 12 0001
    ST      -Y     ,r15     ;W 87 0000
    ST      -Y     ,r11     ;W 49 FFFF
    ST      -Y     ,r30     ;W 86 FFFE
    ST      -Y     ,r31     ;W 00 FFFD
    ST      -Y     ,r6      ;W B6 FFFC

; store with post increment through 0xFFFF
    LDS     r20    ,$0000   ;R AC 0000   set r20 to 172
    LDS     r13    ,$0000   ;R B7 0000   set r13 to 183
    LDS     r4     ,$0000   ;R 67 0000   set r4 to 103
    LDS     r23    ,$0000   ;R 4B 0000   set r23 to 75
    LDS     r21    ,$0000   ;R 0A 0000   set r21 to 10
    LDS     r25    ,$0000   ;R 27 0000   set r25 to 39
    LDS     r31    ,$0000   ;R CA 0000   set r31 to 202
    LDS     r26    ,$0000   ;R 27 0000   set r26 to 39
    ST      Y+     ,r20     ;W AC FFFC
    ST      Y+     ,r13     ;W B7 FFFD
    ST      Y+     ,r4      ;W 67 FFFE
    ST      Y+     ,r23     ;W 4B FFFF
    ST      Y+     ,r21     ;W 0A 0000
    ST      Y+     ,r25     ;W 27 0001
    ST      Y+     ,r31     ;W CA 0002
    ST      Y+     ,r26     ;W 27 0003
    LDI     r30    ,$04     ;            set Z to $0004
    LDI     r31    ,$00     ;
    LDS     r0     ,$0000   ;R EC 0000   set r0 to 236
    ST      Z      ,r0      ;W EC 0004
    LDS     r8     ,$0000   ;R EC 0000   set r8 to 236
    ST      Z      ,r8      ;W EC 0004
    LDS     r31    ,$0000   ;R EC 0000   set r31 to 236
    ST      Z      ,r31     ;W EC 0004

; store with pre decrement through 0x0000
    LDS     r26    ,$0000   ;R 62 0000   set r26 to 98
    LDS     r9     ,$0000   ;R 45 0000   set r9 to 69
    LDS     r6     ,$0000   ;R A9 0000   set r6 to 169
    LDS     r17    ,$0000   ;R DE 0000   set r17 to 222
    LDS     r5     ,$0000   ;R 26 0000   set r5 to 38
    LDS     r0     ,$0000   ;R 9D 0000   set r0 to 157
    LDS     r28    ,$0000   ;R AA 0000   set r28 to 170
    LDS     r19    ,$0000   ;R D5 0000   set r19 to 213
    ST      -Z     ,r26     ;W 62 0003
    ST      -Z     ,r9      ;W 45 0002
    ST      -Z     ,r6      ;W A9 0001
    ST      -Z     ,r17     ;W DE 0000
    ST      -Z     ,r5      ;W 26 FFFF
    ST      -Z     ,r0      ;W 9D FFFE
    ST      -Z     ,r28     ;W AA FFFD
    ST      -Z     ,r19     ;W D5 FFFC

; store with post increment through 0xFFFF
    LDS     r25    ,$0000   ;R B0 0000   set r25 to 176
    LDS     r11    ,$0000   ;R 6C 0000   set r11 to 108
    LDS     r20    ,$0000   ;R 1F 0000   set r20 to 31
    LDS     r29    ,$0000   ;R 20 0000   set r29 to 32
    LDS     r5     ,$0000   ;R 2F 0000   set r5 to 47
    LDS     r10    ,$0000   ;R 4B 0000   set r10 to 75
    LDS     r16    ,$0000   ;R 3C 0000   set r16 to 60
    LDS     r0     ,$0000   ;R 86 0000   set r0 to 134
    ST      Z+     ,r25     ;W B0 FFFC
    ST      Z+     ,r11     ;W 6C FFFD
    ST      Z+     ,r20     ;W 1F FFFE
    ST      Z+     ,r29     ;W 20 FFFF
    ST      Z+     ,r5      ;W 2F 0000
    ST      Z+     ,r10     ;W 4B 0001
    ST      Z+     ,r16     ;W 3C 0002
    ST      Z+     ,r0      ;W 86 0003



;PREPROCESS TestSTD

    LDI     r28    ,$E0     ;            set Y to $FFE0
    LDI     r29    ,$FF     ;
    LDS     r19    ,$0000   ;R A5 0000   set r19 to 165
    LDS     r12    ,$0000   ;R 7F 0000   set r12 to 127
    LDS     r13    ,$0000   ;R B4 0000   set r13 to 180
    LDS     r25    ,$0000   ;R CC 0000   set r25 to 204
    LDS     r8     ,$0000   ;R 4E 0000   set r8 to 78
    LDS     r26    ,$0000   ;R B2 0000   set r26 to 178
    LDS     r22    ,$0000   ;R 8E 0000   set r22 to 142
    LDS     r24    ,$0000   ;R 31 0000   set r24 to 49
    STD     Y+0    ,r19     ;W A5 FFE0
    STD     Y+27   ,r12     ;W 7F FFFB
    STD     Y+17   ,r13     ;W B4 FFF1
    STD     Y+53   ,r25     ;W CC 0015
    STD     Y+46   ,r8      ;W 4E 000E
    STD     Y+43   ,r26     ;W B2 000B
    STD     Y+35   ,r22     ;W 8E 0003
    STD     Y+63   ,r24     ;W 31 001F
    LDI     r30    ,$E0     ;            set Z to $FFE0
    LDI     r31    ,$FF     ;
    LDS     r25    ,$0000   ;R 44 0000   set r25 to 68
    LDS     r28    ,$0000   ;R ED 0000   set r28 to 237
    LDS     r27    ,$0000   ;R 2E 0000   set r27 to 46
    LDS     r6     ,$0000   ;R 65 0000   set r6 to 101
    LDS     r14    ,$0000   ;R CB 0000   set r14 to 203
    LDS     r15    ,$0000   ;R 92 0000   set r15 to 146
    LDS     r26    ,$0000   ;R D6 0000   set r26 to 214
    LDS     r6     ,$0000   ;R 01 0000   set r6 to 1
    STD     Z+0    ,r25     ;W 44 FFE0
    STD     Z+4    ,r28     ;W ED FFE4
    STD     Z+41   ,r27     ;W 2E 0009
    STD     Z+60   ,r6      ;W 65 001C
    STD     Z+46   ,r14     ;W CB 000E
    STD     Z+47   ,r15     ;W 92 000F
    STD     Z+27   ,r26     ;W D6 FFFB
    STD     Z+63   ,r6      ;W 01 001F



;PREPROCESS TestSTS


; do a few simple STSs
    LDS     r0     ,$0000   ;R EC 0000   set r0 to 236
    STS     $0000  ,r0      ;W EC 0000
    LDS     r15    ,$0000   ;R EC 0000   set r15 to 236
    STS     $FF00  ,r15     ;W EC FF00
    LDS     r30    ,$0000   ;R EC 0000   set r30 to 236
    STS     $FFFF  ,r30     ;W EC FFFF

; do some random STSs
    LDS     r20    ,$0000   ;R 03 0000   set r20 to 3
    LDS     r2     ,$0000   ;R 35 0000   set r2 to 53
    LDS     r11    ,$0000   ;R 9B 0000   set r11 to 155
    LDS     r13    ,$0000   ;R 22 0000   set r13 to 34
    LDS     r1     ,$0000   ;R 16 0000   set r1 to 22
    LDS     r7     ,$0000   ;R 83 0000   set r7 to 131
    LDS     r8     ,$0000   ;R A6 0000   set r8 to 166
    LDS     r28    ,$0000   ;R 24 0000   set r28 to 36
    LDS     r26    ,$0000   ;R 5C 0000   set r26 to 92
    LDS     r14    ,$0000   ;R D8 0000   set r14 to 216
    STS     $AC10  ,r20     ;W 03 AC10
    STS     $6311  ,r2      ;W 35 6311
    STS     $E286  ,r11     ;W 9B E286
    STS     $651C  ,r13     ;W 22 651C
    STS     $A354  ,r1      ;W 16 A354
    STS     $8951  ,r7      ;W 83 8951
    STS     $1BC4  ,r8      ;W A6 1BC4
    STS     $3224  ,r28     ;W 24 3224
    STS     $EECE  ,r26     ;W 5C EECE
    STS     $A4ED  ,r14     ;W D8 A4ED

;PREPROCESS TestPUSH

;PREPROCESS TestPOP

; load some random values into registers
    LDS     r16    ,$0000   ;R 7D 0000   set r16 to 125
    LDS     r5     ,$0000   ;R 62 0000   set r5 to 98
    LDS     r19    ,$0000   ;R 78 0000   set r19 to 120
    LDS     r27    ,$0000   ;R D4 0000   set r27 to 212
    LDS     r6     ,$0000   ;R B5 0000   set r6 to 181
    LDS     r30    ,$0000   ;R 2B 0000   set r30 to 43
    LDS     r12    ,$0000   ;R 39 0000   set r12 to 57
    LDS     r20    ,$0000   ;R C8 0000   set r20 to 200
    LDS     r28    ,$0000   ;R 87 0000   set r28 to 135
    LDS     r11    ,$0000   ;R 28 0000   set r11 to 40
    LDS     r8     ,$0000   ;R 82 0000   set r8 to 130
    LDS     r21    ,$0000   ;R B8 0000   set r21 to 184
    LDS     r24    ,$0000   ;R EC 0000   set r24 to 236
    LDS     r4     ,$0000   ;R B6 0000   set r4 to 182
    LDS     r7     ,$0000   ;R A9 0000   set r7 to 169
    LDS     r9     ,$0000   ;R 3C 0000   set r9 to 60
    LDS     r22    ,$0000   ;R 95 0000   set r22 to 149
    LDS     r0     ,$0000   ;R D8 0000   set r0 to 216
    LDS     r17    ,$0000   ;R 69 0000   set r17 to 105
    LDS     r23    ,$0000   ;R FE 0000   set r23 to 254
    LDS     r26    ,$0000   ;R 16 0000   set r26 to 22
    LDS     r13    ,$0000   ;R FF 0000   set r13 to 255
    LDS     r15    ,$0000   ;R 0A 0000   set r15 to 10
    LDS     r2     ,$0000   ;R 4D 0000   set r2 to 77
    LDS     r14    ,$0000   ;R 59 0000   set r14 to 89
    LDS     r31    ,$0000   ;R 0B 0000   set r31 to 11
    LDS     r29    ,$0000   ;R E4 0000   set r29 to 228
    LDS     r1     ,$0000   ;R C8 0000   set r1 to 200
    LDS     r18    ,$0000   ;R 4E 0000   set r18 to 78
    LDS     r10    ,$0000   ;R B5 0000   set r10 to 181
    LDS     r3     ,$0000   ;R E4 0000   set r3 to 228
    LDS     r25    ,$0000   ;R C4 0000   set r25 to 196

; push all the registers
    PUSH    r16             ;W 7D 0000
    PUSH    r5              ;W 62 FFFF
    PUSH    r19             ;W 78 FFFE
    PUSH    r27             ;W D4 FFFD
    PUSH    r6              ;W B5 FFFC
    PUSH    r30             ;W 2B FFFB
    PUSH    r12             ;W 39 FFFA
    PUSH    r20             ;W C8 FFF9
    PUSH    r28             ;W 87 FFF8
    PUSH    r11             ;W 28 FFF7
    PUSH    r8              ;W 82 FFF6
    PUSH    r21             ;W B8 FFF5
    PUSH    r24             ;W EC FFF4
    PUSH    r4              ;W B6 FFF3
    PUSH    r7              ;W A9 FFF2
    PUSH    r9              ;W 3C FFF1
    PUSH    r22             ;W 95 FFF0
    PUSH    r0              ;W D8 FFEF
    PUSH    r17             ;W 69 FFEE
    PUSH    r23             ;W FE FFED
    PUSH    r26             ;W 16 FFEC
    PUSH    r13             ;W FF FFEB
    PUSH    r15             ;W 0A FFEA
    PUSH    r2              ;W 4D FFE9
    PUSH    r14             ;W 59 FFE8
    PUSH    r31             ;W 0B FFE7
    PUSH    r29             ;W E4 FFE6
    PUSH    r1              ;W C8 FFE5
    PUSH    r18             ;W 4E FFE4
    PUSH    r10             ;W B5 FFE3
    PUSH    r3              ;W E4 FFE2
    PUSH    r25             ;W C4 FFE1

; pop all the registers
    POP     r25             ;R C4 FFE1
    POP     r3              ;R E4 FFE2
    POP     r10             ;R B5 FFE3
    POP     r18             ;R 4E FFE4
    POP     r1              ;R C8 FFE5
    POP     r29             ;R E4 FFE6
    POP     r31             ;R 0B FFE7
    POP     r14             ;R 59 FFE8
    POP     r2              ;R 4D FFE9
    POP     r15             ;R 0A FFEA
    POP     r13             ;R FF FFEB
    POP     r26             ;R 16 FFEC
    POP     r23             ;R FE FFED
    POP     r17             ;R 69 FFEE
    POP     r0              ;R D8 FFEF
    POP     r22             ;R 95 FFF0
    POP     r9              ;R 3C FFF1
    POP     r7              ;R A9 FFF2
    POP     r4              ;R B6 FFF3
    POP     r24             ;R EC FFF4
    POP     r21             ;R B8 FFF5
    POP     r8              ;R 82 FFF6
    POP     r11             ;R 28 FFF7
    POP     r28             ;R 87 FFF8
    POP     r20             ;R C8 FFF9
    POP     r12             ;R 39 FFFA
    POP     r30             ;R 2B FFFB
    POP     r6              ;R B5 FFFC
    POP     r27             ;R D4 FFFD
    POP     r19             ;R 78 FFFE
    POP     r5              ;R 62 FFFF
    POP     r16             ;R 7D 0000

; check all the values are unchanged
    STS     $0000  ,r16     ;W 7D 0000   r16 should be 125
    STS     $0000  ,r5      ;W 62 0000   r5 should be 98
    STS     $0000  ,r19     ;W 78 0000   r19 should be 120
    STS     $0000  ,r27     ;W D4 0000   r27 should be 212
    STS     $0000  ,r6      ;W B5 0000   r6 should be 181
    STS     $0000  ,r30     ;W 2B 0000   r30 should be 43
    STS     $0000  ,r12     ;W 39 0000   r12 should be 57
    STS     $0000  ,r20     ;W C8 0000   r20 should be 200
    STS     $0000  ,r28     ;W 87 0000   r28 should be 135
    STS     $0000  ,r11     ;W 28 0000   r11 should be 40
    STS     $0000  ,r8      ;W 82 0000   r8 should be 130
    STS     $0000  ,r21     ;W B8 0000   r21 should be 184
    STS     $0000  ,r24     ;W EC 0000   r24 should be 236
    STS     $0000  ,r4      ;W B6 0000   r4 should be 182
    STS     $0000  ,r7      ;W A9 0000   r7 should be 169
    STS     $0000  ,r9      ;W 3C 0000   r9 should be 60
    STS     $0000  ,r22     ;W 95 0000   r22 should be 149
    STS     $0000  ,r0      ;W D8 0000   r0 should be 216
    STS     $0000  ,r17     ;W 69 0000   r17 should be 105
    STS     $0000  ,r23     ;W FE 0000   r23 should be 254
    STS     $0000  ,r26     ;W 16 0000   r26 should be 22
    STS     $0000  ,r13     ;W FF 0000   r13 should be 255
    STS     $0000  ,r15     ;W 0A 0000   r15 should be 10
    STS     $0000  ,r2      ;W 4D 0000   r2 should be 77
    STS     $0000  ,r14     ;W 59 0000   r14 should be 89
    STS     $0000  ,r31     ;W 0B 0000   r31 should be 11
    STS     $0000  ,r29     ;W E4 0000   r29 should be 228
    STS     $0000  ,r1      ;W C8 0000   r1 should be 200
    STS     $0000  ,r18     ;W 4E 0000   r18 should be 78
    STS     $0000  ,r10     ;W B5 0000   r10 should be 181
    STS     $0000  ,r3      ;W E4 0000   r3 should be 228
    STS     $0000  ,r25     ;W C4 0000   r25 should be 196