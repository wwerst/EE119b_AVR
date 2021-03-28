----------------------------------------------------------------------------
--
--  Atmel AVR Program Memory
--
--  This component describes a program for the AVR CPU.  It creates the 
--  program in a small (334 x 16) ROM.
--
--  Revision History:
--     11 May 00  Glen George       Initial revision (from 5/9/00 version of 
--                                  progmem.vhd).
--     28 Jul 00  Glen George       Added instructions and made memory return
--                                  NOP when not mapped.
--      7 Jun 02  Glen George       Updated commenting.
--     16 May 04  Glen George       Added more instructions for testing and
--                                  updated commenting.
--     21 Jan 08  Glen George       Updated commenting.
--     17 Jan 18  Glen George       Updated commenting.
--     28 Mar 21  Will Werst        Add signal for when final address reached.
--
----------------------------------------------------------------------------


--
--  PROG_MEMORY
--
--  This is the program memory component.  It is just a 334 word ROM with no
--  timing information.  It is meant to be connected to the AVR CPU.  The ROM
--  is always enabled and may be changed when Reset it active.
--
--  Inputs:
--    ProgAB - address bus (16 bits)
--    Reset  - system reset (active low)
--
--  Outputs:
--    ProgDB - program memory data bus (16 bits)
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;


entity  PROG_MEMORY  is

    port (
        ProgAB  :  in   std_logic_vector(15 downto 0);  -- program address bus
        Reset   :  in   std_logic;                      -- system reset
        ProgDB  :  out  std_logic_vector(15 downto 0);  -- program data bus
        FinalAddrLoaded : out std_logic                 -- 1 when ProgAB points to last address
    );

end  PROG_MEMORY;


architecture  ROM  of  PROG_MEMORY  is

    -- define the type for the ROM (an array)
    type  ROMtype  is array(0 to 154 - 1) of std_logic_vector(15 downto 0);

    -- define the actual ROM (initialized to a simple program)
    -- This is from AVR studio binary output. Run the fullprogram.asm program in
    -- debug mode and copy the memory view for program memory. Could
    -- also use Glen's lst2test.c program
    signal  ROMbits  :  ROMtype  :=  ( 
        X"e0b1", X"e0a0", X"e040", X"934d",     -- prog 0x0000    
        X"38a0", X"f7e9", X"0000", X"e000",     -- prog 0x0008    
        X"e110", X"e220", X"e330", X"e440",     -- prog 0x0010    
        X"e550", X"e660", X"e770", X"e880",     -- prog 0x0018    
        X"e990", X"e0a1", X"e1b1", X"e2c1",     -- prog 0x0020    
        X"e3d1", X"e4e1", X"e5f1", X"2e00",     -- prog 0x0028    
        X"2e11", X"2e22", X"2e33", X"2e44",     -- prog 0x0030    
        X"2e55", X"2e66", X"2e77", X"2e88",     -- prog 0x0038    
        X"2e99", X"2eaa", X"2ebb", X"2ecc",     -- prog 0x0040    
        X"2edd", X"2eee", X"2eff", X"e601",     -- prog 0x0048    
        X"e711", X"e821", X"e931", X"e042",     -- prog 0x0050    
        X"e152", X"e262", X"e372", X"e482",     -- prog 0x0058    
        X"e592", X"e6a2", X"e7b2", X"e8c2",     -- prog 0x0060    
        X"e9d2", X"e0e3", X"e1f3", X"0000",     -- prog 0x0068    
        X"0c03", X"1a6d", X"0944", X"2354",     -- prog 0x0070    
        X"624b", X"2d51", X"92df", X"909f",     -- prog 0x0078    
        X"2ce9", X"92ef", X"9c4e", X"920f",     -- prog 0x0080    
        X"926f", X"0c01", X"91ef", X"90bf",     -- prog 0x0088    
        X"95b2", X"1bbe", X"e0f1", X"94c7",     -- prog 0x0090    
        X"73ef", X"e220", X"0fe2", X"92c1",     -- prog 0x0098    
        X"93e1", X"8532", X"9270", X"015f",     -- prog 0x00A0    
        X"9321", X"90b2", X"9331", X"9061",     -- prog 0x00A8    
        X"1037", X"19bd", X"b66f", X"fe60",     -- prog 0x00B0    
        X"92b1", X"9231", X"19b3", X"ffb3",     -- prog 0x00B8    
        X"9021", X"9c14", X"9001", X"9211",     -- prog 0x00C0    
        X"2d3a", X"fa31", X"f913", X"9311",     -- prog 0x00C8    
        X"90b1", X"40e2", X"93e1", X"9473",     -- prog 0x00D0    
        X"947a", X"9433", X"1437", X"f240",     -- prog 0x00D8    
        X"9515", X"94f6", X"e0b1", X"e0a0",     -- prog 0x00E0    
        X"920d", X"921d", X"922d", X"923d",     -- prog 0x00E8    
        X"924d", X"925d", X"926d", X"927d",     -- prog 0x00F0    
        X"928d", X"929d", X"92ad", X"92bd",     -- prog 0x00F8    
        X"92cd", X"92dd", X"92ed", X"92fd",     -- prog 0x0100    
        X"930d", X"931d", X"932d", X"933d",     -- prog 0x0108    
        X"934d", X"935d", X"936d", X"937d",     -- prog 0x0110    
        X"938d", X"939d", X"93ad", X"93bd",     -- prog 0x0118    
        X"93cd", X"93dd", X"93ed", X"93fd",     -- prog 0x0120    
        X"0000", X"0000", X"0000", X"0000",     -- prog 0x0128    
        X"0000", X"0000"                  );    -- prog 0x0130  



begin


    -- always read the value at the current address
    ProgDB <= ROMbits(CONV_INTEGER(ProgAB)) when (CONV_INTEGER(ProgAB) <= ROMbits'high)  else
              X"XXXX";    -- Memory out of bounds

    FinalAddrLoaded <= '1' when CONV_INTEGER(ProgAB) = ROMbits'high else '0';

    -- process to handle Reset
    process(Reset)
    begin

        -- check if Reset is low now
        if  (Reset = '0')  then
            -- reset is active - initialize the ROM (nothing for now)
        end if;

    end process;

end  ROM;
