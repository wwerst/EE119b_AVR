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

.EQU SREG_C = 0

.CSEG ; Start code segment

clear_sreg:
    LDI r16, $00
    OUT $3F, r16

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
;PREPROCESS TestAND
;PREPROCESS TestANDI
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

