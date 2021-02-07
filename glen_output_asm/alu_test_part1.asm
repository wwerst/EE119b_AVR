; Tests the ALU instructions


; Notes:
; The status register can be accessed in the I/O memory space at $3F.
; This test bench uses that to quickly check that all status register
; bits are being See https://people.ece.cornell.edu/land/courses/ece4760/AtmelStuff/at90s4414.pdf

;.MACRO SETMEM ; Sets the memory at address @1 to be the byte @0.
;   
;.ENDMACRO
.MACRO ASSERT ; Assert byte @0 is the value stored at address @1.
    PUSH r16
    PUSH r17
    LDS r16, @1
    LDI r17, @0
    CPSE  r17, r16    ; Compare and skip if equal
    CALL test_failure ; If not equal, call test_failure, else return
    POP r17  
    POP r16
.ENDMACRO

.MACRO CLR_SREG
    BCLR 0
    BCLR 1
    BCLR 2
    BCLR 3
    BCLR 4
    BCLR 5
    BCLR 6
    BCLR 7
.ENDMACRO


.EQU SREG_ADDR = $3F

; It seems that AVR Studio auto-defines these,
; but if they weren't defined, they should have these values:
;.EQU SREG_C = 0
;.EQU SREG_Z = 1
;.EQU SREG_N = 2
;.EQU SREG_V = 3
;.EQU SREG_S = 4
;.EQU SREG_H = 5
;.EQU SREG_T = 6
;.EQU SREG_I = 7


.CSEG ; Start code segment

; TODO for better testing:
; - Randomize some Status register flags to be 1 instead of 0,
;   and then make sure that instructions don't modify
;   flags they are supposed to leave untouched.



;PREPROCESS TestAdd {r16=Rd, r17=Rd, r18=Rd, X={X, Y, Z}}
start_test_add:
    CLR_SREG
test_add_to_zero:
    ldi r16, $00    ; 
    ldi r17, $AF    ;
    ADD r16, r17    ;
    IN  r18, $3F    ; Read the Status register
    LDI r27, $01    ;
    LDI r26, $00    ;
    ST  X,   r16    ;W AF 0100
    ST  X,   r17    ;W AF 0100
    ST  X,   r18    ;W 14 0100

 test_add_of_zero:
    ldi r16, $AF    ; 
    ldi r17, $00    ;
    ADD r16, r17    ;
    IN  r18, $3F    ; Read the Status register
    LDI r27, $01    ;
    LDI r26, $00    ;
    ST  X,   r16    ;W AF 0100
    ST  X,   r17    ;W 00 0100
    ST  X,   r18    ;W 14 0100

test_add_overflow:
    ldi r16, $B0    ; 
    ldi r17, $8F    ;
    ADD r16, r17    ; -- 176 + 143 = 319 = 63 mod 256, carry 1
    IN  r18, $3F    ; Read the Status register
    LDI r27, $01    ;
    LDI r26, $00    ;
    ST  X,   r16    ;W 3F 0100
    ST  X,   r17    ;W 8F 0100
    ST  X,   r18    ;W 19 0100

test_add_overflow_to_zero:
    ldi r16, $7F    ; 
    ldi r17, $81    ;
    ADD r16, r17    ; -- 127 + 129 = 0 with carry 1
    IN  r18, $3F    ; Read the Status register
    LDI r27, $01    ;
    LDI r26, $00    ;
    ST  X,   r16    ;W 00 0100
    ST  X,   r17    ;W 81 0100
    ST  X,   r18    ;W 23 0100

test_add_zeros:
    ldi r16, $00    ; 
    ldi r17, $00    ;
    ADD r16, r17    ; -- 176 + 143 = 319 = 63 mod 256, carry 1
    IN  r18, $3F    ; Read the Status register
    LDI r27, $01    ;
    LDI r26, $00    ;
    ST  X,   r16    ;W 00 0100
    ST  X,   r17    ;W 00 0100
    ST  X,   r18    ;W 02 0100

;PREPROCESS TestADC
start_test_adc:
    CLR_SREG
test_adc_to_zero:
    BCLR SREG_C     ; Clear carry flag
    ldi r16, $00    ; 
    ldi r17, $AF    ;
    ADC r16, r17    ;
    IN  r18, $3F    ; Read the Status register
    LDI r27, $01    ;
    LDI r26, $00    ;
    ST  X,   r16    ;W AF 0100
    ST  X,   r17    ;W AF 0100
    ST  X,   r18    ;W 14 0100

 test_adc_of_zero:
    BCLR SREG_C     ; Clear carry flag
    ldi r16, $AF    ; 
    ldi r17, $00    ;
    ADC r16, r17    ;
    IN  r18, $3F    ; Read the Status register
    LDI r27, $01    ;
    LDI r26, $00    ;
    ST  X,   r16    ;W AF 0100
    ST  X,   r17    ;W 00 0100
    ST  X,   r18    ;W 14 0100

test_adc_overflow:
    BCLR SREG_C     ; Clear carry flag
    ldi r16, $B0    ; 
    ldi r17, $8F    ;
    ADC r16, r17    ; -- 176 + 143 = 319 = 63 mod 256, carry 1
    IN  r18, $3F    ; Read the Status register
    LDI r27, $01    ;
    LDI r26, $00    ;
    ST  X,   r16    ;W 3F 0100
    ST  X,   r17    ;W 8F 0100
    ST  X,   r18    ;W 19 0100

test_adc_overflow_to_zero:
    BCLR SREG_C     ; Clear carry flag
    ldi r16, $7F    ; 
    ldi r17, $81    ;
    ADC r16, r17    ; -- 127 + 129 = 0 with carry 1
    IN  r18, $3F    ; Read the Status register
    LDI r27, $01    ;
    LDI r26, $00    ;
    ST  X,   r16    ;W 00 0100
    ST  X,   r17    ;W 81 0100
    ST  X,   r18    ;W 23 0100

test_adc_zeros:
    BCLR SREG_C     ; Clear carry flag
    ldi r16, $00    ; 
    ldi r17, $00    ;
    ADC r16, r17    ; -- 176 + 143 = 319 = 63 mod 256, carry 1
    IN  r18, $3F    ; Read the Status register
    LDI r27, $01    ;
    LDI r26, $00    ;
    ST  X,   r16    ;W 00 0100
    ST  X,   r17    ;W 00 0100
    ST  X,   r18    ;W 02 0100

; Test adding all zeros with carry flag set
test_adc_with_carry_zeros:
    BSET SREG_C     ; Set carry flag
    ldi r16, $00    ; 
    ldi r17, $00    ;
    ADC r16, r17    ; -- 176 + 143 = 319 = 63 mod 256, carry 1
    IN  r18, $3F    ; Read the Status register
    LDI r27, $01    ;
    LDI r26, $00    ;
    ST  X,   r16    ;W 01 0100
    ST  X,   r17    ;W 00 0100
    ST  X,   r18    ;W 00 0100

; Test adding numbers that add to one with carry set
test_adc_with_carry_overflow_to_one:
    BSET SREG_C     ; Clear carry flag
    ldi r16, $7F    ; 
    ldi r17, $81    ;
    ADC r16, r17    ; -- 127 + 129 = 0 with carry 1
    IN  r18, $3F    ; Read the Status register
    LDI r27, $01    ;
    LDI r26, $00    ;
    ST  X,   r16    ;W 01 0100
    ST  X,   r17    ;W 81 0100
    ST  X,   r18    ;W 21 0100

; Test adding numbers that add to zero with carry set
test_adc_with_carry_overflow_to_zero:
    BSET SREG_C     ; Clear carry flag
    ldi r16, $7E    ; 
    ldi r17, $81    ;
    ADC r16, r17    ; -- 127 + 129 = 0 with carry 1
    IN  r18, $3F    ; Read the Status register
    LDI r27, $01    ;
    LDI r26, $00    ;
    ST  X,   r16    ;W 00 0100
    ST  X,   r17    ;W 81 0100
    ST  X,   r18    ;W 23 0100

;PREPROCESS TestADIW
; ADIW Instruction: 
; Adds an immediate value (0-63) to a register pair and places the result in the register pair.
; 

start_test_adiw:
    CLR_SREG

test_adiw_zero:
    BCLR SREG_H       ; Explicitly make clear H flag is clear, even though done above.
    LDI r24, $00
    LDI r25, $00
    ADIW r25:r24, 0
    IN  r18, $3F      ; Read the Status register
    STS $0101, r25    ;W 00 0101
    STS $0100, r24    ;W 00 0100
    STS $0100, r18    ;W 02 0100

test_adiw_notouch_hflag:
    ; Same test as above, but set the H flag before
    BSET SREG_H
    LDI r24, $00
    LDI r25, $00
    ADIW r25:r24, 0
    IN  r18, $3F      ; Read the Status register
    STS $0101, r25    ;W 00 0101
    STS $0100, r24    ;W 00 0100
    STS $0100, r18    ;W 22 0100

test_adiw_halfcarry_no_effect:
    BCLR SREG_H
    LDI r24, $0F
    LDI r25, $00
    ADIW r25:r24, 1
    IN  r18, $3F      ; Read the Status register
    STS $0101, r25    ;W 00 0101
    STS $0100, r24    ;W 10 0100
    STS $0100, r18    ;W 00 0100

test_adiw_lowcarry:
    LDI r24, $FF
    LDI r25, $00
    ADIW r25:r24, 1
    IN  r18, $3F      ; Read the Status register
    STS $0101, r25    ;W 01 0101
    STS $0100, r24    ;W 00 0100
    STS $0100, r18    ;W 00 0100

test_adiw_typical:
    LDI r24, 235
    LDI r25, 127
    ADIW r25:r24, 20  ; 127*256 + 235 + 20 = 127*256 + 255
    IN  r18, $3F      ; Read the Status register
    STS $0101, r25    ;W 7F 0101
    STS $0100, r24    ;W FF 0100
    STS $0100, r18    ;W 00 0100

test_adiw_signed_overflow:
    LDI r24, 237
    LDI r25, 127
    ADIW r25:r24, 33  ; 127*256 + 237 + 33 = 128*256 + 14
    IN  r18, $3F      ; Read the Status register
    STS $0101, r25    ;W 80 0101
    STS $0100, r24    ;W 0E 0100
    STS $0100, r18    ;W 0C 0100

test_adiw_unsigned_overflow:
    LDI r24, 195
    LDI r25, 255
    ADIW r25:r24, 63  ; 255*256 + 195 + 63 = 1*65536 + 0*256 + 2
    IN  r18, $3F      ; Read the Status register
    STS $0101, r25    ;W 00 0101
    STS $0100, r24    ;W 02 0100
    STS $0100, r18    ;W 01 0100

test_adiw_unsigned_overflow_to_zero:
    LDI r24, 206
    LDI r25, 255
    ADIW r25:r24, 50  ; 255*256 + 206 + 50 = 1*65536 + 0*256 + 0
    IN  r18, $3F      ; Read the Status register
    STS $0101, r25    ;W 00 0101
    STS $0100, r24    ;W 00 0100
    STS $0100, r18    ;W 03 0100

;PREPROCESS TestAND
start_test_and:
    CLR_SREG

test_and_with_zero:
    LDI r20, $F1
    LDI r21, $00
    AND r21, r20
    IN  r18, $3F      ; Read the Status register
    STS $0100, r20    ;W F1 0100
    STS $0100, r21    ;W 00 0100
    STS $0100, r18    ;W 02 0100

test_and_result_zero:
    BSET SREG_V       ; AND should clear V flag always
    LDI r20, $A9
    LDI r21, $46
    AND r21, r20
    IN  r18, $3F      ; Read the Status register
    STS $0100, r20    ;W A9 0100
    STS $0100, r21    ;W 00 0100
    STS $0100, r18    ;W 02 0100

test_and_n_flag:
    BSET SREG_V       ; AND should clear V flag always
    LDI r20, $F9
    LDI r21, $85
    AND r21, r20
    IN  r18, $3F      ; Read the Status register
    STS $0100, r20    ;W F9 0100
    STS $0100, r21    ;W 81 0100
    STS $0100, r18    ;W 14 0100

;PREPROCESS TestANDI
start_test_andi:
    CLR_SREG

test_andi_with_zero:
    LDI r21, $00
    ANDI r21, $F1
    IN  r18, $3F      ; Read the Status register
    STS $0100, r21    ;W 00 0100
    STS $0100, r18    ;W 02 0100

test_andi_result_zero:
    BSET SREG_V       ; AND should clear V flag always
    LDI r21, $46
    ANDI r21, $A9
    IN  r18, $3F      ; Read the Status register
    STS $0100, r21    ;W 00 0100
    STS $0100, r18    ;W 02 0100

test_andi_n_flag:
    BSET SREG_V       ; AND should clear V flag always
    LDI r21, $85
    ANDI r21, $F9
    IN  r18, $3F      ; Read the Status register
    STS $0100, r21    ;W 81 0100
    STS $0100, r18    ;W 14 0100

;PREPROCESS TestASR
start_test_asr:
    CLR_SREG

test_asr_high_zero:
    LDI r16, $6A
    MOV r3, r16
    ; Now, do 8 shifts and check the results regularly.
    ASR r3
    IN  r18, $3F      ; Read the Status register
    STS $0100, r3    ;W 35 0100
    STS $0100, r18    ;W 00 0100

    ASR r3
    IN  r18, $3F      ; Read the Status register
    STS $0100, r3    ;W 1A 0100
    STS $0100, r18    ;W 19 0100

    ASR r3
    IN  r18, $3F      ; Read the Status register
    STS $0100, r3    ;W 0D 0100
    STS $0100, r18    ;W 00 0100

    ASR r3
    IN  r18, $3F      ; Read the Status register
    STS $0100, r3    ;W 06 0100
    STS $0100, r18    ;W 19 0100

    ; Shift twice in a row
    ASR r3
    ASR r3
    IN  r18, $3F      ; Read the Status register
    STS $0100, r3    ;W 01 0100
    STS $0100, r18    ;W 19 0100

    ; Shift to zero
    ASR r3
    IN  r18, $3F      ; Read the Status register
    STS $0100, r3    ;W 00 0100
    STS $0100, r18    ;W 1B 0100

    ; Shift at zero
    ASR r3
    IN  r18, $3F      ; Read the Status register
    STS $0100, r3    ;W 00 0100
    STS $0100, r18    ;W 02 0100


test_asr_high_one:
    LDI r16, $84
    MOV r3, r16
    ; Now, do 8 shifts and check the results regularly.
    ASR r3
    IN  r18, $3F      ; Read the Status register
    STS $0100, r3    ;W C2 0100
    STS $0100, r18    ;W 0C 0100

    ASR r3
    IN  r18, $3F      ; Read the Status register
    STS $0100, r3    ;W E1 0100
    STS $0100, r18    ;W 0C 0100

    ASR r3
    IN  r18, $3F      ; Read the Status register
    STS $0100, r3    ;W F0 0100
    STS $0100, r18    ;W 15 0100

    ASR r3
    IN  r18, $3F      ; Read the Status register
    STS $0100, r3     ;W F8 0100
    STS $0100, r18    ;W 0C 0100

    ; Shift twice in a row
    ASR r3
    ASR r3
    IN  r18, $3F      ; Read the Status register
    STS $0100, r3    ;W FE 0100
    STS $0100, r18    ;W 0C 0100

    ; Shift to zero
    ASR r3
    IN  r18, $3F      ; Read the Status register
    STS $0100, r3    ;W FF 0100
    STS $0100, r18    ;W 0C 0100

    ; Shift at zero
    ASR r3
    IN  r18, $3F      ; Read the Status register
    STS $0100, r3    ;W FF 0100
    STS $0100, r18    ;W 15 0100

;PREPROCESS TestBCLR
start_bclr:
    CLR_SREG


test_bclr:
    ; Go in non-sequential order, clearing bits one-by-one
    LDI r16, $FF
    OUT SREG_ADDR, r16

    ; Clear V -- bit 3
    BCLR SREG_V
    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W F7 0100

    ; Clear H -- bit 5
    BCLR SREG_H
    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W D7 0100

    ; Clear T -- bit 6
    BCLR SREG_T
    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W 97 0100

    ; Clear Z -- bit 1
    BCLR SREG_Z
    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W 95 0100

    ; Clear N -- bit 2
    BCLR SREG_N
    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W 91 0100

    ; Clear C -- bit 0
    BCLR SREG_C
    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W 90 0100

    ; Clear I -- bit 7
    BCLR SREG_I
    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W 10 0100

    ; Clear S -- bit 4
    BCLR SREG_S
    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W 00 0100

;PREPROCESS TestBLD
start_bld:
    CLR_SREG
test_bld:
    ; Go through and write 1s and 0s from T flag to reg
    ; Start with target bit as bit 0
    LDI r17, $00
    BCLR SREG_T
    BLD r17, 0          ; Write 0 to target bit
    STS $0100, r17      ;W 00 0100
    BSET SREG_T         ; Set the T bit
    BLD r17, 0          ; Write 1 to target bit
    STS $0100, r17      ;W 01 0100
    BLD r17, 0          ; Write 1 again to make sure no toggle
    STS $0100, r17      ;W 01 0100

    ; Now, we repeat the above for bits 1-7

    ; Target bit 1
    LDI r17, $00
    BCLR SREG_T
    BLD r17, 1          ; Write 0 to target bit
    STS $0100, r17      ;W 00 0100
    BSET SREG_T         ; Set the T bit
    BLD r17, 1          ; Write 1 to target bit
    STS $0100, r17      ;W 02 0100
    BLD r17, 1          ; Write 1 again to make sure no toggle
    STS $0100, r17      ;W 02 0100

    ; Target bit 2
    LDI r17, $00
    BCLR SREG_T
    BLD r17, 2          ; Write 0 to target bit
    STS $0100, r17      ;W 00 0100
    BSET SREG_T         ; Set the T bit
    BLD r17, 2          ; Write 1 to target bit
    STS $0100, r17      ;W 04 0100
    BLD r17, 2          ; Write 1 again to make sure no toggle
    STS $0100, r17      ;W 04 0100

    ; Target bit 3
    LDI r17, $00
    BCLR SREG_T
    BLD r17, 3          ; Write 0 to target bit
    STS $0100, r17      ;W 00 0100
    BSET SREG_T         ; Set the T bit
    BLD r17, 3          ; Write 1 to target bit
    STS $0100, r17      ;W 08 0100
    BLD r17, 3          ; Write 1 again to make sure no toggle
    STS $0100, r17      ;W 08 0100

    ; Target bit 4
    LDI r17, $00
    BCLR SREG_T
    BLD r17, 4          ; Write 0 to target bit
    STS $0100, r17      ;W 00 0100
    BSET SREG_T         ; Set the T bit
    BLD r17, 4          ; Write 1 to target bit
    STS $0100, r17      ;W 10 0100
    BLD r17, 4          ; Write 1 again to make sure no toggle
    STS $0100, r17      ;W 10 0100

    ; Target bit 5
    LDI r17, $00
    BCLR SREG_T
    BLD r17, 5          ; Write 0 to target bit
    STS $0100, r17      ;W 00 0100
    BSET SREG_T         ; Set the T bit
    BLD r17, 5          ; Write 1 to target bit
    STS $0100, r17      ;W 20 0100
    BLD r17, 5          ; Write 1 again to make sure no toggle
    STS $0100, r17      ;W 20 0100

    ; Target bit 6
    LDI r17, $00
    BCLR SREG_T
    BLD r17, 6          ; Write 0 to target bit
    STS $0100, r17      ;W 00 0100
    BSET SREG_T         ; Set the T bit
    BLD r17, 6          ; Write 1 to target bit
    STS $0100, r17      ;W 40 0100
    BLD r17, 6          ; Write 1 again to make sure no toggle
    STS $0100, r17      ;W 40 0100

    ; Target bit 7
    LDI r17, $00
    BCLR SREG_T
    BLD r17, 7          ; Write 0 to target bit
    STS $0100, r17      ;W 00 0100
    BSET SREG_T         ; Set the T bit
    BLD r17, 7          ; Write 1 to target bit
    STS $0100, r17      ;W 80 0100
    BLD r17, 7          ; Write 1 again to make sure no toggle
    STS $0100, r17      ;W 80 0100

;PREPROCESS TestBSET

; This implements testing for both BSET and BCLR
start_bset:
    CLR_SREG
test_bset:
    ; Go in non-sequential order, setting bits one-by-one
    LDI r16, $00
    OUT SREG_ADDR, r16

    ; Clear V -- bit 3
    BSET SREG_V
    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W 08 0100

    ; Clear H -- bit 5
    BSET SREG_H
    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W 28 0100

    ; Clear T -- bit 6
    BSET SREG_T
    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W 68 0100

    ; Clear Z -- bit 1
    BSET SREG_Z
    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W 6A 0100

    ; Clear N -- bit 2
    BSET SREG_N
    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W 6E 0100

    ; Clear C -- bit 0
    BSET SREG_C
    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W 6F 0100

    ; Clear I -- bit 7
    BSET SREG_I
    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W EF 0100

    ; Clear S -- bit 4
    BSET SREG_S
    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W FF 0100

;PREPROCESS TestBST
start_bst:
    CLR_SREG

test_bst:
    ; Go through and read 1s and 0s into T flag
    LDI r20, $01
    BCLR SREG_T
    BST r20, 1          ; Zero bit read in
    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W 00 0100
    BST r20, 0          ; One bit read in
    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W 40 0100
    STS $0100, r20      ;W 01 0100

    LDI r20, $02
    BCLR SREG_T
    BST r20, 0          ; Zero bit read in
    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W 00 0100
    BST r20, 1
    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W 40 0100
    STS $0100, r20      ;W 02 0100

    LDI r20, $04
    BCLR SREG_T
    BST r20, 7          ; Zero bit read in
    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W 00 0100
    BST r20, 2
    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W 40 0100
    STS $0100, r20      ;W 04 0100

    LDI r20, $08
    BCLR SREG_T
    BST r20, 6          ; Zero bit read in
    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W 00 0100
    BST r20, 3
    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W 40 0100
    STS $0100, r20      ;W 08 0100

    LDI r20, $10
    BCLR SREG_T
    BST r20, 5          ; Zero bit read in
    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W 00 0100
    BST r20, 4
    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W 40 0100
    STS $0100, r20      ;W 10 0100

    LDI r20, $20
    BCLR SREG_T
    BST r20, 4          ; Zero bit read in
    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W 00 0100
    BST r20, 5
    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W 40 0100
    STS $0100, r20      ;W 20 0100

    LDI r20, $40
    BCLR SREG_T
    BST r20, 3          ; Zero bit read in
    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W 00 0100
    BST r20, 6
    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W 40 0100
    STS $0100, r20      ;W 40 0100

    LDI r20, $80
    BCLR SREG_T
    BST r20, 2          ; Zero bit read in
    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W 00 0100
    BST r20, 7
    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W 40 0100
    STS $0100, r20      ;W 80 0100

;PREPROCESS TestCOM
start_com:
    CLR_SREG

; All of the following tests for COM start with
; a value, check complement, and then take complement
; back to original value, check that.
test_com_zero:
    LDI r22, $00        ;
    MOV r6, r22
    COM r6
    ; Check result
    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r6       ;W FF 0100
    STS $0100, r18      ;W 15 0100
    ; Complement back to original value
    COM r6
    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r6       ;W 00 0100
    STS $0100, r18      ;W 03 0100

test_com_one:
    LDI r22, $01        ;
    MOV r6, r22
    COM r6
    ; Check result
    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r6       ;W FE 0100
    STS $0100, r18      ;W 15 0100
    ; Complement back to original value
    COM r6
    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r6       ;W 01 0100
    STS $0100, r18      ;W 01 0100

test_com_other:
    LDI r22, $64        ; Value is 100
    MOV r6, r22
    COM r6
    ; Check result
    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r6       ;W 9B 0100
    STS $0100, r18      ;W 15 0100
    ; Complement back to original value
    COM r6
    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r6       ;W 64 0100
    STS $0100, r18      ;W 01 0100

;PREPROCESS TestCP
start_cp:
    CLR_SREG
test_cp_no_mutate:
    LDI r22, $80
    MOV r4, r22
    LDI r23, $A5
    MOV r7, r23
    CP r4, r7

    STS $0100, r4       ;W 80 0100
    STS $0100, r7       ;W A5 0100

test_cp_greater:
    LDI r22, $C8
    MOV r4, r22
    LDI r23, $46
    MOV r7, r23
    CP r4, r7           ; Compare 200 - 70

    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W 14 0100

test_cp_less:
    LDI r22, $0A
    MOV r4, r22
    LDI r23, $7F
    MOV r7, r23
    CP r4, r7           ; Compare 10 - 127

    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W 35 0100

test_cp_equal:
    LDI r22, $1F
    MOV r4, r22
    LDI r23, $1F
    MOV r7, r23
    CP r4, r7           ; Compare 31 - 31

    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W 02 0100

;PREPROCESS TestCPC
start_cpc:
    CLR_SREG

test_cpc_no_carry_equal:
    BCLR SREG_C
    BSET SREG_Z
    LDI r19, $3F
    LDI r20, $3F
    CPC r19, r20
    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W 02 0100

test_cpc_no_carry_not_equal:
    BCLR SREG_C
    BSET SREG_Z
    LDI r19, $40
    LDI r20, $3F
    CPC r19, r20
    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W 20 0100

test_cpc_carry_equal:
    BSET SREG_C
    BSET SREG_Z
    LDI r19, $40
    LDI r20, $3F
    CPC r19, r20
    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W 22 0100

test_cpc_carry_not_equal:
    BSET SREG_C
    BSET SREG_Z
    LDI r19, $3F
    LDI r20, $3F
    CPC r19, r20
    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W 35 0100

;PREPROCESS TestCPI

; Similar test sequence to CP instruction
start_cpi:
    CLR_SREG
test_cpi_no_mutate:
    LDI r24, $80
    CPI r24, $A5

    STS $0100, r24       ;W 80 0100

test_cpi_greater:
    LDI r24, $C8
    CPI r24, $46           ; Compare 200 - 70

    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W 14 0100

test_cpi_less:
    LDI r24, $0A
    CPI r24, $7F           ; Compare 10 - 127

    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W 35 0100

test_cpi_equal:
    LDI r24, $1F
    CPI r24, $1F           ; Compare 31 - 31

    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W 02 0100
;PREPROCESS TestDEC
start_dec:
    CLR_SREG
test_dec_positive:
    LDI r27, $02        ; Initialize to 2

    DEC r27
    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W 00 0100
    STS $0100, r27      ;W 01 0100

    DEC r27
    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W 02 0100
    STS $0100, r27      ;W 00 0100

    DEC r27
    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W 14 0100
    STS $0100, r27      ;W FF 0100

    DEC r27
    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W 14 0100
    STS $0100, r27      ;W FE 0100

test_dec_negative:
    LDI r27, $81        ; Initialize to -127

    DEC r27
    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W 14 0100
    STS $0100, r27      ;W 80 0100

    DEC r27
    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W 18 0100
    STS $0100, r27      ;W 7F 0100

    DEC r27
    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W 00 0100
    STS $0100, r27      ;W 7E 0100

;PREPROCESS TestEOR
start_eor:
    CLR_SREG
test_eor_zeros:
    LDI r20, $00
    LDI r21, $00

    EOR r20, r21

    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W 02 0100
    STS $0100, r20      ;W 00 0100
    STS $0100, r21      ;W 00 0100

test_eor_rr_ones:
    LDI r20, $00
    LDI r21, $FF

    EOR r20, r21

    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W 14 0100
    STS $0100, r20      ;W FF 0100
    STS $0100, r21      ;W FF 0100

test_eor_rd_ones:
    LDI r20, $FF
    LDI r21, $00

    EOR r20, r21

    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W 14 0100
    STS $0100, r20      ;W FF 0100
    STS $0100, r21      ;W 00 0100

test_eor_both_ones:
    LDI r20, $FF
    LDI r21, $FF

    EOR r20, r21

    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W 02 0100
    STS $0100, r20      ;W 00 0100
    STS $0100, r21      ;W FF 0100

test_eor_random:
    LDI r20, $97        ; 10010111
    LDI r21, $A4        ; 10100100
                        ; 00110011

    EOR r20, r21

    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W 00 0100
    STS $0100, r20      ;W 33 0100
    STS $0100, r21      ;W A4 0100

;PREPROCESS TestINC
start_inc:
    CLR_SREG
test_inc_unsigned:
    LDI r27, $FE        ; Initialize to 254

    INC r27
    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W 14 0100
    STS $0100, r27      ;W FF 0100

    INC r27
    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W 02 0100
    STS $0100, r27      ;W 00 0100

    INC r27
    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W 00 0100
    STS $0100, r27      ;W 01 0100

    INC r27
    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W 00 0100
    STS $0100, r27      ;W 02 0100

test_inc_signed:
    LDI r27, $7E        ; Initialize to 126

    INC r27
    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W 00 0100
    STS $0100, r27      ;W 7F 0100

    INC r27
    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W 0C 0100
    STS $0100, r27      ;W 80 0100

    INC r27
    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W 14 0100
    STS $0100, r27      ;W 81 0100


test_success:
    NOP;
    NOP;

test_failure:
    NOP         ; Put a breakpoint on this line
    RET         ; Return to the point where failure occurred, for debugging
    NOP;

