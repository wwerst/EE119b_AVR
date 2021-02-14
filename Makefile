
.PHONY: all import alu_tests iau_tests dau_tests reg_tests clean

all:
	sleep 1

import:
	mkdir -p work
	ghdl -i --std=08 --workdir=work src/*.vhd
	ghdl -i --std=08 --workdir=work src/tb/*.vhd

alu_tests: import
	ghdl -m --std=08 --workdir=work alu_tb
	ghdl -r --std=08 --workdir=work alu_tb

iau_tests: import
	ghdl -m --std=08 --workdir=work iau_tb
	ghdl -r --std=08 --workdir=work iau_tb

dau_tests: import
	ghdl -m --std=08 --workdir=work dau_tb
	ghdl -r --std=08 --workdir=work dau_tb

reg_tests: import
	ghdl -m --std=08 --workdir=work avr_reg_tb
	ghdl -r --std=08 --workdir=work avr_reg_tb --max-stack-alloc=1024 --vcd=avr_reg_tb.vcd

clean:
	rm -r work/*.cf
