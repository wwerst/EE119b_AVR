---------------------------------------------------------------------

-- AVR CPU Testbench


-- Entities included are
--      cpu_tb: the test bench itself

-- Revision History:

---------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.AVR;

library osvvm;
use osvvm.AlertLogPkg.all;
use osvvm.RandomPkg.all;
use osvvm.CoveragePkg.all;

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

    -- test bench clcok and done
    constant CLK_PERIOD : time := 1 ms;
    signal clk          : std_logic := '0';
    signal done         : boolean := FALSE;

    -- cpu signals
    signal ProgDB  :  std_logic_vector(15 downto 0);   -- program memory data bus
    signal Reset   :  std_logic;                       -- reset signal (active low)
    signal INT0    :  std_logic;                       -- interrupt signal (active low)
    signal INT1    :  std_logic;                       -- interrupt signal (active low)
    signal clock   :  std_logic;                       -- system clock
    signal ProgAB  :  std_logic_vector(15 downto 0);   -- program memory address bus
    signal DataAB  :  std_logic_vector(15 downto 0);   -- data memory address bus
    signal DataWr  :  std_logic;                       -- data memory write enable (active low)
    signal DataRd  :  std_logic;                       -- data memory read enable (active low)
    signal DataDB  :  std_logic_vector(7 downto 0);    -- data memory data bus

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
        clock  => clock ,
        ProgAB => ProgAB,
        DataAB => DataAB,
        DataWr => DataWr,
        DataRd => DataRd,
        DataDB => DataDB
    );

    -- stimulus and check process
    test_p: process
        variable alertId: AlertLogIDType;
    begin
        alertId := GetAlertLogID("AVRDAU", ALERTLOG_BASE_ID);
        --SetAlertStopCount(ERROR, 20);

        -- initializtion
        wait until rising_edge(clk);

        done <= TRUE;
        wait;
    end process;

end architecture testbench;

