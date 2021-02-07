--
--
library ieee;
use ieee.std_logic_1164.all;

package AVR is

    constant WORDSIZE  : natural := 8;
    constant ADDRSIZE: natural := 16;
    subtype word_t is std_logic_vector(WORDSIZE-1 downto 0);
    subtype addr_t is std_logic_vector(ADDRSIZE-1 downto 0);

end package;

--
--  AdderBit
--
--  This is a bit of the adder for doing addition in the ALU.
--
--  Inputs:
--    A  - first operand bit (bus A)
--    B  - second operand bit (bus B)
--    Ci - carry in (from previous bit)
--
--  Outputs:
--    S  - sum for this bit
--    Co - carry out for this bit
--

library ieee;
use ieee.std_logic_1164.all;

entity  AdderBit  is

    port(
        A  : in   std_logic;        -- first operand
        B  : in   std_logic;        -- second operand
        Ci : in   std_logic;        -- carry in from previous bit
        S  : out  std_logic;        -- sum (result)
        Co : out  std_logic         -- carry out to next bit
    );

end  AdderBit;


architecture  dataflow  of  AdderBit  is
begin

    S  <=  A  xor  B  xor  Ci;
    Co <=  (A  and  B)  or  (A  and Ci)  or  (B  and  Ci);

end  dataflow;
