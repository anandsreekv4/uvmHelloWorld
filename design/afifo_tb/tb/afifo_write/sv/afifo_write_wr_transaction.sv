// You can insert code here by setting file_header_inc in file common.tpl

//=============================================================================
// Project  : afifo_tb
//
// File Name: afifo_write_seq_item.sv
//
//
// Version:   1.0
//
// Code created by Easier UVM Code Generator version 2017-01-19 on Sat Jun 26 22:30:53 2021
//=============================================================================
// Description: Sequence item for afifo_write_sequencer
//=============================================================================

`ifndef AFIFO_WRITE_SEQ_ITEM_SV
`define AFIFO_WRITE_SEQ_ITEM_SV

// You can insert code here by setting trans_inc_before_class in file afifo_wr_if.tpl

class wr_transaction extends uvm_sequence_item; 

  `uvm_object_utils(wr_transaction)

  // To include variables in copy, compare, print, record, pack, unpack, and compare2string, define them using trans_var in file afifo_wr_if.tpl
  // To exclude variables from compare, pack, and unpack methods, define them using trans_meta in file afifo_wr_if.tpl

  // Transaction variables
  rand bit [DWDTH-1:0]    wdata;
  rand bit                wrstn;
  rand bit                winc;
  bit                fifo_full;
  bit                fifo_overflow;


  constraint c0 { wrstn == 1; }
  constraint c1 { winc  == 1; }

  extern function new(string name = "");

  // You can remove do_copy/compare/print/record and convert2string method by setting trans_generate_methods_inside_class = no in file afifo_wr_if.tpl
  extern function void do_copy(uvm_object rhs);
  extern function bit  do_compare(uvm_object rhs, uvm_comparer comparer);
  extern function void do_print(uvm_printer printer);
  extern function void do_record(uvm_recorder recorder);
  extern function void do_pack(uvm_packer packer);
  extern function void do_unpack(uvm_packer packer);
  extern function string convert2string();

  // You can insert code here by setting trans_inc_inside_class in file afifo_wr_if.tpl

endclass : wr_transaction 


function wr_transaction::new(string name = "");
  super.new(name);
endfunction : new


// You can remove do_copy/compare/print/record and convert2string method by setting trans_generate_methods_after_class = no in file afifo_wr_if.tpl

function void wr_transaction::do_copy(uvm_object rhs);
  wr_transaction rhs_;
  if (!$cast(rhs_, rhs))
    `uvm_fatal(get_type_name(), "Cast of rhs object failed")
  super.do_copy(rhs);
  wdata         = rhs_.wdata;        
  wrstn         = rhs_.wrstn;        
  winc          = rhs_.winc;         
  fifo_full     = rhs_.fifo_full;    
  fifo_overflow = rhs_.fifo_overflow;
endfunction : do_copy


function bit wr_transaction::do_compare(uvm_object rhs, uvm_comparer comparer);
  bit result;
  wr_transaction rhs_;
  if (!$cast(rhs_, rhs))
    `uvm_fatal(get_type_name(), "Cast of rhs object failed")
  result = super.do_compare(rhs, comparer);
  result &= comparer.compare_field("wdata", wdata,                 rhs_.wdata,         $bits(wdata));
  result &= comparer.compare_field("wrstn", wrstn,                 rhs_.wrstn,         $bits(wrstn));
  result &= comparer.compare_field("winc", winc,                   rhs_.winc,          $bits(winc));
  result &= comparer.compare_field("fifo_full", fifo_full,         rhs_.fifo_full,     $bits(fifo_full));
  result &= comparer.compare_field("fifo_overflow", fifo_overflow, rhs_.fifo_overflow, $bits(fifo_overflow));
  return result;
endfunction : do_compare


function void wr_transaction::do_print(uvm_printer printer);
  if (printer.knobs.sprint == 0)
    `uvm_info(get_type_name(), convert2string(), UVM_MEDIUM)
  else
    printer.m_string = convert2string();
endfunction : do_print


function void wr_transaction::do_record(uvm_recorder recorder);
  super.do_record(recorder);
  // Use the record macros to record the item fields:
  `uvm_record_field("wdata",         wdata)        
  `uvm_record_field("wrstn",         wrstn)        
  `uvm_record_field("winc",          winc)         
  `uvm_record_field("fifo_full",     fifo_full)    
  `uvm_record_field("fifo_overflow", fifo_overflow)
endfunction : do_record


function void wr_transaction::do_pack(uvm_packer packer);
  super.do_pack(packer);
  `uvm_pack_int(wdata)         
  `uvm_pack_int(wrstn)         
  `uvm_pack_int(winc)          
  `uvm_pack_int(fifo_full)     
  `uvm_pack_int(fifo_overflow) 
endfunction : do_pack


function void wr_transaction::do_unpack(uvm_packer packer);
  super.do_unpack(packer);
  `uvm_unpack_int(wdata)         
  `uvm_unpack_int(wrstn)         
  `uvm_unpack_int(winc)          
  `uvm_unpack_int(fifo_full)     
  `uvm_unpack_int(fifo_overflow) 
endfunction : do_unpack


function string wr_transaction::convert2string();
  string s;
  $sformat(s, "%s\n", super.convert2string());
  $sformat(s, {"%s\n",
    "wdata         = 'h%0h  'd%0d\n", 
    "wrstn         = 'h%0h  'd%0d\n", 
    "winc          = 'h%0h  'd%0d\n", 
    "fifo_full     = 'h%0h  'd%0d\n", 
    "fifo_overflow = 'h%0h  'd%0d\n"},
    get_full_name(), wdata, wdata, wrstn, wrstn, winc, winc, fifo_full, fifo_full, fifo_overflow, fifo_overflow);
  return s;
endfunction : convert2string


// You can insert code here by setting trans_inc_after_class in file afifo_wr_if.tpl

`endif // AFIFO_WRITE_SEQ_ITEM_SV

