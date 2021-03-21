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

entity  AVR_CPU_OLD  is

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

end  AVR_CPU_OLD;

architecture dataflow of AVR_CPU_OLD is

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
    -- Single register input
    signal reg_DataInS     : AVR.reg_s_data_t;
    -- Single register outputs
    signal reg_DataOutA    : AVR.reg_s_data_t;
    signal reg_DataOutB    : AVR.reg_s_data_t;
    -- Double register input
    signal reg_DataInD     : AVR.reg_d_data_t;
    -- Double register output
    signal reg_DataOutD    : AVR.reg_d_data_t;
    type reg_ctrl_t is record
        -- Single register input select
        EnableInS   : std_logic;
        SelInS      : AVR.reg_s_sel_t;
        -- Single register output selects
        SelOutA     : AVR.reg_s_sel_t;
        SelOutB     : AVR.reg_s_sel_t;
        -- Double register input select
        EnableInD   : std_logic;
        SelInD      : AVR.reg_d_sel_t;
        -- Double register output selects
        SelOutD     : AVR.reg_d_sel_t;
    end record;
    signal reg_ctrl: reg_ctrl_t;
    subtype reg_ssrc_t is std_logic_vector(1 downto 0);
    constant REG_SSRC_DDB: reg_ssrc_t := "00";
    constant REG_SSRC_ALU: reg_ssrc_t := "01";
    constant REG_SSRC_IMM: reg_ssrc_t := "10";
    signal reg_ssrc: reg_ssrc_t;

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
    signal alu_OpA      : AVR.word_t;   -- first operand
    signal alu_OpB      : AVR.word_t;   -- second operand
    signal alu_Status      : AVR.word_t;   -- Status register
    signal alu_Result      : AVR.word_t;   -- Output result
    type alu_ctrl_t is record
        FlagMask    : AVR.word_t;   -- Flag mask. If 1, then update bit. If 0, leave bit unchanged.
        OpSelect : ALUOp.ALUOP_t;
    end record;
    signal alu_ctrl: alu_ctrl_t;


    signal ir: std_logic_vector(15 downto 0);

    -- state machine
    subtype state_t is integer range 1 to 4;
    signal CurState, NextState: state_t;
    -- when we are on last state of instruction/need to load a new instruction
    signal isLastState: std_logic;

    -- register operands used for load/store
    signal regA, regB: std_logic_vector(4 downto 0);
    -- immediate value from instruction
    signal immediate: std_logic_vector(7 downto 0);
    -- array offset from instruction
    signal loadArr: std_logic_vector(5 downto 0);
begin

    reg_u: AvrReg port map (
        clock,
        reg_ctrl.EnableInS,
        reg_DataInS,
        reg_ctrl.SelInS,
        reg_ctrl.EnableInD,
        reg_DataInD,
        reg_ctrl.SelInD,
        reg_ctrl.SelOutA,
        reg_DataOutA,
        reg_ctrl.SelOutB,
        reg_DataOutB,
        reg_ctrl.SelOutD,
        reg_DataOutD
    );

    iau_u: AvrIau port map (
        clock,
        iau_ctrl.srcSel,
        iau_branch,
        iau_jump,
        ProgDB,
        DataDB,
        reg_DataOutD,
        iau_ctrl.offsetSel,
        ProgAB
    );

    dau_u: AvrDau port map (
        clock,
        dau_ctrl.SrcSel,
        ProgDB,
        reg_DataOutD,
        dau_ctrl.OffsetSel,
        dau_array_off,
        DataAB,
        dau_update
    );

    alu_u: avr_alu port map (
       clk         => clock,
       ALUOpA      => alu_opA,
       ALUOpB      => alu_opB,
       ALUOpSelect => alu_ctrl.OpSelect,
       FlagMask    => alu_ctrl.FlagMask,
       Status      => alu_status,
       Result      => alu_result
    );

    IRProc: process (clock) is begin
        if rising_edge(clock) then
            if isLastState = '1' then
                ir <= ProgDB;
            else
                ir <= ir;
            end if;
        end if;
    end process;

    DecodeProc: process (Reset, ir, CurState, alu_Status) is
    begin
        regA <= ir(8 downto 4);
        regB <= ir(9) & ir(3 downto 0);
        loadArr <= ir(13) & ir(11 downto 10) & ir(2 downto 0);

        -- defaults
        isLastState <= '1';
        -- increment PC
        iau_ctrl.srcSel <= IAU.SRC_PC;
        iau_ctrl.OffsetSel <= IAU.OFF_ONE;
        -- don't do stuff
        reg_ctrl.EnableInS <= '0';
        reg_ctrl.EnableInD <= '0';
        DataRd <= '1';
        DataWr <= '1';

        if (Reset = '0') then
            iau_ctrl.srcSel <= IAU.SRC_ZERO;
            iau_ctrl.OffsetSel <= IAU.OFF_ZERO;
        elsif std_match(ir, Opcodes.OpLD) then
            reg_ctrl.EnableInS <= '1';
            reg_ctrl.SelInS <= regA;
            reg_ssrc <= REG_SSRC_DDB;
            DataRd <= '0'; -- TODO rd and wr have special timing
            dau_ctrl.SrcSel <= DAU.SRC_REG;
            if std_match(ir, Opcodes.OPLDX) then
                reg_ctrl.SelOutD <= "01"; -- X register
                dau_ctrl.OffsetSel <= DAU.OFF_ZERO;
            elsif std_match(ir, Opcodes.OpLDXI) then
                reg_ctrl.SelOutD <= "01"; -- X register
                dau_ctrl.OffsetSel <= DAU.OFF_ONE;
            elsif std_match(ir, Opcodes.OpLDXD) then
                reg_ctrl.SelOutD <= "01"; -- X register
                dau_ctrl.OffsetSel <= DAU.OFF_NEGONE;
            elsif std_match(ir, Opcodes.OpLDYI) then
                reg_ctrl.SelOutD <= "10"; -- Y register
                dau_ctrl.OffsetSel <= DAU.OFF_ONE;
            elsif std_match(ir, Opcodes.OpLDYD) then
                reg_ctrl.SelOutD <= "10"; -- Y register
                dau_ctrl.OffsetSel <= DAU.OFF_NEGONE;
            elsif std_match(ir, Opcodes.OpLDZI) then
                reg_ctrl.SelOutD <= "11"; -- Z register
                dau_ctrl.OffsetSel <= DAU.OFF_ONE;
            elsif std_match(ir, Opcodes.OpLDZD) then
                reg_ctrl.SelOutD <= "11"; -- X register
                dau_ctrl.OffsetSel <= DAU.OFF_NEGONE;
            elsif std_match(ir, Opcodes.OpLDS) then
                isLastState <= '0';
                DataRd <= '1';
                dau_ctrl.srcSel <= DAU.SRC_PDB;
                dau_ctrl.offsetSel <= DAU.OFF_ZERO;
                reg_ctrl.EnableInS <= '0';
                if CurState = 1 then
                    iau_ctrl.offsetSel <= IAU.OFF_ZERO;
                    reg_ctrl.EnableInS <= '1';
                    DataRd <= '0';
                elsif CurState = 2 then
                elsif CurState = 3 then
                    isLastState <= '1';
                end if;
            elsif std_match(ir, Opcodes.OpPOP) then
                -- TODO pop
            end if;
        elsif std_match(ir, Opcodes.OpLDDY) then
            reg_ctrl.EnableInS <= '1';
            reg_ctrl.SelInS <= regA;
            reg_ssrc <= REG_SSRC_DDB;
            DataRd <= '1'; -- TODO rd and wr have special timing
            reg_ctrl.SelOutD <= "10"; -- Y register
            dau_ctrl <= (SrcSel => DAU.SRC_REG, OffsetSel => DAU.OFF_ARRAY);
        elsif std_match(ir, Opcodes.OpLDDZ) then
            reg_ctrl.EnableInS <= '1';
            reg_ctrl.SelInS <= regA;
            reg_ssrc <= REG_SSRC_DDB;
            DataRd <= '1'; -- TODO rd and wr have special timing
            reg_ctrl.SelOutD <= "11"; -- Z register
            dau_ctrl <= (SrcSel => DAU.SRC_REG, OffsetSel => DAU.OFF_ARRAY);
        elsif std_match(ir, Opcodes.OpLDI) then
            reg_ctrl.EnableInS <= '1';
            reg_ctrl.SelInS <= regA;
            reg_ssrc <= REG_SSRC_IMM;
        elsif std_match(ir, Opcodes.OpST) then
            reg_ctrl.SelOutA <= regA;
            DataWr <= '0'; -- TODO rd and wr have special timing
            if std_match(ir, Opcodes.OPSTX) then
            elsif std_match(ir, Opcodes.OPSTXI) then
            elsif std_match(ir, Opcodes.OPSTXD) then
            elsif std_match(ir, Opcodes.OPSTYI) then
            elsif std_match(ir, Opcodes.OPSTYD) then
            elsif std_match(ir, Opcodes.OPSTZI) then
            elsif std_match(ir, Opcodes.OPSTZD) then
            elsif std_match(ir, Opcodes.OPSTS) then
                isLastState <= '0';
                DataWr <= '1';
                dau_ctrl.srcSel <= DAU.SRC_PDB;
                dau_ctrl.offsetSel <= DAU.OFF_ZERO;
                if CurState = 1 then
                    iau_ctrl.offsetSel <= IAU.OFF_ZERO;
                    DataWr <= '0';
                elsif CurState = 2 then
                elsif CurState = 3 then
                    isLastState <= '1';
                end if;
            elsif std_match(ir, Opcodes.OPPUSH) then
            end if;
        end if;
    end process DecodeProc;

    with reg_ssrc select reg_DataInS <= 
        DataDB when REG_SSRC_DDB,
        alu_result when REG_SSRC_ALU,
        immediate when REG_SSRC_IMM,
        (reg_DataInS'RANGE => 'X') when others;

    --ALUMuxProc: process -- process(CurState, decode_signals) -- Maybe 
    --begin
    --    -- Assigns to:
    --    --  ALUOpA
    --    --  ALUOpB
    --    
    --end process ALUMuxProc;


    NextStateProc: process (CurState, isLastState)
    begin
        -- Assigns to:
        --  NextState
        -- Combinationally compute NextState
        NextState <= CurState + 1 when isLastState = '0' else 1;
    end process NextStateProc;


    StoreStateProc: process(clock)
    begin
        if (rising_edge(clock)) then
            CurState <= NextState;
        end if;
    end process StoreStateProc;



end architecture;
