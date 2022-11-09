// ------------------------------------------------------------------
// HSCD Assignment - 1
// AUTHOR: Anand S
// BITS ID: 2021HT80003
// ------------------------------------------------------------------
// Specification : RAM with two sequential read port - 1 cycle delay
// And 1 sequential write port.
// Either reads or writes possible at any given time.

module simple_regfile (
    input   clk
,   input   resetn
,   input   logic regf_wren

// Rd port - N
,   input   logic [3:0] regf_raddrN
,   output  logic signed [7:0] regf_rdoutN

// Rd port - M
,   input   logic [3:0] regf_raddrM
,   output  logic signed [7:0] regf_rdoutM

// Wr port - common
,   input   logic [3:0] regf_waddr
,   input   logic signed [7:0] regf_wdin
);

    logic [7:0] REGF [16];

    always_ff @(posedge clk)
        if (regf_wren)
            REGF[regf_waddr] <= regf_wdin;

    always_ff @(posedge clk) begin
        regf_rdoutN <= REGF[regf_raddrN];
        regf_rdoutM <= REGF[regf_raddrM];
    end

endmodule: simple_regfile
