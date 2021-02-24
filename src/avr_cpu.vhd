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
use ieee.std_logic_arith.all;
use ieee.numeric_std.all;

use opcodes.opcodes.all;
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

    component AvrDau is
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
    signal dau_array_off   : std_logic_vector(5 downto 0);
    signal dau_Update      : AVR.addr_t;
    type dau_ctrl_t is record
        SrcSel      : DAU.source_t;
        OffsetSel   : DAU.offset_t;
    end record;

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

begin

    reg_u: AvrReg port map (
        clock,
        reg_ctrl.EnableInS,
        reg_DataInS,
        reg_ctrl.SelInS,
        reg_ctrl.SelInD,
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
        DataDB,
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


    DecodeProc: process -- process(CurState, decode_signals) -- Comb process
    begin
        -- Assigns to:
        --  All control signals
        --if std_match(ADIW) then
        --    if first_clock then
        --        ADD r1, r2
        --    elsif second_clock
        --        ADC r1, r2
        --    end if;
        --    controls <= something;
        --end if;
    end process DecodeProc;


    ALUMuxProc: process -- process(CurState, decode_signals) -- Maybe 
    begin
        -- Assigns to:
        --  ALUOpA
        --  ALUOpB
        
    end process ALUMuxProc;


    NextStateProc: process -- process(CurState, decode_signals)
    begin
        -- Assigns to:
        --  NextState
        -- Combinationally compute NextState
    end process NextStateProc;


    StoreStateProc: process(clock)
    begin
        if (rising_edge(clock)) then
            --CurState <= NextState;
        end if;
    end process StoreStateProc;



end architecture;
