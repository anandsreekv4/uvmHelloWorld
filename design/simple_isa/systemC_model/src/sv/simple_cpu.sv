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
    logic signed [7:0] pc_incr;
    logic [7:0] pc; // PC can address 256 bytes;
    // Instr mem
    logic   [7:0]  instr_addr;
    logic   [15:0] INSTR     ;
    // Dmem
    logic   dmem_wren      ;
    logic   [7:0] dmem_addr;// common addr port for read and write
    logic   [7:0] dmem_din ;                                          
    logic   [7:0] dmem_dout;                                          
    // regfile
    logic regf_wren;
    logic [3:0] regf_raddrN;
    logic signed [7:0] regf_rdoutN;
    logic [3:0] regf_raddrM;
    logic signed [7:0] regf_rdoutM;
    logic [3:0] regf_waddr;
    logic signed [7:0] regf_wdin;
    // Phase_ctr
    logic [1:0] phase;
    // Alu
    logic [7:0] A, B, O;
    logic       add0_sub1;

    // PC block
    simple_pc u_pc (.*);

    // Instr mem
    simple_instr_mem u_instr_mem (.instr_addr(pc), .*);

    // Dmem
    simple_dmem u_dmem (.*);

    // Regfile
    simple_regfile u_regfile (.*);

    // Phase
    simple_phase_ctr u_phase (.*);
    
    // Alu
    simple_alu u_alu (.*);

    // decode-ex
    simple_decode_ex u_decode_ex (.*);
endmodule: simple_cpu
