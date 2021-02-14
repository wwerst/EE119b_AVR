library ieee;
use ieee.std_logic_1164.all;


use work.AVR;
use work.ALUOp.all;

entity alu_tb is
end alu_tb;

architecture testbench of alu_tb is
    component avr_alu
        port(
            clk         : in   std_logic;
            ALUOpA      : in   AVR.word_t;   -- first operand
            ALUOpB      : in   AVR.word_t;   -- second operand
            ALUOpSelect : in   ALUOP_t;
            FlagMask    : in   AVR.word_t;   -- Flag mask. If 1, then update bit. If 0, leave bit unchanged.
            Status      : out  AVR.word_t;   -- Status register
            Result      : out  AVR.word_t    -- Output result
        );
    end component avr_alu;

    signal clk         : std_logic;
    signal ALUOpA      : AVR.word_t;
    signal ALUOpB      : AVR.word_t;
    signal ALUOpSelect : ALUOP_t;
    signal FlagMask    : AVR.word_t;
    signal Status      : AVR.word_t;
    signal Result      : AVR.word_t;

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

end architecture testbench;
