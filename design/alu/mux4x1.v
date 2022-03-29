// --------------------------------------------------------
// VLSI Arch Assignment - 2
// Author: Anand S
// BITSID: 2021HT80003
// --------------------------------------------------------
// Specifically made for 4x1 as the assignment specifies so,
// otherwise it could have been a parameter as well.
// --------------------------------------------------------
module mux4x1 #(
    `include "alu_params.v"
) (
    input [DATA_WDTH-1:0] in0, in1, in2, in3,
    input [ 1:0]          sel,
    output reg [DATA_WDTH-1:0] out
);
    always @(*) begin: mux_comb
        case (sel)
            2'b00: out = in0;
            2'b01: out = in1;
            2'b10: out = in2;
            2'b11: out = in3;
            default: out = in0;
        endcase
    end

endmodule // mux4x1
