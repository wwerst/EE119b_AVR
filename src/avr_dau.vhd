library ieee;
use ieee.std_logic_1164.all;

package DAU is

    constant SOURCES: natural := 5;
    subtype source_t is natural range SOURCES-1 downto 0;
    constant SRC_PDB: source_t := 0;
    constant SRC_STACK: source_t := 1;
    constant SRC_X: source_t := 2;
    constant SRC_Y: source_t := 3;
    constant SRC_Z: source_t := 4;

    constant OFFSETS: natural := 4;
    subtype offset_t is natural range OFFSETS-1 downto 0;
    constant OFF_ZERO: offset_t := 0;
    constant OFF_ONE: offset_t := 1;
    constant OFF_NEGONE: offset_t := 2;
    constant OFF_ARRAY: offset_t := 3;

end package;
--
-- supported data addressing modes include
-- direct from program data bus
-- X, Y, or Z with optional pre-decrement or post-increment
-- Y or Z with 6 bit offset
-- in addition, from stack with post-decrement or pre-increment

-- These are all implemented as adding offsets.
-- We don't use the MAU's built in incrementer/decrementer,
-- as we don't ever need to increment/decrement with an offset.
-- Other combinations of sources and offsets, while possibly not unreasonable,
-- are still officially not supported,
-- and result in undefined behavior.
--

library ieee;
use ieee.std_logic_1164.all;

use work.AVR;
use work.DAU;
use work.MemUnitConstants;


entity  AvrDau  is
    port(
        clk: in std_logic;
        SrcSel     : in   DAU.source_t;
        PDB: in std_logic_vector(15 downto 0);
        X, Y, Z: in std_logic_vector(15 downto 0);
        OffsetSel  : in   DAU.offset_t;
        array_off: in std_logic_vector(5 downto 0);
        Address    : out  AVR.addr_t;
        Update    : out  AVR.addr_t
    );

end  AvrDau;


architecture  dataflow  of  AvrDau  is
    signal stack: AVR.addr_t := (others => '0');
    constant ZERO: AVR.addr_t := (others => '0');
    constant ONE: AVR.addr_t := (0 => '1', others => '0');
    constant NEGONE: AVR.addr_t := (others => '1');

    signal array_ext: AVR.addr_t;
    signal source_addr, computed_addr: AVR.addr_t;
    signal sources: std_logic_vector(DAU.SOURCES*AVR.ADDRSIZE - 1 downto 0);
    signal offsets: std_logic_vector(DAU.OFFSETS*AVR.ADDRSIZE - 1 downto 0);
begin
    array_ext <= (array_off'RANGE => array_off, others => '0');
    sources <= (Z & Y & Z & stack& pdb);
    source_addr <= sources((srcSel+1)*AVR.ADDRSIZE-1 downto srcSel*AVR.ADDRSIZE);
    offsets <= (
       array_ext &
       NEGONE &
       ONE &
       ZERO
    );

    MU: entity work.MemUnit generic map (
        srcCnt => DAU.SOURCES, offsetCnt => DAU.OFFSETS
    ) port map (
        AddrSrc => sources,
        SrcSel => SrcSel,
        AddrOff => offsets,
        OffsetSel => OffsetSel,
        IncDecSel => MemUnitConstants.MemUnit_INC,
        IncDecBit => 0,
        PrePostSel => MemUnitConstants.MemUnit_PRE,
        Address => computed_addr
    );

    Update <= computed_addr when offsetSel = DAU.OFF_ONE or offsetSel = DAU.OFF_NEGONE
              else source_addr;

    Address <= computed_addr when (srcSel = DAU.SRC_STACK and offsetSel = DAU.OFF_ONE) or (srcSel /= DAU.SRC_Stack and offsetSel = DAU.OFF_NEGONE) else  source_addr;

    process(clk) begin
        if rising_edge(clk) and srcSel = DAU.SRC_STACK then
            stack <= computed_addr;
        end if;
    end process;
end dataflow;
