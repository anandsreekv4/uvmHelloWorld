//-----------------------------------------------------------------------------
// Title         : tb_sqrt
// Project       : sqrt
//-----------------------------------------------------------------------------
// File          : tb_sqrt.sv
// Author        : Anand S/INDIA  <ansn@aremote05>
// Created       : 20.03.2021
// Last modified : 20.03.2021
//-----------------------------------------------------------------------------
// Description :
// Simple TB for the sqrt module
//-----------------------------------------------------------------------------
// Copyright (c) 2021 by Anand Sreekumar This model is the confidential and
// proprietary property of Anand Sreekumar and the possession or use of this
// file requires a written license from Anand Sreekumar.
//------------------------------------------------------------------------------
// Modification history :
// 20.03.2021 : created
//-----------------------------------------------------------------------------

module tb_sqrt;
    
parameter NBITS = 5;
logic clk_i, rstn_i;
logic [NBITS-1:0] N, result_o;
logic start_i, busy, valid_o;

sqrt #(.NBITS(NBITS), .PRECISION(0)) u_sqrt (.*);

initial begin: CLK_GEN
    clk_i <= '0;
    forever #5 clk_i = !clk_i;
end: CLK_GEN

initial begin: do_reset
    rstn_i <= 0;
    repeat (2) @(posedge clk_i);
    rstn_i <= 1;
end: do_reset

initial begin: SEQ
    #50;
    N = 16;
    @(posedge clk_i);
    start_i <= 1;
    @(posedge clk_i);
    start_i <= 0;
    wait(valid_o);
    N = 6;
    @(posedge clk_i);
    start_i <= 1;
    @(posedge clk_i);
    start_i <= 0;
    #200;
    $finish;
end: SEQ

/* DUMP VCD */
initial begin: dump_vcd
    $dumpfile("dump.vcd");
    $dumpvars;
end: dump_vcd
   
endmodule: tb_sqrt
