---------------------------------------------------------------------

-- AVR IAU

-- This is an implementation of an instruction access unit for the AVR.
-- Technically you can use it in something other than an AVR,
-- but the sizes and number of sources and offsets are specialized to the AVR.
-- It can output various offsets or increments to be added
-- to the program counter, as well as loading various sources
-- Instructions requiring features of the IAU include:
--      branch      - add signed 7 bit offset to PC
--      JMP/CALL    - load PC from program data bus
--      RJMP/RCALL  - add signed 12 bit offset to PC from IR
--      IJMP/ICALL  - load PC from Z register
--      RET/RETI    - load high and low bits of PC from data data bus
--      in addition, be able to increment or hold the current PC

-- Packages included are:
--      IAU: constants for all sources and offsets, as well as a subtype
--          for IAU source and offset types

-- Entities included are:
--      AvrIau: the IAU itself

-- Revision History:
--      06 Feb 21   Eric Chen   Initial setup
--      08 Feb 21   Eric Chen   Passing IAU tests
--      15 Feb 21   Eric Chen   Use component declarations.
--                              Do some formatting.
--                              Write revision history. <flux capacitor joke 🤔>

---------------------------------------------------------------------


--
-- Package defining constants for all sources and offsets supported
-- by the IAU, as well as subtypes for sources and offsets
--

library ieee;
use ieee.std_logic_1164.all;

package IAU is

    -- Sources constants; can probably be freely changed
    constant SOURCES: natural := 2;
    subtype source_t is natural range SOURCES-1 downto 0;

    constant SRC_ZERO: source_t := 0;
    constant SRC_PC: source_t := 1;

    -- Offsets constants; can probably be freely changed
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
-- AvrIAU
--
-- The definition of the IAU itself, with a program counter.
-- All features are implemented by adding an offset to a source
-- and storing the result back into the program counter.
-- (we don't use the built in incrementer/decremeter)
--
-- Inputs:
--      clk     - clock to update PC on
--      SrcSel  - source ID, from IAU package
--      branch  - 7 bit signed value
--      jump    - 12 bit signed value
--      PDB     - 16 bit unsigned value
--      DDB     - 8 bit unsigned value
--      Z       - 16 bit unsigned value
--      OffsetSel- offset id, from IAU package
--
-- Outputs:
--      Address - the current program counter
--

library ieee;
use ieee.std_logic_1164.all;

use work.AVR;
use work.IAU;
use work.MemUnitConstants;


entity  AvrIau  is
    port(
        clk         : in  std_logic;
        reset       : in  std_logic;
        SrcSel      : in  IAU.source_t;
        branch      : in  std_logic_vector(6 downto 0);
        jump        : in  std_logic_vector(11 downto 0);
        PDB         : in  AVR.addr_t;
        DDB         : in  std_logic_vector(7 downto 0);
        Z           : in  AVR.addr_t;
        OffsetSel   : in  IAU.offset_t;
        Address     : out AVR.addr_t
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

    -- constant offset values
    constant ZERO   : AVR.addr_t := (others => '0');
    constant ONE    : AVR.addr_t := (0 => '1', others => '0');

    signal pc       : AVR.addr_t;   -- program counter
    signal branch_ext: AVR.addr_t;  -- sign extended branch offset
    signal jump_ext : AVR.addr_t;   -- sign extended jump offset
    -- concatenated vectors of all sources and offsets
    signal sources  : std_logic_vector(IAU.SOURCES*AVR.ADDRSIZE - 1 downto 0);
    signal offsets  : std_logic_vector(IAU.OFFSETS*AVR.ADDRSIZE - 1 downto 0);

    signal next_address: AVR.addr_t;
begin
    -- sign extend branch and jump offsets
    branch_ext  <= (branch'RANGE => branch, others => branch(branch'HIGH));
    jump_ext    <= (jump'RANGE => jump, others => jump(jump'HIGH));
    -- concatenate sources and offsets
    sources     <= (pc & ZERO);   -- pc for relative movements, ZERO for absolute movements
    offsets     <= (    -- One of these offsets is selected by the Mau
        DDB & x"00" &   -- Data Databus  (used for RET instruction)
        x"00" & DDB &   -- Data Databus  (used for RET instruction)
        Z           &   -- Double width register for indirect jumps
        PDB         &   -- Program Data Bus (for an absolute jump, simultan)
        jump_ext    &   -- Select for jump offset
        branch_ext  &   -- Select for branch offset
        ONE         &
        ZERO
    );

    MU: MemUnit generic map (
        srcCnt  => IAU.SOURCES, offsetCnt => IAU.OFFSETS
    ) port map (
        AddrSrc     => sources,
        SrcSel      => SrcSel,
        AddrOff     => offsets,
        OffsetSel   => OffsetSel,
        IncDecSel   => MemUnitConstants.MemUnit_INC,
        IncDecBit   => 0,
        PrePostSel  => MemUnitConstants.MemUnit_PRE,
        Address     => next_address
    );
    Address <= PC;

    -- every clock, update PC
    process(clk) begin
        if rising_edge(clk) then
            if reset = '0' then
                -- Reset to address 0
                pc <= (others => '0');
            else
                pc <= next_address;
            end if;
        end if;
    end process;
end dataflow;
