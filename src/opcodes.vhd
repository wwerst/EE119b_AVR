-----------------------------------------------------------------------------
--
--  AVR opcode package
--
--  This package defines opcode constants for the complete AVR instruction
--  set.  Not all variants of the AVR implement all instructions.
--
--  Revision History
--      4/27/98   Glen George		initial revision
--      4/14/00   Glen George		updated comments
--      4/22/02   Glen George		added new instructions
--      4/22/02   Glen George		updated comments
--      5/16/02   Glen George		fixed LPM instruction constant
--      24 Mar 21 Eric Chen      Implement mov and store instructions
--                               Implement all load instructions
-----------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

package opcodes is

   subtype  opcode_word  is  std_logic_vector(15 downto 0);

--  ALU opcodes

   constant OpADC    :  opcode_word := "000111----------";   -- ADC Rd, Rr
   constant OpADD    :  opcode_word := "000011----------";   -- ADD Rd, Rr
   constant OpADIW   :  opcode_word := "10010110--------";   -- ADIW Rdl, K
   constant OpAND    :  opcode_word := "001000----------";   -- AND Rd, Rr
   constant OpANDI   :  opcode_word := "0111------------";   -- ANDI Rd, K
   constant OpASR    :  opcode_word := "1001010-----0101";   -- ASR Rd
   constant OpBCLR   :  opcode_word := "100101001---1000";   -- BCLR s
   constant OpBLD    :  opcode_word := "1111100-----0---";   -- BLD Rd, b
   constant OpBSET   :  opcode_word := "100101000---1000";   -- BSET s
   constant OpBST    :  opcode_word := "1111101---------";   -- BST Rr, b
   constant OpCOM    :  opcode_word := "1001010-----0000";   -- COM Rd
   constant OpCP     :  opcode_word := "000101----------";   -- CP Rd, Rr
   constant OpCPC    :  opcode_word := "000001----------";   -- CPC Rd, Rr
   constant OpCPI    :  opcode_word := "0011------------";   -- CPI Rd, K
   constant OpDEC    :  opcode_word := "1001010-----1010";   -- DEC Rd
   constant OpEOR    :  opcode_word := "001001----------";   -- EOR Rd, Rr
   constant OpFMUL   :  opcode_word := "000000110---1---";   -- FMUL Rd, Rr
   constant OpFMULS  :  opcode_word := "000000111---0---";   -- FMULS Rd, Rr
   constant OpFMULSU :  opcode_word := "000000111---1---";   -- FMULSU Rd, Rr
   constant OpINC    :  opcode_word := "1001010-----0011";   -- INC Rd
   constant OpLSR    :  opcode_word := "1001010-----0110";   -- LSR Rd
   constant OpMUL    :  opcode_word := "100111----------";   -- MUL Rd, Rr
   constant OpMULS   :  opcode_word := "00000010--------";   -- MULS Rd, Rr
   constant OpMULSU  :  opcode_word := "000000110---0---";   -- MULSU Rd, Rr
   constant OpNEG    :  opcode_word := "1001010-----0001";   -- NEG Rd
   constant OpOR     :  opcode_word := "001010----------";   -- OR Rd, Rr
   constant OpORI    :  opcode_word := "0110------------";   -- ORI Rd, K
   constant OpROR    :  opcode_word := "1001010-----0111";   -- ROR Rd
   constant OpSBC    :  opcode_word := "000010----------";   -- SBC Rd, Rr
   constant OpSBCI   :  opcode_word := "0100------------";   -- SBCI Rd, K
   constant OpSBIW   :  opcode_word := "10010111--------";   -- SBIW Rdl, K
   constant OpSUB    :  opcode_word := "000110----------";   -- SUB Rd, Rr
   constant OpSUBI   :  opcode_word := "0101------------";   -- SUBI Rd, K
   constant OpSWAP   :  opcode_word := "1001010-----0010";   -- SWAP Rd

--  Load and Store Opcodes

   constant OpLD     :  opcode_word := "1001000---------";   -- Loads, including LDS, excluding LDI,LDD
   constant OpLDX    :  opcode_word := "1001000-----1100";   -- LD Rd, X
   constant OpLDXI   :  opcode_word := "1001000-----1101";   -- LD Rd, X+
   constant OpLDXD   :  opcode_word := "1001000-----1110";   -- LD Rd, -X
   constant OpLDY    :  opcode_word := "1000000-----1000";   -- LD Rd, Y
   constant OpLDYI   :  opcode_word := "1001000-----1001";   -- LD Rd, Y+
   constant OpLDYD   :  opcode_word := "1001000-----1010";   -- LD Rd, -Y
   constant OpLDZ    :  opcode_word := "1000000-----0000";   -- LD Rd, Z
   constant OpLDZI   :  opcode_word := "1001000-----0001";   -- LD Rd, Z+
   constant OpLDZD   :  opcode_word := "1001000-----0010";   -- LD Rd, -Z
   constant OpLDS    :  opcode_word := "1001000-----0000";   -- LDS Rd, m
   constant OpPOP    :  opcode_word := "1001000-----1111";   -- POP Rd

   constant OpST     :  opcode_word := "1001001---------";   -- stores
   constant OpSTX    :  opcode_word := "1001001-----1100";   -- ST X, Rr
   constant OpSTXI   :  opcode_word := "1001001-----1101";   -- ST X+, Rr
   constant OpSTXD   :  opcode_word := "1001001-----1110";   -- ST -X, Rr
   constant OpSTY    :  opcode_word := "1000001-----1000";   -- ST Y, Rr
   constant OpSTYI   :  opcode_word := "1001001-----1001";   -- ST Y+, Rr
   constant OpSTYD   :  opcode_word := "1001001-----1010";   -- ST -Y, Rr
   constant OpSTZ    :  opcode_word := "1000001-----0000";   -- ST Z, Rr
   constant OpSTZI   :  opcode_word := "1001001-----0001";   -- ST Z+, Rr
   constant OpSTZD   :  opcode_word := "1001001-----0010";   -- ST -Z, Rr
   constant OpSTS    :  opcode_word := "1001001-----0000";   -- STS m, Rr
   constant OpPUSH   :  opcode_word := "1001001-----1111";   -- PUSH Rd

   constant OpLDDY   :  opcode_word := "10-0--0-----1---";   -- LDD Rd, Y + q
   constant OpLDDZ   :  opcode_word := "10-0--0-----0---";   -- LDD Rd, Z + q
   constant OpSTDY   :  opcode_word := "10-0--1-----1---";   -- STD Y + q, Rr
   constant OpSTDZ   :  opcode_word := "10-0--1-----0---";   -- STD Z + q, Rr

   constant OpLDI    :  opcode_word := "1110------------";   -- LDI Rd, k
   constant OpMOV    :  opcode_word := "001011----------";   -- MOV Rd, Rr

   -- unsupported in our implementation
   --constant OpELPM   :  opcode_word := "1001010111011000";   -- ELPM
   --constant OpELPMZ  :  opcode_word := "1001000-----0110";   -- ELPM Rd, Z
   --constant OpELPMZI :  opcode_word := "1001000-----0111";   -- ELPM Rd, Z+
   --constant OpLPM    :  opcode_word := "1001010111001000";   -- LPM
   --constant OpSPM    :  opcode_word := "1001010111101000";   -- SPM
   --constant OpLPMZ   :  opcode_word := "1001000-----0100";   -- LPM Rd, Z
   --constant OpLPMZI  :  opcode_word := "1001000-----0101";   -- LPM Rd, Z+
   --constant OpMOVW   :  opcode_word := "00000001--------";   -- MOVW Rd, Rr


--  Unconditional Branches

   constant OpEICALL :  opcode_word := "1001010100011001";   -- EICALL
   constant OpEIJMP  :  opcode_word := "1001010000011001";   -- EIJMP
   constant OpJMP    :  opcode_word := "1001010-----110-";   -- JMP a
   constant OpIJMP   :  opcode_word := "10010100----1001";   -- IJMP
   constant OpCALL   :  opcode_word := "1001010-----111-";   -- CALL a
   constant OpICALL  :  opcode_word := "10010101----1001";   -- ICALL
   constant OpRET    :  opcode_word := "100101010--01000";   -- RET
   constant OpRETI   :  opcode_word := "100101010--11000";   -- RETI

   constant OpRJMP   :  opcode_word := "1100------------";   -- RJMP j
   constant OpRCALL  :  opcode_word := "1101------------";   -- RCALL j

--  Conditional Branches

   constant OpBRBC   :  opcode_word := "111101----------";   -- BRBC s, r
   constant OpBRBS   :  opcode_word := "111100----------";   -- BRBS s, r

--  Skip Instructions

   constant OpCPSE   :  opcode_word := "000100----------";   -- CPSE Rd, Rr
   constant OpSBIC   :  opcode_word := "10011001--------";   -- SBIC p, b
   constant OpSBIS   :  opcode_word := "10011011--------";   -- SBIS p, b
   constant OpSBRC   :  opcode_word := "1111110---------";   -- SBRC Rr, b
   constant OpSBRS   :  opcode_word := "1111111---------";   -- SBRS Rr, b

--  I/O Instructions

   constant OpCBI    :  opcode_word := "10011000--------";   -- CBI p, b
   constant OpIN     :  opcode_word := "10110-----------";   -- IN Rd, p
   constant OpOUT    :  opcode_word := "10111-----------";   -- OUT p, Rr
   constant OpSBI    :  opcode_word := "10011010--------";   -- SBI p, b

--  Miscellaneous Instructions

   constant OpBREAK  :  opcode_word := "1001010110011000";   -- BREAK
   constant OpNOP    :  opcode_word := "0000000000000000";   -- NOP
   constant OpSLP    :  opcode_word := "10010101100-1000";   -- SLEEP
   constant OpWDR    :  opcode_word := "10010101101-1000";   -- WDR 


end package;
