SHELL=/bin/bash
.SHELLFLAGS=-O extglob -c
GHDL=ghdl
GHDLFLAGS=-fsynopsys
GHDLRUNFLAGS=--wave=testbench.ghw --stop-time=5us

all: riscv

riscv:*.o
	$(GHDL) -e $(GHDLFLAGS) $@

*.o:*.vhd
	$(GHDL) -a $(GHDLFLAGS) mem/instmem/!(*Testbench).vhd 
	$(GHDL) -a $(GHDLFLAGS) mem/ram/!(*Testbench).vhd 
	$(GHDL) -a $(GHDLFLAGS) alu/*Package.vhd 
	$(GHDL) -a $(GHDLFLAGS) alu/!(*Package|*Testbench).vhd 
	$(GHDL) -a $(GHDLFLAGS) rf/!(*Testbench).vhd 
	$(GHDL) -a $(GHDLFLAGS) util/*.vhd 
	$(GHDL) -a $(GHDLFLAGS) control/!(*Testbench).vhd 
	$(GHDL) -a $(GHDLFLAGS) RISCV.vhd

run: riscv 
	ghdl -r RISCV $(GHDLRUNFLAGS)

clean:
	rm -f *.o riscv *.cf *.ghw
