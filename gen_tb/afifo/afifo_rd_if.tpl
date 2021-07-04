agent_name = afifo_read
trans_item = rd_transaction

trans_var =      bit [DWDTH-1:0]    rdata;
trans_var = rand bit                rrstn;
trans_var = rand bit                rinc;
trans_var =      bit                fifo_empty;
trans_var =      bit                fifo_underflow;

trans_var_constraint = { rrstn == 1; }
trans_var_constraint = { rinc  == 1; }

if_port   = logic rclk_i;
if_port   = logic rrstn_i;
if_port   = logic rinc_i;
if_port   = logic [DWDTH-1:0] rdata_o;
if_port   = logic fifo_empty_o;
if_port   = logic fifo_undrflw_o;
if_clock  = rclk_i


driver_inc = afifo_read_do_drive.sv         inline
monitor_inc = afifo_read_do_mon.sv          inline
agent_cover_inc = afifo_read_cover_inc.sv   inline

agent_seq_inc = afifo_read_reset_seq.sv     inline
