// You can insert code here by setting file_header_inc in file common.tpl

//=============================================================================
// Project  : afifo_tb
//
// File Name: afifo_read_pkg.sv
//
//
// Version:   1.0
//
// Code created by Easier UVM Code Generator version 2017-01-19 on Sat Jun 26 22:30:53 2021
//=============================================================================
// Description: Package for agent afifo_read
//=============================================================================

package afifo_read_pkg;

  `include "uvm_macros.svh"

  import uvm_pkg::*;

  import afifo_tb_pkg::*;

  `include "afifo_read_rd_transaction.sv"
  `include "afifo_read_config.sv"
  `include "afifo_read_driver.sv"
  `include "afifo_read_monitor.sv"
  `include "afifo_read_sequencer.sv"
  `include "afifo_read_coverage.sv"
  `include "afifo_read_agent.sv"
  `include "afifo_read_seq_lib.sv"

endpackage : afifo_read_pkg
