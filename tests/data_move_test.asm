
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
    LDI     r21    ,$EE     ;
    LDI     r20    ,$49     ;
    LDI     r16    ,$A0     ;
    LDI     r27    ,$E4     ;
    LDI     r17    ,$FA     ;
    LDI     r28    ,$86     ;
    LDI     r19    ,$1A     ;
    LDI     r24    ,$F3     ;
    LDI     r22    ,$82     ;
    LDI     r29    ,$5A     ;
    STS     $0000  ,r21     ;W EE 0000   r21 should be 238
    STS     $0000  ,r20     ;W 49 0000   r20 should be 73
    STS     $0000  ,r16     ;W A0 0000   r16 should be 160
    STS     $0000  ,r27     ;W E4 0000   r27 should be 228
    STS     $0000  ,r17     ;W FA 0000   r17 should be 250
    STS     $0000  ,r28     ;W 86 0000   r28 should be 134
    STS     $0000  ,r19     ;W 1A 0000   r19 should be 26
    STS     $0000  ,r24     ;W F3 0000   r24 should be 243
    STS     $0000  ,r22     ;W 82 0000   r22 should be 130
    STS     $0000  ,r29     ;W 5A 0000   r29 should be 90



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
    LD      r18    ,-X      ;R D4 0003
    LD      r10    ,-X      ;R 7C 0002
    LD      r20    ,-X      ;R 87 0001
    LD      r4     ,-X      ;R BA 0000
    LD      r1     ,-X      ;R 3A FFFF
    LD      r12    ,-X      ;R CB FFFE
    LD      r29    ,-X      ;R F6 FFFD
    LD      r16    ,-X      ;R 6A FFFC
    STS     $0000  ,r18     ;W D4 0000   r18 should be 212
    STS     $0000  ,r10     ;W 7C 0000   r10 should be 124
    STS     $0000  ,r20     ;W 87 0000   r20 should be 135
    STS     $0000  ,r4      ;W BA 0000   r4 should be 186
    STS     $0000  ,r1      ;W 3A 0000   r1 should be 58
    STS     $0000  ,r12     ;W CB 0000   r12 should be 203
    STS     $0000  ,r29     ;W F6 0000   r29 should be 246
    STS     $0000  ,r16     ;W 6A 0000   r16 should be 106

; load with post increment through 0xFFFF
    LD      r29    ,X+      ;R 92 FFFC
    LD      r5     ,X+      ;R 71 FFFD
    LD      r22    ,X+      ;R 18 FFFE
    LD      r4     ,X+      ;R 8E FFFF
    LD      r3     ,X+      ;R F2 0000
    LD      r10    ,X+      ;R 1E 0001
    LD      r1     ,X+      ;R D0 0002
    LD      r12    ,X+      ;R 98 0003
    STS     $0000  ,r29     ;W 92 0000   r29 should be 146
    STS     $0000  ,r5      ;W 71 0000   r5 should be 113
    STS     $0000  ,r22     ;W 18 0000   r22 should be 24
    STS     $0000  ,r4      ;W 8E 0000   r4 should be 142
    STS     $0000  ,r3      ;W F2 0000   r3 should be 242
    STS     $0000  ,r10     ;W 1E 0000   r10 should be 30
    STS     $0000  ,r1      ;W D0 0000   r1 should be 208
    STS     $0000  ,r12     ;W 98 0000   r12 should be 152

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
    LD      r16    ,-Y      ;R 07 0003
    LD      r3     ,-Y      ;R F9 0002
    LD      r2     ,-Y      ;R A8 0001
    LD      r25    ,-Y      ;R 5C 0000
    LD      r4     ,-Y      ;R 78 FFFF
    LD      r20    ,-Y      ;R 9D FFFE
    LD      r13    ,-Y      ;R E4 FFFD
    LD      r7     ,-Y      ;R 8D FFFC
    STS     $0000  ,r16     ;W 07 0000   r16 should be 7
    STS     $0000  ,r3      ;W F9 0000   r3 should be 249
    STS     $0000  ,r2      ;W A8 0000   r2 should be 168
    STS     $0000  ,r25     ;W 5C 0000   r25 should be 92
    STS     $0000  ,r4      ;W 78 0000   r4 should be 120
    STS     $0000  ,r20     ;W 9D 0000   r20 should be 157
    STS     $0000  ,r13     ;W E4 0000   r13 should be 228
    STS     $0000  ,r7      ;W 8D 0000   r7 should be 141

; load with post increment through 0xFFFF
    LD      r23    ,Y+      ;R 7F FFFC
    LD      r6     ,Y+      ;R 0B FFFD
    LD      r2     ,Y+      ;R F9 FFFE
    LD      r19    ,Y+      ;R BE FFFF
    LD      r7     ,Y+      ;R 50 0000
    LD      r31    ,Y+      ;R C8 0001
    LD      r25    ,Y+      ;R 5F 0002
    LD      r9     ,Y+      ;R 8E 0003
    STS     $0000  ,r23     ;W 7F 0000   r23 should be 127
    STS     $0000  ,r6      ;W 0B 0000   r6 should be 11
    STS     $0000  ,r2      ;W F9 0000   r2 should be 249
    STS     $0000  ,r19     ;W BE 0000   r19 should be 190
    STS     $0000  ,r7      ;W 50 0000   r7 should be 80
    STS     $0000  ,r31     ;W C8 0000   r31 should be 200
    STS     $0000  ,r25     ;W 5F 0000   r25 should be 95
    STS     $0000  ,r9      ;W 8E 0000   r9 should be 142

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
    LD      r22    ,-Z      ;R 7A 0003
    LD      r20    ,-Z      ;R 70 0002
    LD      r8     ,-Z      ;R 20 0001
    LD      r17    ,-Z      ;R C9 0000
    LD      r10    ,-Z      ;R 9C FFFF
    LD      r13    ,-Z      ;R 1D FFFE
    LD      r26    ,-Z      ;R BD FFFD
    LD      r18    ,-Z      ;R 3C FFFC
    STS     $0000  ,r22     ;W 7A 0000   r22 should be 122
    STS     $0000  ,r20     ;W 70 0000   r20 should be 112
    STS     $0000  ,r8      ;W 20 0000   r8 should be 32
    STS     $0000  ,r17     ;W C9 0000   r17 should be 201
    STS     $0000  ,r10     ;W 9C 0000   r10 should be 156
    STS     $0000  ,r13     ;W 1D 0000   r13 should be 29
    STS     $0000  ,r26     ;W BD 0000   r26 should be 189
    STS     $0000  ,r18     ;W 3C 0000   r18 should be 60

; load with post increment through 0xFFFF
    LD      r4     ,Z+      ;R 3C FFFC
    LD      r23    ,Z+      ;R 5A FFFD
    LD      r2     ,Z+      ;R 0C FFFE
    LD      r20    ,Z+      ;R 66 FFFF
    LD      r11    ,Z+      ;R 35 0000
    LD      r6     ,Z+      ;R 94 0001
    LD      r7     ,Z+      ;R 2A 0002
    LD      r19    ,Z+      ;R BD 0003
    STS     $0000  ,r4      ;W 3C 0000   r4 should be 60
    STS     $0000  ,r23     ;W 5A 0000   r23 should be 90
    STS     $0000  ,r2      ;W 0C 0000   r2 should be 12
    STS     $0000  ,r20     ;W 66 0000   r20 should be 102
    STS     $0000  ,r11     ;W 35 0000   r11 should be 53
    STS     $0000  ,r6      ;W 94 0000   r6 should be 148
    STS     $0000  ,r7      ;W 2A 0000   r7 should be 42
    STS     $0000  ,r19     ;W BD 0000   r19 should be 189



;PREPROCESS TestLDD

    LDI     r28    ,$E0     ;            set Y to $FFE0
    LDI     r29    ,$FF     ;
    LDD     r7     ,Y+0     ;R 73 FFE0
    LDD     r22    ,Y+20    ;R 7A FFF4
    LDD     r14    ,Y+50    ;R EF 0012
    LDD     r30    ,Y+57    ;R 2E 0019
    LDD     r18    ,Y+55    ;R F8 0017
    LDD     r6     ,Y+52    ;R 58 0014
    LDD     r11    ,Y+58    ;R A0 001A
    LDD     r15    ,Y+63    ;R BB 001F
    STS     $0000  ,r7      ;W 73 0000   r7 should be 115
    STS     $0000  ,r22     ;W 7A 0000   r22 should be 122
    STS     $0000  ,r14     ;W EF 0000   r14 should be 239
    STS     $0000  ,r30     ;W 2E 0000   r30 should be 46
    STS     $0000  ,r18     ;W F8 0000   r18 should be 248
    STS     $0000  ,r6      ;W 58 0000   r6 should be 88
    STS     $0000  ,r11     ;W A0 0000   r11 should be 160
    STS     $0000  ,r15     ;W BB 0000   r15 should be 187
    LDI     r30    ,$E0     ;            set Z to $FFE0
    LDI     r31    ,$FF     ;
    LDD     r24    ,Z+0     ;R D3 FFE0
    LDD     r7     ,Z+61    ;R 1B 001D
    LDD     r28    ,Z+41    ;R 05 0009
    LDD     r13    ,Z+63    ;R 1A 001F
    LDD     r6     ,Z+10    ;R E5 FFEA
    LDD     r1     ,Z+4     ;R 59 FFE4
    LDD     r0     ,Z+35    ;R 4D 0003
    LDD     r11    ,Z+63    ;R 45 001F
    STS     $0000  ,r24     ;W D3 0000   r24 should be 211
    STS     $0000  ,r7      ;W 1B 0000   r7 should be 27
    STS     $0000  ,r28     ;W 05 0000   r28 should be 5
    STS     $0000  ,r13     ;W 1A 0000   r13 should be 26
    STS     $0000  ,r6      ;W E5 0000   r6 should be 229
    STS     $0000  ,r1      ;W 59 0000   r1 should be 89
    STS     $0000  ,r0      ;W 4D 0000   r0 should be 77
    STS     $0000  ,r11     ;W 45 0000   r11 should be 69



;PREPROCESS TestLDS


; do a few simple LDSs
    LDS     r0     ,$0000   ;R EC 0000
    STS     $0000  ,r0      ;W EC 0000   r0 should be 236
    LDS     r15    ,$FF00   ;R EC FF00
    STS     $0000  ,r15     ;W EC 0000   r15 should be 236
    LDS     r30    ,$FFFF   ;R EC FFFF
    STS     $0000  ,r30     ;W EC 0000   r30 should be 236

; do some random LDSs
    LDS     r7     ,$7A59   ;R 5C 7A59
    LDS     r4     ,$80FF   ;R FC 80FF
    LDS     r9     ,$0828   ;R 6F 0828
    LDS     r20    ,$3BFB   ;R A0 3BFB
    LDS     r23    ,$689C   ;R 8B 689C
    LDS     r3     ,$9DFB   ;R BD 9DFB
    LDS     r8     ,$31D0   ;R 5B 31D0
    LDS     r1     ,$CA40   ;R 3A CA40
    LDS     r10    ,$A69A   ;R B8 A69A
    LDS     r26    ,$4B8E   ;R C4 4B8E
    STS     $0000  ,r7      ;W 5C 0000   r7 should be 92
    STS     $0000  ,r4      ;W FC 0000   r4 should be 252
    STS     $0000  ,r9      ;W 6F 0000   r9 should be 111
    STS     $0000  ,r20     ;W A0 0000   r20 should be 160
    STS     $0000  ,r23     ;W 8B 0000   r23 should be 139
    STS     $0000  ,r3      ;W BD 0000   r3 should be 189
    STS     $0000  ,r8      ;W 5B 0000   r8 should be 91
    STS     $0000  ,r1      ;W 3A 0000   r1 should be 58
    STS     $0000  ,r10     ;W B8 0000   r10 should be 184
    STS     $0000  ,r26     ;W C4 0000   r26 should be 196



;PREPROCESS TestMOV


; do a few simple MOVs
    LDS     r0     ,$0000   ;R 73 0000
    MOV     r0     ,r1      ;
    STS     $0000  ,r1      ;W 73 0000   r1 should be 115
    LDS     r31    ,$0000   ;R 83 0000
    MOV     r31    ,r30     ;
    STS     $0000  ,r30     ;W 83 0000   r30 should be 131

; do a random move through all registers
    LDS     r23    ,$0000   ;R EC 0000
    MOV     r23    ,r26     ;
    MOV     r26    ,r10     ;
    MOV     r10    ,r18     ;
    MOV     r18    ,r11     ;
    MOV     r11    ,r15     ;
    MOV     r15    ,r24     ;
    MOV     r24    ,r4      ;
    MOV     r4     ,r29     ;
    MOV     r29    ,r30     ;
    MOV     r30    ,r7      ;
    MOV     r7     ,r14     ;
    MOV     r14    ,r27     ;
    MOV     r27    ,r28     ;
    MOV     r28    ,r31     ;
    MOV     r31    ,r22     ;
    MOV     r22    ,r16     ;
    MOV     r16    ,r3      ;
    MOV     r3     ,r19     ;
    MOV     r19    ,r5      ;
    MOV     r5     ,r12     ;
    MOV     r12    ,r21     ;
    MOV     r21    ,r25     ;
    MOV     r25    ,r8      ;
    MOV     r8     ,r13     ;
    MOV     r13    ,r1      ;
    MOV     r1     ,r17     ;
    MOV     r17    ,r9      ;
    MOV     r9     ,r6      ;
    MOV     r6     ,r2      ;
    MOV     r2     ,r20     ;
    MOV     r20    ,r0      ;
    STS     $0000  ,r0      ;W EC 0000   r0 should be 236



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
    LDS     r9     ,$0000   ;R 8D 0000   set r9 to 141
    LDS     r2     ,$0000   ;R F9 0000   set r2 to 249
    LDS     r30    ,$0000   ;R A8 0000   set r30 to 168
    LDS     r3     ,$0000   ;R 6B 0000   set r3 to 107
    LDS     r8     ,$0000   ;R 3F 0000   set r8 to 63
    LDS     r20    ,$0000   ;R 6B 0000   set r20 to 107
    LDS     r31    ,$0000   ;R 83 0000   set r31 to 131
    LDS     r16    ,$0000   ;R 29 0000   set r16 to 41
    ST      -X     ,r9      ;W 8D 0003
    ST      -X     ,r2      ;W F9 0002
    ST      -X     ,r30     ;W A8 0001
    ST      -X     ,r3      ;W 6B 0000
    ST      -X     ,r8      ;W 3F FFFF
    ST      -X     ,r20     ;W 6B FFFE
    ST      -X     ,r31     ;W 83 FFFD
    ST      -X     ,r16     ;W 29 FFFC

; store with post increment through 0xFFFF
    LDS     r6     ,$0000   ;R 73 0000   set r6 to 115
    LDS     r21    ,$0000   ;R 48 0000   set r21 to 72
    LDS     r16    ,$0000   ;R 01 0000   set r16 to 1
    LDS     r17    ,$0000   ;R 86 0000   set r17 to 134
    LDS     r4     ,$0000   ;R 16 0000   set r4 to 22
    LDS     r12    ,$0000   ;R 00 0000   set r12 to 0
    LDS     r31    ,$0000   ;R FA 0000   set r31 to 250
    LDS     r24    ,$0000   ;R 2E 0000   set r24 to 46
    ST      X+     ,r6      ;W 73 FFFC
    ST      X+     ,r21     ;W 48 FFFD
    ST      X+     ,r16     ;W 01 FFFE
    ST      X+     ,r17     ;W 86 FFFF
    ST      X+     ,r4      ;W 16 0000
    ST      X+     ,r12     ;W 00 0001
    ST      X+     ,r31     ;W FA 0002
    ST      X+     ,r24     ;W 2E 0003
    LDI     r28    ,$04     ;            set Y to $0004
    LDI     r29    ,$00     ;
    LDS     r0     ,$0000   ;R EC 0000   set r0 to 236
    ST      Y      ,r0      ;W EC 0004
    LDS     r8     ,$0000   ;R EC 0000   set r8 to 236
    ST      Y      ,r8      ;W EC 0004
    LDS     r25    ,$0000   ;R EC 0000   set r25 to 236
    ST      Y      ,r25     ;W EC 0004

; store with pre decrement through 0x0000
    LDS     r6     ,$0000   ;R D7 0000   set r6 to 215
    LDS     r31    ,$0000   ;R 0F 0000   set r31 to 15
    LDS     r16    ,$0000   ;R FB 0000   set r16 to 251
    LDS     r3     ,$0000   ;R 5D 0000   set r3 to 93
    LDS     r24    ,$0000   ;R 6B 0000   set r24 to 107
    LDS     r25    ,$0000   ;R 6C 0000   set r25 to 108
    LDS     r8     ,$0000   ;R 3E 0000   set r8 to 62
    LDS     r11    ,$0000   ;R 7C 0000   set r11 to 124
    ST      -Y     ,r6      ;W D7 0003
    ST      -Y     ,r31     ;W 0F 0002
    ST      -Y     ,r16     ;W FB 0001
    ST      -Y     ,r3      ;W 5D 0000
    ST      -Y     ,r24     ;W 6B FFFF
    ST      -Y     ,r25     ;W 6C FFFE
    ST      -Y     ,r8      ;W 3E FFFD
    ST      -Y     ,r11     ;W 7C FFFC

; store with post increment through 0xFFFF
    LDS     r8     ,$0000   ;R 60 0000   set r8 to 96
    LDS     r25    ,$0000   ;R E5 0000   set r25 to 229
    LDS     r19    ,$0000   ;R ED 0000   set r19 to 237
    LDS     r17    ,$0000   ;R A0 0000   set r17 to 160
    LDS     r14    ,$0000   ;R 77 0000   set r14 to 119
    LDS     r27    ,$0000   ;R 6F 0000   set r27 to 111
    LDS     r12    ,$0000   ;R 82 0000   set r12 to 130
    LDS     r3     ,$0000   ;R 40 0000   set r3 to 64
    ST      Y+     ,r8      ;W 60 FFFC
    ST      Y+     ,r25     ;W E5 FFFD
    ST      Y+     ,r19     ;W ED FFFE
    ST      Y+     ,r17     ;W A0 FFFF
    ST      Y+     ,r14     ;W 77 0000
    ST      Y+     ,r27     ;W 6F 0001
    ST      Y+     ,r12     ;W 82 0002
    ST      Y+     ,r3      ;W 40 0003
    LDI     r30    ,$04     ;            set Z to $0004
    LDI     r31    ,$00     ;
    LDS     r0     ,$0000   ;R EC 0000   set r0 to 236
    ST      Z      ,r0      ;W EC 0004
    LDS     r8     ,$0000   ;R EC 0000   set r8 to 236
    ST      Z      ,r8      ;W EC 0004
    LDS     r25    ,$0000   ;R EC 0000   set r25 to 236
    ST      Z      ,r25     ;W EC 0004

; store with pre decrement through 0x0000
    LDS     r21    ,$0000   ;R 99 0000   set r21 to 153
    LDS     r20    ,$0000   ;R D9 0000   set r20 to 217
    LDS     r28    ,$0000   ;R 89 0000   set r28 to 137
    LDS     r23    ,$0000   ;R 57 0000   set r23 to 87
    LDS     r16    ,$0000   ;R A2 0000   set r16 to 162
    LDS     r4     ,$0000   ;R 8F 0000   set r4 to 143
    LDS     r27    ,$0000   ;R 74 0000   set r27 to 116
    LDS     r10    ,$0000   ;R A1 0000   set r10 to 161
    ST      -Z     ,r21     ;W 99 0003
    ST      -Z     ,r20     ;W D9 0002
    ST      -Z     ,r28     ;W 89 0001
    ST      -Z     ,r23     ;W 57 0000
    ST      -Z     ,r16     ;W A2 FFFF
    ST      -Z     ,r4      ;W 8F FFFE
    ST      -Z     ,r27     ;W 74 FFFD
    ST      -Z     ,r10     ;W A1 FFFC

; store with post increment through 0xFFFF
    LDS     r20    ,$0000   ;R B3 0000   set r20 to 179
    LDS     r27    ,$0000   ;R D3 0000   set r27 to 211
    LDS     r1     ,$0000   ;R 21 0000   set r1 to 33
    LDS     r23    ,$0000   ;R 76 0000   set r23 to 118
    LDS     r22    ,$0000   ;R 44 0000   set r22 to 68
    LDS     r13    ,$0000   ;R BE 0000   set r13 to 190
    LDS     r19    ,$0000   ;R 17 0000   set r19 to 23
    LDS     r11    ,$0000   ;R A5 0000   set r11 to 165
    ST      Z+     ,r20     ;W B3 FFFC
    ST      Z+     ,r27     ;W D3 FFFD
    ST      Z+     ,r1      ;W 21 FFFE
    ST      Z+     ,r23     ;W 76 FFFF
    ST      Z+     ,r22     ;W 44 0000
    ST      Z+     ,r13     ;W BE 0001
    ST      Z+     ,r19     ;W 17 0002
    ST      Z+     ,r11     ;W A5 0003



;PREPROCESS TestSTD

    LDI     r28    ,$E0     ;            set Y to $FFE0
    LDI     r29    ,$FF     ;
    LDS     r21    ,$0000   ;R FD 0000   set r21 to 253
    LDS     r11    ,$0000   ;R 95 0000   set r11 to 149
    LDS     r24    ,$0000   ;R 98 0000   set r24 to 152
    LDS     r16    ,$0000   ;R BD 0000   set r16 to 189
    LDS     r6     ,$0000   ;R EF 0000   set r6 to 239
    LDS     r5     ,$0000   ;R 3F 0000   set r5 to 63
    LDS     r12    ,$0000   ;R 28 0000   set r12 to 40
    LDS     r22    ,$0000   ;R E3 0000   set r22 to 227
    STD     Y+0    ,r21     ;W FD FFE0
    STD     Y+13   ,r11     ;W 95 FFED
    STD     Y+13   ,r24     ;W 98 FFED
    STD     Y+14   ,r16     ;W BD FFEE
    STD     Y+33   ,r6      ;W EF 0001
    STD     Y+33   ,r5      ;W 3F 0001
    STD     Y+57   ,r12     ;W 28 0019
    STD     Y+63   ,r22     ;W E3 001F
    LDI     r30    ,$E0     ;            set Z to $FFE0
    LDI     r31    ,$FF     ;
    LDS     r12    ,$0000   ;R 5A 0000   set r12 to 90
    LDS     r11    ,$0000   ;R AC 0000   set r11 to 172
    LDS     r0     ,$0000   ;R 82 0000   set r0 to 130
    LDS     r21    ,$0000   ;R 8F 0000   set r21 to 143
    LDS     r18    ,$0000   ;R E1 0000   set r18 to 225
    LDS     r23    ,$0000   ;R 10 0000   set r23 to 16
    LDS     r28    ,$0000   ;R E1 0000   set r28 to 225
    LDS     r2     ,$0000   ;R 80 0000   set r2 to 128
    STD     Z+0    ,r12     ;W 5A FFE0
    STD     Z+51   ,r11     ;W AC 0013
    STD     Z+57   ,r0      ;W 82 0019
    STD     Z+56   ,r21     ;W 8F 0018
    STD     Z+3    ,r18     ;W E1 FFE3
    STD     Z+58   ,r23     ;W 10 001A
    STD     Z+12   ,r28     ;W E1 FFEC
    STD     Z+63   ,r2      ;W 80 001F



;PREPROCESS TestSTS


; do a few simple STSs
    LDS     r0     ,$0000   ;R EC 0000   set r0 to 236
    STS     $0000  ,r0      ;W EC 0000
    LDS     r15    ,$0000   ;R EC 0000   set r15 to 236
    STS     $FF00  ,r15     ;W EC FF00
    LDS     r30    ,$0000   ;R EC 0000   set r30 to 236
    STS     $FFFF  ,r30     ;W EC FFFF

; do some random STSs
    LDS     r1     ,$0000   ;R 24 0000   set r1 to 36
    LDS     r12    ,$0000   ;R 11 0000   set r12 to 17
    LDS     r17    ,$0000   ;R 84 0000   set r17 to 132
    LDS     r6     ,$0000   ;R EF 0000   set r6 to 239
    LDS     r13    ,$0000   ;R AF 0000   set r13 to 175
    LDS     r24    ,$0000   ;R 5B 0000   set r24 to 91
    LDS     r0     ,$0000   ;R 27 0000   set r0 to 39
    LDS     r16    ,$0000   ;R 92 0000   set r16 to 146
    LDS     r18    ,$0000   ;R 65 0000   set r18 to 101
    LDS     r4     ,$0000   ;R C7 0000   set r4 to 199
    STS     $3D73  ,r1      ;W 24 3D73
    STS     $12A9  ,r12     ;W 11 12A9
    STS     $464E  ,r17     ;W 84 464E
    STS     $6C31  ,r6      ;W EF 6C31
    STS     $F4D4  ,r13     ;W AF F4D4
    STS     $05B6  ,r24     ;W 5B 05B6
    STS     $E5F0  ,r0      ;W 27 E5F0
    STS     $C682  ,r16     ;W 92 C682
    STS     $560C  ,r18     ;W 65 560C
    STS     $D510  ,r4      ;W C7 D510

;PREPROCESS TestPUSH

;PREPROCESS TestPOP

; load some random values into registers
    LDS     r28    ,$0000   ;R 7E 0000   set r28 to 126
    LDS     r26    ,$0000   ;R 10 0000   set r26 to 16
    LDS     r31    ,$0000   ;R 6B 0000   set r31 to 107
    LDS     r4     ,$0000   ;R 62 0000   set r4 to 98
    LDS     r24    ,$0000   ;R 0F 0000   set r24 to 15
    LDS     r0     ,$0000   ;R 61 0000   set r0 to 97
    LDS     r14    ,$0000   ;R 39 0000   set r14 to 57
    LDS     r1     ,$0000   ;R FE 0000   set r1 to 254
    LDS     r2     ,$0000   ;R 60 0000   set r2 to 96
    LDS     r16    ,$0000   ;R 64 0000   set r16 to 100
    LDS     r17    ,$0000   ;R DB 0000   set r17 to 219
    LDS     r13    ,$0000   ;R 1A 0000   set r13 to 26
    LDS     r20    ,$0000   ;R 4A 0000   set r20 to 74
    LDS     r11    ,$0000   ;R 10 0000   set r11 to 16
    LDS     r29    ,$0000   ;R D3 0000   set r29 to 211
    LDS     r30    ,$0000   ;R 99 0000   set r30 to 153
    LDS     r7     ,$0000   ;R 87 0000   set r7 to 135
    LDS     r22    ,$0000   ;R D5 0000   set r22 to 213
    LDS     r12    ,$0000   ;R 56 0000   set r12 to 86
    LDS     r21    ,$0000   ;R 6C 0000   set r21 to 108
    LDS     r5     ,$0000   ;R 8D 0000   set r5 to 141
    LDS     r18    ,$0000   ;R 5F 0000   set r18 to 95
    LDS     r15    ,$0000   ;R 8E 0000   set r15 to 142
    LDS     r10    ,$0000   ;R FA 0000   set r10 to 250
    LDS     r19    ,$0000   ;R 41 0000   set r19 to 65
    LDS     r3     ,$0000   ;R B1 0000   set r3 to 177
    LDS     r23    ,$0000   ;R 57 0000   set r23 to 87
    LDS     r6     ,$0000   ;R 1A 0000   set r6 to 26
    LDS     r8     ,$0000   ;R 18 0000   set r8 to 24
    LDS     r9     ,$0000   ;R 48 0000   set r9 to 72
    LDS     r27    ,$0000   ;R B6 0000   set r27 to 182
    LDS     r25    ,$0000   ;R 87 0000   set r25 to 135

; push all the registers
    PUSH    r28             ;W 7E 0000
    PUSH    r26             ;W 10 FFFF
    PUSH    r31             ;W 6B FFFE
    PUSH    r4              ;W 62 FFFD
    PUSH    r24             ;W 0F FFFC
    PUSH    r0              ;W 61 FFFB
    PUSH    r14             ;W 39 FFFA
    PUSH    r1              ;W FE FFF9
    PUSH    r2              ;W 60 FFF8
    PUSH    r16             ;W 64 FFF7
    PUSH    r17             ;W DB FFF6
    PUSH    r13             ;W 1A FFF5
    PUSH    r20             ;W 4A FFF4
    PUSH    r11             ;W 10 FFF3
    PUSH    r29             ;W D3 FFF2
    PUSH    r30             ;W 99 FFF1
    PUSH    r7              ;W 87 FFF0
    PUSH    r22             ;W D5 FFEF
    PUSH    r12             ;W 56 FFEE
    PUSH    r21             ;W 6C FFED
    PUSH    r5              ;W 8D FFEC
    PUSH    r18             ;W 5F FFEB
    PUSH    r15             ;W 8E FFEA
    PUSH    r10             ;W FA FFE9
    PUSH    r19             ;W 41 FFE8
    PUSH    r3              ;W B1 FFE7
    PUSH    r23             ;W 57 FFE6
    PUSH    r6              ;W 1A FFE5
    PUSH    r8              ;W 18 FFE4
    PUSH    r9              ;W 48 FFE3
    PUSH    r27             ;W B6 FFE2
    PUSH    r25             ;W 87 FFE1

; pop all the registers
    POP     r25             ;R 87 FFE1
    POP     r27             ;R B6 FFE2
    POP     r9              ;R 48 FFE3
    POP     r8              ;R 18 FFE4
    POP     r6              ;R 1A FFE5
    POP     r23             ;R 57 FFE6
    POP     r3              ;R B1 FFE7
    POP     r19             ;R 41 FFE8
    POP     r10             ;R FA FFE9
    POP     r15             ;R 8E FFEA
    POP     r18             ;R 5F FFEB
    POP     r5              ;R 8D FFEC
    POP     r21             ;R 6C FFED
    POP     r12             ;R 56 FFEE
    POP     r22             ;R D5 FFEF
    POP     r7              ;R 87 FFF0
    POP     r30             ;R 99 FFF1
    POP     r29             ;R D3 FFF2
    POP     r11             ;R 10 FFF3
    POP     r20             ;R 4A FFF4
    POP     r13             ;R 1A FFF5
    POP     r17             ;R DB FFF6
    POP     r16             ;R 64 FFF7
    POP     r2              ;R 60 FFF8
    POP     r1              ;R FE FFF9
    POP     r14             ;R 39 FFFA
    POP     r0              ;R 61 FFFB
    POP     r24             ;R 0F FFFC
    POP     r4              ;R 62 FFFD
    POP     r31             ;R 6B FFFE
    POP     r26             ;R 10 FFFF
    POP     r28             ;R 7E 0000

; check all the values are unchanged
    STS     $0000  ,r28     ;W 7E 0000   r28 should be 126
    STS     $0000  ,r26     ;W 10 0000   r26 should be 16
    STS     $0000  ,r31     ;W 6B 0000   r31 should be 107
    STS     $0000  ,r4      ;W 62 0000   r4 should be 98
    STS     $0000  ,r24     ;W 0F 0000   r24 should be 15
    STS     $0000  ,r0      ;W 61 0000   r0 should be 97
    STS     $0000  ,r14     ;W 39 0000   r14 should be 57
    STS     $0000  ,r1      ;W FE 0000   r1 should be 254
    STS     $0000  ,r2      ;W 60 0000   r2 should be 96
    STS     $0000  ,r16     ;W 64 0000   r16 should be 100
    STS     $0000  ,r17     ;W DB 0000   r17 should be 219
    STS     $0000  ,r13     ;W 1A 0000   r13 should be 26
    STS     $0000  ,r20     ;W 4A 0000   r20 should be 74
    STS     $0000  ,r11     ;W 10 0000   r11 should be 16
    STS     $0000  ,r29     ;W D3 0000   r29 should be 211
    STS     $0000  ,r30     ;W 99 0000   r30 should be 153
    STS     $0000  ,r7      ;W 87 0000   r7 should be 135
    STS     $0000  ,r22     ;W D5 0000   r22 should be 213
    STS     $0000  ,r12     ;W 56 0000   r12 should be 86
    STS     $0000  ,r21     ;W 6C 0000   r21 should be 108
    STS     $0000  ,r5      ;W 8D 0000   r5 should be 141
    STS     $0000  ,r18     ;W 5F 0000   r18 should be 95
    STS     $0000  ,r15     ;W 8E 0000   r15 should be 142
    STS     $0000  ,r10     ;W FA 0000   r10 should be 250
    STS     $0000  ,r19     ;W 41 0000   r19 should be 65
    STS     $0000  ,r3      ;W B1 0000   r3 should be 177
    STS     $0000  ,r23     ;W 57 0000   r23 should be 87
    STS     $0000  ,r6      ;W 1A 0000   r6 should be 26
    STS     $0000  ,r8      ;W 18 0000   r8 should be 24
    STS     $0000  ,r9      ;W 48 0000   r9 should be 72
    STS     $0000  ,r27     ;W B6 0000   r27 should be 182
    STS     $0000  ,r25     ;W 87 0000   r25 should be 135