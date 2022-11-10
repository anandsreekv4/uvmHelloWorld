// ------------------------------------------------------------------
// HSCD Assignment - 1
// AUTHOR: Anand S
// BITS ID: 2021HT80003
// ------------------------------------------------------------------
// Has 4 phases - IF, ID, EX, WB
// The FSM uses this ctr to sequence the signals


#include "systemc.h"

SC_MODULE(simple_phase_ctr) {
    public:
    sc_in<bool>         clk;
    sc_in<bool>         resetn;
    sc_inout<sc_uint<2> >  phase;

    // local vars
    sc_uint<2> phase_int;

    void phase_ctr_logic_seq () {
        if (resetn.read() == 0) {
            phase_int = 0;
            phase.write(phase_int);
        } else {
            phase_int = phase_int + 1;
            phase.write(phase_int);
            cout << "@" << sc_time_stamp() <<":: Incremented phase = "
                << phase.read() << endl;
        }
    } // endfunction phase_ctr_logic_seq

    // Constructor
    SC_CTOR (simple_phase_ctr) 
        : clk   ("clk")
        , resetn("resetn")
        , phase ("phase")
    {
        cout << "Executing new of simple_phase_ctr" << endl;
        SC_METHOD (phase_ctr_logic_seq);
        sensitive << resetn.neg();
        sensitive << clk.pos();
    } // endconstructore
    // Destructor
    ~simple_phase_ctr() {}
}; // endmodule simple_phase_ctr

SC_MODULE_EXPORT(simple_phase_ctr);
