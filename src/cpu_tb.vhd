---------------------------------------------------------------------

-- AVR CPU Testbench


-- Entities included are
--      cpu_tb: the test bench itself

-- Revision History:

---------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;

use work.AVR;

entity avr_cpu_tb is
end avr_cpu_tb;

architecture testbench of avr_cpu_tb is
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

    -- test bench clock and done
    constant CLK_PERIOD : time := 1 ms;
    signal clk          : std_logic := '0';
    signal done         : boolean := FALSE;
    constant MAX_ERROR_COUNT : integer := 2;

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
            clk <= '0';
            wait for CLK_PERIOD/2;
            clk <= '1';
            wait for CLK_PERIOD/2;
        end loop;
        wait;
    end process;

    UUT: avr_cpu port map (
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

    -- stimulus and check process
    test_p: process
        file vectorsf: text is "glen_test_generator/alu_test_part1_tv.txt";
        variable linenum: integer := 0;
        variable asmCodeLine: line;
        variable error_cnt: integer := 0;
        variable l: line;
        variable fileok: boolean;

        variable vProgDB: std_logic_vector(15 downto 0);
        variable vDataDB: std_logic_vector(7 downto 0);

        variable veProgAB, veDataAB: std_logic_vector(15 downto 0);
        variable veDataWr, veDataRd: std_logic;
        variable veDataDB: std_logic_vector(7 downto 0);

        variable progAB_match, dataAB_match, dataRd_match, dataWr_match, dataDB_match: boolean;
    begin
        INT0 <= '0';
        INT1 <= '0';
        Reset <= '0';
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        Reset <= '1';

        -- initializtion
        while not endfile(vectorsf) loop
            linenum := linenum + 1;
            readline(vectorsf, l);
            if ((l'LENGTH > 0) and (l(1) /= '#'))  then
                hread(l, veProgAB);
                hread(l, vProgDB);
                hread(l, vDataDB);

                read(l, veDataRd);
                read(l, veDataWr);
                hread(l, veDataAB);
                hread(l, veDataDB);
                asmCodeLine := l;

                progDB <= vProgDB;
                dataDB <= vDataDB;

                wait until rising_edge(clk);

                -- On clock, cpu puts out:
                -- progAB
                -- dataAB
                -- DataWr
                -- DataRd
                -- DataDB (inout)

                progAB_match := nonstd_match(progAB, veProgAB);
                dataAB_match := nonstd_match(dataAB, veDataAB);
                dataRd_match := std_match(dataRd, veDataRd);
                dataWr_match := std_match(dataWr, veDataWr);
                dataDB_match := nonstd_match(dataDB, veDataDB);
                if not (progAB_match and dataAB_match and dataRd_match and dataWr_match and dataDB_match) then
                    error_cnt := error_cnt + 1;
                    report "A test error occurred at line " & to_string(linenum);
                    assert progAB_match report "progAB mismatch, expect " & to_hex(veProgAB) & " got " & to_hex(progAB) severity error;
                    assert dataAB_match report "dataAB mismatch, expect " & to_hex(veDataAB) & " got " & to_hex(dataAB) severity error;
                    assert dataRd_match report "Rd mismatch, expect " & to_string(veDataRd) & " got " & to_string(dataRd) severity error;
                    assert dataWr_match report "Wr mismatch, expect " & to_string(veDataWr) & " got " & to_string(dataWr) severity error;
                    if veDataWr = '0' then
                        assert dataDB_match report "dataDB mismatch on cpu write, expect " & to_hex(veDataDB) & " got " & to_hex(DataDB) severity error;
                    end if;
                end if;
                
                if error_cnt >= MAX_ERROR_COUNT then
                    report "Stopping testing early due to high error count";
                    exit;
                end if;

            end if;
        end loop;

        done <= TRUE;
        wait;
    end process;

end architecture testbench;

