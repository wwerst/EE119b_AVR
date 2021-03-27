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
    STS $0100, r18      ;W 19 0100
    STS $0100, r22      ;W 52 0100

    LSR r22
    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W 00 0100
    STS $0100, r22      ;W 29 0100

    LSR r22
    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W 19 0100
    STS $0100, r22      ;W 14 0100

    LSR r22
    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W 00 0100
    STS $0100, r22      ;W 0A 0100

    LSR r22
    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W 00 0100
    STS $0100, r22      ;W 05 0100

    LSR r22
    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W 19 0100
    STS $0100, r22      ;W 02 0100

    LSR r22
    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W 00 0100
    STS $0100, r22      ;W 01 0100

    LSR r22
    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W 1B 0100
    STS $0100, r22      ;W 00 0100

    LSR r22
    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W 02 0100
    STS $0100, r22      ;W 00 0100
;PREPROCESS TestNEG
start_neg:
    CLR_SREG
test_neg_zero:
    LDI r24, $00

    NEG r24
    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W 02 0100
    STS $0100, r24      ;W 00 0100

test_neg_max:
    LDI r24, $FF

    NEG r24
    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W 21 0100
    STS $0100, r24      ;W 01 0100

test_neg_sign_max:
    LDI r24, $7F

    NEG r24
    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W 35 0100
    STS $0100, r24      ;W 81 0100

test_neg_sign_min:
    LDI r24, $80

    NEG r24
    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W 0D 0100
    STS $0100, r24      ;W 80 0100
;PREPROCESS TestOR
start_or:
    CLR_SREG
test_or_zeros:
    LDI r20, $00
    LDI r21, $00

    OR r20, r21

    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W 02 0100
    STS $0100, r20      ;W 00 0100
    STS $0100, r21      ;W 00 0100

test_or_rr_ones:
    LDI r20, $00
    LDI r21, $FF

    OR r20, r21

    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W 14 0100
    STS $0100, r20      ;W FF 0100
    STS $0100, r21      ;W FF 0100

test_or_rd_ones:
    LDI r20, $FF
    LDI r21, $00

    OR r20, r21

    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W 14 0100
    STS $0100, r20      ;W FF 0100
    STS $0100, r21      ;W 00 0100

test_or_both_ones:
    LDI r20, $FF
    LDI r21, $FF

    OR r20, r21

    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W 14 0100
    STS $0100, r20      ;W FF 0100
    STS $0100, r21      ;W FF 0100

test_or_random:
    LDI r20, $97        ; 10010111
    LDI r21, $A4        ; 10100100
                        ; 10110111

    OR r20, r21

    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W 14 0100
    STS $0100, r20      ;W B7 0100
    STS $0100, r21      ;W A4 0100
;PREPROCESS TestORI
start_ori:
    CLR_SREG
test_ori_zeros:
    LDI r20, $00

    ORI r20, $00

    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W 02 0100
    STS $0100, r20      ;W 00 0100

test_ori_rr_ones:
    LDI r20, $00

    ORI r20, $FF

    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W 14 0100
    STS $0100, r20      ;W FF 0100

test_ori_rd_ones:
    LDI r20, $FF

    ORI r20, $00

    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W 14 0100
    STS $0100, r20      ;W FF 0100

test_ori_both_ones:
    LDI r20, $FF

    ORI r20, $FF

    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W 14 0100
    STS $0100, r20      ;W FF 0100

test_ori_random:
    LDI r20, $97        ; 10010111

    ORI r20, $A4

    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W 14 0100
    STS $0100, r20      ;W B7 0100
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
    STS $0100, r18      ;W 15 0100
    STS $0100, r22      ;W D2 0100

    ROR r22
    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W 0C 0100
    STS $0100, r22      ;W E9 0100

    ROR r22
    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W 19 0100
    STS $0100, r22      ;W 74 0100

    ROR r22
    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W 0C 0100
    STS $0100, r22      ;W BA 0100

    LSR r22
    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W 00 0100
    STS $0100, r22      ;W 5D 0100
test_ror_to_zero:
    BCLR SREG_C
    LDI r22, $01        ; Load with random value = 165

    ROR r22
    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W 1B 0100
    STS $0100, r22      ;W 00 0100

    ROR r22
    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W 0C 0100
    STS $0100, r22      ;W 80 0100

;PREPROCESS TestSBC
start_sbc:
    CLR_SREG
test_sbc_nocarry_to_zero:
    BSET SREG_Z         ; The zero flag is cascaded from previous zero flag
    ldi r16, $AF        ; 
    ldi r17, $AF        ;
    SBC r16, r17        ;
    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W 02 0100
    STS $0100, r16      ;W 00 0100
    STS $0100, r17      ;W AF 0100

 test_sbc_nocarry_of_zero:
    BCLR SREG_Z         ; The zero flag is cascaded, so even though
                        ; the result is zero, the flag shouldn't be
                        ; set at end of this test.
    ldi r16, $00        ; 
    ldi r17, $00        ;
    SBC r16, r17        ;
    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W 00 0100
    STS $0100, r16      ;W 00 0100
    STS $0100, r17      ;W 00 0100

 test_sbc_withcarry_to_zero:
    BSET SREG_Z
    BSET SREG_C
    ldi r16, $F1        ; 
    ldi r17, $F0        ;
    SBC r16, r17        ;
    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W 02 0100
    STS $0100, r16      ;W 00 0100
    STS $0100, r17      ;W F0 0100

 test_sbc_carry_underflow_of_zero:
    BSET SREG_C
    ldi r16, $00        ; 
    ldi r17, $00        ;
    SBC r16, r17        ; 0 - 0 - 1 = -1 = 0xFF
    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W 35 0100
    STS $0100, r16      ;W FF 0100
    STS $0100, r17      ;W 00 0100

 test_sbc_carry_underflow_rand:
    BSET SREG_C
    ldi r16, $34        ; 
    ldi r17, $70        ;
    SBC r16, r17        ;
    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W 15 0100
    STS $0100, r16      ;W C3 0100
    STS $0100, r17      ;W 70 0100

;PREPROCESS TestSBCI
start_sbci:
    CLR_SREG
test_sbci_nocarry_to_zero:
    BSET SREG_Z         ; The zero flag is cascaded from previous zero flag
    ldi r16, $AF        ;
    SBCI r16, $AF       ;
    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W 02 0100
    STS $0100, r16      ;W 00 0100

 test_sbci_nocarry_of_zero:
    BCLR SREG_Z         ; The zero flag is cascaded, so even though
                        ; the result is zero, the flag shouldn't be
                        ; set at end of this test.
    ldi r16, $00        ;
    SBCI r16, $00        ;
    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W 00 0100
    STS $0100, r16      ;W 00 0100

 test_sbci_withcarry_to_zero:
    BSET SREG_Z
    BSET SREG_C
    ldi r16, $F1        ;
    SBCI r16, $F0        ;
    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W 02 0100
    STS $0100, r16      ;W 00 0100

 test_sbci_carry_underflow_of_zero:
    BSET SREG_C
    ldi r16, $00        ;
    SBCI r16, $00        ; 0 - 0 - 1 = -1 = 0xFF
    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W 35 0100
    STS $0100, r16      ;W FF 0100

 test_sbci_carry_underflow_rand:
    BSET SREG_C
    ldi r16, $34        ;
    SBCI r16, $70        ;
    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W 15 0100
    STS $0100, r16      ;W C3 0100
;PREPROCESS TestSBIW
start_sbiw:
    CLR_SREG
test_sbiw_normal:
    LDI r25, $03
    LDI r24, $36        ; r25:r24 = 0x0336

    SBIW r25:r24, $39   ; Result = 0x02FD
    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W 00 0100
    STS $0100, r25      ;W 02 0100
    STS $0100, r24      ;W FD 0100

test_sbiw_to_zero:
    LDI r25, $00
    LDI r24, $2F        ; r25:r24 = 0x002F

    SBIW r25:r24, $2F   ; Result = 0x0000
    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W 02 0100
    STS $0100, r25      ;W 00 0100
    STS $0100, r24      ;W 00 0100

test_sbiw_signed_underflow:
    LDI r25, $80
    LDI r24, $05        ; r25:r24 = 0x002F

    SBIW r25:r24, $10   ; Result = 0x7FF5
    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W 18 0100
    STS $0100, r25      ;W 7F 0100
    STS $0100, r24      ;W F5 0100

test_sbiw_underflow:
    LDI r25, $00
    LDI r24, $2F        ; r25:r24 = 0x002F

    SBIW r25:r24, $39   ; Result = 0xFFF6
    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W 15 0100
    STS $0100, r25      ;W FF 0100
    STS $0100, r24      ;W F6 0100




;PREPROCESS TestSUB
start_sub:
    CLR_SREG

test_sub_to_zero:
    ldi r16, $AF        ; 
    ldi r17, $AF        ;
    SUB r16, r17        ;
    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W 02 0100
    STS $0100, r16      ;W 00 0100
    STS $0100, r17      ;W AF 0100

test_sub_of_zero:
    ldi r16, $00        ; 
    ldi r17, $00        ;
    SUB r16, r17        ;
    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W 02 0100
    STS $0100, r16      ;W 00 0100
    STS $0100, r17      ;W 00 0100

test_sub_underflow_of_zero:
    ldi r16, $00        ; 
    ldi r17, $05        ;
    SUB r16, r17        ; 0 - 0 - 1 = -1 = 0xFF
    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W 35 0100
    STS $0100, r16      ;W FB 0100
    STS $0100, r17      ;W 05 0100

test_sub_normal:
    ldi r16, $83        ; 
    ldi r17, $61        ;
    SUB r16, r17        ;
    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W 18 0100
    STS $0100, r16      ;W 22 0100
    STS $0100, r17      ;W 61 0100

test_sub_underflow_rand:
    ldi r16, $34        ; 
    ldi r17, $70        ;
    SUB r16, r17        ;
    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W 15 0100
    STS $0100, r16      ;W C4 0100
    STS $0100, r17      ;W 70 0100

;PREPROCESS TestSUBI
start_subi:
    CLR_SREG

test_subi_to_zero:
    ldi r16, $AF        ;
    SUBI r16, $AF        ;
    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W 02 0100
    STS $0100, r16      ;W 00 0100

test_subi_of_zero:
    ldi r16, $00        ;
    SUBI r16, $00        ;
    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W 02 0100
    STS $0100, r16      ;W 00 0100

test_subi_underflow_of_zero:
    ldi r16, $00        ;
    SUBI r16, $05        ; 0 - 0 - 1 = -1 = 0xFF
    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W 35 0100
    STS $0100, r16      ;W FB 0100

test_subi_normal:
    ldi r16, $83        ;
    SUBI r16, $61        ;
    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W 18 0100
    STS $0100, r16      ;W 22 0100

test_subi_underflow_rand:
    ldi r16, $34        ;
    SUBI r16, $70        ;
    IN  r18, SREG_ADDR  ; Read the Status register
    STS $0100, r18      ;W 15 0100
    STS $0100, r16      ;W C4 0100

;PREPROCESS TestSWAP
start_swap:
    CLR_SREG
test_swap:
    LDI r17, $34
    SWAP r17
    STS $0100, r17      ;W 43 0100

    LDI r22, $7F
    MOV r4, r22
    SWAP r4
    MOV r23, r4
    STS $0100, r23      ;W F7 0100

start_mul:
    CLR_SREG
test_mul_1:
    LDI r23, $13
    LDI r30, $39
    MUL r30, r23        ; 0x13 * 0x39 = 0x043B
    IN r18, SREG_ADDR
    STS $0100, r18      ;W 00 0100
    STS $0100, r23      ;W 13 0100
    STS $0100, r30      ;W 39 0100
    STS $0100, r1      ;W 04 0100
    STS $0100, r0      ;W 3B 0100

test_mul_2:
    LDI r29, $00
    LDI r19, $AF
    MUL r29, r19        ; 0x00 * 0xAF = 0x0000
    IN r18, SREG_ADDR
    STS $0100, r18      ;W 02 0100
    STS $0100, r29      ;W 00 0100
    STS $0100, r19      ;W AF 0100
    STS $0100, r1       ;W 00 0100
    STS $0100, r0       ;W 00 0100

test_mul_3:
    LDI r29, $9F
    LDI r19, $A3
    MUL r29, r19        ; 0x9F * 0xA3 = 0x653D
    IN r18, SREG_ADDR
    STS $0100, r18      ;W 00 0100
    STS $0100, r29      ;W 9F 0100
    STS $0100, r19      ;W A3 0100
    STS $0100, r1       ;W 65 0100
    STS $0100, r0       ;W 3D 0100

test_mul_max_nocarry:
    LDI r29, $D9        ; 217
    LDI r19, $97        ; 151
    MOV r9, r29
    MOV r21, r19
    MUL r9, r21        ; 217 * 151 = 0x7FFF
    IN r18, SREG_ADDR
    STS $0100, r18      ;W 00 0100
    STS $0100, r9       ;W D9 0100
    STS $0100, r21      ;W 97 0100
    STS $0100, r1       ;W 7F 0100
    STS $0100, r0       ;W FF 0100

test_mul_barely_carry:
    LDI r29, $88        ; 136
    LDI r19, $F1        ; 241
    MOV r3, r29
    MOV r2, r19
    MUL r3, r2        ; 136 * 241 = 0x8008
    IN r18, SREG_ADDR
    STS $0100, r18      ;W 01 0100
    STS $0100, r3       ;W 88 0100
    STS $0100, r2       ;W F1 0100
    STS $0100, r1       ;W 80 0100
    STS $0100, r0       ;W 08 0100

test_mul_max:
    LDI r29, $FF        ; 255
    LDI r19, $FF        ; 255
    MOV r13, r29
    MOV r8, r19
    MUL r13, r8        ; 255 * 255 = 0xFE01
    IN r18, SREG_ADDR
    STS $0100, r18      ;W 01 0100
    STS $0100, r13      ;W FF 0100
    STS $0100, r8       ;W FF 0100
    STS $0100, r1       ;W FE 0100
    STS $0100, r0       ;W 01 0100

test_mul_to_r0r1:
    LDI r21, $8B        ; 139
    LDI r20, $EE        ; 238
    MOV r1, r21
    MOV r0, r20
    MUL r1, r0        ; 139 * 238 = 0x813A
    IN r18, SREG_ADDR
    STS $0100, r18      ;W 01 0100
    STS $0100, r1       ;W 81 0100
    STS $0100, r0       ;W 3A 0100

test_success:
    NOP;
    NOP;

test_failure:
    NOP         ; Put a breakpoint on this line
;    RET          RET inst not allowed ; Return to the point where failure occurred, for debugging
    NOP;

