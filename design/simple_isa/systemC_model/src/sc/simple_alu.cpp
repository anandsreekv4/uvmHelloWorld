// ------------------------------------------------------------------
// HSCD Assignment - 1
// AUTHOR: Anand S
// BITS ID: 2021HT80003
// ------------------------------------------------------------------

#include "systemc.h"

SC_MODULE(simple_alu) {
    public:
    sc_in<bool>             clk;
    sc_in<bool>             resetn;
    sc_in<bool>             add0_sub1;
    sc_in<sc_uint<8> >      A;
    sc_in<sc_uint<8> >      B;
    sc_inout<sc_uint<8> >   O;

    // local vars

    void alu_logic_seq();

    // Constructor
    SC_CTOR (simple_alu)
        : clk("clk")
        , resetn("resetn")
        , A("A")
        , B("B")
        , O("O")
    {
        cout << "Executing new of simple_alu" << endl;
        SC_METHOD(alu_logic_seq)
        sensitive << clk.pos();
    }

    // Destructor
    ~simple_alu () {}
};

inline void simple_alu::alu_logic_seq() {
    if (add0_sub1.read() == 1) {
        O.write(A.read() - B.read());
    } else {
        O.write(A.read() + B.read());
    }
    cout << "@" << sc_time_stamp() <<":: ALU updated :: O = "
        << O.read() << " = A(" << A.read() << ") + B(" << B.read()
        << ")" << endl;
}

SC_MODULE_EXPORT(simple_alu);
