export DESIGN=$(basename $(notdir $(shell pwd)))

all:
	bsub -I vlog tb_hcg_clk_ctrl.sv
	bsub -I vsim -novopt tb_hcg_clk_ctrl
