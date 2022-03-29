// --------------------------------------------------------
// VLSI Arch Assignment - 2
// Author: Anand S
// BITSID: 2021HT80003
// --------------------------------------------------------
// ALU toplevel. Interconnects sub-blocks.
// --------------------------------------------------------

module alu #(
    `include "alu_params.v"
) (
    input [DATA_WDTH-1:0] A,
    input [DATA_WDTH-1:0] B,
    input [3:0]           ALUC,
    output[DATA_WDTH-1:0] OUT,
    output                CARRY
);

    wire [DATA_WDTH-1:0] cla_out;               // From u_cla of cla.v
    wire [DATA_WDTH-1:0] out;                   // From u_and_or_mux of mux2x1.v, ...
    wire [DATA_WDTH-1:0] shifter_out;           // From u_shifter of shifter.v
    wire [DATA_WDTH-1:0] AND_out, OR_out;       // From u_AND of alu_lib.v, ... 
    wire [DATA_WDTH-1:0] XOR_out, LUI_out;      // From u_XOR of alu_lib.v, ...
    wire [DATA_WDTH-1:0] AND_OR_out, XOR_LUI_out;

    `define INST
    cla #(
        `include "alu_params.v"
    ) u_cla (
             // Outputs
             .SUM                       (cla_out[DATA_WDTH-1:0]),
             .CARRY                     (CARRY),
             // Inputs
             .A_i                       (A[DATA_WDTH-1:0]),
             .B_i                       (B[DATA_WDTH-1:0]),
             .EN                        (ALUC[2]));

    `define INST
    shifter #(
        `include "alu_params.v"
    ) u_shifter (
                 // Outputs
                 .out_data              (shifter_out[DATA_WDTH-1:0]),
                 // Inputs
                 .sv                    (A[4:0]),
                 .data                  (B[DATA_WDTH-1:0]),
                 .cntrl                 (ALUC[2]),
                 .opr                   (ALUC[3]));

    `define INST
    mux2x1 #(
        `include "alu_params.v"
    ) u_and_or_mux (
                    // Outputs
                    .out                (AND_OR_out[DATA_WDTH-1:0]),
                    // Inputs
                    .in0                (AND_out),
                    .in1                (OR_out),
                    .sel                (ALUC[2]));

    `define INST
    mux2x1 #(
        `include "alu_params.v"
    ) u_xor_lui_mux (
                     // Outputs
                     .out               (XOR_LUI_out[DATA_WDTH-1:0]),
                     // Inputs
                     .in0               (XOR_out),
                     .in1               (LUI_out),
                     .sel               (ALUC[2]));

    `define INST
    mux4x1 #(
        `include "alu_params.v"
    ) u_final_mux (
                   // Outputs
                   .out                 (OUT[DATA_WDTH-1:0]),
                   // Inputs
                   .in0                 (cla_out),
                   .in1                 (AND_OR_out),
                   .in2                 (XOR_LUI_out),
                   .in3                 (shifter_out),
                   .sel                 (ALUC[1:0]));

    `define INST
    alu_AND #(
        `include "alu_params.v"
    ) u_AND (
             // Outputs
             .o                         (AND_out[DATA_WDTH-1:0]),
             // Inputs
             .i0                        (A[DATA_WDTH-1:0]),
             .i1                        (B[DATA_WDTH-1:0]));

    `define INST
    alu_OR #(
        `include "alu_params.v"
    ) u_OR (
             // Outputs
             .o                         (OR_out[DATA_WDTH-1:0]),
             // Inputs
             .i0                        (A[DATA_WDTH-1:0]),
             .i1                        (B[DATA_WDTH-1:0]));

    `define INST
    alu_XOR #(
        `include "alu_params.v"
    ) u_XOR (
             // Outputs
             .o                         (XOR_out[DATA_WDTH-1:0]),
             // Inputs
             .i0                        (A[DATA_WDTH-1:0]),
             .i1                        (B[DATA_WDTH-1:0]));

    `define INST
    alu_LUI #(
        `include "alu_params.v"
    ) u_LUI (
             // Outputs
             .out                       (LUI_out[DATA_WDTH-1:0]),
             // Inputs
             .in                        (B[DATA_WDTH-1:0]));
endmodule // alu

// Local Variables:
// verilog-library-files:("/projects/work/ansn/misc/uvm_playground/uvmHelloWorld/design/alu/alu_lib.v")
// End:
