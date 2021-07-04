task afifo_write_monitor::do_mon();
    string s;
    forever begin
        @(posedge vif.wclk_i);
        m_trans = wr_transaction::type_id::create("m_trans");
        m_trans.wdata = vif.wdata_i;
        m_trans.wrstn = vif.wrstn_i;
        m_trans.fifo_full = vif.fifo_full_o;
        m_trans.fifo_overflow = vif.fifo_ovflw_o;

        s = $sformatf("Sending following trn for coverage:-\n%s", m_trans.convert2string());
        `uvm_info(get_type_name(), s, UVM_MEDIUM)
        analysis_port.write(m_trans);
    end
endtask: do_mon
