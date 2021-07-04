agent_name = afifo_write
trans_item = wr_transaction

trans_var = rand bit [DWDTH-1:0]    wdata;
trans_var = rand bit                wrstn;
trans_var = rand bit                winc;
trans_var =      bit                fifo_full;
trans_var =      bit                fifo_overflow;

trans_var_constraint = { wrstn == 1; }
trans_var_constraint = { winc  == 1; }

if_port   = logic wclk_i;
if_port   = logic wrstn_i;
if_port   = logic winc_i;
if_port   = logic [DWDTH-1:0] wdata_i;
if_port   = logic fifo_full_o;
if_port   = logic fifo_ovflw_o;
if_clock  = wclk_i


driver_inc = afifo_write_do_drive.sv            inline
monitor_inc= afifo_write_do_mon.sv              inline
agent_cover_inc = afifo_write_cover_inc.sv      inline

agent_seq_inc = afifo_write_reset_seq.sv        inline
