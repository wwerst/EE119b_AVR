


library ieee;
use ieee.std_logic_1164.all;

use work.AVR;
use work.AvrReg;

library osvvm;
use osvvm.CoveragePkg.all;


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
    component UUTAvrReg
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
            SelOutA     : out AVR.reg_s_sel_t;
            DataOutA    : out AVR.reg_s_data_t;

            -- Single register B output
            SelOutB     : out AVR.reg_s_sel_t;
            DataOutB    : out AVR.reg_s_data_t;

            -- Double register output
            SelOutD     : out AVR.reg_d_sel_t;
            DataOutD    : out AVR.reg_d_data_t
        );
    end component UUTAvrReg;
    shared variable RegCov : CovPType;
begin

    TestControl: process
    begin
        --osvvm.SetAlertLogName("Test_AvrReg_1");
        wait;
    end process TestControl;

    TestLoop: process
        variable tv_data_in_s: integer;
    begin
        -- Define coverage model
        RegCov.AddBins(GenBin(AtLeast => 1, Min => 0, Max => 100, NumBin => 100));

        for i in 1 to 1000 loop -- Max test count of 1000
            tv_data_in_s := RegCov.GetRandPoint;
            RegCov.ICover(tv_data_in_s);
            exit when RegCov.IsCovered;
        end loop;
        -- Write coverage result
        RegCov.WriteBin;

        -- Done with testing
        wait;
    end process TestLoop;

end architecture testbench;
