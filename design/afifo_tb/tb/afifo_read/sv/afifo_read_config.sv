// You can insert code here by setting file_header_inc in file common.tpl

//=============================================================================
// Project  : afifo_tb
//
// File Name: afifo_read_config.sv
//
//
// Version:   1.0
//
// Code created by Easier UVM Code Generator version 2017-01-19 on Sat Jun 26 22:30:53 2021
//=============================================================================
// Description: Configuration for agent afifo_read
//=============================================================================

`ifndef AFIFO_READ_CONFIG_SV
`define AFIFO_READ_CONFIG_SV

// You can insert code here by setting agent_config_inc_before_class in file afifo_rd_if.tpl

class afifo_read_config extends uvm_object;

  // Do not register config class with the factory

  virtual afifo_read_if    vif;
                  
  uvm_active_passive_enum  is_active = UVM_ACTIVE;
  bit                      coverage_enable;       
  bit                      checks_enable;         

  // You can insert variables here by setting config_var in file afifo_rd_if.tpl

  // You can remove new by setting agent_config_generate_methods_inside_class = no in file afifo_rd_if.tpl

  extern function new(string name = "");

  // You can insert code here by setting agent_config_inc_inside_class in file afifo_rd_if.tpl

endclass : afifo_read_config 


// You can remove new by setting agent_config_generate_methods_after_class = no in file afifo_rd_if.tpl

function afifo_read_config::new(string name = "");
  super.new(name);
endfunction : new


// You can insert code here by setting agent_config_inc_after_class in file afifo_rd_if.tpl

`endif // AFIFO_READ_CONFIG_SV

