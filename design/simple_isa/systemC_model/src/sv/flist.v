`include "simple_pc.sv"
`include "simple_instr_mem.sv"
`include "simple_regfile.sv"
`include "simple_decode_ex.sv"
`include "simple_dmem.sv"
`include "simple_alu.sv"
`ifndef SIMPLE_CPU
    `include "simple_cpu.sv"
`endif // SIMPLE_CPU ()
`ifndef SC
    `include "simple_phase_ctr.sv"
    `include "simple_tb.sv"
`endif // SC ()
