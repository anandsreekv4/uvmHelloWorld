export MODELVER=questasim_10.5c_5

WORKLIBS     = $(REFLIBS:%=%$(WORKSFX))
COMP_TARGETS = $(REFLIBS:%=$(WORKLIB)/%_compile)

LSF = bsub -Ip
VLIB= vlib
VMAP= vmap
VLOG= $(LSF) vlog
VSIM= $(LSF) vsim -novopt
VOPTFLAGS = +acc
VOPT = $(LSF) vopt $(VOPTFLAGS)

WORKSFX = _work

%$(WORKSFX):
	$(VLIB) $(@)
	$(VMAP) $(@) $(@)

# Below line tells make to 'ignore the timestamp of the dir'
# https://stackoverflow.com/questions/1950926/create-directories-using-make-file
# The pipe symbol tells make that the following prereqs are 'order-only'
# 	                   	                                  |
# 	                   +--------------------------------------+
# 	                   |
# 	                   v
%$(WORKSFX)/$(WORKSFX).ts: | %$(WORKSFX)
	touch $@

.PHONY: setup
setup: $(REFLIBS:%=%$(WORKSFX)/$(WORKSFX).ts)

%$(WORKSFX)/_compile.ts: $(REFLIBS:%=%$(WORKSFX)/$(WORKSFX).ts) %
	$(VLOG) -work $(@D) $(WORKLIBS:%= -L %) -f $(@D:%$(WORKSFX)=%)/file_list
	touch $@

.PHONY: compile
compile:$(REFLIBS:%=%$(WORKSFX)/_compile.ts)

%$(WORKSFX)/_elab.ts: $(REFLIBS:%=%$(WORKSFX)/_compile.ts)
	touch $@

.PHONY: elab
elab: $(REFLIBS:%=%$(WORKSFX)/_elab.ts)

.PHONY: sim
sim: $(REFLIBS:%=%$(WORKSFX)/_elab.ts)
	$(VSIM) $(WORKLIBS:%= -L %) $(SIMOPTS) tb$(WORKSFX).top

# Only for quick compile without library setup
.PHONY: simclean
simclean:
	rm -rf *$(WORKSFX)/_elab.ts 
	rm -rf *$(WORKSFX)/_compile.ts 

.PHONY: simclobber
simclobber: simclean
	rm -rf *$(WORKSFX) modelsim.ini transcript 
