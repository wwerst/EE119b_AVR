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

clear_sreg:
    CLR_SREG


;PREPROCESS TestLSR
start_lsr:
    CLR_SREG
test_lsr:
    LDI r22, $A5        ; 10100101

    LSR r22
    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W
    ASSERT $19, $0100   ; LSB=1 before
    STS $0100, r22      ;W
    ASSERT $52, $0100   ; Check the result

    LSR r22
    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W
    ASSERT $00, $0100   ; LSB=0 before
    STS $0100, r22      ;W
    ASSERT $29, $0100   ; Check the result

    LSR r22
    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W
    ASSERT $19, $0100   ; LSB=1 before
    STS $0100, r22      ;W
    ASSERT $14, $0100   ; Check the result

    LSR r22
    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W
    ASSERT $00, $0100   ; LSB=0 before
    STS $0100, r22      ;W
    ASSERT $0A, $0100   ; Check the result

    LSR r22
    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W
    ASSERT $00, $0100   ; LSB=0 before
    STS $0100, r22      ;W
    ASSERT $05, $0100   ; Check the result

    LSR r22
    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W
    ASSERT $19, $0100   ; LSB=1 before
    STS $0100, r22      ;W
    ASSERT $02, $0100   ; Check the result

    LSR r22
    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W
    ASSERT $00, $0100   ; LSB=0 before
    STS $0100, r22      ;W
    ASSERT $01, $0100   ; Check the result

    LSR r22
    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W
    ASSERT $1B, $0100   ; LSB=1 before, Result=0
    STS $0100, r22      ;W
    ASSERT $00, $0100   ; Check the result

    LSR r22
    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W
    ASSERT $02, $0100   ; LSB=0 before, Result=0
    STS $0100, r22      ;W
    ASSERT $00, $0100   ; Check the result
;PREPROCESS TestNEG
start_neg:
    CLR_SREG
test_neg_zero:
    LDI r24, $00

    NEG r24
    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W
    ASSERT $02, $0100   ; Check the flags
    STS $0100, r24      ;W
    ASSERT $00, $0100   ; Check the result

test_neg_max:
    LDI r24, $FF

    NEG r24
    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W
    ASSERT $21, $0100   ; Check the flags
    STS $0100, r24      ;W
    ASSERT $01, $0100   ; Check the result

test_neg_sign_max:
    LDI r24, $7F

    NEG r24
    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W
    ASSERT $35, $0100   ; Check the flags
    STS $0100, r24      ;W
    ASSERT $81, $0100   ; Check the result

test_neg_sign_min:
    LDI r24, $80

    NEG r24
    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W
    ASSERT $0D, $0100   ; Check the flags
    STS $0100, r24      ;W
    ASSERT $80, $0100   ; Check the result
;PREPROCESS TestOR
start_or:
    CLR_SREG
test_or_zeros:
    LDI r20, $00
    LDI r21, $00

    OR r20, r21

    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W
    ASSERT $02, $0100   ; Z=1
    STS $0100, r20      ;W
    ASSERT $00, $0100   ; Result is 0x00
    STS $0100, r21      ;W
    ASSERT $00, $0100   ; Rr is unchanged

test_or_rr_ones:
    LDI r20, $00
    LDI r21, $FF

    OR r20, r21

    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W
    ASSERT $14, $0100   ; S=1, N=1
    STS $0100, r20      ;W
    ASSERT $FF, $0100   ; Result is 0xFF
    STS $0100, r21      ;W
    ASSERT $FF, $0100   ; Rr is unchanged

test_or_rd_ones:
    LDI r20, $FF
    LDI r21, $00

    OR r20, r21

    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W
    ASSERT $14, $0100   ; S=1, N=1
    STS $0100, r20      ;W
    ASSERT $FF, $0100   ; Result is 0xFF
    STS $0100, r21      ;W
    ASSERT $00, $0100   ; Rr is unchanged

test_or_both_ones:
    LDI r20, $FF
    LDI r21, $FF

    OR r20, r21

    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W
    ASSERT $14, $0100   ; S=1, N=1
    STS $0100, r20      ;W
    ASSERT $FF, $0100   ; Result is 0xFF
    STS $0100, r21      ;W
    ASSERT $FF, $0100   ; Rr is unchanged

test_or_random:
    LDI r20, $97        ; 10010111
    LDI r21, $A4        ; 10100100
                        ; 10110111

    OR r20, r21

    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W
    ASSERT $14, $0100   ; S=1, N=1
    STS $0100, r20      ;W
    ASSERT $B7, $0100   ; Result is 0xC7
    STS $0100, r21      ;W
    ASSERT $A4, $0100   ; Rr is unchanged
;PREPROCESS TestORI
start_ori:
    CLR_SREG
test_ori_zeros:
    LDI r20, $00

    ORI r20, $00

    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W
    ASSERT $02, $0100   ; Z=1
    STS $0100, r20      ;W
    ASSERT $00, $0100   ; Result is 0x00

test_ori_rr_ones:
    LDI r20, $00

    ORI r20, $FF

    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W
    ASSERT $14, $0100   ; S=1, N=1
    STS $0100, r20      ;W
    ASSERT $FF, $0100   ; Result is 0xFF

test_ori_rd_ones:
    LDI r20, $FF

    ORI r20, $00

    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W
    ASSERT $14, $0100   ; S=1, N=1
    STS $0100, r20      ;W
    ASSERT $FF, $0100   ; Result is 0xFF

test_ori_both_ones:
    LDI r20, $FF

    ORI r20, $FF

    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W
    ASSERT $14, $0100   ; S=1, N=1
    STS $0100, r20      ;W
    ASSERT $FF, $0100   ; Result is 0xFF

test_ori_random:
    LDI r20, $97        ; 10010111

    ORI r20, $A4

    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W
    ASSERT $14, $0100   ; S=1, N=1
    STS $0100, r20      ;W
    ASSERT $B7, $0100   ; Result is 0xC7
;PREPROCESS TestROR
start_ror:
    CLR_SREG
test_ror_norm:
    ; This test just shifts data through a few times
    ; During which carry flag is set and cleared
    BSET SREG_C
    LDI r22, $A5        ; Load with random value = 165

    ROR r22
    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W
    ASSERT $15, $0100   ; Check flags
    STS $0100, r22      ;W
    ASSERT $D2, $0100   ; Check the result

    ROR r22
    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W
    ASSERT $0C, $0100   ; Check flags
    STS $0100, r22      ;W
    ASSERT $E9, $0100   ; Check the result

    ROR r22
    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W
    ASSERT $19, $0100   ; Check flags
    STS $0100, r22      ;W
    ASSERT $74, $0100   ; Check the result

    ROR r22
    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W
    ASSERT $0C, $0100   ; Check flags
    STS $0100, r22      ;W
    ASSERT $BA, $0100   ; Check the result

    LSR r22
    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W
    ASSERT $00, $0100   ; Check flags
    STS $0100, r22      ;W
    ASSERT $5D, $0100   ; Check the result
test_ror_to_zero:
    BCLR SREG_C
    LDI r22, $01        ; Load with random value = 165

    ROR r22
    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W
    ASSERT $1B, $0100   ; Check flags
    STS $0100, r22      ;W
    ASSERT $00, $0100   ; Check the result

    ROR r22
    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W
    ASSERT $0C, $0100   ; Check flags
    STS $0100, r22      ;W
    ASSERT $80, $0100   ; Check the result

;PREPROCESS TestSBC
start_sbc:
    CLR_SREG
test_sbc_nocarry_to_zero:
    BSET SREG_Z         ; The zero flag is cascaded from previous zero flag
    ldi r16, $AF        ; 
    ldi r17, $AF        ;
    SBC r16, r17        ;
    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W
    ASSERT $02, $0100   ; Check flags
    STS $0100, r16      ;W
    ASSERT $00, $0100   ; Check the result
    STS $0100, r17      ;W
    ASSERT $AF, $0100   ; Check that Rr is unchanged

 test_sbc_nocarry_of_zero:
    BCLR SREG_Z         ; The zero flag is cascaded, so even though
                        ; the result is zero, the flag shouldn't be
                        ; set at end of this test.
    ldi r16, $00        ; 
    ldi r17, $00        ;
    SBC r16, r17        ;
    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W
    ASSERT $00, $0100   ; Check flags
    STS $0100, r16      ;W
    ASSERT $00, $0100   ; Check the result
    STS $0100, r17      ;W
    ASSERT $00, $0100   ; Check that Rr is unchanged

 test_sbc_withcarry_to_zero:
    BSET SREG_Z
    BSET SREG_C
    ldi r16, $F1        ; 
    ldi r17, $F0        ;
    SBC r16, r17        ;
    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W
    ASSERT $02, $0100   ; Check flags
    STS $0100, r16      ;W
    ASSERT $00, $0100   ; Check the result
    STS $0100, r17      ;W
    ASSERT $F0, $0100   ; Check that Rr is unchanged

 test_sbc_carry_underflow_of_zero:
    BSET SREG_C
    ldi r16, $00        ; 
    ldi r17, $00        ;
    SBC r16, r17        ; 0 - 0 - 1 = -1 = 0xFF
    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W
    ASSERT $35, $0100   ; Check flags
    STS $0100, r16      ;W
    ASSERT $FF, $0100   ; Check the result
    STS $0100, r17      ;W
    ASSERT $00, $0100   ; Check that Rr is unchanged

 test_sbc_carry_underflow_rand:
    BSET SREG_C
    ldi r16, $34        ; 
    ldi r17, $70        ;
    SBC r16, r17        ;
    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W
    ASSERT $15, $0100   ; Check flags
    STS $0100, r16      ;W
    ASSERT $C3, $0100   ; Check the result
    STS $0100, r17      ;W
    ASSERT $70, $0100   ; Check that Rr is unchanged

;PREPROCESS TestSBCI
start_sbci:
    CLR_SREG
test_sbci_nocarry_to_zero:
    BSET SREG_Z         ; The zero flag is cascaded from previous zero flag
    ldi r16, $AF        ;
    SBCI r16, $AF       ;
    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W
    ASSERT $02, $0100   ; Check flags
    STS $0100, r16      ;W
    ASSERT $00, $0100   ; Check the result

 test_sbci_nocarry_of_zero:
    BCLR SREG_Z         ; The zero flag is cascaded, so even though
                        ; the result is zero, the flag shouldn't be
                        ; set at end of this test.
    ldi r16, $00        ;
    SBCI r16, $00        ;
    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W
    ASSERT $00, $0100   ; Check flags
    STS $0100, r16      ;W
    ASSERT $00, $0100   ; Check the result

 test_sbci_withcarry_to_zero:
    BSET SREG_Z
    BSET SREG_C
    ldi r16, $F1        ;
    SBCI r16, $F0        ;
    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W
    ASSERT $02, $0100   ; Check flags
    STS $0100, r16      ;W
    ASSERT $00, $0100   ; Check the result

 test_sbci_carry_underflow_of_zero:
    BSET SREG_C
    ldi r16, $00        ;
    SBCI r16, $00        ; 0 - 0 - 1 = -1 = 0xFF
    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W
    ASSERT $35, $0100   ; Check flags
    STS $0100, r16      ;W
    ASSERT $FF, $0100   ; Check the result

 test_sbci_carry_underflow_rand:
    BSET SREG_C
    ldi r16, $34        ;
    SBCI r16, $70        ;
    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W
    ASSERT $15, $0100   ; Check flags
    STS $0100, r16      ;W
    ASSERT $C3, $0100   ; Check the result
;PREPROCESS TestSBIW
start_sbiw:
    CLR_SREG
;PREPROCESS TestSUB
start_sub:
    CLR_SREG
;PREPROCESS TestSUBI
start_subi:
    CLR_SREG
;PREPROCESS TestSWAP
start_swap:
    CLR_SREG
test_swap:
    LDI r17, $34
    SWAP r17
    STS $0100, r17      ;W
    ASSERT $43, $0100

    LDI r22, $7F
    MOV r4, r22
    SWAP r4
    MOV r23, r4
    STS $0100, r23      ;W
    ASSERT $F7, $0100
test_success:
    NOP;
    NOP;

test_failure:
    NOP         ; Put a breakpoint on this line
    RET         ; Return to the point where failure occurred, for debugging
    NOP;

