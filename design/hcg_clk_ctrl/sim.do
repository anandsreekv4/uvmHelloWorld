restart;
vlog tb_hcg_clk_ctrl.sv; 
vopt +acc=a -assertdebug -fsmdebug tb_hcg_clk_ctrl -o opt;
vsim opt +mode=STOP2RUN2WAIT2STOP -fsmdebug -assertdebug +acc;
add wave -r *; 
atv log -enable /u_DUT
run -all
