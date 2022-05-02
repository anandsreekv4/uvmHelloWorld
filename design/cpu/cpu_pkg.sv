// --------------------------------------------------------
// VLSI Arch Assignment - 3
// Author: Anand S
// BITSID: 2021HT80003
// --------------------------------------------------------

package cpu_pkg;

    // ----------------------------------------------------
    // Parameters
    // ----------------------------------------------------
    localparam INSTR_MEM_DEPTH = 128/4; // 128 bytes in words
    localparam REG_FILE_DEPTH  = 32;
    localparam MD_WD   = 16;
    localparam MR_WD   = 9;
    localparam MDMR_WD = MD_WD+MR_WD;
    localparam DATA_WDTH = 32;

    // ----------------------------------------------------
    // Typedefs
    // ----------------------------------------------------
    typedef enum logic [16:0] {
        NA    = 17'b0_0000_0000_0000_0000,
        MUL   = 17'b0_0000_0000_0000_0001,
        SHIFT = 17'b0_0000_0000_0000_0010,
        XOR   = 17'b0_0000_0000_0000_0011,
        NOR   = 17'b0_0000_0000_0000_0100
    } opcode_t;

    typedef logic [$clog2(REG_FILE_DEPTH)-1:0] reg_t;

    typedef struct packed {
        opcode_t    opcode; // [31:15]
        reg_t       rd;     // [14:10]
        reg_t       rs1;    // [9:5]
        reg_t       rs2;    // [4:0]
    } instruction_t;

    typedef instruction_t instr_array_t [INSTR_MEM_DEPTH];

    typedef logic [$clog2(INSTR_MEM_DEPTH)-1:0] instr_mem_addr_t;

    typedef logic signed [31:0] sint32_t;

    typedef logic [31:0] uint32_t;

    typedef struct {
        logic       en;
        sint32_t    data; // write data
        reg_t       addr;
    } port_t;

    typedef struct {
        logic       en;
        reg_t       addr;
    } port_in_t;

    typedef struct {
        instruction_t IR;
    } IF_ID_pipe_t;

    typedef struct {
        logic mul_v_alu;
        logic get_nor;
        logic [3:0] aluc;
    } control_t;

    typedef struct {
        instruction_t IR;
        sint32_t      A;
        sint32_t      B;
        control_t ctrl;
    } ID_EX_pipe_t;

    typedef struct {
        instruction_t   IR;
        sint32_t        C;
    } EX_WB_pipe_t;

endpackage: cpu_pkg
