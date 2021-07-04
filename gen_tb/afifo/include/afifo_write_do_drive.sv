task afifo_write_driver::do_drive();
    @(posedge vif.wclk_i);
    vif.winc_i <= req.winc; // modification so winc only when out of reset
    vif.wdata_i<= req.wdata;
    vif.wrstn_i<= req.wrstn;
    @(posedge vif.wclk_i);
    vif.winc_i <= 0;
endtask: do_drive
