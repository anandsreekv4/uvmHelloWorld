DESIGN=register
UVM_TESTNAME=tx_test
UVM_FLAGS=+UVM_NO_RELNOTES
UVM_VERBOSITY=UVM_MEDIUM
LSF=bsub -Ip
VLOG=$(LSF) vlog
VOPT=$(LSF) vopt +acc

export  MODELVER=questasim_10.5c_5

des_setup:
	make -C design/$(DESIGN) setup
	touch $@

top_setup: des_setup
	vlib tb_lib 
	vmap tb_lib tb_lib
	vlib design_lib
	vmap design_lib design_lib
	touch $@

design_compile: top_setup
	$(VLOG) -work design_lib -f design/$(DESIGN)/src/file_list +incdir+design/$(DESIGN)/src
	touch $@

tb_compile: design_compile
	$(VLOG) -work tb_lib -L design_lib -f design/$(DESIGN)/tb/file_list  +incdir+design/$(DESIGN)/tb
	touch $@

.PHONY: compile
compile: design_compile tb_compile 

elab: compile
	# $(VOPT) -work design_lib $(DESIGN)  -o $(DESIGN)_opt  
	# @echo "-- Simulation executable '$(DESIGN)_opt' created ! --"
	# $(VOPT) -work tb_lib -L design_lib top -o top_opt
	# @echo "-- Simulation executable 'top_opt' created ! --"
	touch $@

.PHONY: sim
sim: elab
	bsub -Ip vsim -novopt -c -L tb_lib -L design_lib tb_lib.top -do sim.do +UVM_TESTNAME=$(UVM_TESTNAME) $(UVM_FLAGS) +UVM_VERBOSITY=$(UVM_VERBOSITY)

.PHONY: clean
clean:
	rm -rf *_compile elab work design/_*

.PHONY: clobber
clobber: clean
	rm -rf tb_lib design_lib modelsim.ini *_setup transcript certe*
