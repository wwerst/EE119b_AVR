
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
    LDI     r26    ,$80     ;
    LDI     r19    ,$A1     ;
    LDI     r16    ,$C7     ;
    LDI     r27    ,$64     ;
    LDI     r28    ,$A5     ;
    LDI     r24    ,$22     ;
    LDI     r29    ,$4B     ;
    LDI     r23    ,$6B     ;
    LDI     r25    ,$D9     ;
    LDI     r21    ,$69     ;
    STS     $0000  ,r26     ;W 80 0000   r26 should be 128
    STS     $0000  ,r19     ;W A1 0000   r19 should be 161
    STS     $0000  ,r16     ;W C7 0000   r16 should be 199
    STS     $0000  ,r27     ;W 64 0000   r27 should be 100
    STS     $0000  ,r28     ;W A5 0000   r28 should be 165
    STS     $0000  ,r24     ;W 22 0000   r24 should be 34
    STS     $0000  ,r29     ;W 4B 0000   r29 should be 75
    STS     $0000  ,r23     ;W 6B 0000   r23 should be 107
    STS     $0000  ,r25     ;W D9 0000   r25 should be 217
    STS     $0000  ,r21     ;W 69 0000   r21 should be 105



;PREPROCESS TestLD


; do a few simple LDs from X register
    LDI     r26    ,$04     ;            set X to $0004
    LDI     r27    ,$00     ;
    LD      r0     ,X       ;R EC 0004
    STS     $0000  ,r0      ;W EC 0000   r0 should be 236
    LD      r8     ,X       ;R EC 0004
    STS     $0000  ,r8      ;W EC 0000   r8 should be 236
    LD      r31    ,X       ;R EC 0004
    STS     $0000  ,r31     ;W EC 0000   r31 should be 236

; load with pre decrement through 0x0000
    LD      r19    ,-X      ;R 70 0003
    LD      r15    ,-X      ;R 74 0002
    LD      r31    ,-X      ;R 0F 0001
    LD      r16    ,-X      ;R 5E 0000
    LD      r3     ,-X      ;R E4 FFFF
    LD      r24    ,-X      ;R D9 FFFE
    LD      r4     ,-X      ;R 43 FFFD
    LD      r9     ,-X      ;R 3C FFFC
    STS     $0000  ,r19     ;W 70 0000   r19 should be 112
    STS     $0000  ,r15     ;W 74 0000   r15 should be 116
    STS     $0000  ,r31     ;W 0F 0000   r31 should be 15
    STS     $0000  ,r16     ;W 5E 0000   r16 should be 94
    STS     $0000  ,r3      ;W E4 0000   r3 should be 228
    STS     $0000  ,r24     ;W D9 0000   r24 should be 217
    STS     $0000  ,r4      ;W 43 0000   r4 should be 67
    STS     $0000  ,r9      ;W 3C 0000   r9 should be 60

; load with post increment through 0xFFFF
    LD      r11    ,X+      ;R 55 FFFC
    LD      r14    ,X+      ;R 83 FFFD
    LD      r18    ,X+      ;R CA FFFE
    LD      r21    ,X+      ;R 80 FFFF
    LD      r28    ,X+      ;R A7 0000
    LD      r5     ,X+      ;R D4 0001
    LD      r3     ,X+      ;R A9 0002
    LD      r1     ,X+      ;R AC 0003
    STS     $0000  ,r11     ;W 55 0000   r11 should be 85
    STS     $0000  ,r14     ;W 83 0000   r14 should be 131
    STS     $0000  ,r18     ;W CA 0000   r18 should be 202
    STS     $0000  ,r21     ;W 80 0000   r21 should be 128
    STS     $0000  ,r28     ;W A7 0000   r28 should be 167
    STS     $0000  ,r5      ;W D4 0000   r5 should be 212
    STS     $0000  ,r3      ;W A9 0000   r3 should be 169
    STS     $0000  ,r1      ;W AC 0000   r1 should be 172

; do a few simple LDs from Y register
    LDI     r28    ,$04     ;            set Y to $0004
    LDI     r29    ,$00     ;
    LD      r0     ,Y       ;R EC 0004
    STS     $0000  ,r0      ;W EC 0000   r0 should be 236
    LD      r8     ,Y       ;R EC 0004
    STS     $0000  ,r8      ;W EC 0000   r8 should be 236
    LD      r31    ,Y       ;R EC 0004
    STS     $0000  ,r31     ;W EC 0000   r31 should be 236

; load with pre decrement through 0x0000
    LD      r10    ,-Y      ;R F7 0003
    LD      r8     ,-Y      ;R 77 0002
    LD      r30    ,-Y      ;R 47 0001
    LD      r13    ,-Y      ;R B7 0000
    LD      r27    ,-Y      ;R 33 FFFF
    LD      r16    ,-Y      ;R 36 FFFE
    LD      r1     ,-Y      ;R 3A FFFD
    LD      r11    ,-Y      ;R D7 FFFC
    STS     $0000  ,r10     ;W F7 0000   r10 should be 247
    STS     $0000  ,r8      ;W 77 0000   r8 should be 119
    STS     $0000  ,r30     ;W 47 0000   r30 should be 71
    STS     $0000  ,r13     ;W B7 0000   r13 should be 183
    STS     $0000  ,r27     ;W 33 0000   r27 should be 51
    STS     $0000  ,r16     ;W 36 0000   r16 should be 54
    STS     $0000  ,r1      ;W 3A 0000   r1 should be 58
    STS     $0000  ,r11     ;W D7 0000   r11 should be 215

; load with post increment through 0xFFFF
    LD      r15    ,Y+      ;R 78 FFFC
    LD      r5     ,Y+      ;R A6 FFFD
    LD      r30    ,Y+      ;R 4E FFFE
    LD      r14    ,Y+      ;R 63 FFFF
    LD      r17    ,Y+      ;R 57 0000
    LD      r22    ,Y+      ;R 2B 0001
    LD      r2     ,Y+      ;R D3 0002
    LD      r9     ,Y+      ;R 51 0003
    STS     $0000  ,r15     ;W 78 0000   r15 should be 120
    STS     $0000  ,r5      ;W A6 0000   r5 should be 166
    STS     $0000  ,r30     ;W 4E 0000   r30 should be 78
    STS     $0000  ,r14     ;W 63 0000   r14 should be 99
    STS     $0000  ,r17     ;W 57 0000   r17 should be 87
    STS     $0000  ,r22     ;W 2B 0000   r22 should be 43
    STS     $0000  ,r2      ;W D3 0000   r2 should be 211
    STS     $0000  ,r9      ;W 51 0000   r9 should be 81

; do a few simple LDs from Z register
    LDI     r30    ,$04     ;            set Z to $0004
    LDI     r31    ,$00     ;
    LD      r0     ,Z       ;R EC 0004
    STS     $0000  ,r0      ;W EC 0000   r0 should be 236
    LD      r8     ,Z       ;R EC 0004
    STS     $0000  ,r8      ;W EC 0000   r8 should be 236
    LD      r31    ,Z       ;R EC 0004
    STS     $0000  ,r31     ;W EC 0000   r31 should be 236

; load with pre decrement through 0x0000
    LD      r6     ,-Z      ;R 7D 0003
    LD      r27    ,-Z      ;R 1D 0002
    LD      r3     ,-Z      ;R 03 0001
    LD      r22    ,-Z      ;R CA 0000
    LD      r19    ,-Z      ;R 88 FFFF
    LD      r24    ,-Z      ;R 00 FFFE
    LD      r20    ,-Z      ;R 8B FFFD
    LD      r15    ,-Z      ;R FD FFFC
    STS     $0000  ,r6      ;W 7D 0000   r6 should be 125
    STS     $0000  ,r27     ;W 1D 0000   r27 should be 29
    STS     $0000  ,r3      ;W 03 0000   r3 should be 3
    STS     $0000  ,r22     ;W CA 0000   r22 should be 202
    STS     $0000  ,r19     ;W 88 0000   r19 should be 136
    STS     $0000  ,r24     ;W 00 0000   r24 should be 0
    STS     $0000  ,r20     ;W 8B 0000   r20 should be 139
    STS     $0000  ,r15     ;W FD 0000   r15 should be 253

; load with post increment through 0xFFFF
    LD      r3     ,Z+      ;R C9 FFFC
    LD      r0     ,Z+      ;R 05 FFFD
    LD      r6     ,Z+      ;R ED FFFE
    LD      r19    ,Z+      ;R 83 FFFF
    LD      r16    ,Z+      ;R 40 0000
    LD      r20    ,Z+      ;R D5 0001
    LD      r21    ,Z+      ;R 62 0002
    LD      r1     ,Z+      ;R 77 0003
    STS     $0000  ,r3      ;W C9 0000   r3 should be 201
    STS     $0000  ,r0      ;W 05 0000   r0 should be 5
    STS     $0000  ,r6      ;W ED 0000   r6 should be 237
    STS     $0000  ,r19     ;W 83 0000   r19 should be 131
    STS     $0000  ,r16     ;W 40 0000   r16 should be 64
    STS     $0000  ,r20     ;W D5 0000   r20 should be 213
    STS     $0000  ,r21     ;W 62 0000   r21 should be 98
    STS     $0000  ,r1      ;W 77 0000   r1 should be 119



;PREPROCESS TestLDD

    LDI     r28    ,$E0     ;            set Y to $FFE0
    LDI     r29    ,$FF     ;
    LDD     r20    ,Y+0     ;R 84 FFE0
    LDD     r24    ,Y+3     ;R D0 FFE3
    LDD     r24    ,Y+42    ;R 87 000A
    LDD     r10    ,Y+5     ;R 21 FFE5
    LDD     r6     ,Y+47    ;R BF 000F
    LDD     r3     ,Y+40    ;R 14 0008
    LDD     r13    ,Y+61    ;R F8 001D
    LDD     r19    ,Y+63    ;R A0 001F
    STS     $0000  ,r20     ;W 84 0000   r20 should be 132
    STS     $0000  ,r24     ;W D0 0000   r24 should be 208
    STS     $0000  ,r24     ;W 87 0000   r24 should be 135
    STS     $0000  ,r10     ;W 21 0000   r10 should be 33
    STS     $0000  ,r6      ;W BF 0000   r6 should be 191
    STS     $0000  ,r3      ;W 14 0000   r3 should be 20
    STS     $0000  ,r13     ;W F8 0000   r13 should be 248
    STS     $0000  ,r19     ;W A0 0000   r19 should be 160
    LDI     r30    ,$E0     ;            set Z to $FFE0
    LDI     r31    ,$FF     ;
    LDD     r3     ,Z+0     ;R 11 FFE0
    LDD     r23    ,Z+32    ;R 72 0000
    LDD     r13    ,Z+52    ;R 65 0014
    LDD     r13    ,Z+35    ;R 3C 0003
    LDD     r11    ,Z+52    ;R EA 0014
    LDD     r22    ,Z+55    ;R 97 0017
    LDD     r6     ,Z+62    ;R 5A 001E
    LDD     r29    ,Z+63    ;R 4F 001F
    STS     $0000  ,r3      ;W 11 0000   r3 should be 17
    STS     $0000  ,r23     ;W 72 0000   r23 should be 114
    STS     $0000  ,r13     ;W 65 0000   r13 should be 101
    STS     $0000  ,r13     ;W 3C 0000   r13 should be 60
    STS     $0000  ,r11     ;W EA 0000   r11 should be 234
    STS     $0000  ,r22     ;W 97 0000   r22 should be 151
    STS     $0000  ,r6      ;W 5A 0000   r6 should be 90
    STS     $0000  ,r29     ;W 4F 0000   r29 should be 79



;PREPROCESS TestLDS


; do a few simple LDSs
    LDS     r0     ,$0000   ;R EC 0000
    STS     $0000  ,r0      ;W EC 0000   r0 should be 236
    LDS     r15    ,$FF00   ;R EC FF00
    STS     $0000  ,r15     ;W EC 0000   r15 should be 236
    LDS     r30    ,$FFFF   ;R EC FFFF
    STS     $0000  ,r30     ;W EC 0000   r30 should be 236

; do some random LDSs
    LDS     r15    ,$9938   ;R CC 9938
    LDS     r28    ,$DDDE   ;R AE DDDE
    LDS     r0     ,$66B7   ;R CD 66B7
    LDS     r30    ,$F974   ;R 44 F974
    LDS     r12    ,$5EEB   ;R BA 5EEB
    LDS     r14    ,$E7A3   ;R BE E7A3
    LDS     r26    ,$EE84   ;R 37 EE84
    LDS     r20    ,$A5FB   ;R B4 A5FB
    LDS     r27    ,$226D   ;R 26 226D
    LDS     r3     ,$22C2   ;R 0E 22C2
    STS     $0000  ,r15     ;W CC 0000   r15 should be 204
    STS     $0000  ,r28     ;W AE 0000   r28 should be 174
    STS     $0000  ,r0      ;W CD 0000   r0 should be 205
    STS     $0000  ,r30     ;W 44 0000   r30 should be 68
    STS     $0000  ,r12     ;W BA 0000   r12 should be 186
    STS     $0000  ,r14     ;W BE 0000   r14 should be 190
    STS     $0000  ,r26     ;W 37 0000   r26 should be 55
    STS     $0000  ,r20     ;W B4 0000   r20 should be 180
    STS     $0000  ,r27     ;W 26 0000   r27 should be 38
    STS     $0000  ,r3      ;W 0E 0000   r3 should be 14



;PREPROCESS TestMOV


; do a few simple MOVs
    LDS     r0     ,$0000   ;R EB 0000
    MOV     r0     ,r1      ;
    STS     $0000  ,r1      ;W EB 0000   r1 should be 235
    LDS     r31    ,$0000   ;R 9F 0000
    MOV     r31    ,r30     ;
    STS     $0000  ,r30     ;W 9F 0000   r30 should be 159

; do a random move through all registers
    LDS     r23    ,$0000   ;R 1B 0000
    MOV     r23    ,r8      ;
    MOV     r8     ,r12     ;
    MOV     r12    ,r14     ;
    MOV     r14    ,r30     ;
    MOV     r30    ,r26     ;
    MOV     r26    ,r22     ;
    MOV     r22    ,r0      ;
    MOV     r0     ,r17     ;
    MOV     r17    ,r13     ;
    MOV     r13    ,r10     ;
    MOV     r10    ,r5      ;
    MOV     r5     ,r29     ;
    MOV     r29    ,r7      ;
    MOV     r7     ,r27     ;
    MOV     r27    ,r9      ;
    MOV     r9     ,r16     ;
    MOV     r16    ,r3      ;
    MOV     r3     ,r18     ;
    MOV     r18    ,r4      ;
    MOV     r4     ,r11     ;
    MOV     r11    ,r20     ;
    MOV     r20    ,r2      ;
    MOV     r2     ,r28     ;
    MOV     r28    ,r19     ;
    MOV     r19    ,r24     ;
    MOV     r24    ,r6      ;
    MOV     r6     ,r31     ;
    MOV     r31    ,r25     ;
    MOV     r25    ,r1      ;
    MOV     r1     ,r21     ;
    MOV     r21    ,r15     ;
    STS     $0000  ,r15     ;W 1B 0000   r15 should be 27



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
    LDS     r16    ,$0000   ;R 17 0000   set r16 to 23
    LDS     r13    ,$0000   ;R 0A 0000   set r13 to 10
    LDS     r29    ,$0000   ;R C7 0000   set r29 to 199
    LDS     r24    ,$0000   ;R 64 0000   set r24 to 100
    LDS     r17    ,$0000   ;R 7C 0000   set r17 to 124
    LDS     r15    ,$0000   ;R 2F 0000   set r15 to 47
    LDS     r9     ,$0000   ;R AB 0000   set r9 to 171
    LDS     r7     ,$0000   ;R B2 0000   set r7 to 178
    ST      -X     ,r16     ;W 17 0003
    ST      -X     ,r13     ;W 0A 0002
    ST      -X     ,r29     ;W C7 0001
    ST      -X     ,r24     ;W 64 0000
    ST      -X     ,r17     ;W 7C FFFF
    ST      -X     ,r15     ;W 2F FFFE
    ST      -X     ,r9      ;W AB FFFD
    ST      -X     ,r7      ;W B2 FFFC

; store with post increment through 0xFFFF
    LDS     r7     ,$0000   ;R 63 0000   set r7 to 99
    LDS     r13    ,$0000   ;R AF 0000   set r13 to 175
    LDS     r8     ,$0000   ;R 65 0000   set r8 to 101
    LDS     r28    ,$0000   ;R BD 0000   set r28 to 189
    LDS     r17    ,$0000   ;R 3A 0000   set r17 to 58
    LDS     r12    ,$0000   ;R E5 0000   set r12 to 229
    LDS     r22    ,$0000   ;R CC 0000   set r22 to 204
    LDS     r9     ,$0000   ;R 8D 0000   set r9 to 141
    ST      X+     ,r7      ;W 63 FFFC
    ST      X+     ,r13     ;W AF FFFD
    ST      X+     ,r8      ;W 65 FFFE
    ST      X+     ,r28     ;W BD FFFF
    ST      X+     ,r17     ;W 3A 0000
    ST      X+     ,r12     ;W E5 0001
    ST      X+     ,r22     ;W CC 0002
    ST      X+     ,r9      ;W 8D 0003
    LDI     r28    ,$04     ;            set Y to $0004
    LDI     r29    ,$00     ;
    LDS     r0     ,$0000   ;R EC 0000   set r0 to 236
    ST      Y      ,r0      ;W EC 0004
    LDS     r8     ,$0000   ;R EC 0000   set r8 to 236
    ST      Y      ,r8      ;W EC 0004
    LDS     r31    ,$0000   ;R EC 0000   set r31 to 236
    ST      Y      ,r31     ;W EC 0004

; store with pre decrement through 0x0000
    LDS     r0     ,$0000   ;R 62 0000   set r0 to 98
    LDS     r18    ,$0000   ;R 63 0000   set r18 to 99
    LDS     r4     ,$0000   ;R EF 0000   set r4 to 239
    LDS     r2     ,$0000   ;R 98 0000   set r2 to 152
    LDS     r27    ,$0000   ;R 18 0000   set r27 to 24
    LDS     r16    ,$0000   ;R 3B 0000   set r16 to 59
    LDS     r9     ,$0000   ;R C4 0000   set r9 to 196
    LDS     r30    ,$0000   ;R 91 0000   set r30 to 145
    ST      -Y     ,r0      ;W 62 0003
    ST      -Y     ,r18     ;W 63 0002
    ST      -Y     ,r4      ;W EF 0001
    ST      -Y     ,r2      ;W 98 0000
    ST      -Y     ,r27     ;W 18 FFFF
    ST      -Y     ,r16     ;W 3B FFFE
    ST      -Y     ,r9      ;W C4 FFFD
    ST      -Y     ,r30     ;W 91 FFFC

; store with post increment through 0xFFFF
    LDS     r20    ,$0000   ;R 6D 0000   set r20 to 109
    LDS     r8     ,$0000   ;R 4F 0000   set r8 to 79
    LDS     r13    ,$0000   ;R A4 0000   set r13 to 164
    LDS     r19    ,$0000   ;R 2A 0000   set r19 to 42
    LDS     r11    ,$0000   ;R 5B 0000   set r11 to 91
    LDS     r26    ,$0000   ;R 84 0000   set r26 to 132
    LDS     r0     ,$0000   ;R 5D 0000   set r0 to 93
    LDS     r27    ,$0000   ;R 56 0000   set r27 to 86
    ST      Y+     ,r20     ;W 6D FFFC
    ST      Y+     ,r8      ;W 4F FFFD
    ST      Y+     ,r13     ;W A4 FFFE
    ST      Y+     ,r19     ;W 2A FFFF
    ST      Y+     ,r11     ;W 5B 0000
    ST      Y+     ,r26     ;W 84 0001
    ST      Y+     ,r0      ;W 5D 0002
    ST      Y+     ,r27     ;W 56 0003
    LDI     r30    ,$04     ;            set Z to $0004
    LDI     r31    ,$00     ;
    LDS     r0     ,$0000   ;R EC 0000   set r0 to 236
    ST      Z      ,r0      ;W EC 0004
    LDS     r8     ,$0000   ;R EC 0000   set r8 to 236
    ST      Z      ,r8      ;W EC 0004
    LDS     r31    ,$0000   ;R EC 0000   set r31 to 236
    ST      Z      ,r31     ;W EC 0004

; store with pre decrement through 0x0000
    LDS     r29    ,$0000   ;R D1 0000   set r29 to 209
    LDS     r8     ,$0000   ;R 01 0000   set r8 to 1
    LDS     r13    ,$0000   ;R B3 0000   set r13 to 179
    LDS     r7     ,$0000   ;R 47 0000   set r7 to 71
    LDS     r16    ,$0000   ;R 67 0000   set r16 to 103
    LDS     r3     ,$0000   ;R F8 0000   set r3 to 248
    LDS     r11    ,$0000   ;R 71 0000   set r11 to 113
    LDS     r15    ,$0000   ;R C0 0000   set r15 to 192
    ST      -Z     ,r29     ;W D1 0003
    ST      -Z     ,r8      ;W 01 0002
    ST      -Z     ,r13     ;W B3 0001
    ST      -Z     ,r7      ;W 47 0000
    ST      -Z     ,r16     ;W 67 FFFF
    ST      -Z     ,r3      ;W F8 FFFE
    ST      -Z     ,r11     ;W 71 FFFD
    ST      -Z     ,r15     ;W C0 FFFC

; store with post increment through 0xFFFF
    LDS     r26    ,$0000   ;R 4F 0000   set r26 to 79
    LDS     r1     ,$0000   ;R 1F 0000   set r1 to 31
    LDS     r12    ,$0000   ;R 1D 0000   set r12 to 29
    LDS     r4     ,$0000   ;R 87 0000   set r4 to 135
    LDS     r21    ,$0000   ;R 4F 0000   set r21 to 79
    LDS     r18    ,$0000   ;R 67 0000   set r18 to 103
    LDS     r3     ,$0000   ;R 63 0000   set r3 to 99
    LDS     r9     ,$0000   ;R 8D 0000   set r9 to 141
    ST      Z+     ,r26     ;W 4F FFFC
    ST      Z+     ,r1      ;W 1F FFFD
    ST      Z+     ,r12     ;W 1D FFFE
    ST      Z+     ,r4      ;W 87 FFFF
    ST      Z+     ,r21     ;W 4F 0000
    ST      Z+     ,r18     ;W 67 0001
    ST      Z+     ,r3      ;W 63 0002
    ST      Z+     ,r9      ;W 8D 0003



;PREPROCESS TestSTD

    LDI     r28    ,$E0     ;            set Y to $FFE0
    LDI     r29    ,$FF     ;
    LDS     r1     ,$0000   ;R 77 0000   set r1 to 119
    LDS     r31    ,$0000   ;R DE 0000   set r31 to 222
    LDS     r4     ,$0000   ;R 39 0000   set r4 to 57
    LDS     r24    ,$0000   ;R B8 0000   set r24 to 184
    LDS     r17    ,$0000   ;R CB 0000   set r17 to 203
    LDS     r31    ,$0000   ;R A4 0000   set r31 to 164
    LDS     r4     ,$0000   ;R 25 0000   set r4 to 37
    LDS     r21    ,$0000   ;R 22 0000   set r21 to 34
    STD     Y+0    ,r1      ;W 77 FFE0
    STD     Y+61   ,r31     ;W DE 001D
    STD     Y+8    ,r4      ;W 39 FFE8
    STD     Y+34   ,r24     ;W B8 0002
    STD     Y+2    ,r17     ;W CB FFE2
    STD     Y+25   ,r31     ;W A4 FFF9
    STD     Y+62   ,r4      ;W 25 001E
    STD     Y+63   ,r21     ;W 22 001F
    LDI     r30    ,$E0     ;            set Z to $FFE0
    LDI     r31    ,$FF     ;
    LDS     r21    ,$0000   ;R 72 0000   set r21 to 114
    LDS     r23    ,$0000   ;R 80 0000   set r23 to 128
    LDS     r4     ,$0000   ;R 92 0000   set r4 to 146
    LDS     r21    ,$0000   ;R EF 0000   set r21 to 239
    LDS     r9     ,$0000   ;R 23 0000   set r9 to 35
    LDS     r15    ,$0000   ;R 0C 0000   set r15 to 12
    LDS     r7     ,$0000   ;R D5 0000   set r7 to 213
    LDS     r12    ,$0000   ;R 9E 0000   set r12 to 158
    STD     Z+0    ,r21     ;W 72 FFE0
    STD     Z+49   ,r23     ;W 80 0011
    STD     Z+52   ,r4      ;W 92 0014
    STD     Z+32   ,r21     ;W EF 0000
    STD     Z+33   ,r9      ;W 23 0001
    STD     Z+15   ,r15     ;W 0C FFEF
    STD     Z+54   ,r7      ;W D5 0016
    STD     Z+63   ,r12     ;W 9E 001F



;PREPROCESS TestSTS


; do a few simple STSs
    LDS     r0     ,$0000   ;R EC 0000   set r0 to 236
    STS     $0000  ,r0      ;W EC 0000
    LDS     r15    ,$0000   ;R EC 0000   set r15 to 236
    STS     $FF00  ,r15     ;W EC FF00
    LDS     r30    ,$0000   ;R EC 0000   set r30 to 236
    STS     $FFFF  ,r30     ;W EC FFFF

; do some random STSs
    LDS     r17    ,$0000   ;R C2 0000   set r17 to 194
    LDS     r10    ,$0000   ;R 72 0000   set r10 to 114
    LDS     r1     ,$0000   ;R 98 0000   set r1 to 152
    LDS     r0     ,$0000   ;R 58 0000   set r0 to 88
    LDS     r9     ,$0000   ;R C4 0000   set r9 to 196
    LDS     r19    ,$0000   ;R E5 0000   set r19 to 229
    LDS     r6     ,$0000   ;R 4D 0000   set r6 to 77
    LDS     r2     ,$0000   ;R 5A 0000   set r2 to 90
    LDS     r21    ,$0000   ;R C3 0000   set r21 to 195
    LDS     r13    ,$0000   ;R 8F 0000   set r13 to 143
    STS     $80A1  ,r17     ;W C2 80A1
    STS     $2993  ,r10     ;W 72 2993
    STS     $8C20  ,r1      ;W 98 8C20
    STS     $EDA4  ,r0      ;W 58 EDA4
    STS     $5AF9  ,r9      ;W C4 5AF9
    STS     $6201  ,r19     ;W E5 6201
    STS     $57E8  ,r6      ;W 4D 57E8
    STS     $D772  ,r2      ;W 5A D772
    STS     $62BC  ,r21     ;W C3 62BC
    STS     $CA2E  ,r13     ;W 8F CA2E

;PREPROCESS TestPUSH

;PREPROCESS TestPOP

; load some random values into registers
    LDS     r15    ,$0000   ;R 74 0000   set r15 to 116
    LDS     r9     ,$0000   ;R 8C 0000   set r9 to 140
    LDS     r17    ,$0000   ;R 93 0000   set r17 to 147
    LDS     r24    ,$0000   ;R 95 0000   set r24 to 149
    LDS     r4     ,$0000   ;R 96 0000   set r4 to 150
    LDS     r28    ,$0000   ;R F2 0000   set r28 to 242
    LDS     r31    ,$0000   ;R 48 0000   set r31 to 72
    LDS     r3     ,$0000   ;R AE 0000   set r3 to 174
    LDS     r14    ,$0000   ;R 15 0000   set r14 to 21
    LDS     r18    ,$0000   ;R 84 0000   set r18 to 132
    LDS     r2     ,$0000   ;R D4 0000   set r2 to 212
    LDS     r21    ,$0000   ;R 19 0000   set r21 to 25
    LDS     r20    ,$0000   ;R 8D 0000   set r20 to 141
    LDS     r10    ,$0000   ;R E4 0000   set r10 to 228
    LDS     r1     ,$0000   ;R FF 0000   set r1 to 255
    LDS     r26    ,$0000   ;R 67 0000   set r26 to 103
    LDS     r27    ,$0000   ;R 53 0000   set r27 to 83
    LDS     r11    ,$0000   ;R 61 0000   set r11 to 97
    LDS     r19    ,$0000   ;R 85 0000   set r19 to 133
    LDS     r7     ,$0000   ;R 3F 0000   set r7 to 63
    LDS     r29    ,$0000   ;R AE 0000   set r29 to 174
    LDS     r16    ,$0000   ;R E2 0000   set r16 to 226
    LDS     r30    ,$0000   ;R A1 0000   set r30 to 161
    LDS     r13    ,$0000   ;R 28 0000   set r13 to 40
    LDS     r0     ,$0000   ;R 5C 0000   set r0 to 92
    LDS     r5     ,$0000   ;R 1B 0000   set r5 to 27
    LDS     r6     ,$0000   ;R 5F 0000   set r6 to 95
    LDS     r8     ,$0000   ;R 08 0000   set r8 to 8
    LDS     r23    ,$0000   ;R 61 0000   set r23 to 97
    LDS     r12    ,$0000   ;R E8 0000   set r12 to 232
    LDS     r25    ,$0000   ;R B1 0000   set r25 to 177
    LDS     r22    ,$0000   ;R 86 0000   set r22 to 134

; push all the registers
    PUSH    r15             ;W 74 0000
    PUSH    r9              ;W 8C FFFF
    PUSH    r17             ;W 93 FFFE
    PUSH    r24             ;W 95 FFFD
    PUSH    r4              ;W 96 FFFC
    PUSH    r28             ;W F2 FFFB
    PUSH    r31             ;W 48 FFFA
    PUSH    r3              ;W AE FFF9
    PUSH    r14             ;W 15 FFF8
    PUSH    r18             ;W 84 FFF7
    PUSH    r2              ;W D4 FFF6
    PUSH    r21             ;W 19 FFF5
    PUSH    r20             ;W 8D FFF4
    PUSH    r10             ;W E4 FFF3
    PUSH    r1              ;W FF FFF2
    PUSH    r26             ;W 67 FFF1
    PUSH    r27             ;W 53 FFF0
    PUSH    r11             ;W 61 FFEF
    PUSH    r19             ;W 85 FFEE
    PUSH    r7              ;W 3F FFED
    PUSH    r29             ;W AE FFEC
    PUSH    r16             ;W E2 FFEB
    PUSH    r30             ;W A1 FFEA
    PUSH    r13             ;W 28 FFE9
    PUSH    r0              ;W 5C FFE8
    PUSH    r5              ;W 1B FFE7
    PUSH    r6              ;W 5F FFE6
    PUSH    r8              ;W 08 FFE5
    PUSH    r23             ;W 61 FFE4
    PUSH    r12             ;W E8 FFE3
    PUSH    r25             ;W B1 FFE2
    PUSH    r22             ;W 86 FFE1

; pop all the registers
    POP     r22             ;R 86 FFE1
    POP     r25             ;R B1 FFE2
    POP     r12             ;R E8 FFE3
    POP     r23             ;R 61 FFE4
    POP     r8              ;R 08 FFE5
    POP     r6              ;R 5F FFE6
    POP     r5              ;R 1B FFE7
    POP     r0              ;R 5C FFE8
    POP     r13             ;R 28 FFE9
    POP     r30             ;R A1 FFEA
    POP     r16             ;R E2 FFEB
    POP     r29             ;R AE FFEC
    POP     r7              ;R 3F FFED
    POP     r19             ;R 85 FFEE
    POP     r11             ;R 61 FFEF
    POP     r27             ;R 53 FFF0
    POP     r26             ;R 67 FFF1
    POP     r1              ;R FF FFF2
    POP     r10             ;R E4 FFF3
    POP     r20             ;R 8D FFF4
    POP     r21             ;R 19 FFF5
    POP     r2              ;R D4 FFF6
    POP     r18             ;R 84 FFF7
    POP     r14             ;R 15 FFF8
    POP     r3              ;R AE FFF9
    POP     r31             ;R 48 FFFA
    POP     r28             ;R F2 FFFB
    POP     r4              ;R 96 FFFC
    POP     r24             ;R 95 FFFD
    POP     r17             ;R 93 FFFE
    POP     r9              ;R 8C FFFF
    POP     r15             ;R 74 0000

; check all the values are unchanged
    STS     $0000  ,r15     ;W 74 0000   r15 should be 116
    STS     $0000  ,r9      ;W 8C 0000   r9 should be 140
    STS     $0000  ,r17     ;W 93 0000   r17 should be 147
    STS     $0000  ,r24     ;W 95 0000   r24 should be 149
    STS     $0000  ,r4      ;W 96 0000   r4 should be 150
    STS     $0000  ,r28     ;W F2 0000   r28 should be 242
    STS     $0000  ,r31     ;W 48 0000   r31 should be 72
    STS     $0000  ,r3      ;W AE 0000   r3 should be 174
    STS     $0000  ,r14     ;W 15 0000   r14 should be 21
    STS     $0000  ,r18     ;W 84 0000   r18 should be 132
    STS     $0000  ,r2      ;W D4 0000   r2 should be 212
    STS     $0000  ,r21     ;W 19 0000   r21 should be 25
    STS     $0000  ,r20     ;W 8D 0000   r20 should be 141
    STS     $0000  ,r10     ;W E4 0000   r10 should be 228
    STS     $0000  ,r1      ;W FF 0000   r1 should be 255
    STS     $0000  ,r26     ;W 67 0000   r26 should be 103
    STS     $0000  ,r27     ;W 53 0000   r27 should be 83
    STS     $0000  ,r11     ;W 61 0000   r11 should be 97
    STS     $0000  ,r19     ;W 85 0000   r19 should be 133
    STS     $0000  ,r7      ;W 3F 0000   r7 should be 63
    STS     $0000  ,r29     ;W AE 0000   r29 should be 174
    STS     $0000  ,r16     ;W E2 0000   r16 should be 226
    STS     $0000  ,r30     ;W A1 0000   r30 should be 161
    STS     $0000  ,r13     ;W 28 0000   r13 should be 40
    STS     $0000  ,r0      ;W 5C 0000   r0 should be 92
    STS     $0000  ,r5      ;W 1B 0000   r5 should be 27
    STS     $0000  ,r6      ;W 5F 0000   r6 should be 95
    STS     $0000  ,r8      ;W 08 0000   r8 should be 8
    STS     $0000  ,r23     ;W 61 0000   r23 should be 97
    STS     $0000  ,r12     ;W E8 0000   r12 should be 232
    STS     $0000  ,r25     ;W B1 0000   r25 should be 177
    STS     $0000  ,r22     ;W 86 0000   r22 should be 134