// ------------------------------------------------------------------
// HSCD Assignment - 1
// AUTHOR: Anand S
// BITS ID: 2021HT80003
// ------------------------------------------------------------------
// Specification : ROM with a sequential read port - 1 cycled delay

#include "systemc.h"

SC_MODULE(simple_regfile) {
    public:
    sc_in<bool>             clk;
    sc_in<bool>             resetn;
    sc_in<bool>             regf_wren;
    // Rd port - N
    sc_in<sc_uint<4> >      regf_raddrN;  // regf is 256 deep
    sc_inout<sc_int<8> >    regf_rdoutN;  // regf is 1 Byte wide

    // Rd port - M
    sc_in<sc_uint<4> >      regf_raddrM;  // regf is 256 deep
    sc_inout<sc_int<8> >    regf_rdoutM;  // regf is 1 Byte wide

    // Wr port - common
    sc_in<sc_uint<4> >      regf_waddr;
    sc_in<sc_uint<8> >      regf_wdin;

    // local vars
    //typedef sc_int<8> regf_t [256];
    //sc_signal<regf_t>   REGF;
    //sc_vector<sc_signal<sc_int<9> >> REGF{"REGF", 256};
   sc_int<8>   REGF [256];


    void read_regf_seq();
    void write_regf_seq();

    // Constructor
    SC_CTOR (simple_regfile)
        : clk("clk")
        , resetn("resetn")
        , regf_wren("regf_wren")
        , regf_raddrN("regf_raddrN")
        , regf_rdoutN("regf_rdoutN")
        , regf_raddrM("regf_raddrM")
        , regf_rdoutM("regf_rdoutM")
        , regf_waddr("regf_waddr")
        , regf_wdin("regf_wdin")
    {
        cout << "Executing new of simple_regfile" << endl;

        SC_METHOD(read_regf_seq)
        sensitive << clk.pos();
        SC_METHOD(write_regf_seq)
        sensitive << clk.pos();
    }

    // Destructor
    ~simple_regfile () {}
};

inline void simple_regfile::read_regf_seq() {
    regf_rdoutN.write(REGF[regf_raddrN.read()]);
    regf_rdoutM.write(REGF[regf_raddrM.read()]);
}

inline void simple_regfile::write_regf_seq() {
    if (regf_wren.read() == 1) {
        int i = int(regf_waddr.read());
        REGF[i] = regf_wdin.read();
        // REGF[regf_waddr.read()] = regf_wdin.read();
    }
}

SC_MODULE_EXPORT(simple_regfile);
