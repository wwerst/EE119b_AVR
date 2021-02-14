library ieee;
use ieee.std_logic_1164.all;

package ALU is
    -- more typing to do less typing?
   constant Cin_ZERO   : std_logic_vector(1 downto 0) := "00";
   constant Cin_ONE    : std_logic_vector(1 downto 0) := "01";
   constant Cin_CIN    : std_logic_vector(1 downto 0) := "10";
   constant Cin_CINBAR : std_logic_vector(1 downto 0) := "11";


--  Shifter command constants
   constant S_LEFT  : std_logic_vector(2 downto 0) := "0--";
   constant S_LSL   : std_logic_vector(2 downto 0) := "000";
   constant S_SWAP  : std_logic_vector(2 downto 0) := "001";
   constant S_ROL   : std_logic_vector(2 downto 0) := "010";
   constant S_RLC   : std_logic_vector(2 downto 0) := "011";
   constant S_LSR   : std_logic_vector(2 downto 0) := "100";
   constant S_ASR   : std_logic_vector(2 downto 0) := "101";
   constant S_ROR   : std_logic_vector(2 downto 0) := "110";
   constant S_RRC   : std_logic_vector(2 downto 0) := "111";


--  ALU command constants
--     may be freely changed

   constant Cmd_FBLOCK  : std_logic_vector(1 downto 0) := "00";
   constant Cmd_ADDER   : std_logic_vector(1 downto 0) := "01";
   constant Cmd_SHIFT   : std_logic_vector(1 downto 0) := "10";

end package;

library ieee;
use ieee.std_logic_1164.all;

use work.AVR;

entity avr_alu is

    port(
            clk         : in   std_logic;
            ALUOpA      : in   AVR.word_t;   -- first operand
            ALUOpB      : in   AVR.word_t;   -- second operand
            ALUOpSelect : in   std_logic_vector(6 downto 0);
            FlagMask    : in   AVR.word_t;   -- Flag mask. If 1, then update bit. If 0, leave bit unchanged.
            Status      : out  AVR.word_t;   -- Status register
            Result      : out  AVR.word_t    -- Output result
    );
end avr_alu;

architecture dataflow of avr_alu is

    component ALU
        generic (
            wordsize : integer := 8      -- default width is 8-bits
        );

        port(
            ALUOpA   : in      std_logic_vector(wordsize - 1 downto 0);   -- first operand
            ALUOpB   : in      std_logic_vector(wordsize - 1 downto 0);   -- second operand
            Cin      : in      std_logic;                                 -- carry in
            FCmd     : in      std_logic_vector(3 downto 0);              -- F-Block operation
            CinCmd   : in      std_logic_vector(1 downto 0);              -- carry in operation
            SCmd     : in      std_logic_vector(2 downto 0);              -- shift operation
            ALUCmd   : in      std_logic_vector(1 downto 0);              -- ALU result select
            Result   : buffer  std_logic_vector(wordsize - 1 downto 0);   -- ALU result
            Cout     : out     std_logic;                                 -- carry out
            HalfCout : out     std_logic;                                 -- half carry out
            Overflow : out     std_logic;                                 -- signed overflow
            Zero     : out     std_logic;                                 -- result is zero
            Sign     : out     std_logic                                  -- sign of result
        );
    end component;
    component StatusReg
        generic (
            wordsize : integer := 8      -- default width is 8-bits
        );

        port(
            RegIn    : in      std_logic_vector(wordsize - 1 downto 0);   -- data to write to register
            RegMask  : in      std_logic_vector(wordsize - 1 downto 0);   -- write mask
            clock    : in      std_logic;                                 -- system clock
            RegOut   : buffer  std_logic_vector(wordsize - 1 downto 0)    -- current register value
        );
    end component;

    signal carry, zero, over, sign, hcarry : std_logic;
    signal status_signal, status_computed, status_mux: AVR.word_t;
    signal result_signal: AVR.word_t;
begin

    -- firstly, everything needs to get sent through a ALU
    alu_c: ALU generic map (wordsize => AVR.WORDSIZE)
        port map (
            ALUOpA,
            ALUOpB,
            status_signal(AVR.STATUS_CARRY),
            FCmd,
            CinCmd,
            SCmd,
            ALUCmd,
            result_signal,
            carry,
            hcarry,
            over,
            Zero,
            Sign
         );
    -- result and status from our computation
    result <= result_signal;
    status_computed <= (
        AVR.STATUS_INT => status_signal(AVR.STATUS_INT),
        AVR.STATUS_TRANS => status_signal(AVR.STATUS_TRANS),
        AVR.STATUS_HCARRY => hcarry,
        AVR.STATUS_SIGN => sign,
        AVR.STATUS_OVER => over,
        AVR.STATUS_NEG => result_signal(result_signal'HIGH),
        AVR.STATUS_ZERO => zero,
        AVR.STATUS_CARRY => carry
    );
    -- we can set the status register from the ALU output,
    -- or the actual computed status.
    status_mux <= result_signal when set_status = '1' else status_computed;
    status_c: StatusReg generic map (wordsize => AVR.WORDSIZE)
        port map (
            status_mux,
            mask,
            clk,
            status_signal
        );
    -- output the acutal status register
    status <= status_signal;
end architecture dataflow;
