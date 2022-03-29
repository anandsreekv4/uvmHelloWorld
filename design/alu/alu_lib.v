// --------------------------------------------------------
// VLSI Arch Assignment - 2
// Author: Anand S
// BITSID: 2021HT80003
// --------------------------------------------------------

module alu_AND #(
    `include "alu_params.v"
) (
    input [DATA_WDTH-1:0] i0,
    input [DATA_WDTH-1:0] i1,
    output[DATA_WDTH-1:0] o
);

    assign o = i0 & i1;

endmodule // alu_AND

module alu_OR #(
    `include "alu_params.v"
) (
    input [DATA_WDTH-1:0] i0,
    input [DATA_WDTH-1:0] i1,
    output[DATA_WDTH-1:0] o
);

    assign o = i0 | i1;

endmodule // alu_OR

module alu_XOR #(
    `include "alu_params.v"
) (
    input [DATA_WDTH-1:0] i0,
    input [DATA_WDTH-1:0] i1,
    output[DATA_WDTH-1:0] o
);

    assign o = i0 ^ i1;

endmodule // alu_XOR

module alu_LUI #(
    `include "alu_params.v"
) (
    input [DATA_WDTH-1:0] in,
    output[DATA_WDTH-1:0] out
);

    assign out = {in[(DATA_WDTH/2)-1:0], {(DATA_WDTH/2){1'b0}}};

endmodule // alu_LUI
