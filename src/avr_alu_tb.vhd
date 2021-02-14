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

    -- AVR: ADIW, INC
    -- Adder only
    constant ADD : std_logic_vector(4 downto 0) := "0000000"; -- R = A + B
    constant ADC : std_logic_vector(4 downto 0) := "0000000"; -- R = A + B + SREG.C

    -- Adder with FBLOCK
    -- AVR: CP (compare), CPI (compare with immediate), DEC, NEG, SBCI
    constant SUB : std_logic_vector(4 downto 0) := "0000000";

    -- AVR: CPC (compare with carry), SBCI
    constant SBC : std_logic_vector(4 downto 0) := "0000000";


    -- AVR: ANDI
    -- FBLOCK only
    constant AND : std_logic_vector(4 downto 0) := "0000000"; -- R = A & B

    -- AVR: ORI
    constant OR : std_logic_vector(4 downto 0) := "0000000"; -- R = A | B

    -- BST is implemented using one of two below.
    constant BCLR : std_logic_vector(4 downto 0) := "0000000"; -- Determine update bit by flag mask
    constant BSET : std_logic_vector(4 downto 0) := "0000000";

    -- AVR: BLD   . BLD is implemented as R = A xor B. Implementation is B has one bit hot if T should change, else all 0.
    constant EOR : std_logic_vector(4 downto 0) := "0000000";

    constant COM : std_logic_vector(4 downto 0) := "0000000"; -- Implemented using FBlock to negate. Note, will need to change the Fblock carry bit output to 1


    -- Shifter only
    constant LSR : std_logic_vector(4 downto 0) := "0000000"; -- Logical shift right

    constant ROR : std_logic_vector(4 downto 0) := "0000000"; -- Rotate right through carry

    constant SWAP : std_logic_vector(4 downto 0) := "0000000"; -- Swap

    constant ASR : std_logic_vector(4 downto 0) := "0000000"; -- R = A[7] concat A >> 1

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
