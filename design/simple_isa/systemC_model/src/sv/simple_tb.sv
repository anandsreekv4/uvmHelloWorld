//`include "flist.v"
module simple_tb;

    // Wires
    logic clk, resetn;
    // DUT
    simple_cpu u_simple_cpu (.*);
    // Clk gen
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
endmodule: simple_tb
