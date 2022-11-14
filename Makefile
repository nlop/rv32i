# Makefile automatically generated by ghdl
# Version: GHDL 1.0.0 (tarball) [Dunoon edition] - GCC back-end code generator
# Command used to generate this makefile:
# ghdl --gen-makefile -fsynopsys DemoTop

SHELL=/bin/bash
.SHELLFLAGS=-O extglob -c
GHDL=ghdl
GHDLFLAGS= -fsynopsys
GHDLRUNFLAGS=--wave=testbench.ghw --stop-time=2us

# Default target
all: demotop

# Testbench
demotestbench: demotop DemoTestbench.o
	$(GHDL) -e $(GHDLFLAGS) $@

# Elaboration target
demotop: /usr/lib/ghdl/ieee/v93/std_logic_1164.o /usr/lib/ghdl/ieee/v93/std_logic_1164-body.o DemoTop.o /usr/lib/ghdl/ieee/v93/numeric_std.o /usr/lib/ghdl/ieee/v93/numeric_std-body.o /usr/lib/ghdl/ieee/v93/std_logic_arith.o /usr/lib/ghdl/ieee/v93/std_logic_unsigned.o RAM.o InstrMem.o ALUPackage.o PipePackage.o RISCV.o ControlUnit.o /usr/lib/ghdl/ieee/v93/std_logic_signed.o PC.o RegisterFile.o ALUNbits.o ConditionChecker.o Extender.o DecodePipe.o ExecutePipe.o MemoryPipe.o WritebackPipe.o ForwardingUnit.o StallUnit.o BranchPredictor.o PCController.o DemuxGeneric93.o MuxGeneric93.o SimpleRegister.o ALUBit.o BarrelShifter.o sumaBit.o SimpleRegisterReset.o debouncer.o DigitEncoder.o SegmentDisplayDriver.o RingCounter.o BCD.o 
	$(GHDL) -e $(GHDLFLAGS) $@

# Run target
run: demotestbench
	$(GHDL) -r demotestbench $(GHDLRUNFLAGS)

# Clean
clean:
	rm -f *.o demotop demotestbench *.cf *.ghw

# Targets to analyze files
/usr/lib/ghdl/ieee/v93/std_logic_1164.o: /usr/lib/ghdl/ieee/v93/../../src/ieee/v93/std_logic_1164.vhdl
	@echo "This file was not locally built ($<)"
	exit 1
/usr/lib/ghdl/ieee/v93/std_logic_1164-body.o: /usr/lib/ghdl/ieee/v93/../../src/ieee/v93/std_logic_1164-body.vhdl
	@echo "This file was not locally built ($<)"
	exit 1
DemoTop.o: DemoTop.vhd
	$(GHDL) -a $(GHDLFLAGS) $<
DemoTestbench.o: DemoTestbench.vhd
	$(GHDL) -a $(GHDLFLAGS) $<
/usr/lib/ghdl/ieee/v93/numeric_std.o: /usr/lib/ghdl/ieee/v93/../../src/ieee/v93/numeric_std.vhdl
	@echo "This file was not locally built ($<)"
	exit 1
/usr/lib/ghdl/ieee/v93/numeric_std-body.o: /usr/lib/ghdl/ieee/v93/../../src/ieee/v93/numeric_std-body.vhdl
	@echo "This file was not locally built ($<)"
	exit 1
/usr/lib/ghdl/ieee/v93/math_real.o: /usr/lib/ghdl/ieee/v93/../../src/ieee/math_real.vhdl
	@echo "This file was not locally built ($<)"
	exit 1
/usr/lib/ghdl/ieee/v93/math_real-body.o: /usr/lib/ghdl/ieee/v93/../../src/ieee/math_real-body.vhdl
	@echo "This file was not locally built ($<)"
	exit 1
/usr/lib/ghdl/ieee/v93/std_logic_arith.o: /usr/lib/ghdl/ieee/v93/../../src/synopsys/std_logic_arith.vhdl
	@echo "This file was not locally built ($<)"
	exit 1
/usr/lib/ghdl/ieee/v93/std_logic_unsigned.o: /usr/lib/ghdl/ieee/v93/../../src/synopsys/std_logic_unsigned.vhdl
	@echo "This file was not locally built ($<)"
	exit 1
RAM.o: mem/ram/RAM.vhd
	$(GHDL) -a $(GHDLFLAGS) $<
InstrMem.o: mem/instmem/InstrMem.vhd
	$(GHDL) -a $(GHDLFLAGS) $<
ALUPackage.o: alu/ALUPackage.vhd
	$(GHDL) -a $(GHDLFLAGS) $<
PipePackage.o: pipes/PipePackage.vhd
	$(GHDL) -a $(GHDLFLAGS) $<
RISCV.o: RISCV.vhd
	$(GHDL) -a $(GHDLFLAGS) $<
ControlUnit.o: control/ControlUnit.vhd
	$(GHDL) -a $(GHDLFLAGS) $<
/usr/lib/ghdl/ieee/v93/std_logic_signed.o: /usr/lib/ghdl/ieee/v93/../../src/synopsys/std_logic_signed.vhdl
	@echo "This file was not locally built ($<)"
	exit 1
PC.o: pc/PC.vhd
	$(GHDL) -a $(GHDLFLAGS) $<
RegisterFile.o: rf/RegisterFile.vhd
	$(GHDL) -a $(GHDLFLAGS) $<
ALUNbits.o: alu/ALUNbits.vhd
	$(GHDL) -a $(GHDLFLAGS) $<
ConditionChecker.o: util/ConditionChecker.vhd
	$(GHDL) -a $(GHDLFLAGS) $<
Extender.o: util/Extender.vhd
	$(GHDL) -a $(GHDLFLAGS) $<
DecodePipe.o: pipes/DecodePipe.vhd
	$(GHDL) -a $(GHDLFLAGS) $<
ExecutePipe.o: pipes/ExecutePipe.vhd
	$(GHDL) -a $(GHDLFLAGS) $<
MemoryPipe.o: pipes/MemoryPipe.vhd
	$(GHDL) -a $(GHDLFLAGS) $<
WritebackPipe.o: pipes/WritebackPipe.vhd
	$(GHDL) -a $(GHDLFLAGS) $<
ForwardingUnit.o: hazard/ForwardingUnit.vhd
	$(GHDL) -a $(GHDLFLAGS) $<
StallUnit.o: hazard/StallUnit.vhd
	$(GHDL) -a $(GHDLFLAGS) $<
BranchPredictor.o: control/BranchPredictor.vhd
	$(GHDL) -a $(GHDLFLAGS) $<
PCController.o: control/PCController.vhd
	$(GHDL) -a $(GHDLFLAGS) $<
DemuxGeneric93.o: rf/DemuxGeneric93.vhd
	$(GHDL) -a $(GHDLFLAGS) $<
MuxGeneric93.o: rf/MuxGeneric93.vhd
	$(GHDL) -a $(GHDLFLAGS) $<
SimpleRegister.o: rf/SimpleRegister.vhd
	$(GHDL) -a $(GHDLFLAGS) $<
ALUBit.o: alu/ALUBit.vhd
	$(GHDL) -a $(GHDLFLAGS) $<
BarrelShifter.o: alu/BarrelShifter.vhd
	$(GHDL) -a $(GHDLFLAGS) $<
sumaBit.o: alu/sumaBit.vhd
	$(GHDL) -a $(GHDLFLAGS) $<
SimpleRegisterReset.o: pipes/SimpleRegisterReset.vhd
	$(GHDL) -a $(GHDLFLAGS) $<
DigitEncoder.o: peripheral/DigitEncoder.vhd
	$(GHDL) -a $(GHDLFLAGS) $<
RingCounter.o: peripheral/RingCounter.vhd
	$(GHDL) -a $(GHDLFLAGS) $<
BCD.o: peripheral/BCD.vhd
	$(GHDL) -a $(GHDLFLAGS) $<
SegmentDisplayDriver.o: peripheral/SegmentDisplayDriver.vhd
	$(GHDL) -a $(GHDLFLAGS) $<
debouncer.o: peripheral/debouncer.vhd
	$(GHDL) -a $(GHDLFLAGS) $<

# Files dependences
/usr/lib/ghdl/ieee/v93/std_logic_1164.o: 
/usr/lib/ghdl/ieee/v93/std_logic_1164-body.o:  /usr/lib/ghdl/ieee/v93/std_logic_1164.o
DemoTop.o:  /usr/lib/ghdl/ieee/v93/std_logic_1164.o /usr/lib/ghdl/ieee/v93/std_logic_1164-body.o
/usr/lib/ghdl/ieee/v93/numeric_std.o:  /usr/lib/ghdl/ieee/v93/std_logic_1164.o
/usr/lib/ghdl/ieee/v93/numeric_std-body.o:  /usr/lib/ghdl/ieee/v93/numeric_std.o
/usr/lib/ghdl/ieee/v93/std_logic_arith.o:  /usr/lib/ghdl/ieee/v93/std_logic_1164.o
/usr/lib/ghdl/ieee/v93/std_logic_unsigned.o:  /usr/lib/ghdl/ieee/v93/std_logic_1164.o /usr/lib/ghdl/ieee/v93/std_logic_arith.o
/usr/lib/ghdl/ieee/v93/math_real.o:
/usr/lib/ghdl/ieee/v93/math_real-body.o:  /usr/lib/ghdl/ieee/v93/math_real.o
RAM.o:  /usr/lib/ghdl/ieee/v93/std_logic_1164.o /usr/lib/ghdl/ieee/v93/numeric_std.o /usr/lib/ghdl/ieee/v93/numeric_std-body.o /usr/lib/ghdl/ieee/v93/std_logic_unsigned.o
InstrMem.o:  /usr/lib/ghdl/ieee/v93/std_logic_1164.o /usr/lib/ghdl/ieee/v93/numeric_std.o
ALUPackage.o:  /usr/lib/ghdl/ieee/v93/std_logic_1164.o
PipePackage.o:  /usr/lib/ghdl/ieee/v93/std_logic_1164.o
RISCV.o:  /usr/lib/ghdl/ieee/v93/std_logic_1164.o /usr/lib/ghdl/ieee/v93/std_logic_unsigned.o ALUPackage.o PipePackage.o
ControlUnit.o:  /usr/lib/ghdl/ieee/v93/std_logic_1164.o
/usr/lib/ghdl/ieee/v93/std_logic_signed.o:  /usr/lib/ghdl/ieee/v93/std_logic_1164.o /usr/lib/ghdl/ieee/v93/std_logic_arith.o
PC.o:  /usr/lib/ghdl/ieee/v93/std_logic_1164.o /usr/lib/ghdl/ieee/v93/std_logic_signed.o
RegisterFile.o:  /usr/lib/ghdl/ieee/v93/std_logic_1164.o
ALUNbits.o:  /usr/lib/ghdl/ieee/v93/std_logic_1164.o ALUPackage.o
ConditionChecker.o:  /usr/lib/ghdl/ieee/v93/std_logic_1164.o
Extender.o:  /usr/lib/ghdl/ieee/v93/std_logic_1164.o
DecodePipe.o:  /usr/lib/ghdl/ieee/v93/std_logic_1164.o
ExecutePipe.o:  /usr/lib/ghdl/ieee/v93/std_logic_1164.o
MemoryPipe.o:  /usr/lib/ghdl/ieee/v93/std_logic_1164.o
WritebackPipe.o:  /usr/lib/ghdl/ieee/v93/std_logic_1164.o
ForwardingUnit.o:  /usr/lib/ghdl/ieee/v93/std_logic_1164.o /usr/lib/ghdl/ieee/v93/numeric_std.o
StallUnit.o:  /usr/lib/ghdl/ieee/v93/std_logic_1164.o
BranchPredictor.o:  /usr/lib/ghdl/ieee/v93/std_logic_1164.o
PCController.o:  /usr/lib/ghdl/ieee/v93/std_logic_1164.o
DemuxGeneric93.o:  /usr/lib/ghdl/ieee/v93/std_logic_1164.o /usr/lib/ghdl/ieee/v93/numeric_std.o
MuxGeneric93.o:  /usr/lib/ghdl/ieee/v93/std_logic_1164.o /usr/lib/ghdl/ieee/v93/numeric_std.o
SimpleRegister.o:  /usr/lib/ghdl/ieee/v93/std_logic_1164.o
ALUBit.o:  /usr/lib/ghdl/ieee/v93/std_logic_1164.o ALUPackage.o
BarrelShifter.o:  /usr/lib/ghdl/ieee/v93/std_logic_1164.o
sumaBit.o:  /usr/lib/ghdl/ieee/v93/std_logic_1164.o
SimpleRegisterReset.o:  /usr/lib/ghdl/ieee/v93/std_logic_1164.o
DemoTestbench.o:  /usr/lib/ghdl/ieee/v93/std_logic_1164.o /usr/lib/ghdl/ieee/v93/std_logic_1164-body.o
SegmentDisplayDriver.o: /usr/lib/ghdl/ieee/v93/std_logic_1164.o /usr/lib/ghdl/ieee/v93/std_logic_1164-body.o /usr/lib/ghdl/ieee/v93/std_logic_arith.o /usr/lib/ghdl/ieee/v93/std_logic_unsigned.o /usr/lib/ghdl/ieee/v93/numeric_std.o /usr/lib/ghdl/ieee/v93/numeric_std-body.o 
DigitEncoder.o:  /usr/lib/ghdl/ieee/v93/std_logic_1164.o /usr/lib/ghdl/ieee/v93/numeric_std.o /usr/lib/ghdl/ieee/v93/numeric_std-body.o
RingCounter.o:  /usr/lib/ghdl/ieee/v93/std_logic_1164.o
BCD.o:  /usr/lib/ghdl/ieee/v93/std_logic_1164.o /usr/lib/ghdl/ieee/v93/std_logic_unsigned.o
debouncer.o:  /usr/lib/ghdl/ieee/v93/std_logic_1164.o /usr/lib/ghdl/ieee/v93/std_logic_1164-body.o /usr/lib/ghdl/ieee/v93/std_logic_unsigned.o /usr/lib/ghdl/ieee/v93/numeric_std.o /usr/lib/ghdl/ieee/v93/numeric_std-body.o /usr/lib/ghdl/ieee/v93/math_real.o /usr/lib/ghdl/ieee/v93/math_real-body.o

