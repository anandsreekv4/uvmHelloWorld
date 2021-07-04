// You can insert code here by setting file_header_inc in file common.tpl

//=============================================================================
// Copyright (c) Anand Sreekumar
//=============================================================================
// Project  : ../../design/afifo
//
// File Name: afifo_write_pkg.sv
//
// Author   : Name   : Anand Sreekumar
//            Email  : anandsreekv4@gmail.com
//            Year   : 2021
//
// Version:   1.0
//
//=============================================================================
// Description: Package for agent afifo_write
//=============================================================================

package afifo_write_pkg;

  `include "uvm_macros.svh"

  import uvm_pkg::*;

  import afifo_tb_pkg::*;

  `include "afifo_write_wr_transaction.sv"
  `include "afifo_write_config.sv"
  `include "afifo_write_driver.sv"
  `include "afifo_write_monitor.sv"
  `include "afifo_write_sequencer.sv"
  `include "afifo_write_coverage.sv"
  `include "afifo_write_agent.sv"
  `include "afifo_write_seq_lib.sv"

endpackage : afifo_write_pkg
