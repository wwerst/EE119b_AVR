---------------------------------------------------------------------

-- AVR ALU

-- This is an implementation of an ALU for the AVR.
-- I was convinced to make an interesting interface
-- where only a fixed set of ops are exposed as constants:
--      ADD, ADC, SUB, AND, OR, BCLR, BSET, XOR, COM, LSR, ROR, SWAP, ASR
-- We might add more if it makes the control unit nicer.

-- Packages included are:
--      ALUOp: constants for all the above ALU ops

-- Entities included are:
--      avr_alu: the ALU itself

-- Revision history:
--      13 Feb 21   Eric Chen   Create ALU
--      14 Feb 21   Will Werst  Create new interface
--      15 Feb 21   Eric Chen   Set up ALU op constants
--      15 Feb 21   Will Werst  Fix ALU op constants
---------------------------------------------------------------------


--
-- Package defining constants for all supported ALU operations.
-- These ALU ops are technically opaque to the user,
-- but are of course designed to directly "decode"
-- to the internal control signals.
--

library ieee;
use ieee.std_logic_1164.all;

use work.ALUConstants;

package ALUOp is
    -- redefine a few things
    constant FBLOCK : std_logic_vector(1 downto 0) := ALUConstants.ALUCmd_FBLOCK;
    constant ADDER  : std_logic_vector(1 downto 0) := ALUConstants.ALUCmd_ADDER;
    constant SHIFT  : std_logic_vector(1 downto 0) := ALUConstants.ALUCmd_SHIFT;

    subtype ALUOP_t is std_logic_vector(6 downto 0);
    --  |   6   5 | 4   3   2   1 | 0    |
    --  |  ALU OP |     sub-op    |status|

    -- adder sub-ops:   |  4    | 3   2 | 1    |
    --                  |add/sub|cincmd |unused|
    -- AVR: ADIW, INC
    constant ADD_Op : ALUOP_t := ADDER  & '0' & ALUConstants.CinCmd_ZERO    & "00"; -- R = A + B
    constant ADC_Op : ALUOP_t := ADDER  & '0' & ALUConstants.CinCmd_CIN     & "00"; -- R = A + B + SREG.C
    -- AVR: CP (compare), CPI (compare with immediate), DEC, NEG, SBCI
    constant SUB_Op : ALUOP_t := ADDER  & '1' & ALUConstants.CinCMD_ONE     & "00";
    -- AVR: CPC (compare with carry), SBCI
    constant SBC_Op : ALUOP_t := ADDER  & '1' & ALUConstants.CinCMD_CINBAR  & "00";


    -- fblock sub-ops:  |   4   3   2   1          |
    --                  |FCmd, see FBlock component|
    -- AVR: ANDI
    constant AND_Op : ALUOP_t := FBLOCK & "1000" & '0'; -- R = A & B
    -- AVR: ORI
    constant OR_Op  : ALUOP_t := FBLOCK & "1110" & '0'; -- R = A | B
    -- BST is implemented using one of two below.
    constant BCLR_Op: ALUOP_t := FBLOCK & "0100" & '1'; -- Result = A and not B. Any bit that is 1 in B, will be 0 in result.
    constant BSET_Op: ALUOP_t := FBLOCK & "1110" & '1'; -- Result = A or B.
    -- AVR: BLD   . BLD is implemented as R = A xor B. Implementation is B has one bit hot if T should change, else all 0.
    constant EOR_Op : ALUOP_t := FBLOCK & "0110" & '0';
    constant COM_Op : ALUOP_t := FBLOCK & "0011" & '0'; -- Implemented using FBlock to negate. Note, will need to change the Fblock carry bit output to 1

    -- Shifter sub-ops: |   4   3   2 | 1    |
    --                  |  SCMD       |unused|
    constant LSR_Op : ALUOP_t := SHIFT  & ALUConstants.SCmd_LSR     & "00"; -- Logical shift right
    constant ROR_Op : ALUOP_t := SHIFT  & ALUConstants.SCmd_RRC     & "00"; -- Rotate right through carry. Note the AVR instruct ROR is RRC.
    constant SWAP_Op: ALUOP_t := SHIFT  & ALUConstants.SCmd_SWAP    & "00"; -- Swap
    constant ASR_Op : ALUOP_t := SHIFT  & ALUConstants.SCmd_ASR     & "00"; -- R = A[7] concat A >> 1

end package;


--
-- avr_alu
--
-- The ALU itself, including a status register.
-- It calculates the operation result with combinatorial logic,
-- and updates the status register (according to flag mask) every clock.
--
-- Inputs:
--      clk     - to update status register on
--      ALUOpA, ALUOpB  - word sized operands
--      ALUOpSelect     - operation to perform, see ALUOp package
--      FlagMask        - if mask is 1, corresponding bit is updated
--                          in the status register.
--                          otherwise, the bit is kept constant
-- Outputs:
--      Status          - Status register, consisting of
--                          carry, zero, negative, overflow, sign, half carry, transfer bit (BLD/BST), and interrupt enable/disable
--                          see AVR package.
--      Result          - ALU operation result
--

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
    signal ALUCmd: std_logic_vector(1 downto 0);

    signal adderSubCmd: std_logic;

    signal carry, zero, over, sign, hcarry : std_logic;

    -- These signals map the internal ALU signals to the AVR's interface for status register results
    signal hcarry_avr, sign_avr, over_avr, neg_avr, zero_avr, carry_avr : std_logic;
    signal status_signal, status_computed, status_mux: AVR.word_t;
    signal result_signal: AVR.word_t;
begin

    -- Generating controls:
    -- top 2 bits are alu command
    ALUCmd <= aluopselect(6 downto 5);

    adderSubCmd <= aluopselect(4);
    -- if doing a fblock op, use provided fcmd
    fcmd <= aluopselect(4 downto 1) when ALUCmd = ALUOp.FBLOCK else
    -- otherwise, only matters if we're doing an add.
    -- pass through second operand if adding, and invert second operand if subtrating
        "1010" when adderSubCmd = '0' -- Pass through B unchanged
        else "0101";                  -- Negate B

    -- only matters if using adder.
    cincmd <= aluopselect(3 downto 2);
    -- only matters if using shifter.
    scmd <= aluopselect(4 downto 2);

    -- firstly, everything needs to get sent through a ALU
    alu_c: ALU generic map (wordsize => AVR.WORDSIZE)
        port map (
            ALUOpA   => ALUOpA,
            ALUOpB   => ALUOpB,
            Cin      => status_signal(AVR.STATUS_CARRY),
            FCmd     => fcmd,
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

    over_avr <= over                  when ALUCmd = ALUOp.Adder   else 
                '0'                   when ALUCmd = ALUOp.FBLOCK  else
                neg_avr xor carry_avr when ALUCmd = ALUOp.SHIFT else
                'X';

    neg_avr <= sign;
    sign_avr <= neg_avr xor over_avr;

    hcarry_avr <= hcarry xor adderSubCmd when ALUCmd = ALUOp.Adder   else
                  ALUOpA(3)              when ALUCmd = ALUOp.SHIFT   else
                  '0'                    when ALUCmd = ALUOp.FBLOCK  else
                  hcarry;

    zero_avr <= zero;
    carry_avr <= carry xor adderSubCmd when ALUCmd = ALUOp.Adder   else
                 '1'                   when ALUCmd = ALUOp.FBLOCK  else   -- Needed for COM instruction
                 carry;

    -- TODO(WHW): This should use constants for indexing ordering, not implicit ordering.
    status_computed <= (
        status_signal(AVR.STATUS_INT),     -- AVR.STATUS_INT
        status_signal(AVR.STATUS_TRANS),   -- AVR.STATUS_TRANS
        hcarry_avr,                        -- AVR.STATUS_HCARRY
        sign_avr,                          -- AVR.STATUS_SIGN
        over_avr,                          -- AVR.STATUS_OVER
        neg_avr,                           -- AVR.STATUS_NEG   
        zero_avr,                          -- AVR.STATUS_ZERO  
        carry_avr                          -- AVR.STATUS_CARRY 
    );
    -- we can set the status register from the ALU output,
    -- or the actual computed status.
    status_mux <= result_signal when aluopselect(0) = '1' else status_computed;
    status_c: StatusReg generic map (wordsize => AVR.WORDSIZE)
        port map (
            RegIn => status_mux,
            RegMask => flagmask,
            clock  => clk,
            RegOut => status_signal
        );
    -- output the acutal status register
    Status <= status_signal;
end architecture dataflow;
