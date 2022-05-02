BSUB = bsub -Ip 
IRUN = $(BSUB) irun
GUI  = 1
ifeq ($(GUI),1)
    RUNOPT += -gui
endif
RUNOPT += -access +rwc -svseed random

all:
	$(IRUN) top.sv $(RUNOPT)

SPYBIN = $(BSUB) /tools/apps/synopsys/SpyGlass-Q-2020.03-1/SPYGLASS_HOME/bin/spyglass
spyg:
	$(SPYBIN)
	
