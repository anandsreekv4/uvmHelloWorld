`include "simple_decode_ex.sv"
`ifndef SC
    `include "simple_phase_ctr.sv"
    `include "simple_alu.sv"
    `include "simple_pc.sv"
    `include "simple_instr_mem.sv"
    `include "simple_dmem.sv"
    `include "simple_regfile.sv"
`endif // SC ()
`include "simple_cpu.sv"
`ifndef SC
    `include "simple_tb.sv"
`endif // SC ()
