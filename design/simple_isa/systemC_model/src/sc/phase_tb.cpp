#include "systemc.h"
#include "simple_phase_ctr.cpp"

int sc_main (int argc, char* argv[]) {
    sc_signal<bool> clk;
    sc_signal<bool> resetn;
    sc_signal<sc_uint<2> > phase;
    int i = 0;

    // Connect the DUT
    simple_phase_ctr u_phase("u_phase");
    u_phase.clk (clk);
    u_phase.resetn(resetn);
    u_phase.phase(phase);

    // sc-start
    sc_start(1, SC_NS);

    // Initializing all variables
    resetn = 1;
    for (i=0; i<5; i++) {
        clk = 0;
        sc_start(1, SC_NS);
        clk = 1;
        sc_start(1, SC_NS);
    }
    resetn = 0; // Assert reset
    cout << "@" << sc_time_stamp() << "Asserting reset\n" << endl;
    for (i=0; i<10;i++) {
        clk = 0;
        sc_start(1, SC_NS);
        clk = 1;
        sc_start(1, SC_NS);
    }
    resetn = 1; // De-assert reset
    cout << "@" << sc_time_stamp() << "De-asserting reset\n" << endl;
    for (i=0; i<5;i++) {
        clk = 0;
        sc_start(1, SC_NS);
        clk = 1;
        sc_start(1, SC_NS);
    }

    cout << "@" << sc_time_stamp() << "Terminatin sim\n" << endl;
    return 0;
}
