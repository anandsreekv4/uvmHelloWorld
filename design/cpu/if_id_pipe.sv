// --------------------------------------------------------
// VLSI Arch Assignment - 3
// Author: Anand S
// BITSID: 2021HT80003
// --------------------------------------------------------

module if_id_pipe
import cpu_pkg::*;
(
    input  logic clk, resetn,
    input  instruction_t IR_next,
    output IF_ID_pipe_t if_id_pipe
);

    always_ff @(posedge clk, negedge resetn) begin
        if (!resetn)
            if_id_pipe <= '{IR: '{opcode:NA, default:0}, default:0};
        else
            if_id_pipe <= '{IR: IR_next};
    end


endmodule: if_id_pipe
