""" Functions and classes for writing AVR assembly in python

Exports a function for every instruction, which returns a representation
using the Instruction class.
Also exports small helpers for displaying ints as register numbers,
8 bit hex values, and 16 bit hex values
"""

def r(i):
    """format an int as a register, like r10"""
    return f"r{i}"
def v(i):
    """format an int as an 8 bit hex literal, like $0F"""
    return f"${i:02X}"
def a(i):
    """format an int as a 16 bit hex literal, like $BEEF"""
    return f"${i:04X}"


class Instruction:
    """represents a single assembly instruction.
    overrides __call__ and __getitem__ to abuse syntax
    to make it nicer(?) to write long programs.
    Also provides support for adding/outputting test comments
    for the test vector generator.
    """
    def __init__(self, name="NOP", args=(), label=None, check=None, note=None):
        """initialize a new instruction.
        Does no checking as to whether the instruction is valid or makes sense;
        all arguments are used as strings
        """
        self.name = name
        self.args = args
        self.label = label
        self.check = check
        self.note = note

    def size(self):
        """size of instruction in words (2 bytes)"""
        # known 2 word instructions
        if (self.name  in ["LDS", "STS", "JMP", "CALL"]):
            return 2
        # assume all other instructions are 1 word
        else:
            return 1

    # integration with EE119 test vector generator
    def read(self, val, addr):
        """expect the instruction to generate a read with given value/address"""
        self.check = ("R", f"{val:02X}", f"{addr:04X}")
        return self
    def write(self, val, addr):
        """expect the instruction to generate a write with given value/address"""
        self.check = ("W", f"{val:02X}", f"{addr:04X}")
        return self
    def skip(self):
        """expect the instruction to be skipped (skip instructions)"""
        self.check = ("S",)
        return self

    def __getitem__(self, label):
        """set a label on the instruction (for calls/jmps)"""
        self.label = label
        return self

    def __call__(self, note):
        """add additional comments about the instruction"""
        self.note = note
        return self

    def __str__(self):
        """return a nicely formatted string representation of the instruction"""
        label = self.label + ":\n" if self.label else ""
        args = ",".join(map(lambda s: f"{str(s):7}", self.args))
        check = " ".join(self.check) if self.check else ""
        comment = f"{check:12}{self.note}" if self.note else check
        return f"{label}    {self.name:8}{args:16};{comment}"
    __repr__ = __str__

def stringify(program):
    """returns a string representation of an entire program.
    Programs consist of Instruction objects, strings, or lists of either.
    Instructions are converted to strings individually.
    strings are passed through as is (plus a newline).
    lists are recursively stringified.
    """
    if isinstance(program, Instruction):
        return str(program)
    elif isinstance(program, str):
        return "\n"+program
    else:
        return "\n".join(map(stringify, program))

"""set of all instructions"""
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

def _makeInstructionFunction(name):
    """generate a function that, when called,
    returns an Instruction object for this particular instruction
    """
    return lambda *args: Instruction(name, args)

# create a function for each instruction in global namespace
for i in INSTRUCTIONS:
    globals()[i] = _makeInstructionFunction(i)