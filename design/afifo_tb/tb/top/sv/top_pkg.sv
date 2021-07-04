// You can insert code here by setting file_header_inc in file common.tpl

//=============================================================================
// Project  : afifo_tb
//
// File Name: top_pkg.sv
//
//
// Version:   1.0
//
//=============================================================================
// Description: Package for top
//=============================================================================

package top_pkg;

  `include "uvm_macros.svh"

  import uvm_pkg::*;

  import afifo_tb_pkg::*;
  import afifo_write_pkg::*;
  import afifo_read_pkg::*;

  `include "top_config.sv"
  `include "top_seq_lib.sv"
  `include "top_env.sv"

endpackage : top_pkg
