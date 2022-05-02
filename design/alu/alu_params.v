// --------------------------------------------------------
// VLSI Arch Assignment - 2
// Author: Anand S
// BITSID: 2021HT80003
// --------------------------------------------------------
// parameters
// --------------------------------------------------------

`ifndef INST
parameter DATA_WDTH = 32

`else

.DATA_WDTH(DATA_WDTH)
`endif // INST

`ifdef INST
    `undef INST
`endif

// General defines
`define ALU_4bit_CLA // Use this define if cla is ripple adder of 4bit CLAs
