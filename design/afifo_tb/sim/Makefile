UVM_TESTNAME=top_test
UVM_VERBOSITY=UVM_HIGH

DUT_INC = +incdir+../dut
VHDL_SRC = dpram.vhd dbl_sync.vhd afifo_rptr_empty.vhd afifo_wptr_full.vhd cdc_pkg.vhd afifo.vhd

SV_SRC = \
../dut/afifo_pkg.sv \
../tb/afifo_write/sv/afifo_write_pkg.sv \
../tb/afifo_write/sv/afifo_write_if.sv \
../tb/afifo_read/sv/afifo_read_pkg.sv \
../tb/afifo_read/sv/afifo_read_if.sv \
../tb/top/sv/top_pkg.sv \
../tb/top_test/sv/top_test_pkg.sv \
../tb/top_tb/sv/top_th.sv \
../tb/top_tb/sv/top_tb.sv \

INC = \
+incdir+../tb/include \
+incdir+../tb/afifo_write/sv \
+incdir+../tb/afifo_read/sv \
+incdir+../tb/top/sv \
+incdir+../tb/top_test/sv \
+incdir+../tb/top_tb/sv \

TOP_MODULE = top_tb
ifdef ASSERT
	DUT_SV_SRC += bindfiles.sv
	TOP_MODULE += bindfiles
endif

qsim: 
	vcom -work cdc $(VHDL_SRC:%=../dut/%)
	vlog -work cdc $(SV_SRC) $(INC)
	# bsub -Ip vhdlcom -nclib -work cdc $(VHDL_SRC)
	# bsub -Ip vericom -sv -nclib -work cdc $(SV_SRC)
	# bsub -Ip vopt +acc -fsmdebug -assertdebug tb_afifo -work cdc +cover=bcesfx -o opt -designfile design.bin -debug
	# vopt +acc -fsmdebug -assertdebug $(TOP_MODULE) -work cdc +cover=bcesfx -o opt -debug
	vsim -c -work cdc top_tb  \
	-voptargs=+acc \
	-solvefaildebug \
	-uvmcontrol=all \
	-classdebug \
	-assertdebug \
	+UVM_TESTNAME=$(UVM_TESTNAME) \
	+UVM_VERBOSITY=$(UVM_VERBOSITY) \
	-do "run -all; quit"


ncsim:
	irun -64bit -linedebug -access +rwc	\
	    -vtimescale 1ns/100ps	\
	    -coverage u -covoverwrite	\
	    +UVM_VERBOSITY=$(UVM_VERBOSITY)	\
	    +UVM_TESTNAME=$(UVM_TESTNAME)	\
	    -abvevalnochange		\
	    $(TOP_MODULE:%=-top %)	\
	    -makelib cdc		\
	    -v93			\
	    $(DUT_INC)			\
	    $(VHDL_SRC:%=../dut/%)	\
	    $(DUT_SV_SRC:%=../dut/%)	\
	    -endlib			\
	    -makelib tb			\
	    $(INC)			\
	    $(SV_SRC)			\
	    -endlib			\
	    $(GUI)

