// You can insert code here by setting file_header_inc in file common.tpl

//=============================================================================
// Copyright (c) Anand Sreekumar
//=============================================================================
// Project  : ../../design/afifo
//
// File Name: afifo_read_driver.sv
//
// Author   : Name   : Anand Sreekumar
//            Email  : anandsreekv4@gmail.com
//            Year   : 2021
//
// Version:   1.0
//
//=============================================================================
// Description: Driver for afifo_read
//=============================================================================

`ifndef AFIFO_READ_DRIVER_SV
`define AFIFO_READ_DRIVER_SV

// You can insert code here by setting driver_inc_before_class in file afifo_rd_if.tpl

class afifo_read_driver extends uvm_driver #(rd_transaction);

  `uvm_component_utils(afifo_read_driver)

  virtual afifo_read_if vif;

  afifo_read_config     m_config;

  extern function new(string name, uvm_component parent);

  // Methods run_phase and do_drive generated by setting driver_inc in file afifo_rd_if.tpl
  extern task run_phase(uvm_phase phase);
  extern task do_drive();

  // You can insert code here by setting driver_inc_inside_class in file afifo_rd_if.tpl

endclass : afifo_read_driver 


function afifo_read_driver::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new


task afifo_read_driver::run_phase(uvm_phase phase);
  `uvm_info(get_type_name(), "run_phase", UVM_HIGH)

  forever
  begin
    seq_item_port.get_next_item(req);
      `uvm_info(get_type_name(), {"req item\n",req.sprint}, UVM_HIGH)
    do_drive();
    seq_item_port.item_done();
  end
endtask : run_phase


// Start of inlined include file ../../design/afifo/tb/include/afifo_read_do_drive.sv
task afifo_read_driver::do_drive();
    @(posedge vif.rclk_i);
    vif.rinc_i <= req.rinc; // modification so rinc only when out of reset
    vif.rrstn_i<= req.rrstn;
    @(posedge vif.rclk_i);
    vif.rinc_i <= 0;
endtask: do_drive
// End of inlined include file

// You can insert code here by setting driver_inc_after_class in file afifo_rd_if.tpl

`endif // AFIFO_READ_DRIVER_SV

