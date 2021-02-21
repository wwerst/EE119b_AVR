---------------------------------------------------------------------

-- Avr Reg Testbench

-- This implements testing for the Avr Register unit.
-- Testing is implemented using OSVVM. These tests are ran in the
-- automatic build system using Github Actions, using GHDL. See
-- the Github Actions script for the documentation for the latest
-- install process for GHDL.
--
-- Revision history:
--      6  Feb 21   Will Werst  Initial implementation
--      13 Feb 21   Will Werst  Fix issues found in testing
--      20 Feb 21   Will Werst  Extend test coverage for double register
--      
---------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.AVR;
use work.AvrReg;
use work.AVR_REG_CONST;

library osvvm;
use osvvm.ScoreBoardPkg_slv;
use osvvm.CoveragePkg.all;
use osvvm.AlertLogPkg.all;


entity avr_reg_tb is
end avr_reg_tb;


-- Testing approach:
-- Data inputs to be stored into registers are random
-- All 8-bit registers must see all 2**8 values stored in them.
-- All 16-bit registers must see all 2**16 values stored in them. Might reduce requirement, but should be doable.
-- All 16-bit registers must be written to, and individual values read out
-- from the 8-bit internal registers
-- All 8-bit registers that are part of 16-bit registers must be written to
-- and read out from 16-bit register
-- Verify behavior when there is a double write (single reg takes precedence).

architecture testbench of avr_reg_tb is
    component AvrReg
        port(
            clk         : in std_logic;
            
            -- Single register input
            EnableInS   : in std_logic;
            DataInS     : in AVR.reg_s_data_t;
            SelInS      : in AVR.reg_s_sel_t;

            -- Double register input
            EnableInD   : in std_logic;
            DataInD     : in AVR.reg_d_data_t;
            SelInD      : in AVR.reg_d_sel_t;

            -- Single register A output
            SelOutA     : in AVR.reg_s_sel_t;
            DataOutA    : out AVR.reg_s_data_t;

            -- Single register B output
            SelOutB     : in AVR.reg_s_sel_t;
            DataOutB    : out AVR.reg_s_data_t;

            -- Double register output
            SelOutD     : in AVR.reg_d_sel_t;
            DataOutD    : out AVR.reg_d_data_t
        );
    end component AvrReg;

    constant CLK_PERIOD: time := 1 ms;
    signal done : boolean := FALSE;
    signal test_initialized : boolean := FALSE;
    signal clk         : std_logic;

    -- Single register input
    signal EnableInS   : std_logic;
    signal DataInS     : AVR.reg_s_data_t;
    signal SelInS      : AVR.reg_s_sel_t;

    -- Double register input
    signal EnableInD   : std_logic;
    signal DataInD     : AVR.reg_d_data_t;
    signal SelInD      : AVR.reg_d_sel_t;

    -- Single register A output
    signal SelOutA     : AVR.reg_s_sel_t;
    signal DataOutA    : AVR.reg_s_data_t;

    -- Single register B output
    signal SelOutB     : AVR.reg_s_sel_t;
    signal DataOutB    : AVR.reg_s_data_t;

    -- Double register output
    signal SelOutD     : AVR.reg_d_sel_t;
    signal DataOutD    : AVR.reg_d_data_t;

    function signedBin(slv: std_logic_vector) return CovBinType is begin
        return GenBin(-2**(slv'LENGTH-1), 2**(slv'LENGTH-1) - 1, slv'LENGTH);
    end function;
    function unsignedBin(slv: std_logic_vector) return CovBinType is begin
        return GenBin(0, 2**slv'LENGTH - 1, slv'LENGTH);
    end function;

    constant NUM_REG_TESTS: integer := 10;
    constant singleRegAddr: CovBinType := GenBin(AtLeast => NUM_REG_TESTS, Min => 0, Max => AVR_REG_CONST.REG_COUNT-1, NumBin => AVR_REG_CONST.REG_COUNT);
    constant doubleRegAddr: CovBinType := GenBin(AtLeast => NUM_REG_TESTS, Min => 0, Max => 3, NumBin => 4);
    constant singleRegData: CovBinType := GenBin(AtLeast => 1, Min => 0, Max => 255, NumBin => 256);
    constant doubleRegData: CovBinType := GenBin(AtLeast => 100, Min => 0, Max => 65535, NumBin => 1);
    constant wordMaxBin: CovBinType := GenBin(255);
    constant dwordMaxBin: CovBinType := GenBin(65535);
    -- Vector elements are:
    -- EnableInS_Int
    -- DataInS
    -- SelInS
    -- EnableInD_Int
    -- DataInD
    -- SelInD
    constant INPUT_BINS: CovMatrix6Type := (
        GenCross(GenBin(0), singleRegData, singleRegAddr, GenBin(0), doubleRegData, doubleRegAddr) &  -- No writing enabled
        GenCross(GenBin(0), singleRegData, singleRegAddr, GenBin(1), doubleRegData, doubleRegAddr) &  -- Write double reg
        GenCross(GenBin(1), singleRegData, singleRegAddr, GenBin(0), doubleRegData, doubleRegAddr) &  -- Write single reg
        GenCross(GenBin(1), singleRegData, singleRegAddr, GenBin(1), doubleRegData, doubleRegAddr)    -- Write both double and single simultaneous
    );

    -- Vector Elements are:
    -- SelOutA_tv
    -- SelOutB_tv
    -- SelOutD_tv
    constant OUTPUT_BINS: CovMatrix3Type := (
        GenCross(singleRegAddr, singleRegAddr, doubleRegAddr)
    );
    shared variable InputRegCov : CovPType;
    shared variable OutputRegCov : CovPType;

    -- Scoreboard user guide: https://github.com/OSVVM/Documentation/blob/master/ScoreboardPkg_user_guide.pdf
    shared variable RegScoreBoard : ScoreBoardPkg_slv.ScoreboardPType;

    type reg_array_t is array (AVR_REG_CONST.REG_COUNT - 1 downto 0) of
                            AVR.reg_s_data_t;
    signal expect_reg : reg_array_t;

    procedure CheckTestResult(tb_id: integer; idx: integer; act_slv : AVR.reg_s_data_t) is
    begin
        AffirmIf(
            tb_id,
            expect_reg(idx) = act_slv,
            " Mismatch at (" & to_string(idx) & ") with actual " & to_string(act_slv) & " != expected " & to_string(expect_reg(idx)));
    end procedure;

begin

    UUT: AvrReg port map (
        clk => clk,
        EnableInS => EnableInS,
        DataInS => DataInS,
        SelInS => SelInS,
        EnableInD => EnableInD,
        DataInD => DataInD,
        SelInD => SelInD,
        SelOutA => SelOutA,
        DataOutA => DataOutA,
        SelOutB => SelOutB,
        DataOutB => DataOutB,
        SelOutD => SelOutD,
        DataOutD => DataOutD
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

    --EnableInS <= to_std_logic(EnableInS_tv);
    --EnableInD <= to_std_logic(EnableInD_tv);

    StimulusProc: process
        -- Input stimulus variables
        variable EnableInS_tv   : integer;
        variable DataInS_tv     : integer;
        variable SelInS_tv      : integer;
        variable EnableInD_tv   : integer;
        variable DataInD_tv     : integer;
        variable SelInD_tv      : integer;

        variable SelOutA_tv     : integer;
        variable DataOutA_tv    : integer;
        variable SelOutB_tv     : integer;
        variable DataOutB_tv    : integer;
        variable SelOutD_tv     : integer;
        variable DataOutD_tv    : integer;
    begin
        SetAlertLogName("REG_Test1");
        
        -- Define coverage model
        InputRegCov.AddBins(INPUT_BINS);
        OutputRegCov.AddBins(OUTPUT_BINS);

        -- Synchronize clock at beginning of test
        wait until rising_edge(clk);

        -- TODO(WHW): Clear all the registers to begin with, and load the same to the scoreboard.
        for reg_idx in 0 to AVR_REG_CONST.REG_COUNT-1 loop
            SelInS <= std_logic_vector(to_unsigned(reg_idx, SelInS'length));
            EnableInS <= '1';
            DataInS <= (others => '0');
            expect_reg(reg_idx) <= (others => '0');
            wait until rising_edge(clk);
        end loop;

        test_initialized <= TRUE;
        while not (InputRegCov.IsCovered and OutputRegCov.IsCovered) loop -- Max test count of 1000
            (EnableInS_tv, DataInS_tv, SelInS_tv, EnableInD_tv, DataInD_tv, SelInD_tv) := InputRegCov.GetRandPoint;
            -- Assign test vector to signals
            EnableInS <= to_std_logic(EnableInS_tv);
            DataInS <= std_logic_vector(to_unsigned(DataInS_tv, DataInS'length ));
            SelInS <= std_logic_vector(to_unsigned(SelInS_tv, SelInS'length));
            EnableInD <= to_std_logic(EnableInD_tv);
            DataInD <= std_logic_vector(to_unsigned(DataInD_tv, DataInD'length));
            SelInD <= std_logic_vector(to_unsigned(SelInD_tv, SelInD'length));

            --RegScoreBoard.Push(to_string(SelInS_tv), DataInS);
            --RegScoreBoard.Push(to_string(SelInD_tv*2 + 0 + 24), DataInD(AVR.WORDSIZE-1 downto 0));
            --RegScoreBoard.Push(to_string(SelInD_tv*2 + 1 + 24), DataInD(2*AVR.WORDSIZE-1 downto AVR.WORDSIZE));

            (SelOutA_tv, SelOutB_tv, SelOutD_tv) := OutputRegCov.GetRandPoint;
            SelOutA <= std_logic_vector(to_unsigned(SelOutA_tv, SelOutA'length));
            SelOutB <= std_logic_vector(to_unsigned(SelOutB_tv, SelOutB'length));
            SelOutD <= std_logic_vector(to_unsigned(SelOutD_tv, SelOutD'length));

            wait until rising_edge(clk);

            -- Store the clocked in values
            -- Single Reg will take precedence, so clock in double first.
            if EnableInD = '1' then
                expect_reg(SelInD_tv*2 + 24) <= DataInD(AVR.WORDSIZE-1 downto 0);
                expect_reg(SelInD_tv*2 + 25) <= DataInD(2*AVR.WORDSIZE-1 downto AVR.WORDSIZE);
            end if;
            if EnableInS = '1' then
                expect_reg(SelInS_tv) <= DataInS;
            end if;
            

            InputRegCov.ICover((EnableInS_tv, DataInS_tv, SelInS_tv, EnableInD_tv, DataInD_tv, SelInD_tv));
            OutputRegCov.ICover((SelOutA_tv, SelOutB_tv, SelOutD_tv));
        end loop;
        -- Write coverage result
        InputRegCov.WriteBin;
        OutputRegCov.WriteBin;

        -- Done with testing
        wait for 100 ms;
        done <= TRUE;
        wait;
    end process StimulusProc;

    CheckProc: process
        variable dreg_low_idx : integer;
        variable dreg_high_idx : integer;
        variable sreg_a_idx : integer;
        variable sreg_b_idx : integer;
        variable tb_id : integer;
    begin
        tb_id := GetAlertLogID("AVR_REG", ALERTLOG_BASE_ID);
        SetAlertStopCount(tb_id, ERROR, 50);
        wait until test_initialized = TRUE;
        while not done loop
            wait until falling_edge(clk);
            dreg_low_idx := to_integer(unsigned(SelOutD))*2 + 24;
            dreg_high_idx := to_integer(unsigned(SelOutD))*2 + 25;
            sreg_a_idx := to_integer(unsigned(SelOutA));
            sreg_b_idx := to_integer(unsigned(SelOutB));
            -- Check double reg output
            CheckTestResult(tb_id, dreg_low_idx,  DataOutD(AVR.WORDSIZE-1 downto 0));
            CheckTestResult(tb_id, dreg_high_idx,  DataOutD(2*AVR.WORDSIZE-1 downto AVR.WORDSIZE));
            CheckTestResult(tb_id, sreg_a_idx, DataOutA);
            CheckTestResult(tb_id, sreg_b_idx, DataOutB);
            --RegScoreBoard.Check(to_string(dreg_low_idx), DataOutD(AVR.WORDSIZE-1 downto 0));
            --RegScoreBoard.Check(to_string(dreg_high_idx), DataOutD(2*AVR.WORDSIZE-1 downto AVR.WORDSIZE));
            --RegScoreBoard.Check(to_string(sreg_a_idx), DataOutA);
            --RegScoreBoard.Check(to_string(sreg_b_idx), DataOutB);
        end loop;
    end process CheckProc;

end architecture testbench;
