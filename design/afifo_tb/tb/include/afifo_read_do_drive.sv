task afifo_read_driver::do_drive();
    @(posedge vif.rclk_i);
    vif.rinc_i <= req.rinc; // modification so rinc only when out of reset
    vif.rrstn_i<= req.rrstn;
    @(posedge vif.rclk_i);
    vif.rinc_i <= 0;
endtask: do_drive
