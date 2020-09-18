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

    /* INTERFACE */
    reg_if #(.WIDTH(8)) ireg_if(clk);

    /* DUT */
    parameter WIDTH = 8;
    register  #(
        .WIDTH(8)
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
        clk = 0;
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

            /* .scope("ifs"), */
            /* .name ("reg_if"), */
            /* .val  (ireg_if) */
        );
    end
   
endmodule : top 

// ^L
// This file uses spaces for indentation.
// Emacs mode setup lines below; DO NOT DELETE!
// Local Variables:
// verilog-library-directories: ("." "design/register/src")
// End:
