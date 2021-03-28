# EE119b_AVR
Repo for AVR instruction set test and implementation in VHDL


# The relevant files for testing are located at:

- test/*   : Contains all of the raw asm files and .ipynb files for generating some of the code
- preprocessed_asm/* : Contains post processed files for glen's output format for alu asm files (ASSERT macro converted to comment format)
- preprocessor.py   : Preprocesses the alu asm files to convert from the ASSERT macro to glen's comment format.