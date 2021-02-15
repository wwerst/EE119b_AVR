library ieee;
use ieee.std_logic_1164.all;

use work.ALUConstants;

package ALUOp is
    -- redefine a few things
    constant FBLOCK : std_logic_vector(1 downto 0) := ALUConstants.ALUCmd_FBLOCK;
    constant ADDER : std_logic_vector(1 downto 0) := ALUConstants.ALUCmd_FBLOCK;
    constant SHIFT : std_logic_vector(1 downto 0) := ALUConstants.ALUCmd_FBLOCK;

    subtype ALUOP_t is std_logic_vector(6 downto 0);
    --  |   6   5 | 4   3   2   1 | 0    |
    --  |  ALU OP |     sub-op    |status|

    -- adder sub-ops:   |  4    | 3   2 | 1    |
    --                  |add/sub|cincmd |unused|
    -- AVR: ADIW, INC
    constant ADD_Op : ALUOP_t := ADDER& '0'& ALUConstants.CinCmd_ZERO& "00"; -- R = A + B
    constant ADC_Op : ALUOP_t := ADDER& '0'& ALUConstants.CinCmd_CIN& "00"; -- R = A + B + SREG.C
    -- AVR: CP (compare), CPI (compare with immediate), DEC, NEG, SBCI
    constant SUB_Op : ALUOP_t := ADDER& '1'& ALUConstants.CinCMD_ONE& "00";
    -- AVR: CPC (compare with carry), SBCI
    constant SBC_Op : ALUOP_t := ADDER& '1'& ALUConstants.CinCMD_CINBAR& "00";


    -- fblock sub-ops:  |   4   3   2   1          |
    --                  |FCmd, see FBlock component|
    -- AVR: ANDI
    constant AND_Op : ALUOP_t := FBLOCK & "1000" & '0'; -- R = A & B
    -- AVR: ORI
    constant OR_Op : ALUOP_t := FBLOCK & "1110" & '0'; -- R = A | B
    -- BST is implemented using one of two below.
    constant BCLR_Op : ALUOP_t := FBLOCK & "0000" & '1'; -- Determine update bit by flag mask
    constant BSET_Op : ALUOP_t := FBLOCK & "1111" & '1';
    -- AVR: BLD   . BLD is implemented as R = A xor B. Implementation is B has one bit hot if T should change, else all 0.
    constant EOR_Op : ALUOP_t := FBLOCK & "0110" & '0';
    constant COM_Op : ALUOP_t := FBLOCK & "0011" & '0'; -- Implemented using FBlock to negate. Note, will need to change the Fblock carry bit output to 1

    -- Shifter sub-ops: |   4   3   2 | 1    |
    --                  |  SCMD       |unused|
    constant LSR_Op : ALUOP_t := SHIFT & ALUConstants.SCmd_LSR & "00"; -- Logical shift right
    constant ROR_Op : ALUOP_t := SHIFT & ALUConstants.SCmd_ROR & "00"; -- Rotate right through carry
    constant SWAP_Op : ALUOP_t := SHIFT & ALUConstants.SCmd_SWAP & "00"; -- Swap
    constant ASR_Op : ALUOP_t := SHIFT & ALUConstants.SCmd_ASR & "00"; -- R = A[7] concat A >> 1

end package;


library ieee;
use ieee.std_logic_1164.all;

use work.AVR;
use work.ALUOp;

entity avr_alu is

    port(
            clk         : in   std_logic;
            ALUOpA      : in   AVR.word_t;   -- first operand
            ALUOpB      : in   AVR.word_t;   -- second operand
            ALUOpSelect : in   ALUOp.ALUOP_t;
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

    signal fcmd: std_logic_vector(3 downto 0);
    signal cincmd: std_logic_vector(1 downto 0);
    signal scmd: std_logic_vector(2 downto 0);
    signal alucmd: std_logic_vector(1 downto 0);
    signal carry, zero, over, sign, hcarry : std_logic;
    signal status_signal, status_computed, status_mux: AVR.word_t;
    signal result_signal: AVR.word_t;
begin

    -- Generating controls:
    -- top 2 bits are alu command
    alucmd <= aluopselect(6 downto 5);

    -- if doing a fblock op, use provided fcmd
    fcmd <= aluopselect(4 downto 1) when aluopselect(6 downto 5)= ALUOp.ADDER else
    -- otherwise, only matters if we're doing an add.
    -- pass through second operand if adding, and invert second operand if subtrating
        "1010" when aluopselect(4) = '0' else "0101";

    -- only matters if using adder.
    cincmd <= aluopselect(3 downto 2);
    -- only matters if using shifter.
    scmd <= aluopselect(4 downto 2);

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
    status_mux <= result_signal when aluopselect(0) = '1' else status_computed;
    status_c: StatusReg generic map (wordsize => AVR.WORDSIZE)
        port map (
            status_mux,
            flagmask,
            clk,
            status_signal
        );
    -- output the acutal status register
    status <= status_signal;
end architecture dataflow;
