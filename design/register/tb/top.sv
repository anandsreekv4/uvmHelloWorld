`include "reg_if.sv"

module top;
// This top should remain static no matter what the test.
// Let's say we need to add a new QVIP, so all we need to 
// do is add the pkg that comes along with it into this 
// file. :)
    
    import uvm_pkg::*;        /* DO NOT REMOVE !*/
    `include "uvm_macros.svh" /* DO NOT REMOVE !*/
    import tx_pkg::*;         /* modify based on DUT and TB*/
   
    /*AUTOREG*/
    logic clk;

    parameter WIDTH = 8;
    int WIDTH_int = WIDTH;

    /* INTERFACE */
    reg_if #(.WIDTH(WIDTH)) ireg_if(clk);

    /* DUT */
    register  #(
        .WIDTH(WIDTH)
    ) ireg (
        /*AUTOINST*/
            // Outputs
            .outa                       (ireg_if.outa[WIDTH-1:0]),
            // Inputs
            .clk                        (ireg_if.clk),
            .reset_n                    (ireg_if.reset_n),
            .enable                     (ireg_if.enable),
            .data                       (ireg_if.data[WIDTH-1:0])
    );

    /* CLOCK GEN */
    initial begin
        clk <= 0;
        forever #5 clk = !clk;
    end
     
    /* RUN TEST */
    initial begin: run_test_call
        run_test();
    end

    /* RESOURCE DB */
    initial begin: rsrc_db
        uvm_config_db #(virtual reg_if)::set(
            null,
            "uvm_test_top.*",
            "reg_if",
            ireg_if
        );
        uvm_config_db #(int)::set(
            .cntxt(null),
            .inst_name("uvm_test_top.*"),
            .field_name("WIDTH"),
            .value(WIDTH_int)
        );
    end

    /* DUMP VCD */
    initial begin: dump_vcd
        $dumpfile("dump.vcd");
        $dumpvars;
    end: dump_vcd
   
endmodule : top 

// ^L
// This file uses spaces for indentation.
// Emacs mode setup lines below; DO NOT DELETE!
// Local Variables:
// verilog-library-directories: ("." "design/register/src")
// End:
