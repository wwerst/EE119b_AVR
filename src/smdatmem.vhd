----------------------------------------------------------------------------
--
--  Atmel AVR Data Memory (Small Version)
--
--  This component describes the data memory for the AVR CPU.  It creates a
--  64K x 8 RAM.  The RAM is actually only 640 bytes (0100-017F and FE00-FFFF)
--  and any reads outside that address range return 'X' and writes outside
--  the range generate error messages.
--
--  Revision History:
--     11 May 98  Glen George       Initial revision.
--      9 May 00  Glen George       Changed from using CS and WE to using RE
--                                  and WE.
--     27 Jul 00  Glen George       Changed to pieces of data RAM - for now
--                                  a chunk (128 bytes) at 0000 and a chunk
--                                  (512 bytes) at FE00.
--      7 May 02  Glen George       Added checks for addresses out of range
--                                  and updated the comments.
--     23 Jan 06  Glen George       Updated comments.
--     17 Jan 18  Glen George       Write current data value instead of
--                                  previous value when address bus changes
--                                  while WE is active.
--
----------------------------------------------------------------------------


--
--  DATA_MEMORY
--
--  This is the data memory component.  It is just a 64 Kbyte RAM with no
--  timing information.  It is meant to be connected to the AVR CPU.
--
--  Inputs:
--    RE     - read enable (active low)
--    WE     - write enable (active low)
--    DataAB - address bus (16 bits)
--
--  Inputs/Outputs:
--    DataDB - data memory data bus (8 bits)
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;


entity  DATA_MEMORY  is

    port (
        RE      : in     std_logic;             	-- read enable (active low)
        WE      : in     std_logic;		            -- write enable (active low)
        DataAB  : in     std_logic_vector(15 downto 0); -- memory address bus
        DataDB  : inout  std_logic_vector(7 downto 0);  -- memory data bus
        TestCompare : in std_logic
    );

end  DATA_MEMORY;


architecture  RAM  of  DATA_MEMORY  is

    -- define the type for the RAM (128 byte RAM)
    type  RAMtype  is array (0 to 127) of std_logic_vector(7 downto 0);

    -- now define the RAMs (initialized to X)
    signal  RAMbits0100  :  RAMtype  := (others => (others => 'X'));
    signal  RAMbitsFE00  :  RAMtype  := (others => (others => 'X'));
    signal  RAMbitsFE80  :  RAMtype  := (others => (others => 'X'));
    signal  RAMbitsFF00  :  RAMtype  := (others => (others => 'X'));
    signal  RAMbitsFF80  :  RAMtype  := (others => (others => 'X'));

    signal  ExpectedRAMbits0100 : RAMtype := (
        X"2c", X"03", X"6b", X"70",  
        X"40", X"50", X"40", X"70",  
        X"80", X"31", X"01", X"2f",  
        X"7b", X"31", X"31", X"28",  
        X"61", X"3c", X"20", X"01",  
        X"2b", X"03", X"22", X"32",  
        X"42", X"52", X"1a", X"01",  
        X"82", X"92", X"2f", X"01",  
        X"00", X"00", X"ef", X"23",  
        X"2e", X"2f", X"7b", X"27",  
        X"20", X"03", X"20", X"6f",  
        X"2c", X"03", X"2e", X"2f",  
        X"00", X"00", X"20", X"30",  
        X"00", X"03", X"36", X"00",  
        X"00", X"00", X"00", X"00",  
        X"00", X"00", X"00", X"00",  
        X"00", X"00", X"e7", X"43",  
        X"9f", X"4f", X"20", X"67",  
        X"55", X"03", X"4a", X"03",  
        X"4c", X"03", X"9f", X"4f",  
        X"00", X"51", X"20", X"65",  
        X"03", X"03", X"03", X"57",  
        X"03", X"59", X"00", X"00",  
        X"00", X"00", X"00", X"70",  
        X"00", X"00", X"00", X"00",  
        X"00", X"00", X"00", X"00",  
        X"00", X"00", X"00", X"00",  
        X"00", X"00", X"00", X"00",  
        X"00", X"00", X"00", X"00",  
        X"00", X"00", X"00", X"00",  
        X"00", X"00", X"00", X"00",  
        X"00", X"00", X"00", X"00");

    function to_hex(slv : std_logic_vector) return string is
        variable l : line;
    begin
        hwrite(l, slv);
        return l.all;
    end to_hex;

begin

    process
    begin

        -- wait for an input to change
	wait on  RE, WE, DataAB;

        -- first check if reading
	if  (RE = '0')  then
	    -- reading, put the data out (check address)
	    if  (CONV_INTEGER(DataAB) >= 16#0100# and CONV_INTEGER(DataAB) < 16#0180#)  then
	        DataDB <= RAMbits0100(CONV_INTEGER(DataAB) - 16#0100#);
	    elsif  (CONV_INTEGER(DataAB) >= 16#FF80#)  then
	        DataDB <= RAMbitsFF80(CONV_INTEGER(DataAB - 16#FF80#));
	    elsif  (CONV_INTEGER(DataAB) >= 16#FF00#)  then
	        DataDB <= RAMbitsFF00(CONV_INTEGER(DataAB - 16#FF00#));
	    elsif  (CONV_INTEGER(DataAB) >= 16#FE80#)  then
	        DataDB <= RAMbitsFE80(CONV_INTEGER(DataAB - 16#FE80#));
	    elsif  (CONV_INTEGER(DataAB) >= 16#FE00#)  then
	        DataDB <= RAMbitsFE00(CONV_INTEGER(DataAB - 16#FE00#));
	    else
                -- outside of any allowable address range - set output to X
	        DataDB <= "XXXXXXXX";
            end if;
	else
	    -- not reading, send data bus to hi-Z
	    DataDB <= "ZZZZZZZZ";
	end if;

	-- now check if writing
	if  (WE'event and (WE = '1'))  then
	    -- rising edge of write - write the data (check which address range)
	    if  (CONV_INTEGER(DataAB) >= 16#0100# and CONV_INTEGER(DataAB) < 16#0180#)  then
            RAMbits0100(CONV_INTEGER(DataAB) - 16#0100#) <= DataDB;
	    elsif  (CONV_INTEGER(DataAB) >= 16#FF80#)  then
 	        RAMbitsFF80(CONV_INTEGER(DataAB - 16#FF80#)) <= DataDB;
	    elsif  (CONV_INTEGER(DataAB) >= 16#FF00#)  then
 	        RAMbitsFF00(CONV_INTEGER(DataAB - 16#FF00#)) <= DataDB;
	    elsif  (CONV_INTEGER(DataAB) >= 16#FE80#)  then
 	        RAMbitsFE80(CONV_INTEGER(DataAB - 16#FE80#)) <= DataDB;
	    elsif  (CONV_INTEGER(DataAB) >= 16#FE00#)  then
 	        RAMbitsFE00(CONV_INTEGER(DataAB - 16#FE00#)) <= DataDB;
            else
                -- outside of any allowable address range - generate an error
                assert (false or now = 0 ns)
                    report  "Attempt to write to a non-existant address " & to_hex(DataAB)
                    severity  FAILURE;
            end if;
	    -- wait for the update to happen
	    wait for 0 ns;
	end if;

	-- finally check if WE low with the address changing
	if  (DataAB'event and (WE = '0'))  then
            -- output error message
	    REPORT "Glitch on Data Address bus"
	    SEVERITY  ERROR;
	    -- address changed with WE low - trash the old location
	    if  (CONV_INTEGER(DataAB) >= 16#0100# and CONV_INTEGER(DataAB) < 16#0180#)  then
            DataDB <= RAMbits0100(CONV_INTEGER(DataAB));
	    elsif  (CONV_INTEGER(DataAB'delayed) >= 16#FF80#)  then
	        RAMbitsFF80(CONV_INTEGER(DataAB'delayed - 16#FF80#)) <= DataDB;
	    elsif  (CONV_INTEGER(DataAB'delayed) >= 16#FF00#)  then
	        RAMbitsFF00(CONV_INTEGER(DataAB'delayed - 16#FF00#)) <= DataDB;
	    elsif  (CONV_INTEGER(DataAB'delayed) >= 16#FE80#)  then
	        RAMbitsFE80(CONV_INTEGER(DataAB'delayed - 16#FE80#)) <= DataDB;
	    elsif  (CONV_INTEGER(DataAB'delayed) >= 16#FE00#)  then
	        RAMbitsFE00(CONV_INTEGER(DataAB'delayed - 16#FE00#)) <= DataDB;
            end if;
	end if;

    end process;

    process
        variable slv_memory_index: std_logic_vector(15 downto 0);
        variable test_failure: boolean;
    begin
        wait until rising_edge(TestCompare);
        test_failure := FALSE;
        for memory_index in 0 to 127 loop
            wait for 1 ms;
            slv_memory_index := std_logic_vector(to_unsigned(memory_index + 256, 16));
            if RAMbits0100(memory_index) /= ExpectedRAMbits0100(memory_index) then
                test_failure := TRUE;
                assert FALSE
                    report "Data mismatch at " & to_hex(slv_memory_index)
                    severity ERROR;
            end if;
        end loop;

        if test_failure then
            -- Test failure, dump data memory for troubleshooting
            for memory_index in 0 to 31 loop
                wait for 1 ms;
                slv_memory_index := std_logic_vector(to_unsigned(memory_index*4 + 256, 16));
                report ("data 0x" & to_hex(slv_memory_index) & " " & 
                        to_hex(RAMbits0100(memory_index*4 + 0))  & " " &
                        to_hex(RAMbits0100(memory_index*4 + 1))  & " " &
                        to_hex(RAMbits0100(memory_index*4 + 2))  & " " &
                        to_hex(RAMbits0100(memory_index*4 + 3)));
            end loop;
        else
            report "Checked data memory, all data matches. Test Successful.";
        end if;
        
    end process;


end  RAM;
