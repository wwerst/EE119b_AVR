

all:
	sleep 1

import:
	ghdl -i --std=08 --workdir=work src/mau_tb.vhd
	ghdl -i --std=08 --workdir=work src/common.vhd
	ghdl -i --std=08 --workdir=work src/avr_iau.vhd
	ghdl -i --std=08 --workdir=work src/avr_reg.vhd
	ghdl -i --std=08 --workdir=work src/reg.vhd
	ghdl -i --std=08 --workdir=work src/tb/avr_reg_tb.vhd

alu_tests:
	ghdl -i --workdir=work src/alu.vhd src/alu_tb.vhd

mau_tests:
	ghdl -m --std=08 --workdir=work mau_tb
	ghdl -r --std=08 --workdir=work mau_tb

reg_tests:
	ghdl -m --std=08 --workdir=work avr_reg_tb
	ghdl -r --std=08 --workdir=work avr_reg_tb

clean:
	rm work/*.cf
