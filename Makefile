

all:
	sleep 1

import:
	mkdir work
	ghdl -i --std=08 --workdir=work src/*.vhd

alu_tests:
	ghdl -m --std=08 --workdir=work alu_tb
	ghdl -r --std=08 --workdir=work alu_tb

iau_tests:
	ghdl -m --std=08 --workdir=work iau_tb
	ghdl -r --std=08 --workdir=work iau_tb
dau_tests:
	ghdl -m --std=08 --workdir=work dau_tb
	ghdl -r --std=08 --workdir=work dau_tb

clean:
	rm -r work
