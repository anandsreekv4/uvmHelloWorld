// ------------------------------------------------------------------
// HSCD Assignment - 1
// AUTHOR: Anand S
// BITS ID: 2021HT80003
// ------------------------------------------------------------------
// Specification : ROM with a sequential read port - 1 cycled delay

module simple_instr_mem (
    input   clk
,   input   resetn
,   input   logic   [7:0]  instr_addr // Instr mem is 512 bytes deep (256 Half-words)
,   output  logic   [15:0] INSTR      // Each instr is 2 bytes long
);

    // The instr mem
    logic [15:0] INSTR_MEM [256];

    always_comb begin
        INSTR_MEM[0] = 'h300a; /* 0: MOV R0, 0xa; Setup                                               */
        INSTR_MEM[1] = 'h3100; /* 1: MOV R1, 0x0; Setup                                               */
        INSTR_MEM[2] = 'h3201; /* 2: MOV R2, 0x1; Setup                                               */
        INSTR_MEM[3] = 'h3300; /* 3: MOV R3, 0x0; Setup                                               */
        INSTR_MEM[4] = 'h4031; /* 4: ADD R3, R1 ; R3 = R3 + R1        -- R3 accumulates the sum       */
        INSTR_MEM[5] = 'h4012; /* 5: ADD R1, R2 ; R1 = R1 + 1; INC R1 -- New num created by incr of R1*/
        INSTR_MEM[6] = 'h5002; /* 6: SUB R0, R2 ; R0 = R0 - 1; DEC R1                                 */
        INSTR_MEM[7] = 'h90fd; /* 7: JNZ R0, -3 ; PC = PC + (-3) if R0 != 0                           */
    end

    // Sequential read
    always_ff @(posedge clk)
        INSTR <= INSTR_MEM[instr_addr];

endmodule: simple_instr_mem
