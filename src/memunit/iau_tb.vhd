---------------------------------------------------------------------

-- AVR IAU Testbench

-- This is a test of the AVR IAU.
-- It inputs all supported sources and offsets,
-- and checks that the program counter is updated correctly.

-- Entities included are
--      iau_tb: the test bench itself

-- Revision History:
--      08 Feb 21   Eric Chen   Write and pass IAU tests
--      12 Feb 21   Eric Chen   Actually test source select
--      15 Feb 21   Eric Chen   Use component declaration
--                              Comments and formatting
--      17 Feb 21   Eric Chen   take far too long to figure out vhdl procedures
--                              Add non-random tests
--      20 Feb 21   Eric Chen   Set larger AtLeast on bins

---------------------------------------------------------------------


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
    component AvrIau
        port(
            clk         : in  std_logic;
            reset       : in  std_logic;
            SrcSel      : in  IAU.source_t;
            branch      : in  std_logic_vector(6 downto 0);
            jump        : in  std_logic_vector(11 downto 0);
            PDB         : in  AVR.addr_t;
            DDB         : in  std_logic_vector(7 downto 0);
            Z           : in  AVR.addr_t;
            OffsetSel   : in  IAU.offset_t;
            Address     : out AVR.addr_t
        );
    end component;

    -- Set up test bench clock and done signal
    constant CLK_PERIOD : time      := 1 ms;
    signal clk          : std_logic := '0';
    signal reset        : std_logic := '1';
    signal done         : boolean   := FALSE;

    -- signals for IAU
    signal srcSel       : IAU.source_t;
    signal branch       : std_logic_vector(6 downto 0);
    signal jump         : std_logic_vector(11 downto 0);
    signal PDB          : AVR.addr_t;
    signal DDB          : std_logic_vector(7 downto 0);
    signal Z            : AVR.addr_t;
    signal OffsetSel    : IAU.offset_t;
    signal address      : AVR.addr_t;

    -- test bench signals, expected values
    signal offsetValue: integer := 0;
    signal expected_pc: integer;
    signal expected_address: AVR.addr_t;

    -- test bench functions
    -- OSVVM bins for a std_logic_vector representing a signed number
    function signedBin(slv: std_logic_vector) return CovBinType is begin
        return GenBin(-2**(slv'LENGTH-1), 2**(slv'LENGTH-1) - 1, slv'LENGTH);
    end function;
    -- OSVVM bins for a std_logic_vector representing an unsigned number
    function unsignedBin(slv: std_logic_vector) return CovBinType is begin
        return GenBin(0, 2**slv'LENGTH - 1, slv'LENGTH);
    end function;

    shared variable rv: RandomPType;
    subtype stimulus_t is integer_vector(1 to 3);
    procedure applyStimulus (
        stimulus            : stimulus_t;
        signal srcSel, offsetSel: out integer;
        signal offsetValue  : out integer;
        signal branch       : out std_logic_vector(6 downto 0);
        signal jump         : out std_logic_vector(11 downto 0);
        signal PDB          : out AVR.addr_t;
        signal DDB          : out std_logic_vector(7 downto 0);
        signal Z            : out AVR.addr_t
   ) is 
        variable src_v, off_v, off  : integer;
    begin
            (src_v, off_v, off) := stimulus;
            srcSel      <= src_v;
            offsetsel   <= off_v;
            offsetValue <= off;
            -- by default, all offset values are random
            branch      <= rv.RandSlv(branch'LENGTH);
            jump        <= rv.RandSlv(jump'LENGTH);
            pdb         <= rv.RandSlv(pdb'LENGTH);
            ddb         <= rv.RandSlv(ddb'LENGTH);
            z           <= rv.RandSlv(z'LENGTH);

            -- depending on which offset is selected,
            -- convert offset to correct format and place in correct signal
            if    off_v = IAU.OFF_BRANCH then
                branch  <= std_logic_vector(to_signed(off, branch'LENGTH));
            elsif off_v = IAU.OFF_JUMP then
                jump    <= std_logic_vector(to_signed(off, jump'LENGTH));
            elsif off_v = IAU.OFF_Z then
                z       <= std_logic_vector(to_unsigned(off, z'LENGTH));
            elsif off_v = IAU.OFF_PDB then
                pdb     <= std_logic_vector(to_unsigned(off, pdb'LENGTH));
            elsif off_v = IAU.OFF_DDBLO or off_v = IAU.OFF_DDBHI then
                ddb     <= std_logic_vector(to_unsigned(off, ddb'LENGTH));
            end if;

    end applyStimulus;

    -- Declare test coverage
    -- non random tests:
    type vectors_t is array(integer range <>) of stimulus_t;
    constant tests  : vectors_t := (
        -- minimum and maximum of each offset
        (IAU.SRC_ZERO   , IAU.OFF_BRANCH,-2**6      ),
        (IAU.SRC_ZERO   , IAU.OFF_BRANCH, 2**6-1    ),
        (IAU.SRC_ZERO   , IAU.OFF_JUMP  ,-2**11     ),
        (IAU.SRC_ZERO   , IAU.OFF_JUMP  , 2**11-1   ),
        (IAU.SRC_ZERO   , IAU.OFF_PDB   , 0         ),
        (IAU.SRC_ZERO   , IAU.OFF_PDB   , 2**16-1   ),
        (IAU.SRC_ZERO   , IAU.OFF_Z     , 0         ),
        (IAU.SRC_ZERO   , IAU.OFF_Z     , 2**16-1   ),
        (IAU.SRC_ZERO   , IAU.OFF_DDBLO , 0         ),
        (IAU.SRC_ZERO   , IAU.OFF_DDBLO , 2**8-1    ),
        (IAU.SRC_ZERO   , IAU.OFF_DDBHI , 0         ),
        (IAU.SRC_ZERO   , IAU.OFF_DDBHI , 2**8-1    ),
        -- set program counter to small value
        (IAU.SRC_ZERO, IAU.OFF_Z        , 42         ),
        -- under/overflow with branch offset
        (IAU.SRC_PC     , IAU.OFF_BRANCH,-53        ),
        (IAU.SRC_PC     , IAU.OFF_BRANCH, 57        ),
        -- under/overflow with jump offset
        (IAU.SRC_PC     , IAU.OFF_JUMP  ,-420       ),
        (IAU.SRC_PC     , IAU.OFF_JUMP  , 1080      ),
        -- overflow with PDB offset
        (IAU.SRC_PC     , IAU.OFF_PDB   , 2**16-1   ),
        -- overflow with Z offset
        (IAU.SRC_PC     , IAU.OFF_Z     , 2**16-1   ),
        -- set program counter to large value
        (IAU.SRC_ZERO   , IAU.OFF_Z     , 2**16-42  ),
        -- overflow with DDBLO offset
        (IAU.SRC_PC     , IAU.OFF_DDBLO , 63        ),
        -- overflow with DDBHI offset
        (IAU.SRC_PC     , IAU.OFF_DDBHI , 212       ),
        (IAU.SRC_PC     , IAU.OFF_DDBHI , 212       )
    );
    shared variable covBin: CovPType;
    constant srcBins: CovBinType := GenBin(0,IAU.SOURCES-1);
    -- Test combinations of sources, offsets, and values of the offset
    constant BINS: CovMatrix3Type := (
        GenCross(AtLeast => 1000,Bin1 => srcBins, Bin2 => GenBin(IAU.OFF_ZERO)  , Bin3 => GenBin(0)         ) &
        GenCross(AtLeast => 1000,Bin1 => srcBins, Bin2 => GenBin(IAU.OFF_ONE)   , Bin3 => GenBin(1)         ) &
        GenCross(AtLeast => 1000,Bin1 => srcBins, Bin2 => GenBin(IAU.OFF_BRANCH), Bin3 => signedBin(branch) ) &
        GenCross(AtLeast => 1000,Bin1 => srcBins, Bin2 => GenBin(IAU.OFF_JUMP)  , Bin3 => signedBin(jump)   ) &
        GenCross(AtLeast => 1000,Bin1 => srcBins, Bin2 => GenBin(IAU.OFF_PDB)   , Bin3 => unsignedBin(pdb)  ) &
        GenCross(AtLeast => 1000,Bin1 => srcBins, Bin2 => GenBin(IAU.OFF_Z)     , Bin3 => unsignedBin(z)    ) &
        GenCross(AtLeast => 1000,Bin1 => srcBins, Bin2 => GenBin(IAU.OFF_DDBLO) , Bin3 => unsignedBin(ddb)  ) &
        GenCross(AtLeast => 1000,Bin1 => srcBins, Bin2 => GenBin(IAU.OFF_DDBHI) , Bin3 => unsignedBin(ddb)  )
    );
begin
    clock_p: process begin
        -- toggle the clock until done
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
        reset => reset,
        srcSel => srcSel,
        branch => branch,
        jump => jump,
        pdb => pdb,
        ddb => ddb,
        z => z,
        offsetSel => offsetSel,
        address => address
    );

    -- testing process.
    -- generate stimuli and compare results until coverage complete
    test_p: process
        variable stimulus  : stimulus_t;  -- test stimulus
        variable alertId            : AlertLogIDType;
    begin
        -- set up the coverage and reporting
        covBin.AddBins(BINS);
        alertId := GetAlertLogID("AVRIAU", ALERTLOG_BASE_ID);
        --SetAlertStopCount(ERROR, 20);

        -- zero out PC
        wait until rising_edge(clk);
        srcSel <= IAU.SRC_ZERO;
        offsetSel <= IAU.OFF_Z;
        Z <= (others => '0');

        for i in tests'LOW to tests'HIGH loop
            wait until rising_edge(clk);
            applyStimulus(tests(i), srcSel, offsetSel, offsetValue,
                branch, jump, pdb, ddb, z);

            -- check pc is correct
            AffirmIf(alertId, address = expected_address, "mismatch");
        end loop;

        -- should not have trouble with intelligent coverage
        while not covBin.IsCovered loop
            wait until rising_edge(clk);
            -- get new stimulus
            stimulus := covBin.GetRandPoint;
            covBin.ICover(stimulus);
            -- record stimuli in signals

            applyStimulus(stimulus, srcSel, offsetSel, offsetValue,
                branch, jump, pdb, ddb, z);

            -- check pc is correct
            AffirmIf(alertId, address = expected_address, "mismatch");
        end loop;

        -- all coverage complete
        done <= TRUE;
        --covBin.WriteBin(WritePassFail => TRUE);
        wait;
    end process;

    -- computes expected results for test
    expected_p: process (clk)
        variable addr: integer := 0;
    begin
        -- start with selected source
        if srcSel = IAU.SRC_ZERO then
            addr := 0;
        else
            addr := expected_pc;
        end if;

        -- add selected offset.
        -- special case if setting the high bits from DDB
        if offsetSel = IAU.OFF_DDBHI then
            addr := (addr + offsetValue*(2**DDB'LENGTH)) mod 2**AVR.ADDRSIZE;
        -- otherwise, just add offset.
        else
            addr := (addr + offsetValue) mod 2**AVR.ADDRSIZE;
        end if;

        -- output result and update expected PC
        expected_address <= std_logic_vector(to_unsigned(addr, AVR.ADDRSIZE));
        if rising_edge(clk) then
            expected_pc <= addr;
        end if;

    end process;
end architecture testbench;

