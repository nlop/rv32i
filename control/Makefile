# Makefile automatically generated by ghdl
# Version: GHDL 1.0.0 (tarball) [Dunoon edition] - GCC back-end code generator
# Command used to generate this makefile:
# ghdl --gen-makefile Testbench

GHDL=ghdl
GHDLFLAGS=
GHDLRUNFLAGS=--wave=testbench.ghw --stop-time=5us

# Default target
all: controlunit

# Elaboration target
testbench: /usr/lib/ghdl/ieee/v93/std_logic_1164.o /usr/lib/ghdl/ieee/v93/std_logic_1164-body.o Testbench.o ControlUnit.o
	$(GHDL) -e $(GHDLFLAGS) $@

controlunit: /usr/lib/ghdl/ieee/v93/std_logic_1164.o /usr/lib/ghdl/ieee/v93/std_logic_1164-body.o ControlUnit.o
	$(GHDL) -e $(GHDLFLAGS) $@

# Run target
run: testbench
	$(GHDL) -r testbench $(GHDLRUNFLAGS)

# Targets to analyze files
/usr/lib/ghdl/ieee/v93/std_logic_1164.o: /usr/lib/ghdl/ieee/v93/../../src/ieee/v93/std_logic_1164.vhdl
	@echo "This file was not locally built ($<)"
	exit 1
/usr/lib/ghdl/ieee/v93/std_logic_1164-body.o: /usr/lib/ghdl/ieee/v93/../../src/ieee/v93/std_logic_1164-body.vhdl
	@echo "This file was not locally built ($<)"
	exit 1
Testbench.o: Testbench.vhd
	$(GHDL) -a $(GHDLFLAGS) $<
ControlUnit.o: ControlUnit.vhd
	$(GHDL) -a $(GHDLFLAGS) $<

# Files dependences
/usr/lib/ghdl/ieee/v93/std_logic_1164.o: 
/usr/lib/ghdl/ieee/v93/std_logic_1164-body.o:  /usr/lib/ghdl/ieee/v93/std_logic_1164.o
Testbench.o:  /usr/lib/ghdl/ieee/v93/std_logic_1164.o /usr/lib/ghdl/ieee/v93/std_logic_1164-body.o
ControlUnit.o:  /usr/lib/ghdl/ieee/v93/std_logic_1164.o

clean:
	rm -f *.o *.cf *.ghw controlunit testbench
