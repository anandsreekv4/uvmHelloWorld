BSUB = bsub -Ip 
IRUN = $(BSUB) irun
GUI  = 1
ifeq ($(GUI),1)
    RUNOPT += -gui
endif
RUNOPT += -access +rwc

all:
	$(IRUN) top.sv $(RUNOPT)
