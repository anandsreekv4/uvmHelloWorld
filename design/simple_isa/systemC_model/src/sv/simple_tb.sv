module simple_tb;

    // Wires
    reg clk, resetn;
    wire [1:0] phase;
    // DUT
    simple_cpu u_simple_cpu (.*);
    //    simple_phase_ctr u_phase(
    //        .clk    (clk)
    //    ,   .resetn (resetn)
    //    ,   .phase  (phase)
    //    );
    //    // Clk gen
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
        #2000;
        $finish;
    end: finish
endmodule: simple_tb
