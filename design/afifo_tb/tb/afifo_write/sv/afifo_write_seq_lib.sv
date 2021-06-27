// You can insert code here by setting file_header_inc in file common.tpl

//=============================================================================
// Project  : afifo_tb
//
// File Name: afifo_write_seq_lib.sv
//
//
// Version:   1.0
//
// Code created by Easier UVM Code Generator version 2017-01-19 on Sat Jun 26 22:30:53 2021
//=============================================================================
// Description: Sequence for agent afifo_write
//=============================================================================

`ifndef AFIFO_WRITE_SEQ_LIB_SV
`define AFIFO_WRITE_SEQ_LIB_SV

class afifo_write_default_seq extends uvm_sequence #(wr_transaction);

  `uvm_object_utils(afifo_write_default_seq)

  afifo_write_config  m_config;

  extern function new(string name = "");
  extern task body();

`ifndef UVM_POST_VERSION_1_1
  // Functions to support UVM 1.2 objection API in UVM 1.1
  extern function uvm_phase get_starting_phase();
  extern function void set_starting_phase(uvm_phase phase);
`endif

endclass : afifo_write_default_seq


function afifo_write_default_seq::new(string name = "");
  super.new(name);
endfunction : new


task afifo_write_default_seq::body();
  `uvm_info(get_type_name(), "Default sequence starting", UVM_HIGH)

  req = wr_transaction::type_id::create("req");
  start_item(req); 
  if ( !req.randomize() )
    `uvm_error(get_type_name(), "Failed to randomize transaction")
  finish_item(req); 

  `uvm_info(get_type_name(), "Default sequence completed", UVM_HIGH)
endtask : body


`ifndef UVM_POST_VERSION_1_1
function uvm_phase afifo_write_default_seq::get_starting_phase();
  return starting_phase;
endfunction: get_starting_phase


function void afifo_write_default_seq::set_starting_phase(uvm_phase phase);
  starting_phase = phase;
endfunction: set_starting_phase
`endif


`include "afifo_write_reset_seq.sv"

`endif // AFIFO_WRITE_SEQ_LIB_SV

