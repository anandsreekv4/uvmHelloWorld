// ------------------------------------------------------------------
// HSCD Assignment - 1
// AUTHOR: Anand S
// BITS ID: 2021HT80003
// ------------------------------------------------------------------
// Specification : ROM with a sequential read port - 1 cycled delay

#include "systemc.h"

SC_MODULE(simple_instr_mem) {
    public:
    sc_in<bool>             clk;
    sc_in<bool>             resetn;
    sc_in<sc_uint<8> >      instr_addr; // INSTR mem is 256 deep
    sc_inout<sc_uint<16> >  INSTR;      // INSTR mem is 2 Bytes wide

    // local vars
    typedef sc_uint <16> instruction_mem_t [256];

    instruction_mem_t INSTR_MEM;

    void read_instr_mem_seq();

    // Constructor
    SC_CTOR (simple_instr_mem)
        : clk("clk")
        , resetn("resetn")
        , instr_addr("instr_addr")
        , INSTR("INSTR")
    {
        cout << "Executing new of simple_instr_mem" << endl;
        INSTR_MEM[0] = /* 0: MOV R0, 0xa */ 0x300a;// Setup
        INSTR_MEM[1] = /* 1: MOV R1, 0x0 */ 0x3100;// Setup
        INSTR_MEM[2] = /* 2: MOV R2, 0x1 */ 0x3201;// Setup
        INSTR_MEM[3] = /* 3: MOV R3, 0x0 */ 0x3300;// Setup
        INSTR_MEM[4] = /* 4: ADD R3, R1  */ 0x4031;// R3 = R3 + R1        -- R3 accumulates the sum
        INSTR_MEM[5] = /* 5: ADD R1, R2  */ 0x4012;// R1 = R1 + 1; INC R1 -- New num created by incr of R1
        INSTR_MEM[6] = /* 6: SUB R0, R2  */ 0x5002;// R0 = R0 - 1; DEC R1
        INSTR_MEM[7] = /* 7: JNZ R0, -3  */ 0x90fd;// PC = PC + (-3) if R0 != 0

        SC_METHOD(read_instr_mem_seq)
        sensitive << clk.pos();
    }

    // Destructor
    ~simple_instr_mem () {}
};

inline void simple_instr_mem::read_instr_mem_seq() {
    INSTR.write(INSTR_MEM[instr_addr.read()]);
}


SC_MODULE_EXPORT(simple_instr_mem);
