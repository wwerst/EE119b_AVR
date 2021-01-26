def r(i):
    return f"r{i}"
def v(i):
    return f"${i:02X}"
def a(i):
    return f"${i:04X}"
class Instruction:
    data = {}
    def __init__(self, name="NOP", args=(), label=None, check=None, note=None):
        self.name = name
        self.args = args
        self.label = label
        self.check = check
        self.note = note

    def read(self, val, addr):
        self.check = ("R", f"{val:02X}", f"{addr:04X}")
        return self
    def write(self, val, addr):
        self.check = ("W", f"{val:02X}", f"{addr:04X}")
        return self
    def skip(self):
        self.check = ("S",)
        return self
    def __getitem__(self, label):
        self.label = label
        return self
    def __call__(self, note):
        self.note = note
        return self
    def __str__(self):
        label = self.label + ":\n" if self.label else ""
        args = ",".join(map(lambda s: f"{s:7}", self.args))
        check = " ".join(self.check) if self.check else ""
        comment = f"{check:12}{self.note}" if self.note else check
        return f"{label}    {self.name:8}{args:16};{comment}"
    __repr__ = __str__

def stringify(i):
    if isinstance(i, Instruction):
        return str(i)
    elif isinstance(i, str):
        return "\n"+i
    else:
        return "\n".join(map(stringify, i))
    
INSTRUCTIONS = set("""
ADC
ADD
ADIW
AND
ANDI
ASR
BCLR
BLD
BSET
BST
COM
CP
CPC
CPI
DEC
EOR
INC
LSR
NEG
OR
ORI
ROR
SBC
SBCI
SBIW
SUB
SUBI
SWAP
LD
LDD
LDI
LDS
MOV
ST
STD
STS
POP
PUSH
JMP
RJMP
IJMP
CALL
RCALL
ICALL
RET
RETI
BRBC
BRBS
CPSE
SBRC
SBRS
NOP""".split("\n"))
def makeInstructionFunction(instruction):
    return lambda *args: Instruction(instruction, args)
for i in INSTRUCTIONS:
    globals()[i] = makeInstructionFunction(i)