library ieee;
use ieee.std_logic_1164.all;

entity alu_tb is

end alu_tb;

architecture testbench of alu_tb is
    component avr_alu
        port(
            clk         : in   std_logic;
            ALUOpA      : in   AVR.word_t;   -- first operand
            ALUOpB      : in   AVR.word_t;   -- second operand
            ALUOpSelect : in   std_logic_vector(6 downto 0);
            FlagMask    : in   AVR.word_t;   -- Flag mask. If 1, then update bit. If 0, leave bit unchanged.
            Status      : out  AVR.word_t;   -- Status register
            Result      : out  AVR.word_t    -- Output result
        );
    end component avr_alu;

    constant ADD : std_logic_vector(4 downto 0) := "110100";
begin
    UUT: avr_alu port map (
        clk         => clk        ,
        ALUOpA      => ALUOpA     ,
        ALUOpB      => ALUOpB     ,
        ALUOpSelect => ALUOpSelect,
        FlagMask    => FlagMask   ,
        Status      => Status     ,
        Result      => Result
    );

    Cl

end architecture testbench;
