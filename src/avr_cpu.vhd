----------------------------------------------------------------------------
--
--  Atmel AVR CPU
--
--  This is the implementation of the complete AVR CPU.
--
--  Revision History:
--     11 May 98  Glen George       Initial revision.
--      9 May 00  Glen George       Updated comments.
--      7 May 02  Glen George       Updated comments.
--     21 Jan 08  Glen George       Updated comments.
--     22 Feb 21  Eric Chen         Start sketching implementation
--
----------------------------------------------------------------------------


--
--  AVR_CPU
--
--  Inputs:
--    ProgDB - program memory data bus (16 bits)
--    Reset  - active low reset signal
--    INT0   - active low interrupt
--    INT1   - active low interrupt
--    clock  - the system clock
--
--  Outputs:
--    ProgAB - program memory address bus (16 bits)
--    DataAB - data memory address bus (16 bits)
--    DataWr - data write signal
--    DataRd - data read signal
--
--  Inputs/Outputs:
--    DataDB - data memory data bus (8 bits)
--

library ieee;
use ieee.std_logic_1164.all;
--use ieee.std_logic_arith.all;
use ieee.numeric_std.all;

use work.opcodes;
use work.AVR;
use work.IAU;
use work.DAU;
use work.ALUOp;

entity  AVR_CPU  is

    port (
        ProgDB  :  in     std_logic_vector(15 downto 0);   -- program memory data bus
        Reset   :  in     std_logic;                       -- reset signal (active low)
        INT0    :  in     std_logic;                       -- interrupt signal (active low)
        INT1    :  in     std_logic;                       -- interrupt signal (active low)
        clock   :  in     std_logic;                       -- system clock
        ProgAB  :  out    std_logic_vector(15 downto 0);   -- program memory address bus
        DataAB  :  out    std_logic_vector(15 downto 0);   -- data memory address bus
        DataWr  :  out    std_logic;                       -- data memory write enable (active low)
        DataRd  :  out    std_logic;                       -- data memory read enable (active low)
        DataDB  :  inout  std_logic_vector(7 downto 0)     -- data memory data bus
    );

end  AVR_CPU;

architecture dataflow of AVR_CPU is

    component AvrIau is
        port(
            clk         : in  std_logic;
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
    signal iau_branch      : std_logic_vector(6 downto 0);
    signal iau_jump        : std_logic_vector(11 downto 0);
    type iau_ctrl_t is record
        srcSel: IAU.source_t;
        offsetSel: IAU.offset_t;
    end record;
    signal iau_ctrl: iau_ctrl_t;


    component AvrReg is
        port (
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
    end component;

    type reg_read_ctrl_t is record
        -- Single register output selects
        SelOutA     : AVR.reg_s_sel_t;
        SelOutB     : AVR.reg_s_sel_t;
        -- Double register output selects
        SelOutD     : AVR.reg_d_sel_t;
    end record;
    signal reg_read_ctrl : reg_read_ctrl_t;

    -- Single register outputs
    signal reg_DataOutA    : AVR.reg_s_data_t;
    signal reg_DataOutB    : AVR.reg_s_data_t;
    -- Double register output
    signal reg_DataOutD    : AVR.reg_d_data_t;

    type reg_write_ctrl_t is record
        -- Single register input select
        EnableInS   : std_logic;
        SelInS      : AVR.reg_s_sel_t;
        -- Double register input select
        EnableInD   : std_logic;
        SelInD      : AVR.reg_d_sel_t;
    end record;
    signal reg_write_ctrl : reg_write_ctrl_t;
    -- Single register input
    signal reg_DataInS     : AVR.reg_s_data_t;
    -- Double register input
    signal reg_DataInD     : AVR.reg_d_data_t;


    component AvrDau is
        port(
            clk         : in  std_logic;
            SrcSel      : in  DAU.source_t;
            PDB         : in  std_logic_vector(15 downto 0);
            reg         : in  std_logic_vector(15 downto 0);
            OffsetSel   : in  DAU.offset_t;
            array_off   : in  std_logic_vector(5 downto 0);
            Address     : out AVR.addr_t;
            Update      : out AVR.addr_t
        );
    end component;
    signal dau_array_off   : std_logic_vector(5 downto 0);
    signal dau_Update      : AVR.addr_t;
    type dau_ctrl_t is record
        SrcSel      : DAU.source_t;
        OffsetSel   : DAU.offset_t;
    end record;
    signal dau_ctrl: dau_ctrl_t;

    component avr_alu is
        port(
            clk         : in   std_logic;
            ALUOpA      : in   AVR.word_t;   -- first operand
            ALUOpB      : in   AVR.word_t;   -- second operand
            ALUOpSelect : in   ALUOp.ALUOP_t;
            FlagMask    : in   AVR.word_t;   -- Flag mask. If 1, then update bit. If 0, leave bit unchanged.
            Status      : out  AVR.word_t;   -- Status register
            Result      : out  AVR.word_t    -- Output result
        );
    end component;
    signal alu_SReg     : AVR.word_t;   -- Status register
    signal alu_Result   : AVR.word_t;   -- Output result


    signal InstReg: std_logic_vector(15 downto 0);
    signal InstPayload: std_logic_vector(15 downto 0);

    signal decodeReg16d : integer range 0 to 15;
    signal decodeReg32d : integer range 0 to 31;

    -- state machine
    subtype decode_state_t is integer range 0 to 3;
    signal CurState, NextState: decode_state_t;

    type execute_op_data_t is record
        OpA            : AVR.word_t;
        OpB            : AVR.word_t;
        ALUOpCode      : ALUOp.ALUOP_t;
        ALUFlagMask    : AVR.word_t;
        writeRegEnS    : std_logic;
        writeRegSelS   : AVR.reg_s_sel_t;
        --writeRegEnD    : std_logic;
        --writeRegSelD   : AVR.reg_d_sel_t;
    end record;

    signal CurExecuteOpData, NextExecuteOpData : execute_op_data_t;

    type write_op_data_t is record
        dataS          : AVR.word_t;
        writeRegEnS    : std_logic;
        writeRegSelS   : AVR.reg_s_sel_t;
        --dataD          : AVR.word_t;
        --writeRegEnD    : std_logic;
        --writeRegSelD   : AVR.reg_d_sel_t;
    end record;

    signal CurWriteOpData, NextWriteOpData : write_op_data_t;


begin




    reg_u: AvrReg port map (
        clk       => clock,
        EnableInS => reg_write_ctrl.EnableInS,
        DataInS   => reg_DataInS,
        SelInS    => reg_write_ctrl.SelInS,
        EnableInD => reg_write_ctrl.EnableInD,
        DataInD   => reg_DataInD,
        SelInD    => reg_write_ctrl.SelInD,
        SelOutA   => reg_read_ctrl.SelOutA,
        DataOutA  => reg_DataOutA,
        SelOutB   => reg_read_ctrl.SelOutB,
        DataOutB  => reg_DataOutB,
        SelOutD   => reg_read_ctrl.SelOutD,
        DataOutD  => reg_DataOutD
    );

    iau_u: AvrIau port map (
        clk       => clock,
        SrcSel    => iau_ctrl.srcSel,
        branch    => iau_branch,
        jump      => iau_jump,
        PDB       => ProgDB,
        DDB       => DataDB,
        Z         => reg_DataOutD,
        OffsetSel => iau_ctrl.offsetSel,
        Address   => ProgAB
    );

    dau_u: AvrDau port map (
        clk       => clock,
        SrcSel    => dau_ctrl.SrcSel,
        PDB       => ProgDB,
        reg       => reg_DataOutD,
        OffsetSel => dau_ctrl.OffsetSel,
        array_off => dau_array_off,
        Address   => DataAB,
        Update    => dau_update
    );

    alu_u: avr_alu port map (
       clk         => clock,
       ALUOpA      => CurExecuteOpData.OpA,
       ALUOpB      => CurExecuteOpData.OpB,
       ALUOpSelect => CurExecuteOpData.ALUOpCode,
       FlagMask    => CurExecuteOpData.ALUFlagMask,
       Status      => alu_SReg,
       Result      => alu_result
    );

    -- Loads the data from ProgDB
    -- Can either be loaded into the instruction
    -- register normally, or into payload register
    InstrLatchProc: process(clk)
    begin
        if rising_edge(clk) then
            InstReg <= ProgDB;
        end if;
    end process InstrLatchProc;


    decodeReg16d <= to_integer(unsigned(InstReg(7 downto 4))) + 16;
    decodeReg32d <= to_integer(unsigned(InstReg(8 downto 4)));

    -- Combinational logic that calculates the following:
    --   iau_ctrl: Controls what the next address that is fetched is.
    --   dau_ctrl: Controls what the data access unit is doing.
    --   reg_read_ctrl: Controls what is being read from register unit.
    --   ExecuteOpData: The op that is passed to execute stage.
    --   
    DecodeProc: process(all)
        variable tmp_int : integer;
    begin
        -- Minimum instructions needed to start testing:
        -- BCLR
        -- LDI
        -- ADD
        -- IN Rd, $3F  ; Read status register
        -- ST X, Rd

        -- Assign defaults
        -- Only the below assigned variables should be changed in this,
        -- to avoid implied latch
        iau_ctrl.srcSel <= IAU.SRC_PC; -- Start from current program counter
        iau_ctrl.OffsetSel <= IAU.OFF_ONE; -- Increment address by one
        dau_ctrl.SrcSel <= DAU.SRC_REG; -- Keep dau address the same
        dau_ctrl.OffsetSel <= DAU.OFF_ZERO; -- Leave dau address unchanged
        reg_read_ctrl.SelOutA <= (others => '0');
        reg_read_ctrl.SelOutB <= (others => '0');
        reg_read_ctrl.SelOutD <= (others => '0');

        -- Default to executing a pass-through of OpA to result
        -- Done by adding OpA to OpB = 0, then making sure flags don't change.
        -- This makes passing data through to write unit easy.
        NextExecuteOpData.OpA <= (others => '0');
        NextExecuteOpData.OpB <= (others => '0');
        NextExecuteOpData.ALUOpCode <= ALUOp.ADD_Op;
        NextExecuteOpData.ALUFlagMask <= (others => '0');
        NextExecuteOpData.writeRegEnS <= '0';
        NextExecuteOpData.writeRegSelS <= (others => '0');

        if Reset = '0' then
            null;
        else
            if std_match(InstReg, OpBCLR) then
                tmp_int := to_integer(unsigned(InstReg(6 downto 4)));
                NextExecuteOpData.OpA <= alu_SReg;
                NextExecuteOpData.OpB(tmp_int) <= '1';
                NextExecuteOpData.ALUOpCode <= ALUOp.BCLR_Op;
            elsif std_match(InstReg, OpLDI) then
                -- Pass immediate through ALU into write unit
                NextExecuteOpData.writeRegEnS <= '1';
                NextExecuteOpData.writeRegSelS <= std_logic_vector(to_unsigned(decodeReg16d, 5));
                NextExecuteOpData.OpA(7 downto 4) <= InstReg(11 downto 8);
                NextExecuteOpData.OpA(3 downto 0) <= InstReg(3 downto 0);
            elsif std_match(InstReg, OpADD) then
                null;
            elsif std_match(InstReg, OpIN) then
                null;
            elsif std_match(InstReg, OpST) then
                null;
            else
                null;
            end if;
        end if;
    end process DecodeProc;

    -----------------
    -----------------
    -- Execute Unit
    -----------------
    -----------------

    -- This could be registered later
    CurExecuteOpData <= NextExecuteOpData;

    -- Connects with ALU and does ALU ops
    ExecuteProc: process(all)
    begin
        NextWriteOpData.dataS <= alu_Result;
        NextWriteOpData.writeRegEnS <= '0';
        NextWriteOpData.writeRegSelS <= (others => '0');
        if reset = '0' then
        else
            NextWriteOpData.writeRegEnS <= CurExecuteOpData.writeRegEnS;
            NextWriteOpData.writeRegSelS <= CurExecuteOpData.writeRegSelS;
        end if;
    end process ExecuteProc;


    -----------------
    -----------------
    -- Write Unit
    -----------------
    -----------------

    -- This could be registered later
    CurWriteOpData <= NextWriteOpData;

    -- Connects with Register write interface and writes data
    WriteProc: process(all)
    begin
        reg_write_ctrl.EnableInS <= CurWriteOpData.writeRegEnS;
        reg_write_ctrl.SelInS <= CurWriteOpData.writeRegSelS;
        reg_write_ctrl.EnableInD <= '0';
        reg_write_ctrl.SelInD <= (others => '0');
        reg_DataInS <= CurWriteOpData.dataS;
        reg_DataInD <= (others => '0');
        
    end process WriteProc;

end architecture;
