//------------------------------------------------------------
// MELZG642 VLSI Architecure Assignment #1
// Name: Anand S
// BITSID: 2021HT80003
//------------------------------------------------------------
module mult #(
    parameter MD_WD     = 16, // Multiplicand width
    parameter MR_WD     =  9, // Multiplier width
    parameter MDMR_WD   = MD_WD+MR_WD
) (
    input  logic [MD_WD-1:0]    A,
    input  logic [MR_WD-1:0]    B,
    output logic [MDMR_WD-1:0]  O
);

    assign O = A*B;

endmodule: mult
