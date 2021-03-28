# Homework 4 submission

This is a snapshot of the EE119b_AVR repo relevant sections for
Homework 4. The repo is located at: https://github.com/wwerst/EE119b_AVR

Team: Will Werst and Eric Chen

# Summary

The design files are all located in the src folder. The test vectors are located in
test_vectors folder as .lss files. These listing files are generated from asm files,
that are either handwritten or generated via a jupyter notebook python script
(see tests folder for these asm files). When the appropriate makefile target is ran,
the LSS files are compiled to a custom file format, using a modified version of lst2test.c
There is one exception to this, the flow_uncond_branch test vectors are manually edited from
the original listing file output to reorder the vectors for jumps.

The testing is all done with GHDL, and there is a Makefile that will run the different
testing commands. For environment setup for GHDL, see the .github/workflows/run_ghdl_tests.yml
Github Actions config file. This config file is used by Github to run all tests on a
fresh install of GHDL on every commit as well, so you can view those test results on Github
at repo url above.

Tests are done on the subcomponents of cpu, as well as the cpu as a whole.

# Extra Credit

## Multiply

The MUL instruction was implemented in the CPU. It utilizes Xilinx synthesis to select the optimal
multiplier (DSP slices or logic) in the ALU. I looked at implementing with Wallace tree or other
hardware multiplier, but decided to leave it to optimizer.

## Implementation

The design was implemented. Relevant files are in xilinx_implementation folder. Results:

Slices:
	Number of Slices                       1094 out of 8672   12%
		  Number of SLICEMs                     64 out of 4336    1%

Data Sheet report:
-----------------
All values displayed in nanoseconds (ns)

Clock to Setup on destination clock clock
---------------+---------+---------+---------+---------+
               | Src:Rise| Src:Fall| Src:Rise| Src:Fall|
Source Clock   |Dest:Rise|Dest:Rise|Dest:Fall|Dest:Fall|
---------------+---------+---------+---------+---------+
clock          |   24.919|         |         |         |
---------------+---------+---------+---------+---------+


Timing summary:
---------------

Timing errors: 0  Score: 0  (Setup/Max: 0, Hold: 0)

Constraints cover 105333649 paths, 0 nets, and 7265 connections

Design statistics:
   Minimum period:  24.919ns{1}   (Maximum frequency:  40.130MHz)


# The relevant files for testing are located at:

- .github/* : Contains the Github Actions config file for script. Also documents setup for new computer, since Github Actions runs tests from blank install every time.
- preprocessed_asm/* : Contains post processed files for glen's output format for alu asm files (ASSERT macro converted to comment format)
- src/* : Contains all of the vhdl code for design.
- test_vectors/* : Contains the lss files and the compiled test vectors for testing cpu.
- tests/*   : Contains all of the raw asm files and .ipynb files for generating some of the code
- xilinx_implementation/* : Contains files and artifacts from xilinx implementation of design.
- preprocessor.py   : Preprocesses the alu asm files to convert from the ASSERT macro to glen's comment format.
- Control_Architecture_Sketch.pdf : A sketch of the architecture of design
- Makefile: Contains make targets for different tests