//------------------------------------------------------------
// MELZG642 VLSI Architecure Assignment #1
// Name: Anand S
// BITSID: 2021HT80003
//------------------------------------------------------------
module fulladder
(
    input  logic   A,
    input  logic   B,
    input  logic   CIN,
    output logic   SUM, CARRY
);

assign SUM = A ^ B ^ CIN;
assign CARRY = (A & B) | (B & CIN) | (CIN & A);

endmodule: fulladder
