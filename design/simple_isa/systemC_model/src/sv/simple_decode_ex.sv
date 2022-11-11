// ------------------------------------------------------------------
// HSCD Assignment - 1
// AUTHOR: Anand S
// BITS ID: 2021HT80003
// ------------------------------------------------------------------
// Specification : RAM with two sequential read port - 1 cycle delay
// And 1 sequential write port.
// Either reads or writes possible at any given time.

module simple_decode_ex (
    input   clk
,   input   resetn

// Ctrl inputs
// -- instr
,   input   logic   [15:0]INSTR
// -- phase
,   input   logic   [1:0] phase
// -- regf 
,   input   logic   [7:0] regf_rdoutN
,   input   logic   [7:0] regf_rdoutM
// -- dmem
,   input   logic   [7:0] dmem_dout
// -- alu
,   input   logic   [7:0] O

// Ctrl outputs
// -- regf 
,   output  logic         regf_wren
,   output  logic   [7:0] regf_wdin
,   output  logic   [3:0] regf_raddrN
,                         regf_raddrM
,                         regf_waddr
// -- dmem
,   output  logic         dmem_wren
,   output  logic  [7:0]  dmem_addr
,   output  logic  [7:0]  dmem_din
// -- pc
,   output  logic  [7:0]  pc_incr
// -- alu
,   output  logic         add0_sub1
,   output  logic  [7:0]  A
,                         B
);
    `define OPCODE 15:12
    `define OP1_DIRECT 11:8
    `define OP2_DIRECT 7:0
    `define OP1 7:4
    `define OP2 3:0
    `define IF 0
    `define ID 1
    `define EX 2
    `define WB 3

    // This is a pure combinational block - only drives the output as required
    // for a given phase based on extensive muxing on the phase and the opcode
    always_comb begin: decode_ex_logic_comb
        // defaults
        regf_wren   = 0;
        regf_wdin   = 'x;
        regf_raddrN = 'x;
        regf_raddrM = 'x;
        regf_waddr  = 'x;
                    
        dmem_wren   = 'x;
        dmem_addr   = 'x;
        dmem_din    = 'x;
                    
        pc_incr     = 1;
        add0_sub1   = 0;
        
        // conditional updates
        case (INSTR[`OPCODE])
            0: begin // MOV Rn, direct; |0x0|Rn||dir|ect|; Rn = M(direct)
                case (phase)
                    `ID: begin
                        // Read M(direct)
                        dmem_wren = 0;
                        dmem_addr = INSTR[`OP2_DIRECT];
                    end
                    `EX: begin
                        // Read M(direct)
                        dmem_wren = 0;
                        dmem_addr = INSTR[`OP2_DIRECT];
                    end
                    `WB: begin
                        // Read M(direct)
                        dmem_wren = 0;
                        dmem_addr = INSTR[`OP2_DIRECT];
                        // Write to Rn
                        regf_wren = 1;
                        regf_wdin = dmem_dout;
                        regf_waddr= INSTR[`OP1_DIRECT];
                    end
                endcase
            end
            1: begin // MOV direct, Rn; |0x1|Rn||dir|ect|; M(direct) = Rn
                case (phase)
                    `ID: begin
                        // Read Rn
                        regf_wren = 0;
                        regf_raddrN = INSTR[`OP1_DIRECT];
                    end
                    `EX: begin
                        // Read Rn
                        regf_wren = 0;
                        regf_raddrN = INSTR[`OP1_DIRECT];
                        // write back early
                        dmem_wren = 1;
                        dmem_addr = INSTR[`OP2_DIRECT];
                        dmem_din  = regf_rdoutN;
                    end
                    `WB: begin
                        // Read Rn
                        regf_wren = 0;
                        regf_raddrN = INSTR[`OP1_DIRECT];
                        // write back early
                        dmem_wren = 1;
                        dmem_addr = INSTR[`OP2_DIRECT];
                        dmem_din  = regf_rdoutN;                    
                    end
                endcase
            end
            2: begin // MOV @Rn,Rm    ; |0x2|  ||Rn |Rm |; M(Rn) = Rm
                case (phase)
                    `ID: begin
                        // Read Rn
                        regf_wren = 0;
                        regf_raddrN = INSTR[`OP1];
                        regf_raddrM = INSTR[`OP2]; 
                    end
                    `EX: begin
                        // Read Rn
                        regf_wren = 1;
                        regf_raddrN = INSTR[`OP1];
                        // write back early
                        dmem_wren  = 1;
                        dmem_addr  = regf_rdoutN;
                        dmem_din   = regf_rdoutM;
                    end
                    `WB: begin
                        // Read Rn
                        regf_wren = 1;
                        regf_raddrN = INSTR[`OP1];
                        // write back early
                        dmem_wren  = 1;
                        dmem_addr  = regf_rdoutN;
                        dmem_din   = regf_rdoutM;                
                    end
                endcase         
            end
            3: begin // MOV Rn, #immed; |0x3|Rn||Imm|edt|; Rn = #immed
                case (phase)
                    `ID: begin
                        // Directly write to Rn and be done with it
                        regf_wren = 1;
                        regf_wdin = INSTR[`OP2_DIRECT];
                        regf_waddr= INSTR[`OP1_DIRECT];
                    end
                endcase
            end
            4: begin // ADD Rn, Rm    ; |0x4|  ||Rn |Rm |; Rn = Rn + Rm
                case (phase)
                    `ID: begin
                        // Read Rn and Rm
                        regf_wren   = 0;
                        regf_raddrN = INSTR[`OP1];
                        regf_raddrM = INSTR[`OP2];
                    end
                    `EX: begin
                        // Read Rn and Rm
                        regf_wren   = 0;
                        regf_raddrN = INSTR[`OP1];
                        regf_raddrM = INSTR[`OP2];
                        // Select add
                        add0_sub1   = 0;
                        A           = regf_rdoutN;
                        B           = regf_rdoutM;
                    end
                    `WB: begin
                        // Read Rn and Rm
                        regf_wren   = 0;
                        regf_raddrN = INSTR[`OP1];
                        regf_raddrM = INSTR[`OP2];
                        // Select add
                        add0_sub1   = 0;
                        A           = regf_rdoutN;
                        B           = regf_rdoutM;
                        // Update Rn (OP1) in regfile
                        regf_wren   = 1;
                        regf_waddr  = INSTR[`OP1];
                        regf_wdin   = O;
                    end
                endcase
            end
            5: begin // SUB Rn, Rm    ; |0x5|  ||Rn |Rm |; Rn = Rn - Rm
                case (phase)
                    `ID: begin
                        // Read Rn and Rm
                        regf_wren   = 0;
                        regf_raddrN = INSTR[`OP1];
                        regf_raddrM = INSTR[`OP2];
                    end
                    `EX: begin
                        // Read Rn and Rm
                        regf_wren   = 0;
                        regf_raddrN = INSTR[`OP1];
                        regf_raddrM = INSTR[`OP2];
                        // Select add
                        add0_sub1   = 1;
                        A           = regf_rdoutN;
                        B           = regf_rdoutM;
                    end
                    `WB: begin
                        // Read Rn and Rm
                        regf_wren   = 0;
                        regf_raddrN = INSTR[`OP1];
                        regf_raddrM = INSTR[`OP2];
                        // Select add
                        add0_sub1   = 1;
                        A           = regf_rdoutN;
                        B           = regf_rdoutM;
                        // Update Rn (OP1) in regfile
                        regf_wren   = 1;
                        regf_waddr  = INSTR[`OP1];
                        regf_wdin   = O;
                    end
                endcase
            end
            8: begin // JZ  Rn, reltiv; |0x8|R4||rel|tiv|; PC = PC + relative
                case (phase)
                    `ID: begin
                        // Read Rn and relative value (DIRCT format)
                        regf_wren   = 0;
                        regf_raddrN = INSTR[`OP1_DIRECT];
                    end
                    `EX: begin
                        // Read Rn and relative value (DIRCT format)
                        regf_wren   = 0;
                        regf_raddrN = INSTR[`OP1_DIRECT];
                        if (regf_rdoutN != 0) begin
                            pc_incr = INSTR[`OP2_DIRECT];
                        end
                    end
                    `WB: begin
                        // Read Rn and relative value (DIRCT format)
                        regf_wren   = 0;
                        regf_raddrN = INSTR[`OP1_DIRECT];
                        if (regf_rdoutN == 0) begin
                            pc_incr = INSTR[`OP2_DIRECT];
                        end
                    end
                endcase
            end
            9: begin // JZ  Rn, reltiv; |0x8|R4||rel|tiv|; PC = PC + relative
                case (phase)
                    `ID: begin
                        // Read Rn and relative value (DIRCT format)
                        regf_wren   = 0;
                        regf_raddrN = INSTR[`OP1_DIRECT];
                    end
                    `EX: begin
                        // Read Rn and relative value (DIRCT format)
                        regf_wren   = 0;
                        regf_raddrN = INSTR[`OP1_DIRECT];
                        if (regf_rdoutN != 0) begin
                            pc_incr = INSTR[`OP2_DIRECT];
                        end
                    end
                    `WB: begin
                        // Read Rn and relative value (DIRCT format)
                        regf_wren   = 0;
                        regf_raddrN = INSTR[`OP1_DIRECT];
                        if (regf_rdoutN != 0) begin
                            pc_incr = INSTR[`OP2_DIRECT];
                        end
                    end
                endcase
            end
            default: begin
                case (phase)
                    `ID, `EX, `WB: begin
                        $error("Invalid OPCODE used!!\n");
                        $finish;
                    end
                endcase
            end
        endcase
    end: decode_ex_logic_comb

endmodule: simple_decode_ex
