
STACK_SIZE = $(shell ulimit -s)

.PHONY: all lst2test cpu_test_vector_files import alu_tests iau_tests dau_tests reg_tests clean

all:
	sleep 1

lst2test:
	gcc glen_test_generator/lst2test.c -o glen_test_generator/lst2test

cpu_test_vector_files: lst2test
	cd glen_test_generator; ./lst2test < alu_test_part1.lss > alu_test_part1_tv.txt
	cd glen_test_generator; ./lst2test < alu_test_part2.lss > alu_test_part2_tv.txt

import: clean
	mkdir -p work
	ghdl -i --std=08 --workdir=work src/*.vhd
	ghdl -i --std=08 --workdir=work src/alu/*.vhd
	ghdl -i --std=08 --workdir=work src/memunit/*.vhd
	ghdl -i --std=08 --workdir=work src/registers/*.vhd

alu_tests: import
	ghdl -m --std=08 --workdir=work alu_tb
	ghdl -r --std=08 --workdir=work alu_tb --vcd=avr_alu_tb.vcd

iau_tests: import
	ghdl -m --std=08 --workdir=work iau_tb
	ghdl -r --std=08 --workdir=work iau_tb --vcd=avr_iau_tb.vcd

dau_tests: import
	ghdl -m --std=08 --workdir=work dau_tb
	ghdl -r --std=08 --workdir=work dau_tb --vcd=avr_dau_tb.vcd

reg_tests: import
	ghdl -m --std=08 --workdir=work avr_reg_tb
	ghdl -r --std=08 --workdir=work avr_reg_tb --max-stack-alloc=$(STACK_SIZE) --vcd=avr_reg_tb.vcd

cpu_tests: import cpu_test_vector_files
	ghdl -m --std=08 --workdir=work avr_cpu_tb
	ghdl -r --std=08 --workdir=work avr_cpu_tb --wave=avr_cpu_tb.ghw --vcd=avr_cpu_tb.vcd

cpu_alu_tests: import cpu_test_vector_files
	ghdl -m --std=08 --workdir=work avr_cpu_tb
	ghdl -r --std=08 --workdir=work avr_cpu_tb --wave=avr_cpu_tb.ghw --vcd=avr_cpu_tb.vcd -gtest_vector_filename="glen_test_generator/alu_test_part1_tv.txt"
	ghdl -r --std=08 --workdir=work avr_cpu_tb --wave=avr_cpu_tb.ghw --vcd=avr_cpu_tb.vcd -gtest_vector_filename="glen_test_generator/alu_test_part2_tv.txt"

clean:
	rm -r work/*.cf || true
	rm *.vcd        || true
	rm *.ghw        || true
