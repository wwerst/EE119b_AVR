---------------------------------------------------------------------

-- AVRReg

-- This is an implementation of a register unit for the AVR
-- It uses a general register unit, and provides both single and double
-- word register access, according to the AVR spec. 

-- Entities included are:
--      AvrReg: Contains implementation of register unit

-- Revision history:
--      6  Feb 21   Will Werst  Initial implementation
--      13 Feb 21   Will Werst  Fix issues found in testing
--      20 Feb 21   Will Werst  Add additional documentation
--      
---------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

use work.AVR;

package AVR_REG_CONST is
    -- Contains any constants used in
    constant REG_COUNT : natural := 32;
end package AVR_REG_CONST;


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.AVR;
use work.AVR_REG_CONST;



--
--  AvrReg
--
--  This is an implementation of a register unit for the AVR. It implements
--  single register access for r0-r31, and double width register access for the
--  double width groupings of r24-r31 (e.g. r25:r24, r27:r26, etc.)
--
--  Inputs:
--    clk           - the system clock
--    
--    EnableInS   - Latch single register input on next clock
--    DataInS     - Data for single register input
--    SelInS      - Single register input address to load to
--    
--    EnableInD   - Latch double register input on next clock
--    DataInD     - Data for double register input
--    SelInD      - Select the address to load double register to. Range from 0 to 3.
--                  Note that single register writes will overwrite double register writes
--                  if both target the same address.
--  Outputs:
--    SelOutA     - Single reg A address select
--    DataOutA    - Word that SelOutA points to.
--    
--    SelOutB     - Single reg B address select
--    DataOutB    - Word that SelOutB points to.
--    
--    SelOutD     - Double reg D address select
--    DataOutD    - Double word that SelOutD points to.
--    

entity AvrReg is
    port(
        clk         : in std_logic;
        
        -- Single register input
        EnableInS   : in std_logic;
        DataInS     : in AVR.reg_s_data_t;
        SelInS      : in AVR.reg_s_sel_t;

        -- Double register input
        EnableInD   : in std_logic;
        DataInD     : in AVR.reg_d_data_t;
        SelInD      : in AVR.reg_d_sel_t;

        -- Single register A output
        SelOutA     : in AVR.reg_s_sel_t;
        DataOutA    : out AVR.reg_s_data_t;

        -- Single register B output
        SelOutB     : in AVR.reg_s_sel_t;
        DataOutB    : out AVR.reg_s_data_t;

        -- Double register output
        SelOutD     : in AVR.reg_d_sel_t;
        DataOutD    : out AVR.reg_d_data_t
    );
end AvrReg;


architecture dataflow of AvrReg is
    constant wordsize : integer := AVR.WORDSIZE;
    constant regcnt   : integer := AVR_REG_CONST.REG_COUNT;
    component RegArray
        generic (
            regcnt   : integer := regcnt;
            wordsize : integer := wordsize
        );

        port(
            RegIn     : in   std_logic_vector(wordsize - 1 downto 0);
            RegInSel  : in   integer  range regcnt - 1 downto 0;
            RegStore  : in   std_logic;
            RegASel   : in   integer  range regcnt - 1 downto 0;
            RegBSel   : in   integer  range regcnt - 1 downto 0;
            RegDIn    : in   std_logic_vector(2 * wordsize - 1 downto 0);
            RegDInSel : in   integer  range regcnt/2 - 1 downto 0;
            RegDStore : in   std_logic;
            RegDSel   : in   integer  range regcnt/2 - 1 downto 0;
            clock     : in   std_logic;
            RegA      : out  std_logic_vector(wordsize - 1 downto 0);
            RegB      : out  std_logic_vector(wordsize - 1 downto 0);
            RegD      : out  std_logic_vector(2 * wordsize - 1 downto 0)
        );
    end component RegArray;

    -- Internal signals for hooking up to RegArray
    signal RA_RegIn     : std_logic_vector(wordsize - 1 downto 0);
    signal RA_RegInSel  : integer  range regcnt - 1 downto 0;
    signal RA_RegStore  : std_logic;
    signal RA_RegASel   : integer  range regcnt - 1 downto 0;
    signal RA_RegBSel   : integer  range regcnt - 1 downto 0;
    signal RA_RegDIn    : std_logic_vector(2 * wordsize - 1 downto 0);
    signal RA_RegDInSel : integer  range regcnt/2 - 1 downto 0;
    signal RA_RegDStore : std_logic;
    signal RA_RegDSel   : integer  range regcnt/2 - 1 downto 0;
    signal RA_RegA      : std_logic_vector(wordsize - 1 downto 0);
    signal RA_RegB      : std_logic_vector(wordsize - 1 downto 0);
    signal RA_RegD      : std_logic_vector(2 * wordsize - 1 downto 0);

begin

    RegArrayMap: RegArray port map (
        RegIn     =>  RA_RegIn,
        RegInSel  =>  RA_RegInSel,
        RegStore  =>  RA_RegStore,
        RegASel   =>  RA_RegASel,
        RegBSel   =>  RA_RegBSel,
        RegDIn    =>  RA_RegDIn,
        RegDInSel =>  RA_RegDInSel,
        RegDStore =>  RA_RegDStore,
        RegDSel   =>  RA_RegDSel,
        clock     =>  clk,
        RegA      =>  RA_RegA,
        RegB      =>  RA_RegB,
        RegD      =>  RA_RegD
    );

    -- Single register input connection
    RA_RegIn <= DataInS;
    RA_RegInSel <= to_integer(unsigned(SelInS));
    RA_RegStore <= EnableInS;

    -- Double Register Input connection
    RA_RegDIn <= DataInD;
    RA_RegDInSel <= to_integer("11" & unsigned(SelInD));
    RA_RegDStore <= EnableInD;

    -- Single Register A output
    RA_RegASel <= to_integer(unsigned(SelOutA));
    DataOutA <= RA_RegA;

    -- Single Register B output
    RA_RegBSel <= to_integer(unsigned(SelOutB));
    DataOutB <= RA_RegB;

    -- Double Register output
    RA_RegDSel <= to_integer("11" & unsigned(SelOutD));
    DataOutD <= RA_RegD;

end dataflow;
