// --------------------------------------------------------
// VLSI Arch Assignment - 3
// Author: Anand S
// BITSID: 2021HT80003
// --------------------------------------------------------

module cpu
import cpu_pkg::*;
(
    input   logic   clk, resetn
);
    instr_mem_addr_t    pc;
    IF_ID_pipe_t        if_id_pipe_s;
    ID_EX_pipe_t        id_ex_pipe_s;
    EX_WB_pipe_t        ex_wb_pipe_s;
    sint32_t            A, B, C, ex_out, alu_out;
    logic [24:0]        mult_out;
    instruction_t       instruction_word;
    logic               mul_v_alu;
    logic               carry;
    logic [3:0]         ALUC;
    logic               get_nor;

    // --------------------------
    // PC
    // --------------------------
    always_ff @(posedge clk, negedge resetn) begin
        if (!resetn)        pc <= 0;
        else if (pc >='hc)  pc <= 0;
        else                pc <= pc + 4;
    end

    // --------------------------
    // IF stage
    // --------------------------
    instr_mem
    u_instr_mem (
                 // Interfaces
                 .raddr                 (pc),
                 .instruction_word      (instruction_word),
                 // Inputs
                 .clk                   (clk),
                 .resetn                (resetn),
                 .re                    (1'b1)); // Always enabled

    if_id_pipe
    u_if_id_pipe (
                  // Interfaces
                  .IR_next              (instruction_word),
                  // Outputs
                  .if_id_pipe           (if_id_pipe_s),
                  // Inputs
                  .clk                  (clk),
                  .resetn               (resetn));

    // --------------------------
    // ID stage
    // --------------------------
    reg_file
    u_reg_file (
                // Interfaces
                .addrA                  (if_id_pipe_s.IR.rs2),
                .addrB                  (if_id_pipe_s.IR.rs1),
                .addrC                  (ex_wb_pipe_s.IR.rd),
`ifdef RD_STALL_ALLOWED
                .C                      (ex_wb_pipe_ss.C),
`else
                .C                      (ex_wb_pipe_s.C),
`endif
                .A                      (A),
                .B                      (B),
                // Inputs
                .clk                    (clk),
                .resetn                 (resetn),
                .enA                    (1'b1),
                .enB                    (1'b1),
                .enC                    (1'b1));

`ifdef RD_STALL_ALLOWED                
    // Stall the controls before reaching the pipeline
    always_ff @(posedge clk, negedge resetn) begin:aluc_dec
        if (!resetn) begin
            get_nor   <= 0;
            mul_v_alu <= 0;
            ALUC      <= 4'bxxxx;
        end  else begin
            get_nor   <= 0;
            mul_v_alu <= 0;
            ALUC      <= 4'bxxxx;
            case (if_id_pipe_s.IR.opcode)
                MUL: begin
                    mul_v_alu <= 1;
                end
                SHIFT: begin
                    ALUC <= 4'b0011; // Assuming SHIFT means sll
                end
                XOR: begin
                    ALUC <= 4'b0010;
                end
                NOR: begin
                    ALUC <= 4'b0101; // Use OR of ALU and negate externally
                    get_nor <= 1;
                end
            endcase
        end
    end:aluc_dec
`else
    always_comb begin: aluc_dec
        mul_v_alu = 0;
        ALUC =  4'bxxxx;
        get_nor = 0;
        case (if_id_pipe_s.IR.opcode)
            MUL:    mul_v_alu = 1;
            SHIFT:  ALUC = 4'b0011;
            XOR:    ALUC = 4'b0010;
            NOR: begin
                    ALUC = 4'b0101;
                    get_nor = 1;
            end
        endcase
    end: aluc_dec
`endif

    id_ex_pipe
    u_id_ex_pipe (
                  // Interfaces
                  .IR_next              (if_id_pipe_s.IR),
                  .A_next               (A),
                  .B_next               (B),
                  // Outputs
                  .id_ex_pipe           (id_ex_pipe_s),
                  // Inputs
                  .clk                  (clk),
                  .resetn               (resetn),
                  .aluc_next            (ALUC),
                  .get_nor_next         (get_nor),
                  .mul_v_alu_next       (mul_v_alu));

    // --------------------------
    // EX stage
    // --------------------------
    mult_xy
    u_mult (
            // Outputs
            .O                          (mult_out[MDMR_WD-1:0]),
            // Inputs
            .A                          (id_ex_pipe_s.A[MD_WD-1:0]),
            .B                          (id_ex_pipe_s.B[MR_WD-1:0]));

    alu
    u_alu (
           // Outputs
           .OUT                         (alu_out[DATA_WDTH-1:0]),
           .CARRY                       (carry),
           // Inputs
           .A                           (id_ex_pipe_s.A[DATA_WDTH-1:0]),
           .B                           (id_ex_pipe_s.B[DATA_WDTH-1:0]),
           .ALUC                        (id_ex_pipe_s.ctrl.aluc[3:0]));

    assign ex_out = (id_ex_pipe_s.ctrl.mul_v_alu)?
                        signed'({7'b0, mult_out[24:0]}):
                        ((id_ex_pipe_s.ctrl.get_nor)?
                            ~(signed'(alu_out)):
                            signed'(alu_out)
                        );

    ex_wb_pipe
    u_ex_wb_pipe (
    /*AUTOINST*/
                  // Interfaces
                  .IR_next              (id_ex_pipe_s.IR),
                  .C_next               (ex_out),
                  .ex_wb_pipe           (ex_wb_pipe_s),
                  // Inputs
                  .clk                  (clk),
                  .resetn               (resetn));

    // --------------------------
    // WB stage
    // --------------------------
`ifdef RD_STALL_ALLOWED
    EX_WB_pipe_t ex_wb_pipe_ss; // stalled version for timing
    always_ff @(posedge clk, negedge resetn) begin
        if (!resetn) begin
            ex_wb_pipe_ss <= '{IR: '{opcode:NA, default:0}, default:0};
        end else begin
            ex_wb_pipe_ss <= ex_wb_pipe_s;
        end
    end
`endif
endmodule: cpu
