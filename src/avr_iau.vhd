library ieee;
use ieee.std_logic_1164.all;

package IAU is

    constant SOURCES: natural := 2;
    constant SRC_ZERO: natural := 0;
    constant SRC_PC: natural := 1;

    constant OFFSETS: natural := 5;
    constant OFF_ZERO: natural := 0;
    constant OFF_ONE: natural := 1;
    constant OFF_IR: natural := 2;
    constant OFF_PROGDB: natural := 3;
    constant OFF_Z: natural := 4;
    constant OFF_DDBLO: natural := 5;
    constant OFF_DDBHI: natural := 6;

end package;
--
--

library ieee;
use ieee.std_logic_1164.all;

use work.AVR;
use work.IAU;


entity  AvrIau  is
    port(
        clk: in std_logic;
        SrcSel     : in   integer  range IAU.SOURCES-1 downto 0;
        AddrOff    : in   std_logic_vector(IAU.OFFSETS * AVR.ADDRSIZE - 1 downto 0);
        OffsetSel  : in   integer  range IAU.OFFSETS+1 downto 0;
        Address    : out  AVR.addr_t
    );

end  AvrIau;


architecture  dataflow  of  AvrIau  is
    component MemUnit
        generic (
            srcCnt       : integer;
            offsetCnt    : integer;
            maxIncDecBit : integer := 0; -- default is only inc/dec bit 0
            wordsize     : integer := 16 -- default address width is 16 bits
        );

        port(
            AddrSrc    : in   std_logic_vector(srccnt * wordsize - 1 downto 0);
            SrcSel     : in   integer  range srccnt - 1 downto 0;
            AddrOff    : in   std_logic_vector(offsetcnt * wordsize - 1 downto 0);
            OffsetSel  : in   integer  range offsetcnt - 1 downto 0;
            IncDecSel  : in   std_logic;
            IncDecBit  : in   integer  range maxIncDecBit downto 0;
            PrePostSel : in   std_logic;
            Address    : out  std_logic_vector(wordsize - 1 downto 0);
            AddrSrcOut : out  std_logic_vector(wordsize - 1 downto 0)
        );
    end component;

    signal pc: AVR.addr_t;
    constant ZERO: AVR.addr_t := (others => '0');
    constant ONE: AVR.addr_t := (0 => '1', others => '0');
    signal sources: std_logic_vector(IAU.SOURCES*AVR.ADDRSIZE - 1 downto 0);
    signal offsets: std_logic_vector((IAU.OFFSETS+2)*AVR.ADDRSIZE - 1 downto 0);
begin
    sources <= (ZERO & pc);
    offsets <= (ZERO & ONE & AddrOff);

    MU: MemUnit generic map (
        srcCnt => 2, offsetCnt => 6
    ) port map (
        AddrSrc => sources,
        SrcSel => SrcSel,
        AddrOff => offsets,
        OffsetSel => OffsetSel,
        IncDecSel => '0',
        IncDecBit => 0,
        PrePostSel => '0',
        Address => Address
    );

    process(clk) begin
        if rising_edge(clk) then
            pc <= Address;
        end if;
    end process;
end dataflow;
