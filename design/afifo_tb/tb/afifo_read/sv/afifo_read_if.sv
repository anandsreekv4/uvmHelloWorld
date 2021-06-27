// You can insert code here by setting file_header_inc in file common.tpl

//=============================================================================
// Project  : afifo_tb
//
// File Name: afifo_read_if.sv
//
//
// Version:   1.0
//
// Code created by Easier UVM Code Generator version 2017-01-19 on Sat Jun 26 22:30:53 2021
//=============================================================================
// Description: Signal interface for agent afifo_read
//=============================================================================

`ifndef AFIFO_READ_IF_SV
`define AFIFO_READ_IF_SV

interface afifo_read_if(); 

  timeunit      1ns;
  timeprecision 1ps;

  import afifo_tb_pkg::*;
  import afifo_read_pkg::*;

  logic rclk_i;
  logic rrstn_i;
  logic rinc_i;
  logic [DWDTH-1:0] rdata_o;
  logic fifo_empty_o;
  logic fifo_undrflw_o;

  // You can insert properties and assertions here

  // You can insert code here by setting if_inc_inside_interface in file afifo_rd_if.tpl

endinterface : afifo_read_if

`endif // AFIFO_READ_IF_SV

