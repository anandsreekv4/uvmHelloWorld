// You can insert code here by setting file_header_inc in file common.tpl

//=============================================================================
// Project  : afifo_tb
//
// File Name: afifo_write_if.sv
//
//
// Version:   1.0
//
//=============================================================================
// Description: Signal interface for agent afifo_write
//=============================================================================

`ifndef AFIFO_WRITE_IF_SV
`define AFIFO_WRITE_IF_SV

interface afifo_write_if(); 

  timeunit      1ns;
  timeprecision 1ps;

  import afifo_tb_pkg::*;
  import afifo_write_pkg::*;

  logic wclk_i;
  logic wrstn_i;
  logic winc_i;
  logic [DWDTH-1:0] wdata_i;
  logic fifo_full_o;
  logic fifo_ovflw_o;

  // You can insert properties and assertions here

  // You can insert code here by setting if_inc_inside_interface in file afifo_wr_if.tpl

endinterface : afifo_write_if

`endif // AFIFO_WRITE_IF_SV

