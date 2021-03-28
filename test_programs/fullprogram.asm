; Test program for cpu
; This program manipulates data in a somewhat random fashion
; and loads and stores from data memory.
; It can be used as a full cpu testbench for functionality
; by running the program on cpu and comparing data contents
; at end to the data contents of known-good AVR studio sim.
;
; It only does writes to 0x0100-0x017F and 0xFE00-FFFF

clear_mem:
    LDI     r27,    $01
    LDI     r26,    $00
    LDI     r20,    $00

; Loop to clear data from 0x0100 to 0x017F
loop_clear_mem:
    ST      X+,     r20
    CPI     r26,    $80
    BRBC    SREG_Z, loop_clear_mem
    NOP


setup_regs:
    LDI     r16,    $00
    LDI     r17,    $10
    LDI     r18,    $20
    LDI     r19,    $30
    LDI     r20,    $40
    LDI     r21,    $50
    LDI     r22,    $60
    LDI     r23,    $70
    LDI     r24,    $80
    LDI     r25,    $90
    LDI     r26,    $01
    LDI     r27,    $11
    LDI     r28,    $21
    LDI     r29,    $31
    LDI     r30,    $41
    LDI     r31,    $51

    MOV     r0,     r16
    MOV     r1,     r17
    MOV     r2,     r18
    MOV     r3,     r19
    MOV     r4,     r20
    MOV     r5,     r21
    MOV     r6,     r22
    MOV     r7,     r23
    MOV     r8,     r24
    MOV     r9,     r25
    MOV     r10,    r26
    MOV     r11,    r27
    MOV     r12,    r28
    MOV     r13,    r29
    MOV     r14,    r30
    MOV     r15,    r31

    LDI     r16,    $61
    LDI     r17,    $71
    LDI     r18,    $81
    LDI     r19,    $91
    LDI     r20,    $02
    LDI     r21,    $12
    LDI     r22,    $22
    LDI     r23,    $32
    LDI     r24,    $42
    LDI     r25,    $52
    LDI     r26,    $62
    LDI     r27,    $72
    LDI     r28,    $82
    LDI     r29,    $92
    LDI     r30,    $03
    LDI     r31,    $13


; Now, run a program with five sections
; Each section touches every register,
; and there are a variety of instructions used,
; with care sometimes to schedule data hazards
; such as reading a register immediately after writing.
run_program:
    NOP

section_1:
    ADD     r0,     r3
    SUB     r6,     r29
    SBC     r20,    r4
    AND     r21,    r20
    ORI     r20,    $2B
    MOV     r21,    r1
    PUSH    r13             ;1
    POP     r9              ;0
    MOV     r14,    r9
    PUSH    r14             ;1
    MUL     r4,     r14
    PUSH    r0              ;2
    PUSH    r6             ;3

    ADD     r0,     r1
    POP     r30
    POP     r11
    SWAP    r27
    SUB     r27,    r30
    LDI     r31,    $01
    ROR     r12

    ; Conduct a store to memory
    ANDI    r30,    $3F        ; Mask so Z < 0x013F
    LDI     r18,    $20
    ADD     r30,    r18        ; Offset Z so 0x0120 < Z < 0x015F
    ST      Z+,     r12
    ST      Z+,     r30
    LDD     r19,    Z+10
    STS     $015F,  r7
    ST      Z+,     r18
    LD      r11,    -Z          ; Store/read same addr
    ST      Z+,     r19
    LD      r6,    Z+
    CPSE    r3,     r7
    SUB     r27,    r13
    IN      r6,     $3F         ; Loads the status register
    SBRS    r6,     SREG_C
    ST      Z+,     r11
    ST      Z+,     r3
    SUB     r27,    r3
    SBRS    r27,    3
    LD      r2,     Z+
    MUL     r1,     r4
    LD      r0,     Z+
    ST      Z+,     r1      
    MOV     r19,    r10
    BST     r3,     1
    BLD     r17,    3
    ST      Z+,     r17
    LD      r11,    Z+         
    SBCI    r30,    $02         ; Z has been incremented
                                ; enough times that this
                                ; won't go below 0x0100
    ST      Z+,     r30         ; Bunch of dependencies on
                                ; previous result
    INC     r7
    DEC     r7
    INC     r3
    CP      r3,     r7          
    BRBS    SREG_C, section_1   ; Loop in section 1,
                                ; where r3 increments
                                ; and r7 is constant
    
    ASR     r17
    LSR     r15

section_2:

section_3:

section_4:

section_5:


dump_regs:
    ; Load registers into data memory
    LDI     r27,    $01
    LDI     r26,    $00
    

    ST      X+,     r0
    ST      X+,     r1
    ST      X+,     r2
    ST      X+,     r3
    ST      X+,     r4
    ST      X+,     r5
    ST      X+,     r6
    ST      X+,     r7
    ST      X+,     r8
    ST      X+,     r9
    ST      X+,     r10
    ST      X+,     r11
    ST      X+,     r12
    ST      X+,     r13
    ST      X+,     r14
    ST      X+,     r15
    ST      X+,     r16
    ST      X+,     r17
    ST      X+,     r18
    ST      X+,     r19
    ST      X+,     r20
    ST      X+,     r21
    ST      X+,     r22
    ST      X+,     r23
    ST      X+,     r24
    ST      X+,     r25
    ST      X+,     r26
    ST      X+,     r27
    ST      X+,     r28
    ST      X+,     r29
    ST      X+,     r30
    ST      X+,     r31

done:
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
