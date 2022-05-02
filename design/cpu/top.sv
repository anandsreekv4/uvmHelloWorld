// --------------------------------------------------------
// VLSI Arch Assignment - 3
// Author: Anand S
// BITSID: 2021HT80003
// --------------------------------------------------------

`include "flist.v"
module top;
    logic clk;
    logic resetn;

    // ---------------------
    // DUT
    // ---------------------
    cpu
    u_cpu (
    /*AUTOINST*/
           // Inputs
           .clk                         (clk),
           .resetn                      (resetn));

    initial begin
        clk <= 0;
        forever #5 clk = ~ clk;
    end

    initial begin: seq
        resetn = 0;
        #10;
        resetn = 1;
    end: seq
    initial begin: finish
        #200;
        $finish;
    end: finish
endmodule: top
