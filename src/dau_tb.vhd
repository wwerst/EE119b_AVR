library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.AVR;
use work.DAU;

library osvvm;
use osvvm.AlertLogPkg.all;
use osvvm.RandomPkg.all;
use osvvm.CoveragePkg.all;

entity dau_tb is
end dau_tb;

architecture testbench of dau_tb is
    constant CLK_PERIOD: time := 1 ms;
    signal done: boolean := FALSE;
    signal clk: std_logic := '0';

    signal srcValue, offsetValue: integer := 0;

    signal srcSel: DAU.source_t;
    signal PDB: std_logic_vector(15 downto 0);
    signal X, Y, Z: std_logic_vector(15 downto 0);
    signal OffsetSel  : DAU.offset_t;
    signal array_off: std_logic_vector(5 downto 0);
    signal address, update: AVR.addr_t;

    signal expected_stack: integer := 0;
    signal expected_address, expected_update: AVR.addr_t;

    function signedBin(slv: std_logic_vector) return CovBinType is begin
        return GenBin(-2**(slv'LENGTH-1), 2**(slv'LENGTH-1) - 1, slv'LENGTH);
    end function;
    function unsignedBin(slv: std_logic_vector) return CovBinType is begin
        return GenBin(0, 2**slv'LENGTH - 1, slv'LENGTH);
    end function;

    shared variable covBin: CovPType;
    constant BINS: CovMatrix4Type := (
        -- all registers can be accessed, incremented, or decremented
        GenCross(
            GenBin(DAU.SRC_X) & GenBin(DAU.SRC_Y) & GenBin(DAU.SRC_Z),
            unsignedBin(PDB),
            GenBin(DAU.OFF_ZERO) & GenBin(DAU.OFF_ONE) & GenBin(DAU.OFF_NEGONE),
            unsignedBin(array_off)
        ) &
        -- Y and Z registers additionally support array offsets
        GenCross(
            GenBin(DAU.SRC_Y) & GenBin(DAU.SRC_Z),
            unsignedBin(PDB),
            GenBin(DAU.OFF_ARRAY),
            unsignedBin(array_off)
        ) &
        -- stack supports push and pop
        GenCross(
            GenBin(DAU.SRC_STACK),
            unsignedBin(PDB),
            GenBin(DAU.OFF_ONE) & GenBin(DAU.OFF_NEGONE),
            unsignedBin(array_off)
        ) &
        -- PDB can only be used directly
        GenCross(
            GenBin(DAU.SRC_PDB),
            unsignedBin(PDB),
            GenBin(DAU.OFF_ZERO),
            unsignedBin(array_off)
        )
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

    UUT: entity work.AvrDau port map (
        clk => clk,
        srcSel => srcSel,
        pdb => pdb,
        x => x,
        y => y,
        z => z,
        offsetSel => offsetSel,
        array_off => array_off,
        address => address,
        update => update
    );

    process
        variable rv: RandomPType;
        variable src_v, src, off_v, off: integer;
        variable alertId: AlertLogIDType;
    begin
        covBin.AddBins(BINS);
        alertId := GetAlertLogID("AVRDAU", ALERTLOG_BASE_ID);
        --SetAlertStopCount(ERROR, 20);

        while not covBin.IsCovered loop
            wait until rising_edge(clk);
            (src_v, src, off_v, off) := covBin.GetRandPoint;

            pdb <= rv.RandSlv(pdb'LENGTH);
            x <= rv.RandSlv(x'LENGTH);
            y <= rv.RandSlv(y'LENGTH);
            z <= rv.RandSlv(z'LENGTH);
            array_off <= rv.RandSlv(array_off'LENGTH);

            srcSel <= src_v;
            srcValue <= src;
            offsetsel <= off_v;
            offsetValue <= off;

            covBin.ICover((src_v, src, off_v, off));
            array_off <= std_logic_vector(to_unsigned(off, array_off'LENGTH));
            if src_v = DAU.SRC_PDB then
                pdb <= std_logic_vector(to_unsigned(src, pdb'LENGTH));
            elsif src_v = DAU.SRC_X then
                x <= std_logic_vector(to_unsigned(src, x'LENGTH));
            elsif src_v = DAU.SRC_Y then
                y <= std_logic_vector(to_unsigned(src, y'LENGTH));
            elsif src_v = DAU.SRC_Z then
                z <= std_logic_vector(to_unsigned(src, z'LENGTH));
            end if;

            AffirmIf(alertId, address = expected_address, "address mismatch");
            AffirmIf(alertId, update = expected_update, "update mismatch");
        end loop;
        done <= TRUE;
        --covBin.WriteBin;

        wait;
    end process;

    process (clk)
        variable addr, addroff: integer := 0;
    begin
        if srcSel = DAU.SRC_STACK then
            addr := expected_stack;
        else
            addr := srcValue;
        end if;
        if offsetSel = DAU.OFF_ONE then
            addroff := (addr + 1) mod 2**AVR.ADDRSIZE;
        elsif offsetSel = DAU.OFF_ZERO then
            addroff := (addr + 0) mod 2**AVR.ADDRSIZE;
        elsif offsetSel = DAU.OFF_NEGONE then
            addroff := (addr - 1) mod 2**AVR.ADDRSIZE;
        elsif offsetSel = DAU.OFF_ARRAY then
            addroff := (addr + offsetValue) mod 2**AVR.ADDRSIZE;
        end if;

        -- pre update
        if ((srcSel = DAU.SRC_X or srcSel = DAU.SRC_Y or srcSel = DAU.SRC_Z) and offsetSel = DAU.OFF_NEGONE) 
            or (srcSel = DAU.SRC_STACK and offsetSel = DAU.OFF_ONE) then
            expected_address <= std_logic_vector(to_unsigned(addroff, AVR.ADDRSIZE));
            expected_update <= std_logic_vector(to_unsigned(addroff, AVR.ADDRSIZE));
        -- post update
        elsif ((srcSel = DAU.SRC_X or srcSel = DAU.SRC_Y or srcSel = DAU.SRC_Z) and offsetSel = DAU.OFF_ONE) 
            or (srcSel = DAU.SRC_STACK and offsetSel = DAU.OFF_NEGONE) then
            expected_address <= std_logic_vector(to_unsigned(addr, AVR.ADDRSIZE));
            expected_update <= std_logic_vector(to_unsigned(addroff, AVR.ADDRSIZE));
        -- no update
        else
            expected_address <= std_logic_vector(to_unsigned(addroff, AVR.ADDRSIZE));
            expected_update <= std_logic_vector(to_unsigned(addr, AVR.ADDRSIZE));
        end if;

        if rising_edge(clk) then
            if srcSel = DAU.SRC_STACK then
                expected_stack <= addroff;
            end if;
        end if;

    end process;
end architecture testbench;

