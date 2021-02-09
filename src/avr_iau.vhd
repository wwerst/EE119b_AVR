library ieee;
use ieee.std_logic_1164.all;

package IAU is

    constant SOURCES: natural := 2;
    subtype source_t is natural range SOURCES-1 downto 0;
    constant SRC_ZERO: source_t := 0;
    constant SRC_PC: source_t := 1;

    constant OFFSETS: natural := 8;
    subtype offset_t is natural range OFFSETS-1 downto 0;

    constant OFF_ZERO: offset_t := 0;
    constant OFF_ONE: offset_t := 1;
    constant OFF_BRANCH: offset_t := 2;
    constant OFF_JUMP: offset_t := 3;
    constant OFF_PDB: offset_t := 4;
    constant OFF_Z: offset_t := 5;
    constant OFF_DDBLO: offset_t := 6;
    constant OFF_DDBHI: offset_t := 7;

end package;
--
-- The instructions requiring features of the IAU include
-- branch- add signed 7 bit offset to PC
-- JMP/CALL- load PC from program data bus
-- RJMP/RCALL- add signed 12 bit offset to PC from IR
-- IJMP/ICALL- load PC from Z register
-- RET/RETI- load high and low bits of PC from data data bus
-- in addition, be able to increment or hold the current PC

-- These are all implemented as adding offsets to the PC (including 0 and 1).
--

library ieee;
use ieee.std_logic_1164.all;

use work.AVR;
use work.IAU;
use work.MemUnitConstants;


entity  AvrIau  is
    port(
        clk: in std_logic;
        SrcSel     : in   IAU.source_t;
        --AddrOff    : in   std_logic_vector(IAU.OFFSETS * AVR.ADDRSIZE - 1 downto 0);
        branch: in std_logic_vector(6 downto 0);
        jump: in std_logic_vector(11 downto 0);
        PDB: in std_logic_vector(15 downto 0);
        DDB: in std_logic_vector(7 downto 0);
        Z: in std_logic_vector(15 downto 0);
        OffsetSel  : in   IAU.offset_t;
        Address    : out  AVR.addr_t
    );

end  AvrIau;


architecture  dataflow  of  AvrIau  is
    signal pc: AVR.addr_t;
    constant ZERO: AVR.addr_t := (others => '0');
    constant ONE: AVR.addr_t := (0 => '1', others => '0');
    signal branch_ext, jump_ext: AVR.addr_t;
    signal sources: std_logic_vector(IAU.SOURCES*AVR.ADDRSIZE - 1 downto 0);
    signal offsets: std_logic_vector(IAU.OFFSETS*AVR.ADDRSIZE - 1 downto 0);
begin
    branch_ext <= (branch'RANGE => branch, others => branch(branch'HIGH));
    jump_ext <= (jump'RANGE => jump, others => jump(jump'HIGH));
    sources <= (pc & ZERO);
    offsets <= (
        DDB & x"00" &
        x"00" & DDB &
        Z &
        PDB &
        jump_ext &
        branch_ext &
        ONE &
        ZERO
    );

    MU: entity work.MemUnit generic map (
        srcCnt => IAU.SOURCES, offsetCnt => IAU.OFFSETS
    ) port map (
        AddrSrc => sources,
        SrcSel => SrcSel,
        AddrOff => offsets,
        OffsetSel => OffsetSel,
        IncDecSel => MemUnitConstants.MemUnit_INC,
        IncDecBit => 0,
        PrePostSel => MemUnitConstants.MemUnit_PRE,
        Address => Address
    );

    process(clk) begin
        if rising_edge(clk) then
            pc <= Address;
        end if;
    end process;
end dataflow;
