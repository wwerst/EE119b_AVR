---------------------------------------------------------------------

-- AVR DAU

-- This is an implementation of a data access unit for the AVR.
-- Technically you can use it in something other than an AVR,
-- but the sizes and number of sources and offsets are specialized to the AVR.
-- It can output various offsets or increments added to various sources.
-- Supported data addressing modes include
--      direct from program data bus
--      X, Y, or Z with optional pre-decrement or post-increment
--      Y or Z with 6 bit offset
--      in addition, from stack with post-decrement or pre-increment

-- Packages included are:
--      DAU: constants for all sources and offsets, as well as a subtype
--          for DAU source and offset types

-- Entities included are:
--      AvrDau: the DAU itself

-- Revision History:
--      12 Feb 21   Eric Chen   set up DAU
--      15 Feb 21   Eric Chen   Use component declarations.
--                              Do some formatting.
--      22 Feb 21   Eric Chen   Merge register inputs.
--      27 Mar 21   Will Werst  Fix stack starting at 0000 instead of
--                              FFFF. See git history for more details.
---------------------------------------------------------------------


--
-- Package defining constants for all sources and offsets supported
-- by the DAU, as well as subtypes for sources and offsets
--

library ieee;
use ieee.std_logic_1164.all;

package DAU is

    -- sources constants
    constant SOURCES: natural := 3;
    subtype source_t is natural range SOURCES-1 downto 0;

    constant SRC_PDB: source_t := 0;
    constant SRC_STACK: source_t := 1;
    constant SRC_REG: source_t := 2;

    -- offsets constants
    constant OFFSETS: natural := 4;
    subtype offset_t is natural range OFFSETS-1 downto 0;

    constant OFF_ZERO: offset_t := 0;
    constant OFF_ONE: offset_t := 1;
    constant OFF_NEGONE: offset_t := 2;
    constant OFF_ARRAY: offset_t := 3;

end package;
--

--
-- AvrDau
--
-- The DAU itself, including a stack pointer.
-- All accesses are implemented by adding an offset to the source
-- We don't use the MAU's built in incrementer/decrementer,
-- as we don't ever need to increment/decrement with an offset.
-- Other combinations of sources and offsets, while possibly not unreasonable,
-- are not officially supported, so we declare they result in undefined behavior,
-- thus are under no obligation to test them...? :P
--
-- Inputs
--      clk         - to update stack pointer on
--      reset       - reset state, in particular stack pointer.
--      SrcSel      - source to use, see DAU package for options
--      PDB         - program data bus value, to use as source
--      reg         - register bus that can be used as a source
--      OffsetSel   - offset to use, see DAU package for options
--      array_off   - 6 bit unsigned offset for array addressing
--
-- Outputs
--      address     - address to access memory at
--                      has offset added to it in normal or pre-update accesses,
--                      or is equal to the source in the case of post-updates
--      update      - new value of registers or stack.
--                      used for incrementing/decrementing accesses.
--

library ieee;
use ieee.std_logic_1164.all;

use work.AVR;
use work.DAU;
use work.MemUnitConstants;


entity  AvrDau  is
    port(
        clk         : in  std_logic;
        reset       : in  std_logic;
        SrcSel      : in  DAU.source_t;
        PDB         : in  std_logic_vector(15 downto 0);
        reg         : in  std_logic_vector(15 downto 0);
        OffsetSel   : in  DAU.offset_t;
        array_off   : in  std_logic_vector(5 downto 0);
        Address     : out AVR.addr_t;
        Update      : out AVR.addr_t
    );

end  AvrDau;


architecture  dataflow  of  AvrDau  is
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

    -- internal source, the stack pointer
    signal stack    : AVR.addr_t;
    -- constant offsets
    constant ZERO   : AVR.addr_t := (others => '0');
    constant ONE    : AVR.addr_t := (0 => '1', others => '0');
    constant NEGONE : AVR.addr_t := (others => '1');

    signal array_ext                    : AVR.addr_t; -- zero extended array offset
    -- signals to generate the update address
    signal source_addr, computed_addr   : AVR.addr_t;

    -- concatenated sources and offsets
    signal sources: std_logic_vector(DAU.SOURCES*AVR.ADDRSIZE - 1 downto 0);
    signal offsets: std_logic_vector(DAU.OFFSETS*AVR.ADDRSIZE - 1 downto 0);

begin
    -- zero extend the unsigned offset
    array_ext   <= (array_ext'HIGH - array_off'HIGH - 1 downto 0 => '0') & array_off;
    -- sources and offsets
    sources     <= (reg & stack& pdb);
    offsets <= (
       array_ext &
       NEGONE &
       ONE &
       ZERO
    );
    -- store source address into a signal.
    -- Is also done by the MemUnit internally, so ideally this gets optimized out,
    -- but may be asking too much
    source_addr <= sources((srcSel+1)*AVR.ADDRSIZE-1 downto srcSel*AVR.ADDRSIZE);

    MU: MemUnit generic map (
        srcCnt => DAU.SOURCES, offsetCnt => DAU.OFFSETS
    ) port map (
        AddrSrc => sources,
        SrcSel      => SrcSel,
        AddrOff     => offsets,
        OffsetSel   => OffsetSel,
        IncDecSel   => MemUnitConstants.MemUnit_INC,
        IncDecBit   => 0,
        PrePostSel  => MemUnitConstants.MemUnit_PRE,
        Address     => computed_addr
    );

    -- only output the computed update address if doing an increment or decrement
    Update <= computed_addr when offsetSel = DAU.OFF_ONE or offsetSel = DAU.OFF_NEGONE
              else source_addr;

    -- we want to access memory with the computed address if:
    --  we are pre-incrementing the stack
    --  we are doing an array offset
    --  we are pre-decrementing a register
    Address <= 
        computed_addr when 
            (srcSel = DAU.SRC_STACK and offsetSel = DAU.OFF_ONE) or 
            (srcSel = DAU.SRC_REG and offsetSel = DAU.OFF_ARRAY) or 
            (srcSel = DAU.SRC_REG and offsetSel = DAU.OFF_NEGONE) 
        else source_addr;

    -- if doing stack access, update stack pointer on clock
    process (clk) begin
        if rising_edge(clk) then
            if reset = '0' then
                stack <= (others => '1');
            elsif srcSel = DAU.SRC_STACK then
                stack <= computed_addr;
            end if;
        end if;
    end process;
end dataflow;
