//------------------------------------------------------------
// MELZG642 VLSI Architecure Assignment #1
// Name: Anand S
// BITSID: 2021HT80003
//------------------------------------------------------------
module ppg #(
    parameter MD_WD     = 16, // Multiplicand width
    parameter MR_WD     =  9, // Multiplier width
    parameter MDMR_WD   = MD_WD+MR_WD
) (
    input  logic [MD_WD-1:0]    A,
    input  logic [MR_WD-1:0]    B,
    output logic [MDMR_WD-1:0]  PP [0:MR_WD-1]
);


    always_comb begin: PP_gen
        for (int ii=0; ii<MR_WD; ii++) begin
            PP[ii]      = '0; // pad zeros
            for (int jj=0; jj<MD_WD; jj++) begin
                PP[ii][jj+ii]  = B[ii] & A[jj];
            end
        end
    end: PP_gen

endmodule: mult
