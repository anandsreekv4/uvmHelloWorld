// --------------------------------------------------------
// VLSI Arch Assignment - 2
// Author: Anand S
// BITSID: 2021HT80003
// --------------------------------------------------------
// file list include
// --------------------------------------------------------

`ifndef __INCLUDE_FILES__
`define __INCLUDE_FILES__
    // ALU files
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
    // MUL files
    `include "mult16x9behav.sv"
    `include "ppg.sv"
    `include "fulladder.sv"
    `include "csa.sv"
    `include "cpa.sv"
    `include "mult_xy.sv"
    // CPU files
    `include "cpu_pkg.sv"
    `include "ex_wb_pipe.sv"
    `include "id_ex_pipe.sv"
    `include "if_id_pipe.sv"
    `include "instr_mem.sv"
    `include "reg_file.sv"
    `include "cpu.sv"
`endif // __INCLUDE_FILES__
