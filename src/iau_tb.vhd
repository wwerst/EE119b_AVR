library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.AVR;
use work.IAU;

library osvvm;
use osvvm.AlertLogPkg.all;
use osvvm.RandomPkg.all;
use osvvm.CoveragePkg.all;

entity iau_tb is
end iau_tb;

architecture testbench of iau_tb is
    constant CLK_PERIOD: time := 1 ms;
    signal done: boolean := FALSE;
    signal clk: std_logic := '0';

    signal offsetValue: integer := 0;

    signal srcSel: IAU.source_t;
    signal branch: std_logic_vector(6 downto 0);
    signal jump: std_logic_vector(11 downto 0);
    signal PDB: std_logic_vector(15 downto 0);
    signal DDB: std_logic_vector(7 downto 0);
    signal Z: std_logic_vector(15 downto 0);
    signal OffsetSel  : IAU.offset_t;
    signal address: AVR.addr_t;

    signal expected_pc: integer;
    signal expected_address: AVR.addr_t;

    function signedBin(slv: std_logic_vector) return CovBinType is begin
        return GenBin(-2**(slv'LENGTH-1), 2**(slv'LENGTH-1) - 1, slv'LENGTH);
    end function;
    function unsignedBin(slv: std_logic_vector) return CovBinType is begin
        return GenBin(0, 2**slv'LENGTH - 1, slv'LENGTH);
    end function;

    shared variable covBin: CovPType;
    constant srcBins: CovBinType := GenBin(0,IAU.SOURCES-1);
    constant BINS: CovMatrix3Type := (
        GenCross(srcBins, GenBin(IAU.OFF_ZERO), GenBin(0)) &
        GenCross(srcBins, GenBin(IAU.OFF_ONE), GenBin(1)) &
        GenCross(srcBins, GenBin(IAU.OFF_BRANCH), signedBin(branch)) &
        GenCross(srcBins, GenBin(IAU.OFF_JUMP), signedBin(jump)) &
        GenCross(srcBins, GenBin(IAU.OFF_PDB), unsignedBin(pdb)) &
        GenCross(srcBins, GenBin(IAU.OFF_Z), unsignedBin(z)) &
        GenCross(srcBins, GenBin(IAU.OFF_DDBLO), unsignedBin(ddb)) &
        GenCross(srcBins, GenBin(IAU.OFF_DDBHI), unsignedBin(ddb))
    );
begin
    process begin
        while not done loop
            clk <= '0';
            wait for CLK_PERIOD/2;
            clk <= '1';
            wait for CLK_PERIOD/2;
        end loop;
        wait;
    end process;

    UUT: entity work.AvrIau port map (
        clk => clk,
        srcSel => srcSel,
        branch => branch,
        jump => jump,
        pdb => pdb,
        ddb => ddb,
        z => z,
        offsetSel => offsetSel,
        address => address
    );

    process
        variable rv: RandomPType;
        variable src_v, off_v, off: integer;
        variable alertId: AlertLogIDType;
    begin
        covBin.AddBins(BINS);
        alertId := GetAlertLogID("AVRIAU", ALERTLOG_BASE_ID);
        --SetAlertStopCount(ERROR, 20);

        -- zero out PC
        wait until rising_edge(clk);
        srcSel <= IAU.SRC_ZERO;
        offsetSel <= IAU.OFF_Z;
        Z <= (others => '0');

        while not covBin.IsCovered loop
            wait until rising_edge(clk);
            (src_v, off_v, off) := covBin.GetRandPoint;

            srcSel <= src_v;
            branch <= rv.RandSlv(branch'LENGTH);
            jump <= rv.RandSlv(jump'LENGTH);
            pdb <= rv.RandSlv(pdb'LENGTH);
            ddb <= rv.RandSlv(ddb'LENGTH);
            z <= rv.RandSlv(z'LENGTH);
            offsetsel <= off_v;
            offsetValue <= off;

            covBin.ICover((src_v, off_v, off));
            if off_v = IAU.OFF_BRANCH then
                branch <= std_logic_vector(to_signed(off, branch'LENGTH));
            elsif off_v = IAU.OFF_JUMP then
                jump <= std_logic_vector(to_signed(off, jump'LENGTH));
            elsif off_v = IAU.OFF_Z then
                z <= std_logic_vector(to_unsigned(off, z'LENGTH));
            elsif off_v = IAU.OFF_PDB then
                pdb <= std_logic_vector(to_unsigned(off, pdb'LENGTH));
            elsif off_v = IAU.OFF_DDBLO or off_v = IAU.OFF_DDBHI then
                ddb <= std_logic_vector(to_unsigned(off, ddb'LENGTH));
            end if;

            AffirmIf(alertId, address = expected_address, "mismatch");
        end loop;
        done <= TRUE;
        covBin.WriteBin;

        wait;
    end process;

    process (clk)
        variable addr: integer := 0;
    begin
        if srcSel = IAU.SRC_ZERO then
            addr := 0;
        else
            addr := expected_pc;
        end if;
        if offsetSel = IAU.OFF_DDBHI then
            addr := (addr + offsetValue*(2**DDB'LENGTH)) mod 2**AVR.ADDRSIZE;
        else
            addr := (addr + offsetValue) mod 2**AVR.ADDRSIZE;
        end if;

        expected_address <= std_logic_vector(to_unsigned(addr, AVR.ADDRSIZE));
        if rising_edge(clk) then
            expected_pc <= addr;
        end if;

    end process;
end architecture testbench;

