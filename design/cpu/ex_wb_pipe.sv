// --------------------------------------------------------
// VLSI Arch Assignment - 3
// Author: Anand S
// BITSID: 2021HT80003
// --------------------------------------------------------

module ex_wb_pipe
import cpu_pkg::*;
(
    input logic clk, resetn,
    input instruction_t IR_next,
    input sint32_t C_next,

    output EX_WB_pipe_t ex_wb_pipe
);


    always_ff @(posedge clk, negedge resetn) begin
        if (!resetn)
            ex_wb_pipe <= '{IR: '{opcode:NA, default:0}, default:0};
        else
            ex_wb_pipe <= '{IR:IR_next, C: C_next};
    end

endmodule: ex_wb_pipe
