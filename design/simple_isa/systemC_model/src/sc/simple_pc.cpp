// ------------------------------------------------------------------
// HSCD Assignment - 1
// AUTHOR: Anand S
// BITS ID: 2021HT80003
// ------------------------------------------------------------------

#include "systemc.h"

SC_MODULE(simple_pc) {
    public:
    sc_in<bool>             clk;
    sc_in<bool>             resetn;
    sc_in<sc_uint<2> >      phase;
    sc_in<sc_int<8> >       pc_incr;
    sc_inout<sc_uint<8> >   pc;

    // local vars

    void pc_logic_seq();
    void pc_wdog();

    // Constructor
    SC_CTOR (simple_pc)
        : clk("clk")
        , resetn("resetn")
        , phase("phase")
        , pc_incr("pc_incr")
        , pc("pc")
    {
        cout << "Executing new of simple_pc" << endl;

        SC_METHOD(pc_logic_seq)
        sensitive << resetn.neg();
        sensitive << clk.pos();

        SC_METHOD(pc_wdog)
        sensitive << pc;
    }

    // Destructor
    ~simple_pc () {}
};

inline void simple_pc::pc_logic_seq() {
    if (resetn.read() == 0) {
        pc.write(0);
    } else {
        if (phase.read() == 3) {
            pc.write(pc.read() + pc_incr.read());
        }
    }
}

inline void simple_pc::pc_wdog() {
    if (pc.read() >= 8 && (resetn.read() == 1)) {
        cout << "@" << sc_time_stamp() << ":: PC overflowing to 8. Exiting." 
            << endl;
        sc_stop();
    }
}

SC_MODULE_EXPORT(simple_pc);
