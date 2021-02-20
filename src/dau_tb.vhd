---------------------------------------------------------------------

-- AVR DAU Testbench

-- This is a test of the AVR DAU.
-- It inputs all supported sources and offsets,
-- and checks that the addresses output are correct.

-- Entities included are
--      dau_tb: the test bench itself

-- Revision History:
--      12 Feb 21   Eric Chen   start DAU tests
--      15 Feb 21   Eric Chen   Use component declaration
--                              Comments and formatting
--      17 Feb 21   Eric Chen   Add non-random tests

---------------------------------------------------------------------

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
    component AvrDau
        port(
            clk         : in  std_logic;
            SrcSel      : in  DAU.source_t;
            PDB         : in  std_logic_vector(15 downto 0);
            X, Y, Z     : in  std_logic_vector(15 downto 0);
            OffsetSel   : in  DAU.offset_t;
            array_off   : in  std_logic_vector(5 downto 0);
            Address     : out AVR.addr_t;
            Update      : out AVR.addr_t
        );
    end component;

    -- test bench clcok and done
    constant CLK_PERIOD : time := 1 ms;
    signal clk          : std_logic := '0';
    signal done         : boolean := FALSE;

    -- dau signals
    signal srcSel           : DAU.source_t;
    signal PDB              : std_logic_vector(15 downto 0);
    signal X, Y, Z          : std_logic_vector(15 downto 0);
    signal OffsetSel        : DAU.offset_t;
    signal array_off        : std_logic_vector(5 downto 0);
    signal address, update  : AVR.addr_t;

    -- test bench signals
    signal srcValue, offsetValue            : integer := 0;
    signal expected_stack                   : integer := 0;
    signal expected_address, expected_update: AVR.addr_t;

    -- test bench functions
    function signedBin(slv: std_logic_vector) return CovBinType is begin
        return GenBin(-2**(slv'LENGTH-1), 2**(slv'LENGTH-1) - 1, slv'LENGTH);
    end function;

    function unsignedBin(slv: std_logic_vector) return CovBinType is begin
        return GenBin(0, 2**slv'LENGTH - 1, slv'LENGTH);
    end function;

    shared variable rv: RandomPType;
    subtype stimulus_t is integer_vector(1 to 4);
    procedure applyStimulus(
        stimulus: stimulus_t;
        signal srcSel, srcValue, offsetSel, offsetValue: out integer;
        signal array_off: out std_logic_vector(5 downto 0);
        signal pdb, x, y, z: out AVR.addr_t
    ) is 
        variable src_v, src, off_v, off: integer;
    begin
        (src_v, src, off_v, off) := stimulus;
        -- store stimulus into signals
        srcSel <= src_v;
        srcValue <= src;
        offsetsel <= off_v;
        offsetValue <= off;

        -- we only control one offset
        array_off <= std_logic_vector(to_unsigned(off, array_off'LENGTH));

        -- sources are random by default
        pdb <= rv.RandSlv(pdb'LENGTH);
        x <= rv.RandSlv(x'LENGTH);
        y <= rv.RandSlv(y'LENGTH);
        z <= rv.RandSlv(z'LENGTH);
        -- set source based on selection
        if src_v = DAU.SRC_PDB then
            pdb <= std_logic_vector(to_unsigned(src, pdb'LENGTH));
        elsif src_v = DAU.SRC_X then
            x <= std_logic_vector(to_unsigned(src, x'LENGTH));
        elsif src_v = DAU.SRC_Y then
            y <= std_logic_vector(to_unsigned(src, y'LENGTH));
        elsif src_v = DAU.SRC_Z then
            z <= std_logic_vector(to_unsigned(src, z'LENGTH));
        end if;
    end procedure;

    -- declare coverage
    type vectors_t is array(integer range <>) of stimulus_t;
    constant tests  : vectors_t := (
        -- underflow stack
        (DAU.SRC_STACK  , 42                , DAU.OFF_NEGONE, 42),
        (DAU.SRC_STACK  , 42                , DAU.OFF_NEGONE, 42),
        (DAU.SRC_STACK  , 42                , DAU.OFF_NEGONE, 42),
        -- overflow stack
        (DAU.SRC_STACK  , 42                , DAU.OFF_ONE   , 42),
        (DAU.SRC_STACK  , 42                , DAU.OFF_ONE   , 42),
        (DAU.SRC_STACK  , 42                , DAU.OFF_ONE   , 42),
        (DAU.SRC_STACK  , 42                , DAU.OFF_ONE   , 42),
        (DAU.SRC_STACK  , 42                , DAU.OFF_ONE   , 42),
        -- underflow with a decrement
        (DAU.SRC_X      , 0                 , DAU.OFF_NEGONE, 42),
        (DAU.SRC_Y      , 0                 , DAU.OFF_NEGONE, 42),
        (DAU.SRC_Z      , 0                 , DAU.OFF_NEGONE, 42),
        -- overflow with increment
        (DAU.SRC_X      , 2**AVR.ADDRSIZE-1 , DAU.OFF_ONE   , 42),
        (DAU.SRC_Y      , 2**AVR.ADDRSIZE-1 , DAU.OFF_ONE   , 42),
        (DAU.SRC_Z      , 2**AVR.ADDRSIZE-1 , DAU.OFF_ONE   , 42),
        -- overflow with array offset
        (DAU.SRC_Y      , 2**AVR.ADDRSIZE-42, DAU.OFF_ARRAY , 57),
        (DAU.SRC_Z      , 2**AVR.ADDRSIZE-42, DAU.OFF_ARRAY , 57)
    );
    shared variable covBin  : CovPType;
    constant BINS           : CovMatrix4Type := (
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
    clock_p: process begin
        while not done loop
            clk <= '0';
            wait for CLK_PERIOD/2;
            clk <= '1';
            wait for CLK_PERIOD/2;
        end loop;
        wait;
    end process;

    UUT: AvrDau port map (
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

    -- stimulus and check process
    test_p: process
        variable stimulus: stimulus_t;
        variable alertId: AlertLogIDType;
    begin
        covBin.AddBins(BINS);
        alertId := GetAlertLogID("AVRDAU", ALERTLOG_BASE_ID);
        --SetAlertStopCount(ERROR, 20);

        -- initializtion
        srcSel <= DAU.SRC_PDB;
        offsetSel <= DAU.OFF_ZERO;
        pdb <= (others => '0');
        wait until rising_edge(clk);

        for i in tests'LOW to tests'HIGH loop
            wait until rising_edge(clk);
            applyStimulus(tests(i), srcSel, srcValue, offsetSel, offsetValue,
                array_off, pdb, x, y, z);

            -- check both outputted addresses
            AffirmIf(alertId, address = expected_address, "address mismatch");
            AffirmIf(alertId, update = expected_update, "update mismatch");
        end loop;

        while not covBin.IsCovered loop
            wait until rising_edge(clk);
            -- get new stimulus
            stimulus := covBin.GetRandPoint;
            covBin.ICover(stimulus);
            applyStimulus(stimulus, srcSel, srcValue, offsetSel, offsetValue,
                array_off, pdb, x, y, z);

            -- check both outputted addresses
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
        -- only special input is the stack
        if srcSel = DAU.SRC_STACK then
            addr := expected_stack;
        else
            addr := srcValue;
        end if;
        -- compute the address with offset
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
        if ((srcSel /= DAU.SRC_STACK) and offsetSel = DAU.OFF_NEGONE) 
            or (srcSel = DAU.SRC_STACK and offsetSel = DAU.OFF_ONE) then
            expected_address <= std_logic_vector(to_unsigned(addroff, AVR.ADDRSIZE));
            expected_update <= std_logic_vector(to_unsigned(addroff, AVR.ADDRSIZE));
        -- post update
        elsif ((srcSel /= DAU.SRC_STACK) and offsetSel = DAU.OFF_ONE) 
            or (srcSel = DAU.SRC_STACK and offsetSel = DAU.OFF_NEGONE) then
            expected_address <= std_logic_vector(to_unsigned(addr, AVR.ADDRSIZE));
            expected_update <= std_logic_vector(to_unsigned(addroff, AVR.ADDRSIZE));
        -- no update
        else
            expected_address <= std_logic_vector(to_unsigned(addroff, AVR.ADDRSIZE));
            expected_update <= std_logic_vector(to_unsigned(addr, AVR.ADDRSIZE));
        end if;

        -- if doing a stack access, update stack pointer on clock
        if rising_edge(clk) then
            if srcSel = DAU.SRC_STACK then
                expected_stack <= addroff;
            end if;
        end if;

    end process;
end architecture testbench;

