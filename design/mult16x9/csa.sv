//------------------------------------------------------------
// MELZG642 VLSI Architecure Assignment #1
// Name: Anand S
// BITSID: 2021HT80003
//------------------------------------------------------------
// Consider this example:-
// A:1111
// B:1111
// Partial Product array: (4+4)*4 dimensions
// PP[0]:00001111  x
// PP[1]:00011110  y
// PP[2]:00111100  z
//                sum   :00101101   x
//                carry :0011110Z   y               (pad zero, truncate MSB)
// PP[3]:01111000                   z
//                                  sum  :01101001
//                                  carry:01111000  (pad zero, truncate MSB)
//                                  FAsum:11100001, cout:0
// So always the csa can be invoked with MDMR_WD of x,y,z,sum,carry
module csa #(
    parameter MD_WD     = 16, // Multiplicand width
    parameter MR_WD     =  9, // Multiplier width
    parameter MDMR_WD   = MD_WD+MR_WD
) (
    input  logic [MDMR_WD-1:0] x, y, z,
    output logic [MDMR_WD-1:0] sum, carry
);

    logic [MDMR_WD-1:0] c_int;

    genvar ii, jj;
    generate
    for (ii=0; ii<MDMR_WD; ii++) begin: stage_1
        fulladder i_FA_stg1(.A(x[ii]),.B(y[ii]),.CIN(z[ii]),.SUM(sum[ii]),.CARRY(c_int[ii]));
    end: stage_1
    endgenerate

    assign carry = {c_int[MDMR_WD-2:0],1'b0};

endmodule: csa
