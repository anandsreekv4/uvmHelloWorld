export DESIGN=$(basename $(notdir $(shell pwd)))

info:
	@echo "INFORMATION ON DIRECTORY STRUCTURE: "
	@echo "DESIGN : $(DESIGN)"
	@echo "SRC    : $(DESIGN)/src"
	@echo "TB     : $(DESIGN)/tb"

dut_setup: info
	make -C src setup

tb_setup: info
	make -C tb setup

setup: dut_setup tb_setup
