//------------------------------------------------------------
// MELZG642 VLSI Architecure Assignment #1
// Name: Anand S
// BITSID: 2021HT80003
//------------------------------------------------------------
`include "mult16x9behav.sv"
`include "ppg.sv"
`include "fulladder.sv"
`include "csa.sv"
`include "cpa.sv"
`include "mult_xy.sv"
module top;
    localparam MD_WD =16;                           // Multiplicand width
    localparam MR_WD = 9;                           // Multiplier width
    localparam MDMR_WD = MD_WD+MR_WD;

    logic [MD_WD-1:0] A;
    logic [MR_WD-1:0] B;
    logic [MDMR_WD-1:0] O;
    logic [MDMR_WD-1:0] O_xy;
    logic [MDMR_WD-1:0]  PP [0:MR_WD-1];
    logic test_done;

    mult    #(MD_WD,MR_WD) u_mult   (.*);           // Behavrioural multiplier
    mult_xy #(MD_WD,MR_WD) u_mult_xy(.O(O_xy),.*);  // Structural multiplier

    initial begin: SEQ
        A = 39256;
        B = 500;
        #10;
        test_done = 1;
        #1 $finish;
    end: SEQ

    always_comb begin: check
        if (test_done===1) begin
            ERR_O_MISMATCH: assert(O===O_xy)
                 $display("INFO: Behavioural Mult value O(%d) matches actual value O_xy(%d)", O, O_xy);
            else $error ("ERROR: Behavioural Mult value O(%d) does not match actual value O_xy(%d)", O, O_xy);
        end
    end: check
endmodule: top
