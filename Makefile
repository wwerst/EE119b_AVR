

all:
	sleep 1

alu_tests:
	ghdl -i --workdir=work src/alu.vhd src/alu_tb.vhd

mau_tests:
	ghdl -i --workdir=work src/mau.vhd src/mau_tb.vhd

clean:
	rm work/*.cf
