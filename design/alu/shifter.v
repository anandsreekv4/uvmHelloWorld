// --------------------------------------------------------
// VLSI Arch Assignment - 2
// Author: Anand S
// BITSID: 2021HT80003
// --------------------------------------------------------
// Barrel shifter : The question is a little ambiguous. I 
// interpreted the requirement as, the control input A[4:0]
// will shift the 32 bit B input by *upto* 32 bits. But it
// is not mentioned anywhere explicitly in the assigment.
// Inputs: -
// 1. A[4:0] - shift value (sv)
// 2. B[31:0]- shift data  (data)
// 3. ALUC[2]- control inp (cntrl)
// 4. ALUC[3]- selects either logical or arith operations (opr)
// ALUC[3:2] to be used in following specific way : -
// +---------------------+
// |ALUC[3:2] | Function |
// +---------------------+
// | 2'b00    | SLL      |
// | 2'b01    | SLR      |
// | 2'b1x    | SRA      |
// +---------------------+
// --------------------------------------------------------

module shifter #(
    `include "alu_params.v"
) (
    input [4:0]             sv,
    input [DATA_WDTH-1:0]   data,
    input                   cntrl, // ALUC[2]
    input                   opr,   // ALUC[3]
    output[DATA_WDTH-1:0]   out_data
);

    reg [DATA_WDTH-1:0]     c_out;
    always @(*) begin: shifter_comb
        case({opr,cntrl})
            2'b00: begin // SLL
                c_out = data << sv;
            end
            2'b01: begin // SLR
                c_out = data >> sv;
            end
            2'b10,
            2'b11: begin // SRA
                c_out = $signed(data) >>> sv;
            end
        endcase
    end

    assign out_data = c_out;

endmodule // shifter
