; Tests the ALU instructions


; Notes:
; The status register can be accessed in the I/O memory space at $3F.
; This test bench uses that to quickly check that all status register
; bits are being See https://people.ece.cornell.edu/land/courses/ece4760/AtmelStuff/at90s4414.pdf

clear_sreg:
    LDI r16, $00
    OUT $3F, r16

;PREPROCESS TestAdd {r16=Rd, r17=Rd, r18=Rd, X={X, Y, Z}}
test_add_to_zero:
    ldi r16, $00    ; 
    ldi r17, $AF    ;
    ADD r16, r17    ;
	IN  r18, $3F    ; Read the Status register
    LDI r27, $FF    ;
    LDI r26, $00    ;
    ST  X,   r16    ;W AF FF00   Check the add result
	ST  X,   r17    ;W AF FF00   Check the read-only operand
	ST  X,   r18    ;W 14 FF00  Check the status register

 test_add_of_zero:
    ldi r16, $AF    ; 
    ldi r17, $00    ;
    ADD r16, r17    ;
	IN  r18, $3F    ; Read the Status register
    LDI r27, $FF    ;
    LDI r26, $00    ;
    ST  X,   r16    ;W AF FF00  Writes out ADD(AF, 00)
	ST  X,   r17    ;W 00 FF00  Check the read-only operand
	ST  X,   r18    ;W 14 FF00  Check the status register

test_add_overflow:
    ldi r16, $B0    ; 
    ldi r17, $8F    ;
    ADD r16, r17    ; -- 176 + 143 = 319 = 63 mod 256, carry 1
	IN  r18, $3F    ; Read the Status register
    LDI r27, $FF    ;
    LDI r26, $00    ;
    ST  X,   r16    ;W 3F FF00  Writes out ADD result
	ST  X,   r17    ;W 8F FF00   Check the read-only operand
	ST  X,   r18    ;W 19 FF00  Check the status register.

test_add_overflow_to_zero:
    ldi r16, $7F    ; 
    ldi r17, $81    ;
    ADD r16, r17    ; -- 127 + 129 = 0 with carry 1
	IN  r18, $3F    ; Read the Status register
    LDI r27, $FF    ;
    LDI r26, $00    ;
    ST  X,   r16    ;W 00 FF00  Writes out ADD result
	ST  X,   r17    ;W 81 FF00   Check the read-only operand
	ST  X,   r18    ;W 23 FF00  Check the status register.

test_add_zeros:
    ldi r16, $00    ; 
    ldi r17, $00    ;
    ADD r16, r17    ; -- 176 + 143 = 319 = 63 mod 256, carry 1
	IN  r18, $3F    ; Read the Status register
    LDI r27, $FF    ;
    LDI r26, $00    ;
    ST  X,   r16    ;W 00 FF00  Writes out ADD result
	ST  X,   r17    ;W 00 FF00   Check the read-only operand
	ST  X,   r18    ;W 02 FF00  Check the status register.

    NOP;
    NOP;
    NOP;

;PREPROCESS TestADC
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

