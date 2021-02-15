library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.AVR;
use work.ALUOp;

library osvvm;
use osvvm.CoveragePkg.all;
use osvvm.AlertLogPkg.all;

entity alu_tb is
end alu_tb;

architecture testbench of alu_tb is
    component avr_alu
        port(
            clk         : in   std_logic;
            ALUOpA      : in   AVR.word_t;   -- first operand
            ALUOpB      : in   AVR.word_t;   -- second operand
            ALUOpSelect : in   ALUOp.ALUOP_t;
            FlagMask    : in   AVR.word_t;   -- Flag mask. If 1, then update bit. If 0, leave bit unchanged.
            Status      : out  AVR.word_t;   -- Status register
            Result      : out  AVR.word_t    -- Output result
        );
    end component avr_alu;

    constant CLK_PERIOD: time := 1 ms;
    signal done : boolean := FALSE;
    signal clk         : std_logic;

    signal UUT_ALUOpA      : AVR.word_t;
    signal UUT_ALUOpB      : AVR.word_t;
    signal UUT_ALUOpSelect : ALUOp.ALUOP_t;
    signal UUT_FlagMask    : AVR.word_t;
    signal UUT_Status      : AVR.word_t;
    signal UUT_Result      : AVR.word_t;


    signal prev_Status     : AVR.word_t;


    constant randomWordBin: CovBinType := GenBin(AtLeast => 10000, Min => 0, Max => 255, NumBin => 1);

    constant INPUT_BINS: CovMatrix3Type := (
        GenCross(GenBin(to_integer(unsigned(ALUOp.ADD_Op))), randomWordBin, randomWordBin) &
        GenCross(GenBin(to_integer(unsigned(ALUOp.ADC_Op))), randomWordBin, randomWordBin) &
        GenCross(GenBin(to_integer(unsigned(ALUOp.SUB_Op))), randomWordBin, randomWordBin) &
        GenCross(GenBin(to_integer(unsigned(ALUOp.SBC_Op))), randomWordBin, randomWordBin) &

        GenCross(GenBin(to_integer(unsigned(ALUOp.AND_Op))), randomWordBin, randomWordBin) &
        GenCross(GenBin(to_integer(unsigned(ALUOp.OR_Op))), randomWordBin, randomWordBin)  &
        GenCross(GenBin(to_integer(unsigned(ALUOp.EOR_Op))), randomWordBin, randomWordBin) &
        GenCross(GenBin(to_integer(unsigned(ALUOp.COM_Op))), randomWordBin, randomWordBin)  
    );

    shared variable AluCov : CovPType;

begin
    UUT: avr_alu port map (
        clk         => clk            ,
        ALUOpA      => UUT_ALUOpA     ,
        ALUOpB      => UUT_ALUOpB     ,
        ALUOpSelect => UUT_ALUOpSelect,
        FlagMask    => UUT_FlagMask   ,
        Status      => UUT_Status     ,
        Result      => UUT_Result
    );

    ClockProc: process
    begin
        while not done loop
            clk <= '0';
            wait for CLK_PERIOD/2;
            clk <= '1';
            wait for CLK_PERIOD/2;
        end loop;
        wait;
    end process ClockProc;

    StimulusProc: process
        variable tv_ALUOpSelect : integer;
        variable tv_ALUOpA      : integer;
        variable tv_ALUOpB      : integer;
    begin
        SetAlertLogName("ALU_Test1");

        AluCov.AddBins(INPUT_BINS);

        while not (AluCov.IsCovered) loop
            (tv_ALUOpSelect, tv_ALUOpA, tv_ALUOpB) := AluCov.GetRandPoint;

            UUT_ALUOpSelect <= std_logic_vector(to_unsigned(tv_ALUOpSelect, UUT_ALUOpSelect'length));
            UUT_ALUOpA <= std_logic_vector(to_unsigned(tv_ALUOpA, UUT_ALUOpA'length));
            UUT_ALUOpB <= std_logic_vector(to_unsigned(tv_ALUOpB, UUT_ALUOpB'length));

            -- TODO(WHW): Implement different flag masks for ops
            UUT_FlagMask <= (others => '1');

            prev_Status <= UUT_Status;
            wait until rising_edge(clk);

            AluCov.ICover((tv_ALUOpSelect, tv_ALUOpA, tv_ALUOpB));
        end loop;
        AluCov.WriteBin;

        done <= TRUE;
        wait;
    end process StimulusProc;

    CheckProc: process
        variable tb_id : integer;
        variable opa_int : integer;
        variable opb_int : integer;
        variable res_int : integer;
        variable expect_int : integer;
        variable expect_slv : AVR.word_t;
    begin
        tb_id := GetAlertLogID("AVR_ALU", ALERTLOG_BASE_ID);
        while not done loop
            wait until falling_edge(clk);
            opa_int := to_integer(unsigned(UUT_ALUOpA));
            opb_int := to_integer(unsigned(UUT_ALUOpB));
            res_int := to_integer(unsigned(UUT_Result));
            case UUT_ALUOpSelect is
                when ALUOp.ADD_Op =>
                    expect_int := (opa_int + opb_int) mod 256;
                    -- TODO(WHW): Add flag checking
                    AffirmIf(tb_id, expect_int = res_int, " Add op incorrect");
                when ALUOp.ADC_Op =>
                    expect_int := 1 when UUT_Status(AVR.STATUS_CARRY) = '1' else 0;
                    expect_int := (expect_int + opa_int + opb_int) mod 256;
                    -- TODO(WHW): Add flag checking
                    AffirmIf(tb_id, expect_int = res_int, " Adc op incorrect");
                when ALUOp.SUB_Op =>
                    expect_int := (opa_int - opb_int) mod 256;
                    -- TODO(WHW): Add flag checking
                    AffirmIf(tb_id, expect_int = res_int, " Sub op incorrect");
                when ALUOp.SBC_Op =>
                    expect_int := 1 when UUT_Status(AVR.STATUS_CARRY) = '1' else 0;
                    expect_int := (opa_int - opb_int - expect_int) mod 256;
                    -- TODO(WHW): Add flag checking
                    AffirmIf(tb_id, expect_int = res_int, " SBC op incorrect");
                when ALUOp.AND_Op =>
                    expect_slv := (UUT_ALUOpA and UUT_ALUOpB);
                    -- TODO(WHW): Add flag checking
                    AffirmIf(tb_id, expect_slv = UUT_Result, " AND op incorrect");
                when ALUOp.OR_Op =>
                    expect_slv := (UUT_ALUOpA or UUT_ALUOpB);
                    -- TODO(WHW): Add flag checking
                    AffirmIf(tb_id, expect_slv = UUT_Result, " OR op incorrect");
                when ALUOp.EOR_Op =>
                    expect_slv := (UUT_ALUOpA xor UUT_ALUOpB);
                    -- TODO(WHW): Add flag checking
                    AffirmIf(tb_id, expect_slv = UUT_Result, " EOR op incorrect");
                when ALUOp.COM_Op =>
                    expect_slv := not UUT_ALUOpA;
                    -- TODO(WHW): Add flag checking
                    AffirmIf(tb_id, expect_slv = UUT_Result, " COM op incorrect");
                when others =>
                    AffirmIf(tb_id, FALSE, " Unexpected opcode sent ");
            end case;
        end loop;
        wait;
    end process CheckProc;

end architecture testbench;
