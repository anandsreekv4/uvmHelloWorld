#include "systemc.h"
#include <iostream>
#include "simple_cpu.h"

SC_MODULE(simple_tb) {
    sc_clock clk;
    sc_event reset_deactivation_event;
    sc_signal<bool> resetn;

    int counter;

    // module instances
    simple_cpu* u_simple_cpu;

    void reset_generator();

    // Constructor
    SC_CTOR(simple_tb) 
        : clk ("clock", 10, SC_NS, 0.5, 0.0, SC_NS, false)
        , resetn("resetn")
    {
        // Create instances
        u_simple_cpu = new simple_cpu("u_simple_cpu", "simple_cpu");
        u_simple_cpu->clk(clk);
        u_simple_cpu->resetn(resetn);

        SC_METHOD(reset_generator);
        sensitive << reset_deactivation_event;
    }

    // Destructor
    ~simple_tb() {
        delete u_simple_cpu; u_simple_cpu = 0;
    }
};

inline void simple_tb::reset_generator() {
    static bool first = true;
    if (first) {
        first = false;
        resetn.write(0);
        reset_deactivation_event.notify(20, SC_NS);
    }
    else
        resetn.write(1);
}

SC_MODULE_EXPORT(simple_tb);


/*
int sc_main (int argc, char* argv[]) {
    // Wires
    // Generate a 10ns clock with a duty cycle of 50%
    sc_clock clk("clock", 10, SC_NS, 0.5);
    sc_signal<bool> resetn;

    // DUT
    simple_cpu u_simple_cpu ("u_simple_cpu");
    u_simple_cpu.clk (clk);
    u_simple_cpu.clk (resetn);

    // sc_start
    cout << "@" << sc_time_stamp() << "Asserting reset\n" << endl;
    resetn = 0; // Assert resetn
    cout << "@" << sc_time_stamp() << "De-asserting reset\n" << endl;
    sc_start (50, SC_NS); // Assert for 10 ns
    resetn = 1; // De-assert resetn
    sc_start (2000, SC_NS); // de-assert it for 2000ns

    cout << "@" << sc_time_stamp() << "Terminatin sim\n" << endl;
    return 0;
}
*/
