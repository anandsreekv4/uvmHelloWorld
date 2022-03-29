// --------------------------------------------------------
// VLSI Arch Assignment - 2
// Author: Anand S
// BITSID: 2021HT80003
// --------------------------------------------------------
// CLA: Carry look-ahead adder.
// Inputs: -
// A[31:0] - Op1
// B[31:0] - Op2
// ALUC[2] - Enable input
// Outputs: -
// SUM[31:0]- P[i] ^ C[i]
// C[i+1]   - G[i] + P[i]*C[i]; G[i] = A[i]*B[i] and P[i] = A[i] ^ B[i]
// --------------------------------------------------------

module cla #(
    `include "alu_params.v"
) (
    input [DATA_WDTH-1:0] A_i, B_i,
    input                 EN, // seems this is for subtraction?
    output[DATA_WDTH-1:0] SUM,
    output                CARRY
);

    reg  [DATA_WDTH-1:0] A, B, P, G, S;
    reg  [DATA_WDTH  :0] C;

    integer ii;
    always @(*) begin: cla_comb
        A    = A_i;
        B    = (EN)? ~B_i : B_i; // Assuming EN is high for SUB operation.
        C[0] = (EN)? 1'b1 : 1'b0;// B and C[0] used to create B's 2's comp
        for (ii=0; ii<DATA_WDTH; ii=ii+1) begin
            P[ii] = A[ii] ^ B[ii];
            G[ii] = A[ii] & B[ii];
            S[ii] = P[ii] ^ C[ii];
            C[ii+1] = G[ii] | (P[ii] & C[ii]);
        end
    end
    assign CARRY = C[DATA_WDTH];
    assign SUM   = S;

endmodule // cla
