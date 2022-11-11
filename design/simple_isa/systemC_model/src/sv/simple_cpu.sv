// ------------------------------------------------------------------
// HSCD Assignment - 1
// AUTHOR: Anand S
// BITS ID: 2021HT80003
// ------------------------------------------------------------------
// Top level hookup

module simple_cpu (
    input   clk
,   input   resetn
);
    // Interconnect wires
    // PC block
    wire signed [7:0] pc_incr;
    wire [7:0] pc; // PC can address 256 bytes;
    // Instr mem
    wire   [7:0]  instr_addr;
    wire   [15:0] INSTR     ;
    // Dmem
    wire   dmem_wren      ;
    wire   [7:0] dmem_addr;// common addr port for read and write
    wire   [7:0] dmem_din ;                                          
    wire   [7:0] dmem_dout;                                          
    // regfile
    wire regf_wren;
    wire [3:0] regf_raddrN;
    wire signed [7:0] regf_rdoutN;
    wire [3:0] regf_raddrM;
    wire signed [7:0] regf_rdoutM;
    wire [3:0] regf_waddr;
    wire signed [7:0] regf_wdin;
    // Phase_ctr
    wire [1:0] phase;
    // Alu
    wire [7:0] A, B, O;
    wire       add0_sub1;

    // PC block
    simple_pc u_pc (
        .clk    (clk)
    ,   .resetn (resetn)
    ,   .phase  (phase)
    ,   .pc_incr(pc_incr)
    ,   .pc     (pc));

    // Instr mem
    simple_instr_mem u_instr_mem (
        .clk        (clk)
    ,   .resetn     (resetn)
    ,   .instr_addr (pc)
    ,   .INSTR      (INSTR));

    // Dmem
    simple_dmem u_dmem (
        .clk        (clk)
    ,   .resetn     (resetn)
    ,   .dmem_wren  (dmem_wren)
    ,   .dmem_addr  (dmem_addr)
    ,   .dmem_din   (dmem_din)
    ,   .dmem_dout  (dmem_dout));

    // Regfile
    simple_regfile u_regfile (
        .clk        (clk)
    ,   .resetn     (resetn)
    ,   .regf_wren  (regf_wren)
    ,   .regf_raddrN(regf_raddrN)
    ,   .regf_rdoutN(regf_rdoutN)
    ,   .regf_raddrM(regf_raddrM)
    ,   .regf_rdoutM(regf_rdoutM)
    ,   .regf_waddr (regf_waddr)
    ,   .regf_wdin  (regf_wdin));

    // decode-ex
    simple_decode_ex u_decode_ex (.*);

    // Phase
    simple_phase_ctr u_phase (
        .clk    (clk)
    ,   .resetn (resetn)
    ,   .phase  (phase));
    
    // Alu
    simple_alu u_alu (
        .clk (clk)
    ,   .resetn(resetn)
    ,   .add0_sub1(add0_sub1)
    ,   .A(A)
    ,   .B(B)
    ,   .O(O));

endmodule: simple_cpu
