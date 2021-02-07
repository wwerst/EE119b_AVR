-- avr_reg
--
-- Implements AVR register unit
--
-- Author: Will Werst

library ieee;
use ieee.std_logic_1164.all;

use work.AVR;

package AVR_REG_CONST is
    -- Contains any constants used in
    constant REG_COUNT : natural := 32;
end package AVR_REG_CONST;


library ieee;
use ieee.std_logic_1164.all;

use work.AVR;
use work.AVR_REG_CONST;

entity AvrReg is
    port(
        clk         : in std_logic;
        
        -- Single register input
        EnableInS   : in std_logic;
        DataInS     : in reg_s_data_t;
        SelInS      : in reg_s_sel_t;

        -- Double register input
        EnableInD   : in std_logic;
        DataInD     : in reg_d_data_t;
        SelInD      : in reg_s_sel_t;

        -- Single register A output
        SelOutA     : out reg_s_sel_t;
        DataOutA    : out reg_s_data_t;

        -- Single register B output
        SelOutB     : out reg_s_sel_t;
        DataOutB    : out reg_s_data_t;

        -- Double register output
        SelOutD     : out reg_d_sel_t;
        DataOutD    : out reg_d_data_t
    );
end AvrReg;


architecture dataflow of AvrReg is
    component RegUnit
        generic (
            regcnt   : integer := 32;    -- default number of registers is 32
            wordsize : integer := 8      -- default width is 8-bits
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
    end component RegUnit;

begin

end dataflow;
