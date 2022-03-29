//------------------------------------------------------------
// MELZG642 VLSI Architecure Assignment #1
// Name: Anand S
// BITSID: 2021HT80003
//------------------------------------------------------------
module cpa #(
    parameter MD_WD     = 16, // Multiplicand width
    parameter MR_WD     =  9, // Multiplier width
    parameter MDMR_WD   = MD_WD+MR_WD
) (
    input  logic [MDMR_WD-1:0] x, y,
    output logic [MDMR_WD-1:0] sum,
    output logic               cout
);


    logic [MDMR_WD  :0]  cint;              // Final CPA carry
    assign cint[0]= '0;
    genvar ii,jj;
    generate
        for(ii=0;ii<MDMR_WD;ii++) begin: stage_fa
            fulladder i_FA(.A(x[ii]),.B(y[ii]),.CIN(cint[ii]),.SUM(sum[ii]),.CARRY(cint[ii+1]));
        end: stage_fa
    endgenerate
    assign cout  = cint[MDMR_WD-1];

endmodule: cpa
