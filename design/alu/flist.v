// --------------------------------------------------------
// VLSI Arch Assignment - 2
// Author: Anand S
// BITSID: 2021HT80003
// --------------------------------------------------------
// file list include
// --------------------------------------------------------

`ifndef __INCLUDE_FILES__
`define __INCLUDE_FILES__
`include "alu_lib.v"
`ifdef ALU_4bit_CLA
    `include "cla_4bit.v"
    `include "cla_top.v"
`else
    `include "cla.v"
`endif
`include "mux2x1.v"
`include "mux4x1.v"
`include "shifter.v"
`include "alu.v"
`endif
