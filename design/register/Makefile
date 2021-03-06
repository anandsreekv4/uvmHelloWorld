export DESIGN=$(basename $(notdir $(shell pwd)))
RTL_TOOL=vsim
MAKEDIR=../../make

REFLIBS = \
	  src \
	  tb

SIMOPTS = -do sim.do
ifndef GUI
    SIMOPTS+= -c
endif
SIMOPTS+= +UVM_TESTNAME=$(UVM_TESTNAME) $(UVM_FLAGS)
SIMOPTS+= +UVM_VERBOSITY=$(UVM_VERBOSITY)
SIMOPTS+= -wlf trace.wlf
SIMOPTS+= -uvmcontrol=all -classdebug -msgmode both
SIMOPTS+= -coverage
ifndef NORANDSEED
    SIMOPTS+= -sv_seed random
endif
ifeq ($(DEBUG),1)
    SIMOPTS+= +UVM_CONFIG_DB_TRACE
    UVM_VERBOSITY=UVM_DEBUG
endif

UVM_TESTNAME=tx_test
UVM_FLAGS=+UVM_NO_RELNOTES
UVM_VERBOSITY=UVM_MEDIUM

TOPIMAGE = tb$(WORKSFX).top

VLOGFLAGS += +define+WIDTH=32

.PHONY: info
info:
	@echo "------------------------------------"
	@echo "INFORMATION ON DIRECTORY STRUCTURE: "
	@echo "DESIGN : $(DESIGN)"
	@echo "SRC    : $(DESIGN)/src"
	@echo "TB     : $(DESIGN)/tb"
	@echo "------------------------------------"

dut_setup: info
	make -C src setup

tb_setup: info
	make -C tb setup

include $(MAKEDIR)/$(RTL_TOOL).mk

.PHONY: clean
clean: simclean

.PHONY: clobber
clobber: simclobber
	rm -rf certe* vsim_stack* verdi* novas* vfastLog
