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

    constant CLK_PERIOD: time := 1 us;
    signal done : boolean := FALSE;
    signal clk         : std_logic;

    signal UUT_ALUOpA      : AVR.word_t;
    signal UUT_ALUOpB      : AVR.word_t;
    signal UUT_ALUOpSelect : ALUOp.ALUOP_t;
    signal UUT_FlagMask    : AVR.word_t;
    signal UUT_Status      : AVR.word_t;
    signal UUT_Result      : AVR.word_t;


    signal prev_Status     : AVR.word_t;

    signal prev_expected_sreg : AVR.word_t := "--------";

    constant NUM_TESTS_PER_OP : integer := 10000;

    constant randomWordBin: CovBinType := GenBin(AtLeast => NUM_TESTS_PER_OP, Min => 0, Max => 255, NumBin => 1);

    constant AtMostOneHotBin: CovBinType := GenBin((0, 1, 2, 4, 8, 16, 32, 64, 128));

    constant INPUT_BINS: CovMatrix3Type := (
        -- Arithmetic
        GenCross(GenBin(to_integer(unsigned(ALUOp.ADD_Op))), randomWordBin, randomWordBin) &
        GenCross(GenBin(to_integer(unsigned(ALUOp.ADC_Op))), randomWordBin, randomWordBin) &
        GenCross(GenBin(to_integer(unsigned(ALUOp.SUB_Op))), randomWordBin, randomWordBin) &
        GenCross(GenBin(to_integer(unsigned(ALUOp.SBC_Op))), randomWordBin, randomWordBin) &

        -- Bit-logical
        GenCross(GenBin(to_integer(unsigned(ALUOp.AND_Op))), randomWordBin, randomWordBin) &
        GenCross(GenBin(to_integer(unsigned(ALUOp.OR_Op))), randomWordBin, randomWordBin)  &
        GenCross(GenBin(to_integer(unsigned(ALUOp.EOR_Op))), randomWordBin, randomWordBin) &
        GenCross(GenBin(to_integer(unsigned(ALUOp.COM_Op))), randomWordBin, randomWordBin) &

        -- Status register manipulation
        GenCross(GenBin(to_integer(unsigned(ALUOp.BCLR_Op))), randomWordBin, AtMostOneHotBin) &
        GenCross(GenBin(to_integer(unsigned(ALUOp.BSET_Op))), randomWordBin, AtMostOneHotBin) &

        -- Shifter ops
        GenCross(GenBin(to_integer(unsigned(ALUOp.LSR_Op))), randomWordBin, randomWordBin) &
        GenCross(GenBin(to_integer(unsigned(ALUOp.ROR_Op))), randomWordBin, randomWordBin) &
        GenCross(GenBin(to_integer(unsigned(ALUOp.SWAP_Op))), randomWordBin, randomWordBin) &
        GenCross(GenBin(to_integer(unsigned(ALUOp.ASR_Op))), randomWordBin, randomWordBin)
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

    CheckResultProc: process
        variable tb_id : integer;
        variable opa_int : integer;
        variable opb_int : integer;
        variable res_int : integer;
        variable expect_int : integer;
        variable expect_slv : AVR.word_t;
    begin
        tb_id := GetAlertLogID("AVR_ALU", ALERTLOG_BASE_ID);
        while not done loop
            wait until rising_edge(clk);
            opa_int := to_integer(unsigned(UUT_ALUOpA));
            opb_int := to_integer(unsigned(UUT_ALUOpB));
            res_int := to_integer(unsigned(UUT_Result));
            case UUT_ALUOpSelect is
                when ALUOp.ADD_Op =>
                    expect_int := (opa_int + opb_int) mod 256;
                    -- TODO(WHW): Add flag checking on the status register
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
                when ALUOp.BCLR_Op =>
                    for i in UUT_ALUOpB'range loop
                        if UUT_ALUOpB(i) = '1' then
                            expect_slv(i) := '0';
                        else
                            expect_slv(i) := UUT_ALUOpA(i);
                        end if;
                    end loop;
                    -- TODO(WHW): Add flag checking
                    AffirmIf(tb_id, expect_slv = UUT_Result, " BCLR op incorrect");
                when ALUOp.BSET_Op =>
                    for i in UUT_ALUOpB'range loop
                        if UUT_ALUOpB(i) = '1' then
                            expect_slv(i) := '1';
                        else
                            expect_slv(i) := UUT_ALUOpA(i);
                        end if;
                    end loop;
                    -- TODO(WHW): Add flag checking
                    AffirmIf(tb_id, expect_slv = UUT_Result, " BSET op incorrect");
                when ALUOp.LSR_Op =>
                    expect_slv := '0' & UUT_ALUOpA(UUT_ALUOpA'high downto 1);
                    -- TODO(WHW): Add flag checking
                    AffirmIf(tb_id, expect_slv = UUT_Result, " LSR op incorrect");
                when ALUOp.ROR_Op =>
                    expect_slv := UUT_Status(AVR.STATUS_CARRY) & UUT_ALUOpA(UUT_ALUOpA'high downto 1);
                    -- TODO(WHW): Add flag checking
                    AffirmIf(tb_id, expect_slv = UUT_Result, " ROR op incorrect");
                when ALUOp.SWAP_Op =>
                    expect_slv := UUT_ALUOpA(3 downto 0) & UUT_ALUOpA(7 downto 4);
                    -- TODO(WHW): Add flag checking
                    AffirmIf(tb_id, expect_slv = UUT_Result, " SWAP op incorrect");
                when ALUOp.ASR_Op =>
                    expect_slv := UUT_ALUOpA(UUT_ALUOpA'high) & UUT_ALUOpA(UUT_ALUOpA'high downto 1);
                    -- TODO(WHW): Add flag checking
                    AffirmIf(tb_id, expect_slv = UUT_Result, " ASR op incorrect");
                when others =>
                    AffirmIf(tb_id, FALSE, " Unexpected opcode sent ");
            end case;
        end loop;
        wait;
    end process CheckResultProc;

    GenerateExpectedStatusRegProc: process
        variable tb_id : integer;
        variable opa_uint : integer;
        variable opb_uint : integer;
        variable opa_sint : integer;
        variable opb_sint : integer;
        variable exp_res_uint : integer;
        variable exp_res_sint : integer;
        variable expect_sreg : AVR.word_t;
    begin
        tb_id := GetAlertLogID("AVR_ALU", ALERTLOG_BASE_ID);
        while not done loop
            wait until rising_edge(clk);
            opa_uint := to_integer(unsigned(UUT_ALUOpA));
            opb_uint := to_integer(unsigned(UUT_ALUOpB));
            opa_sint := to_integer(signed(UUT_ALUOpA));
            opb_sint := to_integer(signed(UUT_ALUOpB));
            expect_sreg := "--------";
            case UUT_ALUOpSelect is
                when ALUOp.ADD_Op =>
                    -- Compute C and Z
                    exp_res_uint := opa_uint + opb_uint;
                    expect_sreg(AVR.STATUS_CARRY) := '1' when exp_res_uint >= 256 else '0';
                    expect_sreg(AVR.STATUS_ZERO) := '1' when exp_res_uint mod 256 = 0 else '0';

                    -- Compute H
                    exp_res_uint := (opa_uint mod 16) + (opb_uint mod 16);
                    expect_sreg(AVR.STATUS_HCARRY) := '1' when exp_res_uint >= 16 else '0';
                    
                    -- Compute V = Two's complement overflow
                    expect_sreg(AVR.STATUS_OVER) := '1' when opa_sint + opb_sint > 127 or opa_sint + opb_sint < -128 else '0';

                    -- Compute N  = result is negative
                    exp_res_uint := opa_uint + opb_uint;
                    expect_sreg(AVR.STATUS_NEG) := to_unsigned(exp_res_uint, 16)(7); -- Convert to large unsigned number, pick out 7th bit

                    -- Compute S
                    expect_sreg(AVR.STATUS_SIGN) := expect_sreg(AVR.STATUS_NEG) xor expect_sreg(AVR.STATUS_OVER);
                when ALUOp.ADC_Op =>
                    -- Compute C and Z
                    exp_res_uint := 1 when UUT_Status(AVR.STATUS_CARRY) = '1' else 0;
                    exp_res_uint := exp_res_uint + opa_uint + opb_uint;
                    expect_sreg(AVR.STATUS_CARRY) := '1' when exp_res_uint >= 256 else '0';
                    expect_sreg(AVR.STATUS_ZERO) := '1' when exp_res_uint mod 256 = 0 else '0';

                    -- Compute H
                    exp_res_uint := 1 when UUT_Status(AVR.STATUS_CARRY) = '1' else 0;
                    exp_res_uint := exp_res_uint + (opa_uint mod 16) + (opb_uint mod 16);
                    expect_sreg(AVR.STATUS_HCARRY) := '1' when exp_res_uint >= 16 else '0';

                    -- Compute V = Two's complement overflow
                    exp_res_sint := 1 when UUT_Status(AVR.STATUS_CARRY) = '1' else 0;
                    exp_res_sint := exp_res_sint + opa_sint + opb_sint;
                    expect_sreg(AVR.STATUS_OVER) := '1' when exp_res_sint > 127 or exp_res_sint < -128 else '0';

                    -- Compute N  = result is negative
                    exp_res_uint := 1 when UUT_Status(AVR.STATUS_CARRY) = '1' else 0;
                    exp_res_uint := exp_res_uint + opa_uint + opb_uint;
                    expect_sreg(AVR.STATUS_NEG) := to_unsigned(exp_res_uint, 16)(7); -- Convert to large unsigned number, pick out 7th bit

                    -- Compute S
                    expect_sreg(AVR.STATUS_SIGN) := expect_sreg(AVR.STATUS_NEG) xor expect_sreg(AVR.STATUS_OVER);
                when ALUOp.SUB_Op =>
                when ALUOp.SBC_Op =>
                when ALUOp.AND_Op =>
                    expect_sreg(AVR.STATUS_OVER) := '0';
                when ALUOp.OR_Op =>
                when ALUOp.EOR_Op =>
                when ALUOp.COM_Op =>
                when ALUOp.BCLR_Op =>
                when ALUOp.BSET_Op =>
                when ALUOp.LSR_Op =>
                when ALUOp.ROR_Op =>
                when ALUOp.SWAP_Op =>
                when ALUOp.ASR_Op =>
                when others =>
                    null;
            end case;
            -- Check the previous status register value
            AffirmIf(tb_id, std_match(UUT_Status, prev_expected_sreg), " Status reg mismatch, expected " & to_string(prev_expected_sreg) & " but observed " & to_string(UUT_Status));
            prev_expected_sreg <= expect_sreg;
        end loop;
        wait;
    end process GenerateExpectedStatusRegProc;

end architecture testbench;
