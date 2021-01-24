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

.EQU SREG_C = 0
.EQU SREG_Z = 1
.EQU SREG_N = 2
.EQU SREG_V = 3
.EQU SREG_S = 4
.EQU SREG_H = 5
.EQU SREG_T = 6
.EQU SREG_I = 7

.CSEG ; Start code segment

; TODO for better testing:
; - Randomize some Status register flags to be 1 instead of 0,
;   and then make sure that instructions don't modify
;   flags they are supposed to leave untouched.

clear_sreg:
    CLR_SREG

;PREPROCESS TestAdd {r16=Rd, r17=Rd, r18=Rd, X={X, Y, Z}}
test_add_to_zero:
    ldi r16, $00    ; 
    ldi r17, $AF    ;
    ADD r16, r17    ;
    IN  r18, $3F    ; Read the Status register
    LDI r27, $01    ;
    LDI r26, $00    ;
    ST  X,   r16    ;W AF 0100   Check the add result
    ASSERT $AF, $0100
    ST  X,   r17    ;W AF 0100   Check the read-only operand
    ASSERT $AF, $0100
    ST  X,   r18    ;W 14 0100  Check the status register
    ASSERT $14, $0100

 test_add_of_zero:
    ldi r16, $AF    ; 
    ldi r17, $00    ;
    ADD r16, r17    ;
    IN  r18, $3F    ; Read the Status register
    LDI r27, $01    ;
    LDI r26, $00    ;
    ST  X,   r16    ;W AF 0100  Writes out ADD(AF, 00)
    ASSERT $AF, $0100
    ST  X,   r17    ;W 00 0100  Check the read-only operand
    ASSERT $00, $0100
    ST  X,   r18    ;W 14 0100  Check the status register
    ASSERT $14, $0100

test_add_overflow:
    ldi r16, $B0    ; 
    ldi r17, $8F    ;
    ADD r16, r17    ; -- 176 + 143 = 319 = 63 mod 256, carry 1
    IN  r18, $3F    ; Read the Status register
    LDI r27, $01    ;
    LDI r26, $00    ;
    ST  X,   r16    ;W 3F 0100  Writes out ADD result
    ASSERT $3F, $0100
    ST  X,   r17    ;W 8F 0100   Check the read-only operand
    ASSERT $8F, $0100
    ST  X,   r18    ;W 19 0100  Check the status register.
    ASSERT $19, $0100

test_add_overflow_to_zero:
    ldi r16, $7F    ; 
    ldi r17, $81    ;
    ADD r16, r17    ; -- 127 + 129 = 0 with carry 1
    IN  r18, $3F    ; Read the Status register
    LDI r27, $01    ;
    LDI r26, $00    ;
    ST  X,   r16    ;W 00 0100  Writes out ADD result
    ASSERT $00, $0100
    ST  X,   r17    ;W 81 0100   Check the read-only operand
    ASSERT $81, $0100
    ST  X,   r18    ;W 23 0100  Check the status r egister.
    ASSERT $23, $0100

test_add_zeros:
    ldi r16, $00    ; 
    ldi r17, $00    ;
    ADD r16, r17    ; -- 176 + 143 = 319 = 63 mod 256, carry 1
    IN  r18, $3F    ; Read the Status register
    LDI r27, $01    ;
    LDI r26, $00    ;
    ST  X,   r16    ;W 00 0100  Writes out ADD result
    ASSERT $00, $0100
    ST  X,   r17    ;W 00 0100   Check the read-only operand
    ASSERT $00, $0100
    ST  X,   r18    ;W 02 0100  Check the status register.
    ASSERT $02, $0100

;PREPROCESS TestADC
test_adc_to_zero:
    BCLR SREG_C     ; Clear carry flag
    ldi r16, $00    ; 
    ldi r17, $AF    ;
    ADC r16, r17    ;
    IN  r18, $3F    ; Read the Status register
    LDI r27, $01    ;
    LDI r26, $00    ;
    ST  X,   r16    ;W AF 0100   Check the add result
    ASSERT $AF, $0100
    ST  X,   r17    ;W AF 0100   Check the read-only operand
    ASSERT $AF, $0100
    ST  X,   r18    ;W 14 0100  Check the status register
    ASSERT $14, $0100

 test_adc_of_zero:
    BCLR SREG_C     ; Clear carry flag
    ldi r16, $AF    ; 
    ldi r17, $00    ;
    ADC r16, r17    ;
    IN  r18, $3F    ; Read the Status register
    LDI r27, $01    ;
    LDI r26, $00    ;
    ST  X,   r16    ;W AF 0100  Writes out ADD(AF, 00)
    ASSERT $AF, $0100
    ST  X,   r17    ;W 00 0100  Check the read-only operand
    ASSERT $00, $0100
    ST  X,   r18    ;W 14 0100  Check the status register
    ASSERT $14, $0100

test_adc_overflow:
    BCLR SREG_C     ; Clear carry flag
    ldi r16, $B0    ; 
    ldi r17, $8F    ;
    ADC r16, r17    ; -- 176 + 143 = 319 = 63 mod 256, carry 1
    IN  r18, $3F    ; Read the Status register
    LDI r27, $01    ;
    LDI r26, $00    ;
    ST  X,   r16    ;W 3F 0100  Writes out ADD result
    ASSERT $3F, $0100
    ST  X,   r17    ;W 8F 0100   Check the read-only operand
    ASSERT $8F, $0100
    ST  X,   r18    ;W 19 0100  Check the status register.
    ASSERT $19, $0100

test_adc_overflow_to_zero:
    BCLR SREG_C     ; Clear carry flag
    ldi r16, $7F    ; 
    ldi r17, $81    ;
    ADC r16, r17    ; -- 127 + 129 = 0 with carry 1
    IN  r18, $3F    ; Read the Status register
    LDI r27, $01    ;
    LDI r26, $00    ;
    ST  X,   r16    ;W 00 0100  Writes out ADD result
    ASSERT $00, $0100
    ST  X,   r17    ;W 81 0100   Check the read-only operand
    ASSERT $81, $0100
    ST  X,   r18    ;W 23 0100  Check the status r egister.
    ASSERT $23, $0100

test_adc_zeros:
    BCLR SREG_C     ; Clear carry flag
    ldi r16, $00    ; 
    ldi r17, $00    ;
    ADC r16, r17    ; -- 176 + 143 = 319 = 63 mod 256, carry 1
    IN  r18, $3F    ; Read the Status register
    LDI r27, $01    ;
    LDI r26, $00    ;
    ST  X,   r16    ;W 00 0100  Writes out ADD result
    ASSERT $00, $0100
    ST  X,   r17    ;W 00 0100   Check the read-only operand
    ASSERT $00, $0100
    ST  X,   r18    ;W 02 0100  Check the status register.
    ASSERT $02, $0100

; Test adding all zeros with carry flag set
test_adc_with_carry_zeros:
    BSET SREG_C     ; Set carry flag
    ldi r16, $00    ; 
    ldi r17, $00    ;
    ADC r16, r17    ; -- 176 + 143 = 319 = 63 mod 256, carry 1
    IN  r18, $3F    ; Read the Status register
    LDI r27, $01    ;
    LDI r26, $00    ;
    ST  X,   r16    ;W 01 0100  Writes out ADD result
    ASSERT $01, $0100
    ST  X,   r17    ;W 00 0100   Check the read-only operand
    ASSERT $00, $0100
    ST  X,   r18    ;W 00 0100  Check the status register.
    ASSERT $00, $0100

; Test adding numbers that add to one with carry set
test_adc_with_carry_overflow_to_one:
    BSET SREG_C     ; Clear carry flag
    ldi r16, $7F    ; 
    ldi r17, $81    ;
    ADC r16, r17    ; -- 127 + 129 = 0 with carry 1
    IN  r18, $3F    ; Read the Status register
    LDI r27, $01    ;
    LDI r26, $00    ;
    ST  X,   r16    ;W 01 0100  Writes out ADD result
    ASSERT $01, $0100
    ST  X,   r17    ;W 81 0100   Check the read-only operand
    ASSERT $81, $0100
    ST  X,   r18    ;W 21 0100  Check the status r egister.
    ASSERT $21, $0100

; Test adding numbers that add to zero with carry set
test_adc_with_carry_overflow_to_zero:
    BSET SREG_C     ; Clear carry flag
    ldi r16, $7E    ; 
    ldi r17, $81    ;
    ADC r16, r17    ; -- 127 + 129 = 0 with carry 1
    IN  r18, $3F    ; Read the Status register
    LDI r27, $01    ;
    LDI r26, $00    ;
    ST  X,   r16    ;W 00 0100  Writes out ADD result
    ASSERT $00, $0100
    ST  X,   r17    ;W 81 0100   Check the read-only operand
    ASSERT $81, $0100
    ST  X,   r18    ;W 23 0100  Check the status r egister.
    ASSERT $23, $0100

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
    ASSERT $00, $0101 ; The high register value should be zero
    STS $0100, r24    ;W 00 0100
    ASSERT $00, $0100 ; The low register value should be zero
    STS $0100, r18    ;W 02 0100
    ASSERT $02, $0100

test_adiw_notouch_hflag:
    ; Same test as above, but set the H flag before
    BSET SREG_H
    LDI r24, $00
    LDI r25, $00
    ADIW r25:r24, 0
    IN  r18, $3F      ; Read the Status register
    STS $0101, r25    ;W 00 0101
    ASSERT $00, $0101 ; The high register value should be zero
    STS $0100, r24    ;W 00 0100
    ASSERT $00, $0100 ; The low register value should be zero
    STS $0100, r18    ;W 22 0100
    ASSERT $22, $0100

test_adiw_halfcarry_no_effect:
    BCLR SREG_H
    LDI r24, $0F
    LDI r25, $00
    ADIW r25:r24, 1
    IN  r18, $3F      ; Read the Status register
    STS $0101, r25    ;W 00 0101
    ASSERT $00, $0101 ; Check high register
    STS $0100, r24    ;W 10 0100
    ASSERT $10, $0100 ; Check low register
    STS $0100, r18    ;W 00 0100
    ASSERT $00, $0100

test_adiw_lowcarry:
    LDI r24, $FF
    LDI r25, $00
    ADIW r25:r24, 1
    IN  r18, $3F      ; Read the Status register
    STS $0101, r25    ;W
    ASSERT $01, $0101 ; The high register value should be 1
    STS $0100, r24    ;W
    ASSERT $00, $0100 ; The low register value should have all carried out and be zero
    STS $0100, r18    ;W
    ASSERT $00, $0100 ; There should be no carry and also no zero since high set

test_adiw_typical:
    LDI r24, 235
    LDI r25, 127
    ADIW r25:r24, 20  ; 127*256 + 235 + 20 = 127*256 + 255
    IN  r18, $3F      ; Read the Status register
    STS $0101, r25    ;W
    ASSERT $7F, $0101 ; The high register value should be 142 base 10
    STS $0100, r24    ;W
    ASSERT $FF, $0100 ; The low register value should be 14 base 10
    STS $0100, r18    ;W
    ASSERT $00, $0100 ; V=0, N=0, S=0

test_adiw_signed_overflow:
    LDI r24, 237
    LDI r25, 127
    ADIW r25:r24, 33  ; 127*256 + 237 + 33 = 128*256 + 14
    IN  r18, $3F      ; Read the Status register
    STS $0101, r25    ;W
    ASSERT $80, $0101 ; The high register value should be 142 base 10
    STS $0100, r24    ;W
    ASSERT $0E, $0100 ; The low register value should be 14 base 10
    STS $0100, r18    ;W
    ASSERT $0C, $0100 ; V=1, N=1, S=N XOR V=0

test_adiw_unsigned_overflow:
    LDI r24, 195
    LDI r25, 255
    ADIW r25:r24, 63  ; 255*256 + 195 + 63 = 1*65536 + 0*256 + 2
    IN  r18, $3F      ; Read the Status register
    STS $0101, r25    ;W
    ASSERT $00, $0101 ; The high register value should be 142 base 10
    STS $0100, r24    ;W
    ASSERT $02, $0100 ; The low register value should be 14 base 10
    STS $0100, r18    ;W
    ASSERT $01, $0100 ; V=0, N=0, S=N XOR V=1, C=1

test_adiw_unsigned_overflow_to_zero:
    LDI r24, 206
    LDI r25, 255
    ADIW r25:r24, 50  ; 255*256 + 206 + 50 = 1*65536 + 0*256 + 0
    IN  r18, $3F      ; Read the Status register
    STS $0101, r25    ;W
    ASSERT $00, $0101 ; The high register value should be 142 base 10
    STS $0100, r24    ;W
    ASSERT $00, $0100 ; The low register value should be 14 base 10
    STS $0100, r18    ;W
    ASSERT $03, $0100 ; V=0, N=0, S=N XOR V=0, C=1, Z=1

;PREPROCESS TestAND
start_test_and:
    CLR_SREG

test_and_with_zero:
    LDI r20, $F1
    LDI r21, $00
    AND r21, r20
    IN  r18, $3F      ; Read the Status register
    STS $0100, r20    ;W
    ASSERT $F1, $0100 ; Original contents should still be there 
    STS $0100, r21    ;W
    ASSERT $00, $0100 ; ANDing with zero should give zero
    STS $0100, r18    ;W
    ASSERT $02, $0100 ; Z=1

test_and_result_zero:
    BSET SREG_V       ; AND should clear V flag always
    LDI r20, $A9
    LDI r21, $46
    AND r21, r20
    IN  r18, $3F      ; Read the Status register
    STS $0100, r20    ;W
    ASSERT $A9, $0100 ; Original contents should still be there 
    STS $0100, r21    ;W
    ASSERT $00, $0100 ; 0xA9 & 0x46 = 0x00
    STS $0100, r18    ;W
    ASSERT $02, $0100 ; Z=1

test_and_n_flag:
    BSET SREG_V       ; AND should clear V flag always
    LDI r20, $F9
    LDI r21, $85
    AND r21, r20
    IN  r18, $3F      ; Read the Status register
    STS $0100, r20    ;W
    ASSERT $F9, $0100 ; Original contents should still be there 
    STS $0100, r21    ;W
    ASSERT $81, $0100 ; 0xF9 & 0x85 = 0x81
    STS $0100, r18    ;W
    ASSERT $14, $0100 ; N=1, V=0, S=N XOR V=1

;PREPROCESS TestANDI
start_test_andi:
    CLR_SREG

test_andi_with_zero:
    LDI r21, $00
    ANDI r21, $F1
    IN  r18, $3F      ; Read the Status register
    STS $0100, r21    ;W
    ASSERT $00, $0100 ; ANDing with zero should give zero
    STS $0100, r18    ;W
    ASSERT $02, $0100 ; Z=1

test_andi_result_zero:
    BSET SREG_V       ; AND should clear V flag always
    LDI r21, $46
    ANDI r21, $A9
    IN  r18, $3F      ; Read the Status register
    STS $0100, r21    ;W
    ASSERT $00, $0100 ; 0xA9 & 0x46 = 0x00
    STS $0100, r18    ;W
    ASSERT $02, $0100 ; Z=1

test_andi_n_flag:
    BSET SREG_V       ; AND should clear V flag always
    LDI r21, $85
    ANDI r21, $F9
    IN  r18, $3F      ; Read the Status register
    STS $0100, r21    ;W
    ASSERT $81, $0100 ; 0xF9 & 0x85 = 0x81
    STS $0100, r18    ;W
    ASSERT $14, $0100 ; N=1, V=0, S=N XOR V=1

;PREPROCESS TestASR
;PREPROCESS TestBCLR
;PREPROCESS TestBLD
;PREPROCESS TestBSET
;PREPROCESS TestBST
;PREPROCESS TestCOM
;PREPROCESS TestCP
;PREPROCESS TestCPC
;PREPROCESS TestCPI
;PREPROCESS TestDEC
;PREPROCESS TestEOR
;PREPROCESS TestINC
;PREPROCESS TestLSR
;PREPROCESS TestNEG
;PREPROCESS TestOR
;PREPROCESS TestORI
;PREPROCESS TestROR
;PREPROCESS TestSBC
;PREPROCESS TestSBCI
;PREPROCESS TestSBIW
;PREPROCESS TestSUB
;PREPROCESS TestSUBI
;PREPROCESS TestSWAP


test_success:
    NOP;
    NOP;

test_failure:
    NOP         ; Put a breakpoint on this line
    RET         ; Return to the point where failure occurred, for debugging
    NOP;

