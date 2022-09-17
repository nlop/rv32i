# Makefile automatically generated by ghdl
# Version: GHDL 1.0.0 (tarball) [Dunoon edition] - GCC back-end code generator
# Command used to generate this makefile:
# ghdl --gen-makefile -fsynopsys RISCV

SHELL=/bin/bash
.SHELLFLAGS=-O extglob -c
GHDL=ghdl
GHDLFLAGS=-fsynopsys
GHDLRUNFLAGS=--wave=testbench.ghw --stop-time=5us

# Default target
all: top

# Elaboration targets
testbench: top Testbench.o
	$(GHDL) -e $(GHDLFLAGS) $@

top: riscv Top.o
	$(GHDL) -e $(GHDLFLAGS) $@

riscv: /usr/lib/ghdl/ieee/v93/std_logic_1164.o /usr/lib/ghdl/ieee/v93/std_logic_1164-body.o /usr/lib/ghdl/ieee/v93/std_logic_arith.o /usr/lib/ghdl/ieee/v93/std_logic_unsigned.o ALUPackage.o PipePackage.o RISCV.o ControlUnit.o /usr/lib/ghdl/ieee/v93/numeric_std.o /usr/lib/ghdl/ieee/v93/numeric_std-body.o InstrMem.o /usr/lib/ghdl/ieee/v93/std_logic_signed.o PC.o RegisterFile.o ALUNbits.o DecodePipe.o ExecutePipe.o MemoryPipe.o WritebackPipe.o ConditionChecker.o RAM.o Extender.o DemuxGeneric93.o ForwardingUnit.o BarrelShifter.o MuxGeneric93.o SimpleRegister.o ALUBit.o sumaBit.o
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
/usr/lib/ghdl/ieee/v93/std_logic_arith.o: /usr/lib/ghdl/ieee/v93/../../src/synopsys/std_logic_arith.vhdl
	@echo "This file was not locally built ($<)"
	exit 1
/usr/lib/ghdl/ieee/v93/std_logic_unsigned.o: /usr/lib/ghdl/ieee/v93/../../src/synopsys/std_logic_unsigned.vhdl
	@echo "This file was not locally built ($<)"
	exit 1
ALUPackage.o: alu/ALUPackage.vhd
	$(GHDL) -a $(GHDLFLAGS) $<
PipePackage.o: pipes/PipePackage.vhd
	$(GHDL) -a $(GHDLFLAGS) $<
Testbench.o: Testbench.vhd
	$(GHDL) -a $(GHDLFLAGS) $<
Top.o: Top.vhd
	$(GHDL) -a $(GHDLFLAGS) $<
RISCV.o: RISCV.vhd
	$(GHDL) -a $(GHDLFLAGS) $<
ControlUnit.o: control/ControlUnit.vhd
	$(GHDL) -a $(GHDLFLAGS) $<
/usr/lib/ghdl/ieee/v93/numeric_std.o: /usr/lib/ghdl/ieee/v93/../../src/ieee/v93/numeric_std.vhdl
	@echo "This file was not locally built ($<)"
	exit 1
/usr/lib/ghdl/ieee/v93/numeric_std-body.o: /usr/lib/ghdl/ieee/v93/../../src/ieee/v93/numeric_std-body.vhdl
	@echo "This file was not locally built ($<)"
	exit 1
InstrMem.o: mem/instmem/InstrMem.vhd
	$(GHDL) -a $(GHDLFLAGS) $<
/usr/lib/ghdl/ieee/v93/std_logic_signed.o: /usr/lib/ghdl/ieee/v93/../../src/synopsys/std_logic_signed.vhdl
	@echo "This file was not locally built ($<)"
	exit 1
PC.o: pc/PC.vhd
	$(GHDL) -a $(GHDLFLAGS) $<
RegisterFile.o: rf/RegisterFile.vhd
	$(GHDL) -a $(GHDLFLAGS) $<
DecodePipe.o: pipes/DecodePipe.vhd
	$(GHDL) -a $(GHDLFLAGS) $<
ExecutePipe.o: pipes/ExecutePipe.vhd
	$(GHDL) -a $(GHDLFLAGS) $<
MemoryPipe.o: pipes/MemoryPipe.vhd
	$(GHDL) -a $(GHDLFLAGS) $<
WritebackPipe.o: pipes/WritebackPipe.vhd
	$(GHDL) -a $(GHDLFLAGS) $<
ALUNbits.o: alu/ALUNbits.vhd
	$(GHDL) -a $(GHDLFLAGS) $<
ConditionChecker.o: util/ConditionChecker.vhd
	$(GHDL) -a $(GHDLFLAGS) $<
RAM.o: mem/ram/RAM.vhd
	$(GHDL) -a $(GHDLFLAGS) $<
Extender.o: util/Extender.vhd
	$(GHDL) -a $(GHDLFLAGS) $<
ForwardingUnit.o: hazard/ForwardingUnit.vhd
	$(GHDL) -a $(GHDLFLAGS) $<
DemuxGeneric93.o: rf/DemuxGeneric93.vhd
	$(GHDL) -a $(GHDLFLAGS) $<
BarrelShifter.o: alu/BarrelShifter.vhd
	$(GHDL) -a $(GHDLFLAGS) $<
MuxGeneric93.o: rf/MuxGeneric93.vhd
	$(GHDL) -a $(GHDLFLAGS) $<
SimpleRegister.o: rf/SimpleRegister.vhd
	$(GHDL) -a $(GHDLFLAGS) $<
ALUBit.o: alu/ALUBit.vhd
	$(GHDL) -a $(GHDLFLAGS) $<
sumaBit.o: alu/sumaBit.vhd
	$(GHDL) -a $(GHDLFLAGS) $<

# Files dependences
/usr/lib/ghdl/ieee/v93/std_logic_1164.o: 
/usr/lib/ghdl/ieee/v93/std_logic_1164-body.o:  /usr/lib/ghdl/ieee/v93/std_logic_1164.o
/usr/lib/ghdl/ieee/v93/std_logic_arith.o:  /usr/lib/ghdl/ieee/v93/std_logic_1164.o
/usr/lib/ghdl/ieee/v93/std_logic_unsigned.o:  /usr/lib/ghdl/ieee/v93/std_logic_1164.o /usr/lib/ghdl/ieee/v93/std_logic_arith.o
ALUPackage.o:  /usr/lib/ghdl/ieee/v93/std_logic_1164.o
PipePackage.o:  /usr/lib/ghdl/ieee/v93/std_logic_1164.o
RISCV.o:  /usr/lib/ghdl/ieee/v93/std_logic_1164.o /usr/lib/ghdl/ieee/v93/std_logic_1164-body.o /usr/lib/ghdl/ieee/v93/std_logic_unsigned.o ALUPackage.o PipePackage.o
Top.o:  /usr/lib/ghdl/ieee/v93/std_logic_1164.o /usr/lib/ghdl/ieee/v93/std_logic_1164-body.o
Testbench.o:  /usr/lib/ghdl/ieee/v93/std_logic_1164.o /usr/lib/ghdl/ieee/v93/std_logic_1164-body.o
ControlUnit.o:  /usr/lib/ghdl/ieee/v93/std_logic_1164.o
/usr/lib/ghdl/ieee/v93/numeric_std.o:  /usr/lib/ghdl/ieee/v93/std_logic_1164.o
/usr/lib/ghdl/ieee/v93/numeric_std-body.o:  /usr/lib/ghdl/ieee/v93/numeric_std.o
InstrMem.o:  /usr/lib/ghdl/ieee/v93/std_logic_1164.o /usr/lib/ghdl/ieee/v93/numeric_std.o /usr/lib/ghdl/ieee/v93/numeric_std-body.o
/usr/lib/ghdl/ieee/v93/std_logic_signed.o:  /usr/lib/ghdl/ieee/v93/std_logic_1164.o /usr/lib/ghdl/ieee/v93/std_logic_arith.o
PC.o:  /usr/lib/ghdl/ieee/v93/std_logic_1164.o /usr/lib/ghdl/ieee/v93/std_logic_signed.o
RegisterFile.o:  /usr/lib/ghdl/ieee/v93/std_logic_1164.o
ALUNbits.o:  /usr/lib/ghdl/ieee/v93/std_logic_1164.o ALUPackage.o
DecodePipe.o:  /usr/lib/ghdl/ieee/v93/std_logic_1164.o
ExecutePipe.o:  /usr/lib/ghdl/ieee/v93/std_logic_1164.o
MemoryPipe.o:  /usr/lib/ghdl/ieee/v93/std_logic_1164.o
WritebackPipe.o:  /usr/lib/ghdl/ieee/v93/std_logic_1164.o
ConditionChecker.o:  /usr/lib/ghdl/ieee/v93/std_logic_1164.o
RAM.o:  /usr/lib/ghdl/ieee/v93/std_logic_1164.o /usr/lib/ghdl/ieee/v93/numeric_std.o
Extender.o:  /usr/lib/ghdl/ieee/v93/std_logic_1164.o
DemuxGeneric93.o:  /usr/lib/ghdl/ieee/v93/std_logic_1164.o /usr/lib/ghdl/ieee/v93/numeric_std.o
ForwardingUnit.o:  /usr/lib/ghdl/ieee/v93/std_logic_1164.o /usr/lib/ghdl/ieee/v93/numeric_std.o
BarrelShifter.o:  /usr/lib/ghdl/ieee/v93/std_logic_1164.o
MuxGeneric93.o:  /usr/lib/ghdl/ieee/v93/std_logic_1164.o /usr/lib/ghdl/ieee/v93/numeric_std.o
SimpleRegister.o:  /usr/lib/ghdl/ieee/v93/std_logic_1164.o
ALUBit.o:  /usr/lib/ghdl/ieee/v93/std_logic_1164.o ALUPackage.o
sumaBit.o:  /usr/lib/ghdl/ieee/v93/std_logic_1164.o

clean:
	rm -f *.o riscv top testbench *.cf *.ghw
