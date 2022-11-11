// ------------------------------------------------------------------
// HSCD Assignment - 1
// AUTHOR: Anand S
// BITS ID: 2021HT80003
// ------------------------------------------------------------------
// Specification : RAM with a sequential read port - 1 cycled delay
// Either reads or writes possible at any given time.


#include "systemc.h"

SC_MODULE(simple_dmem) {
    public:
    sc_in<bool>             clk;
    sc_in<bool>             resetn;
    sc_in<bool>             dmem_wren;
    sc_in<sc_uint<8> >      dmem_addr;  // dmem is 256 deep
    sc_inout<sc_uint<8> >   dmem_din;   // dmem is 2 Bytes wide
    sc_inout<sc_uint<8> >   dmem_dout;  // dmem is 2 Bytes wide

    // local vars
    sc_uint<8>   dmem [256];


    void read_dmem_seq();
    void write_dmem_seq();

    // Constructor
    SC_CTOR (simple_dmem)
        : clk("clk")
        , resetn("resetn")
        , dmem_wren("dmem_wren")
        , dmem_addr("dmem_addr")
        , dmem_din("dmem_din")
        , dmem_dout("dmem_dout")
    {
        cout << "Executing new of simple_dmem" << endl;

        SC_METHOD(read_dmem_seq)
        sensitive << clk.pos();
        SC_METHOD(write_dmem_seq)
        sensitive << clk.pos();
    }

    // Destructor
    ~simple_dmem () {}
};

inline void simple_dmem::read_dmem_seq() {
    dmem_dout.write(dmem[dmem_addr.read()]);
}

inline void simple_dmem::write_dmem_seq() {
    if (dmem_wren.read() == 1) {
        dmem[dmem_addr.read()] = dmem_din.read();
    }
}

SC_MODULE_EXPORT(simple_dmem);
