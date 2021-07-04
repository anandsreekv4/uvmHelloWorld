// You can insert code here by setting file_header_inc in file common.tpl

//=============================================================================
// Copyright (c) Anand Sreekumar
//=============================================================================
// Project  : ../../design/afifo
//
// File Name: afifo_read_seq_item.sv
//
// Author   : Name   : Anand Sreekumar
//            Email  : anandsreekv4@gmail.com
//            Year   : 2021
//
// Version:   1.0
//
//=============================================================================
// Description: Sequence item for afifo_read_sequencer
//=============================================================================

`ifndef AFIFO_READ_SEQ_ITEM_SV
`define AFIFO_READ_SEQ_ITEM_SV

// You can insert code here by setting trans_inc_before_class in file afifo_rd_if.tpl

class rd_transaction extends uvm_sequence_item; 

  `uvm_object_utils(rd_transaction)

  // To include variables in copy, compare, print, record, pack, unpack, and compare2string, define them using trans_var in file afifo_rd_if.tpl
  // To exclude variables from compare, pack, and unpack methods, define them using trans_meta in file afifo_rd_if.tpl

  // Transaction variables
  bit [DWDTH-1:0]    rdata;
  rand bit                rrstn;
  rand bit                rinc;
  bit                fifo_empty;
  bit                fifo_underflow;


  constraint c0 { rrstn == 1; }
  constraint c1 { rinc  == 1; }

  extern function new(string name = "");

  // You can remove do_copy/compare/print/record and convert2string method by setting trans_generate_methods_inside_class = no in file afifo_rd_if.tpl
  extern function void do_copy(uvm_object rhs);
  extern function bit  do_compare(uvm_object rhs, uvm_comparer comparer);
  extern function void do_print(uvm_printer printer);
  extern function void do_record(uvm_recorder recorder);
  extern function void do_pack(uvm_packer packer);
  extern function void do_unpack(uvm_packer packer);
  extern function string convert2string();

  // You can insert code here by setting trans_inc_inside_class in file afifo_rd_if.tpl

endclass : rd_transaction 


function rd_transaction::new(string name = "");
  super.new(name);
endfunction : new


// You can remove do_copy/compare/print/record and convert2string method by setting trans_generate_methods_after_class = no in file afifo_rd_if.tpl

function void rd_transaction::do_copy(uvm_object rhs);
  rd_transaction rhs_;
  if (!$cast(rhs_, rhs))
    `uvm_fatal(get_type_name(), "Cast of rhs object failed")
  super.do_copy(rhs);
  rdata          = rhs_.rdata;         
  rrstn          = rhs_.rrstn;         
  rinc           = rhs_.rinc;          
  fifo_empty     = rhs_.fifo_empty;    
  fifo_underflow = rhs_.fifo_underflow;
endfunction : do_copy


function bit rd_transaction::do_compare(uvm_object rhs, uvm_comparer comparer);
  bit result;
  rd_transaction rhs_;
  if (!$cast(rhs_, rhs))
    `uvm_fatal(get_type_name(), "Cast of rhs object failed")
  result = super.do_compare(rhs, comparer);
  result &= comparer.compare_field("rdata", rdata,                   rhs_.rdata,          $bits(rdata));
  result &= comparer.compare_field("rrstn", rrstn,                   rhs_.rrstn,          $bits(rrstn));
  result &= comparer.compare_field("rinc", rinc,                     rhs_.rinc,           $bits(rinc));
  result &= comparer.compare_field("fifo_empty", fifo_empty,         rhs_.fifo_empty,     $bits(fifo_empty));
  result &= comparer.compare_field("fifo_underflow", fifo_underflow, rhs_.fifo_underflow, $bits(fifo_underflow));
  return result;
endfunction : do_compare


function void rd_transaction::do_print(uvm_printer printer);
  if (printer.knobs.sprint == 0)
    `uvm_info(get_type_name(), convert2string(), UVM_MEDIUM)
  else
    printer.m_string = convert2string();
endfunction : do_print


function void rd_transaction::do_record(uvm_recorder recorder);
  super.do_record(recorder);
  // Use the record macros to record the item fields:
  `uvm_record_field("rdata",          rdata)         
  `uvm_record_field("rrstn",          rrstn)         
  `uvm_record_field("rinc",           rinc)          
  `uvm_record_field("fifo_empty",     fifo_empty)    
  `uvm_record_field("fifo_underflow", fifo_underflow)
endfunction : do_record


function void rd_transaction::do_pack(uvm_packer packer);
  super.do_pack(packer);
  `uvm_pack_int(rdata)          
  `uvm_pack_int(rrstn)          
  `uvm_pack_int(rinc)           
  `uvm_pack_int(fifo_empty)     
  `uvm_pack_int(fifo_underflow) 
endfunction : do_pack


function void rd_transaction::do_unpack(uvm_packer packer);
  super.do_unpack(packer);
  `uvm_unpack_int(rdata)          
  `uvm_unpack_int(rrstn)          
  `uvm_unpack_int(rinc)           
  `uvm_unpack_int(fifo_empty)     
  `uvm_unpack_int(fifo_underflow) 
endfunction : do_unpack


function string rd_transaction::convert2string();
  string s;
  $sformat(s, "%s\n", super.convert2string());
  $sformat(s, {"%s\n",
    "rdata          = 'h%0h  'd%0d\n", 
    "rrstn          = 'h%0h  'd%0d\n", 
    "rinc           = 'h%0h  'd%0d\n", 
    "fifo_empty     = 'h%0h  'd%0d\n", 
    "fifo_underflow = 'h%0h  'd%0d\n"},
    get_full_name(), rdata, rdata, rrstn, rrstn, rinc, rinc, fifo_empty, fifo_empty, fifo_underflow, fifo_underflow);
  return s;
endfunction : convert2string


// You can insert code here by setting trans_inc_after_class in file afifo_rd_if.tpl

`endif // AFIFO_READ_SEQ_ITEM_SV

