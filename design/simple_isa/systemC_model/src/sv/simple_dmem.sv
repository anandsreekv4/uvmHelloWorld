// ------------------------------------------------------------------
// HSCD Assignment - 1
// AUTHOR: Anand S
// BITS ID: 2021HT80003
// ------------------------------------------------------------------
// Specification : RAM with a sequential read port - 1 cycled delay
// Either reads or writes possible at any given time.

module simple_dmem (
    input   clk
,   input   resetn
,   input   logic   dmem_wren
,   input   logic   [7:0] dmem_addr // common addr port for read and write
,   input   logic   [7:0] dmem_din
,   output  logic   [7:0] dmem_dout
);

    logic [7:0] dmem [256];

    always_ff @(posedge clk) begin
        dmem_dout           <= dmem[dmem_addr];
        if (dmem_wren)
            dmem[dmem_addr] <= dmem_din;
    end

endmodule: simple_dmem
