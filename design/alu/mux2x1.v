// --------------------------------------------------------
// VLSI Arch Assignment - 2
// Author: Anand S
// BITSID: 2021HT80003
// --------------------------------------------------------
// Specifically made for 2x1 as the assignment specifies so,
// otherwise it could have been a parameter as well.
// --------------------------------------------------------
module mux2x1 #(
    `include "alu_params.v"
) (
    input [DATA_WDTH-1:0] in0, in1,
    input                 sel,
    output reg [DATA_WDTH-1:0] out
);

    always @(*) begin: mux_comb
        case (sel)
            1'b0: out = in0;
            1'b1: out = in1;
            default: out = in0;
        endcase
    end

endmodule // mux2x1
