
; Tests the flow control conditional branch instructions.
; These tests assume the BSET and BCLR instructions are functional.


;PREPROCESS TestBRBS
    BSET    0               ;
    BRBS    0      ,branchSet0;            bit set => branch should be taken
    .ORG    0x0010          ;
branchSet0:
    BCLR    0               ;
    BRBS    0      ,branchSet0;            bit cleared => branch should not be taken
    BSET    1               ;
    BRBS    1      ,branchSet1;            bit set => branch should be taken
    .ORG    0x0020          ;
branchSet1:
    BCLR    1               ;
    BRBS    1      ,branchSet1;            bit cleared => branch should not be taken
    BSET    2               ;
    BRBS    2      ,branchSet2;            bit set => branch should be taken
    .ORG    0x0030          ;
branchSet2:
    BCLR    2               ;
    BRBS    2      ,branchSet2;            bit cleared => branch should not be taken
    BSET    3               ;
    BRBS    3      ,branchSet3;            bit set => branch should be taken
    .ORG    0x0040          ;
branchSet3:
    BCLR    3               ;
    BRBS    3      ,branchSet3;            bit cleared => branch should not be taken
    BSET    4               ;
    BRBS    4      ,branchSet4;            bit set => branch should be taken
    .ORG    0x0050          ;
branchSet4:
    BCLR    4               ;
    BRBS    4      ,branchSet4;            bit cleared => branch should not be taken
    BSET    5               ;
    BRBS    5      ,branchSet5;            bit set => branch should be taken
    .ORG    0x0060          ;
branchSet5:
    BCLR    5               ;
    BRBS    5      ,branchSet5;            bit cleared => branch should not be taken
    BSET    6               ;
    BRBS    6      ,branchSet6;            bit set => branch should be taken
    .ORG    0x0070          ;
branchSet6:
    BCLR    6               ;
    BRBS    6      ,branchSet6;            bit cleared => branch should not be taken
    BSET    7               ;
    BRBS    7      ,branchSet7;            bit set => branch should be taken
    .ORG    0x0080          ;
branchSet7:
    BCLR    7               ;
    BRBS    7      ,branchSet7;            bit cleared => branch should not be taken

;PREPROCESS TestBRBC
    BCLR    0               ;
    BRBC    0      ,branchClear0;            bit clear => branch should be taken
    .ORG    0x0090          ;
branchClear0:
    BSET    0               ;
    BRBC    0      ,branchClear0;            bit set => branch should not be taken
    BCLR    1               ;
    BRBC    1      ,branchClear1;            bit clear => branch should be taken
    .ORG    0x00A0          ;
branchClear1:
    BSET    1               ;
    BRBC    1      ,branchClear1;            bit set => branch should not be taken
    BCLR    2               ;
    BRBC    2      ,branchClear2;            bit clear => branch should be taken
    .ORG    0x00B0          ;
branchClear2:
    BSET    2               ;
    BRBC    2      ,branchClear2;            bit set => branch should not be taken
    BCLR    3               ;
    BRBC    3      ,branchClear3;            bit clear => branch should be taken
    .ORG    0x00C0          ;
branchClear3:
    BSET    3               ;
    BRBC    3      ,branchClear3;            bit set => branch should not be taken
    BCLR    4               ;
    BRBC    4      ,branchClear4;            bit clear => branch should be taken
    .ORG    0x00D0          ;
branchClear4:
    BSET    4               ;
    BRBC    4      ,branchClear4;            bit set => branch should not be taken
    BCLR    5               ;
    BRBC    5      ,branchClear5;            bit clear => branch should be taken
    .ORG    0x00E0          ;
branchClear5:
    BSET    5               ;
    BRBC    5      ,branchClear5;            bit set => branch should not be taken
    BCLR    6               ;
    BRBC    6      ,branchClear6;            bit clear => branch should be taken
    .ORG    0x00F0          ;
branchClear6:
    BSET    6               ;
    BRBC    6      ,branchClear6;            bit set => branch should not be taken
    BCLR    7               ;
    BRBC    7      ,branchClear7;            bit clear => branch should be taken
    .ORG    0x0100          ;
branchClear7:
    BSET    7               ;
    BRBC    7      ,branchClear7;            bit set => branch should not be taken