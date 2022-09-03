SHELL=/bin/bash
.SHELLFLAGS=-O extglob -c
WORKDIR=/home/sebs/riscv-core/build/
GHDL=ghdl
GHDLFLAGS=
GHDLRUNFLAGS=--wave=testbench.ghw --stop-time=5us

all: riscv

riscv:*.o
	$(GHDL) -e $(GHDLFLAGS) $@

*.o:*.vhd
	$(GHDL) -a $(GHDLFLAGS) mem/instmem/*.vhd 
	$(GHDL) -a $(GHDLFLAGS) alu/*Package.vhd 
	$(GHDL) -a $(GHDLFLAGS) alu/!(*Package).vhd 
	$(GHDL) -a $(GHDLFLAGS) rf/*.vhd 
	$(GHDL) -a $(GHDLFLAGS) RISCV.vhd

run: riscv 
	ghdl -r RISCV $(GHDLRUNFLAGS)

clean:
	rm -f *.o riscv *.cf
