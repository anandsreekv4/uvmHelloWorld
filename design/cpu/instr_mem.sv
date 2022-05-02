// --------------------------------------------------------
// VLSI Arch Assignment - 3
// Author: Anand S
// BITSID: 2021HT80003
// --------------------------------------------------------

module instr_mem
import cpu_pkg::*;
(
    input   logic               clk, resetn, re,
    input   instr_mem_addr_t    raddr,
    output  instruction_t       instruction_word
);

    // Instr mem can be implemented as Read-Only for this application
    instr_array_t instr_mem_array;
    logic [($clog2(INSTR_MEM_DEPTH/4))-1:0] raddr_int;
    
    assign raddr_int = raddr >> 2; // Ensures word alignment

    always_comb  begin: mem_init
        foreach (instr_mem_array[i]) begin
            instr_mem_array[i] = '{opcode: NA, default: 0};
            // synopsys translate off
            $display ("instr_mem_array[%0d] = %p", i, instr_mem_array[i]);
            // synopsys translate on
        end
        instr_mem_array[0] = '{opcode: MUL,   rd: 3, rs1: 2, rs2: 1};
        instr_mem_array[1] = '{opcode: SHIFT, rd: 6, rs1: 5, rs2: 4};
        instr_mem_array[2] = '{opcode: XOR,   rd: 9, rs1: 8, rs2: 7};
        instr_mem_array[3] = '{opcode: NOR,   rd:13, rs1:11, rs2:10};
    end: mem_init

`ifdef RD_STALL_ALLOWED
    always_ff @(posedge clk, negedge resetn) begin
        if (!resetn) begin
            instruction_word <= '{opcode:NA, default:0};
        end else begin
            if (re) instruction_word <= instr_mem_array[raddr_int];
        end
    end
`else
    // asynch read port
    assign instruction_word = instr_mem_array[raddr_int];
`endif

endmodule: instr_mem
