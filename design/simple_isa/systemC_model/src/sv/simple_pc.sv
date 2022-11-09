// ------------------------------------------------------------------
// HSCD Assignment - 1
// AUTHOR: Anand S
// BITS ID: 2021HT80003
// ------------------------------------------------------------------

module simple_pc (
    input   clk
,   input   resetn
,   input   logic [1:0] phase
,   input   logic signed [7:0] pc_incr

,   output  logic [7:0] pc // PC can address 256 bytes

);

    always_ff @(posedge clk, negedge resetn) begin: pc_incr_logic_seq
        if (!resetn) begin
            pc <= '0;
        end else begin
            if (phase == 2'b11)
                pc <= signed'(pc + pc_incr);
        end
    end: pc_incr_logic_seq

endmodule: simple_pc
