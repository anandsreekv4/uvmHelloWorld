// ------------------------------------------------------------------
// HSCD Assignment - 1
// AUTHOR: Anand S
// BITS ID: 2021HT80003
// ------------------------------------------------------------------
// Has 4 phases - IF, ID, EX, WB
// The FSM uses this ctr to sequence the signals

module simple_phase_ctr (
    input   clk
,   input   resetn
,   output  logic [1:0] phase
);

    always_ff @(posedge clk, negedge resetn)
        if (!resetn)
            phase <= 0;
        else
            phase <= phase + 1;

endmodule: simple_phase_ctr
