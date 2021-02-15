library ieee;
use ieee.std_logic_1164.all;

package ALUOp is

    subtype ALUOP_t is std_logic_vector(6 downto 0);
    -- AVR: ADIW, INC
    -- Adder only
    constant ADD_Op : ALUOP_t := "0000000"; -- R = A + B
    constant ADC_Op : ALUOP_t := "0000000"; -- R = A + B + SREG.C

    -- Adder with FBLOCK
    -- AVR: CP (compare), CPI (compare with immediate), DEC, NEG, SBCI
    constant SUB_Op : ALUOP_t := "0000000";

    -- AVR: CPC (compare with carry), SBCI
    constant SBC_Op : ALUOP_t := "0000000";


    -- AVR: ANDI
    -- FBLOCK only
    constant AND_Op : ALUOP_t := "0000000"; -- R = A & B

    -- AVR: ORI
    constant OR_Op : ALUOP_t := "0000000"; -- R = A | B

    -- BST is implemented using one of two below.
    constant BCLR_Op : ALUOP_t := "0000000"; -- Determine update bit by flag mask
    constant BSET_Op : ALUOP_t := "0000000";

    -- AVR: BLD   . BLD is implemented as R = A xor B. Implementation is B has one bit hot if T should change, else all 0.
    constant EOR_Op : ALUOP_t := "0000000";

    constant COM_Op : ALUOP_t := "0000000"; -- Implemented using FBlock to negate. Note, will need to change the Fblock carry bit output to 1


    -- Shifter only
    constant LSR_Op : ALUOP_t := "0000000"; -- Logical shift right

    constant ROR_Op : ALUOP_t := "0000000"; -- Rotate right through carry

    constant SWAP_Op : ALUOP_t := "0000000"; -- Swap

    constant ASR_Op : ALUOP_t := "0000000"; -- R = A[7] concat A >> 1

end package;


library ieee;
use ieee.std_logic_1164.all;

use work.AVR;
use work.ALUOp.all;

entity avr_alu is

    port(
            clk         : in   std_logic;
            ALUOpA      : in   AVR.word_t;   -- first operand
            ALUOpB      : in   AVR.word_t;   -- second operand
            ALUOpSelect : in   ALUOP_t;
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

    signal sreg_carry, sreg_zero, sreg_over, sreg_sign, sreg_hcarry : std_logic;
    signal status_signal, status_computed, status_mux: AVR.word_t;
begin

    -- firstly, everything needs to get sent through a ALU
    alu_c: ALU generic map (wordsize => AVR.WORDSIZE)
        port map (
            ALUOpA   => ALUOpA,
            ALUOpB   => ALUOpB,
            Cin      => status_signal(AVR.STATUS_CARRY),
            FCmd     => FCmd,
            CinCmd   => CinCmd,
            SCmd     => SCmd,
            ALUCmd   => ALUCmd,
            Result   => result_signal,
            Cout     => carry,
            HalfCout => hcarry,
            Overflow => over,
            Zero     => Zero,
            Sign     => Sign
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
