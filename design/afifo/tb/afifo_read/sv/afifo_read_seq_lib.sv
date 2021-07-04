// You can insert code here by setting file_header_inc in file common.tpl

//=============================================================================
// Copyright (c) Anand Sreekumar
//=============================================================================
// Project  : ../../design/afifo
//
// File Name: afifo_read_seq_lib.sv
//
// Author   : Name   : Anand Sreekumar
//            Email  : anandsreekv4@gmail.com
//            Year   : 2021
//
// Version:   1.0
//
//=============================================================================
// Description: Sequence for agent afifo_read
//=============================================================================

`ifndef AFIFO_READ_SEQ_LIB_SV
`define AFIFO_READ_SEQ_LIB_SV

class afifo_read_default_seq extends uvm_sequence #(rd_transaction);

  `uvm_object_utils(afifo_read_default_seq)

  afifo_read_config  m_config;

  extern function new(string name = "");
  extern task body();

`ifndef UVM_POST_VERSION_1_1
  // Functions to support UVM 1.2 objection API in UVM 1.1
  extern function uvm_phase get_starting_phase();
  extern function void set_starting_phase(uvm_phase phase);
`endif

endclass : afifo_read_default_seq


function afifo_read_default_seq::new(string name = "");
  super.new(name);
endfunction : new


task afifo_read_default_seq::body();
  `uvm_info(get_type_name(), "Default sequence starting", UVM_HIGH)

  req = rd_transaction::type_id::create("req");
  start_item(req); 
  if ( !req.randomize() )
    `uvm_error(get_type_name(), "Failed to randomize transaction")
  finish_item(req); 

  `uvm_info(get_type_name(), "Default sequence completed", UVM_HIGH)
endtask : body


`ifndef UVM_POST_VERSION_1_1
function uvm_phase afifo_read_default_seq::get_starting_phase();
  return starting_phase;
endfunction: get_starting_phase


function void afifo_read_default_seq::set_starting_phase(uvm_phase phase);
  starting_phase = phase;
endfunction: set_starting_phase
`endif


// Start of inlined include file ../../design/afifo/tb/include/afifo_read_reset_seq.sv
class afifo_read_reset_seq extends afifo_read_default_seq;
    `uvm_object_utils(afifo_read_reset_seq)

    extern function new(string name="");
    extern task body();
endclass: afifo_read_reset_seq

function afifo_read_reset_seq::new (string name="" );
    super.new(name);
endfunction: new

task afifo_read_reset_seq::body();
    `uvm_info(get_type_name(), "Reset sequence starting", UVM_MEDIUM)

    req = rd_transaction::type_id::create("req");
    start_item(req);
    req.rrstn = 0; // Just send an empty default trn
    req.rinc  = 0; // Just send an empty default trn
    finish_item(req);
    `uvm_info(get_type_name(), "Reset sequence done", UVM_MEDIUM)
endtask: body

class afifo_read_reset_lift_seq extends afifo_read_default_seq;
    `uvm_object_utils(afifo_read_reset_lift_seq)

    extern function new (string name="");
    extern task body();
endclass: afifo_read_reset_lift_seq

function afifo_read_reset_lift_seq::new (string name="");
    super.new(name);
endfunction: new

task afifo_read_reset_lift_seq::body();
    `uvm_info(get_type_name(), "Reset lift-off starting", UVM_MEDIUM)

    req = rd_transaction::type_id::create("req");
    start_item(req);
    req.rrstn = 1;
    req.rinc  = 0; // For lift-off, don't try to read immediately
    finish_item(req);

    `uvm_info(get_type_name(), "Reset lift-off done!", UVM_MEDIUM)
endtask: body
// End of inlined include file

`endif // AFIFO_READ_SEQ_LIB_SV

