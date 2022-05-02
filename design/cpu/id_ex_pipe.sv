// --------------------------------------------------------
// VLSI Arch Assignment - 3
// Author: Anand S
// BITSID: 2021HT80003
// --------------------------------------------------------

module id_ex_pipe
import cpu_pkg::*;
(
    input logic clk, resetn,
    input instruction_t IR_next,
    input sint32_t A_next, B_next,
    input mul_v_alu_next, get_nor_next,
    input logic [3:0] aluc_next,

    output ID_EX_pipe_t id_ex_pipe
);


    always_ff @(posedge clk, negedge resetn) begin
        if (!resetn)
            id_ex_pipe <= '{IR: '{opcode:NA, default:0}, default:0};
        else
            id_ex_pipe <= '{IR: IR_next, 
                            A: A_next,
                            B: B_next,
                            ctrl: '{mul_v_alu: mul_v_alu_next,
                                    get_nor: get_nor_next,
                                    aluc: aluc_next
                                   }
                        };
    end


endmodule: id_ex_pipe
