task afifo_read_monitor::do_mon();
    string s;
    forever begin
        @(posedge vif.rclk_i);
        m_trans = rd_transaction::type_id::create("m_trans");
        m_trans.rdata = vif.rdata_o;
        m_trans.rrstn = vif.rrstn_i;
        m_trans.fifo_empty = vif.fifo_empty_o;
        m_trans.fifo_underflow = vif.fifo_undrflw_o;

        s = $sformatf("Sending following trn for coverage:-\n%s", m_trans.convert2string());
        `uvm_info(get_type_name(), s, UVM_DEBUG)
        analysis_port.write(m_trans);
    end
endtask: do_mon
