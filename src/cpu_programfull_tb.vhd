---------------------------------------------------------------------
--
-- AVR CPU Full Program Testbench
-- 
-- This testbench runs a full program and then the data contents
-- are compared against expected data contents.
-- 
-- 
--
-- Entities included are
--      cpu_programfull_tb: the test bench itself
--
-- Revision History:
--     27 Mar 21  Will Werst        Finish implementing full cpu. See git
--                                  history for more granular details
--                                  and revision history.
---------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;

use work.AVR;

library osvvm;
use osvvm.CoveragePkg.all;
use osvvm.AlertLogPkg.all;

entity cpu_programfull_tb is
end cpu_programfull_tb;

architecture testbench of cpu_programfull_tb is
    component Avr_cpu
        port (
            ProgDB  :  in     std_logic_vector(15 downto 0);   -- program memory data bus
            Reset   :  in     std_logic;                       -- reset signal (active low)
            INT0    :  in     std_logic;                       -- interrupt signal (active low)
            INT1    :  in     std_logic;                       -- interrupt signal (active low)
            clock   :  in     std_logic;                       -- system clock
            ProgAB  :  out    std_logic_vector(15 downto 0);   -- program memory address bus
            DataAB  :  out    std_logic_vector(15 downto 0);   -- data memory address bus
            DataWr  :  out    std_logic;                       -- data memory write enable (active low)
            DataRd  :  out    std_logic;                       -- data memory read enable (active low)
            DataDB  :  inout  std_logic_vector(7 downto 0)     -- data memory data bus
        );
    end component;

    component PROG_MEMORY
        port (
            ProgAB  :  in   std_logic_vector(15 downto 0);  -- program address bus
            Reset   :  in   std_logic;                      -- system reset
            ProgDB  :  out  std_logic_vector(15 downto 0);  -- program data bus
            FinalAddrLoaded : out std_logic                 -- 1 when ProgAB points to last address
        );
    end component;

    component DATA_MEMORY
        port (
            RE      : in     std_logic;                 -- read enable (active low)
            WE      : in     std_logic;             -- write enable (active low)
            DataAB  : in     std_logic_vector(15 downto 0); -- memory address bus
            DataDB  : inout  std_logic_vector(7 downto 0);  -- memory data bus
            TestCompare : in std_logic               -- Signal to trigger
                                                     -- data print/compare at end of test   
        );
    end component;

    -- test bench clock and done
    constant CLK_PERIOD : time := 1 ms;
    signal clk          : std_logic := '0';
    signal done         : boolean := FALSE;
    constant MAX_ERROR_COUNT : integer := 2;
    signal TestCompare  : std_logic := '0';
    signal FinalAddrLoaded : std_logic;

    -- cpu signals
    signal ProgDB  :  std_logic_vector(15 downto 0);   -- program memory data bus
    signal Reset   :  std_logic;                       -- reset signal (active low)
    signal INT0    :  std_logic;                       -- interrupt signal (active low)
    signal INT1    :  std_logic;                       -- interrupt signal (active low)
    signal ProgAB  :  std_logic_vector(15 downto 0);   -- program memory address bus
    signal DataAB  :  std_logic_vector(15 downto 0);   -- data memory address bus
    signal DataWr  :  std_logic;                       -- data memory write enable (active low)
    signal DataRd  :  std_logic;                       -- data memory read enable (active low)
    signal DataDB  :  std_logic_vector(7 downto 0);    -- data memory data bus

    function nonstd_match(a, b: std_logic_vector) return boolean is
    begin
        if (b = (b'RANGE => 'X')) then
            return TRUE;
        else
            return std_match(a, b);
        end if;
    end nonstd_match;

    function to_hex(slv : std_logic_vector) return string is
        variable l : line;
    begin
        hwrite(l, slv);
        return l.all;
    end to_hex;

begin
    clock_p: process begin
        while not done loop
            clk <= '1';
            wait for CLK_PERIOD/2;
            clk <= '0';
            wait for CLK_PERIOD/2;
        end loop;
        wait;
    end process;

    UUT_CPU: avr_cpu port map (
        ProgDB => ProgDB,
        Reset  => Reset ,
        INT0   => INT0  ,
        INT1   => INT1  ,
        clock  => clk ,
        ProgAB => ProgAB,
        DataAB => DataAB,
        DataWr => DataWr,
        DataRd => DataRd,
        DataDB => DataDB
    );

    PROG_MEM: PROG_MEMORY port map (
        ProgAB => ProgAB,
        Reset => Reset,
        ProgDB => ProgDB,
        FinalAddrLoaded => FinalAddrLoaded
        );

    DATA_MEM: DATA_MEMORY port map (
        RE => DataRd,
        WE => DataWr,
        DataAB => DataAB,
        DataDB => DataDB,
        TestCompare => TestCompare
    );

    -- stimulus and check process
    test_p: process
    begin
        INT0 <= '0';
        INT1 <= '0';
        Reset <= '0';
        -- Wait for six cycles with reset,
        -- and bring out of reset after that.
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        Reset <= '1';

        -- Wait for program to reach final instruction
        while FinalAddrLoaded /= '1' loop
            wait until rising_edge(clk);
        end loop;
        report "Reached terminalProgAddr";
        done <= TRUE;
        TestCompare <= '1';
        wait;
    end process;

end architecture testbench;

