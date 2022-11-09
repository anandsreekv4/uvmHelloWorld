// ------------------------------------------------------------------
// HSCD Assignment - 1
// AUTHOR: Anand S
// BITS ID: 2021HT80003
// ------------------------------------------------------------------

module simple_alu (
    input   clk
,   input   resetn
,   input   logic add0_sub1
,   input   logic [7:0] A
,                       B
,   output  logic [7:0] O
);

    always_ff@(posedge clk) begin
        if (add0_sub1) begin
            O <= A - B;
        end else begin
            O <= A + B;
        end
    end
endmodule: simple_alu
