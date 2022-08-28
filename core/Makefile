analyze: 
	ghdl -a *.vhd
elaborate:
	ghdl -e RegisterFile
	ghdl -e RegisterFileTest
sim:
	ghdl -r  RegisterFileTest --wave=registerfile.ghw --stop-time=5us
testbench:
	ghdl -a RegisterFileTest.vhd
	ghdl -e RegisterFileTest


