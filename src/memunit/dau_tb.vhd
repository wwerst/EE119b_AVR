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
--      20 Feb 21   Eric Chen   Set larger AtLeast on bins
--      22 Feb 21   Eric Chen   Merge register inputs
--      27 Mar 21   Will Werst  Fix stack starting at 0000 instead of
--                              FFFF. See git history for more details.
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
            reset       : in  std_logic;
            SrcSel      : in  DAU.source_t;
            PDB         : in  std_logic_vector(15 downto 0);
            reg         : in  std_logic_vector(15 downto 0);
            OffsetSel   : in  DAU.offset_t;
            array_off   : in  std_logic_vector(5 downto 0);
            Address     : out AVR.addr_t;
            Update      : out AVR.addr_t
        );
    end component;

    -- test bench clcok and done
    constant CLK_PERIOD : time := 1 ms;
    signal clk          : std_logic := '0';
    signal reset        : std_logic := '1';
    signal done         : boolean := FALSE;

    -- dau signals
    signal srcSel           : DAU.source_t;
    signal PDB              : std_logic_vector(15 downto 0);
    signal reg              : std_logic_vector(15 downto 0);
    signal OffsetSel        : DAU.offset_t;
    signal array_off        : std_logic_vector(5 downto 0);
    signal address, update  : AVR.addr_t;

    -- test bench signals
    signal srcValue, offsetValue            : integer := 0;
    signal expected_stack                   : integer := 2**16 - 1;
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
        signal pdb, reg : out AVR.addr_t
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
        reg <= rv.RandSlv(reg'LENGTH);
        -- set source based on selection
        if src_v = DAU.SRC_PDB then
            pdb <= std_logic_vector(to_unsigned(src, pdb'LENGTH));
        elsif src_v = DAU.SRC_REG then
            reg <= std_logic_vector(to_unsigned(src, reg'LENGTH));
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
        (DAU.SRC_REG    , 0                 , DAU.OFF_NEGONE, 42),
        -- overflow with increment
        (DAU.SRC_REG    , 2**AVR.ADDRSIZE-1 , DAU.OFF_ONE   , 42),
        -- overflow with array offset
        (DAU.SRC_REG    , 2**AVR.ADDRSIZE-42, DAU.OFF_ARRAY , 57)
    );
    shared variable covBin  : CovPType;
    constant BINS           : CovMatrix4Type := (
        -- all registers can be accessed, incremented, or decremented
        GenCross(
            AtLeast => 50,
            Bin1 => GenBin(DAU.SRC_REG),
            Bin2 => unsignedBin(PDB),
            Bin3 => GenBin(DAU.OFF_ZERO) & GenBin(DAU.OFF_ONE) & GenBin(DAU.OFF_NEGONE),
            Bin4 => unsignedBin(array_off)
        ) &
        -- Y and Z registers additionally support array offsets
        GenCross(
            AtLeast => 50,
            Bin1 => GenBin(DAU.SRC_REG),
            Bin2 => unsignedBin(PDB),
            Bin3 => GenBin(DAU.OFF_ARRAY),
            Bin4 => unsignedBin(array_off)
        ) &
        -- stack supports push and pop
        GenCross(
            AtLeast => 50,
            Bin1 => GenBin(DAU.SRC_STACK),
            Bin2 => unsignedBin(PDB),
            Bin3 => GenBin(DAU.OFF_ONE) & GenBin(DAU.OFF_NEGONE),
            Bin4 => unsignedBin(array_off)
        ) &
        -- PDB can only be used directly
        GenCross(
            AtLeast => 50,
            Bin1 => GenBin(DAU.SRC_PDB),
            Bin2 => unsignedBin(PDB),
            Bin3 => GenBin(DAU.OFF_ZERO),
            Bin4 => unsignedBin(array_off)
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
        reset => reset,
        srcSel => srcSel,
        pdb => pdb,
        reg => reg,
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
        reset <= '0';
        wait until rising_edge(clk);
        reset <= '1';
        wait until rising_edge(clk);

        for i in tests'LOW to tests'HIGH loop
            wait until rising_edge(clk);
            applyStimulus(tests(i), srcSel, srcValue, offsetSel, offsetValue,
                array_off, pdb, reg);

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
                array_off, pdb, reg);

            -- check both outputted addresses
            AffirmIf(alertId, address = expected_address, "address mismatch");
            AffirmIf(alertId, update = expected_update, "update mismatch");
        end loop;
        done <= TRUE;
        --covBin.WriteBin;

        wait;
    end process;

    process(all)
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
    end process;

    process(clk)
    begin
        -- if doing a stack access, update stack pointer on clock
        if rising_edge(clk) then
            if srcSel = DAU.SRC_STACK then
                expected_stack <= to_integer(unsigned(expected_update));
            end if;
        end if;
    end process;
end architecture testbench;

