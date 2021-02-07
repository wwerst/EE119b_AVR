library ieee;
use ieee.std_logic_1164.all;
use work.AVR;
use work.IAU;

library osvvm;
--use osvvm.RandomPkg.all;
use osvvm.CoveragePkg.all;

entity mau_tb is

end mau_tb;

architecture testbench of mau_tb is
    component AvrIau
        port(
            clk: in std_logic;
            SrcSel     : in   integer  range IAU.SOURCES-1 downto 0;
            AddrOff    : in   std_logic_vector(IAU.OFFSETS * AVR.ADDRSIZE - 1 downto 0);
            OffsetSel  : in   integer  range IAU.OFFSETS+1 downto 0;
            Address    : out  AVR.addr_t
        );
    end component;

    signal done: boolean := FALSE;
    signal clk: std_logic;
    signal srcSel: integer;
    signal addrOff: std_logic_vector(IAU.OFFSETS * AVR.ADDRSIZE-1 downto 0);
    signal offsetSel: integer;
    signal address: AVR.addr_t;
    shared variable crossBin: CovPType;
begin
    process
        variable test1, test2: integer;
    begin
        crossBin.AddCross(GenBin(1,2), GenBin(3,4));

        while not crossBin.IsCovered loop
            (test1, test2) <= crossBin.GetRandPoint;

            crossBin.ICover((test1, test2));
        end loop;
        covBin.WriteBin;

        wait;
    end process;
end architecture testbench;
