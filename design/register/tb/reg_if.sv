/////////////////////////////////////////////////////////////////////////
// Interface: reg_if
// Purpose  : To provide a layer of abstraction bw the TB and DUT 
//            by adding this statically allocated object called intf.
//            Reusability - Key point is, the intf can be connected to a
//            virtual/dynamic object, which is used by the TB(fully dynamic)
/////////////////////////////////////////////////////////////////////////

interface reg_if  (input logic clk);
    import tx_pkg::*; // This is required since there are references
    // to classes defined in this pkg.
    // data
    logic [WIDTH-1:0] outa;
    logic [WIDTH-1:0] data;

    // control
    logic       enable;
    logic       reset_n;

    //
    // clocking
    //
    clocking tx_master_cb @(posedge clk);
        default input #1step output #1ns;
        output data,reset_n,enable;
        input outa;
    endclocking: tx_master_cb

    clocking tx_slave_cb @(posedge clk);
        default input #1step output #1ns;
        input data,reset_n,enable;
        // output outa;                // Cannot READ an output clockvar as it si write-only!
        input outa;
    endclocking: tx_slave_cb

    // 
    // -- methods --
    //
    task automatic transfer (input tx_item tx);
        @(tx_master_cb);
        tx_master_cb.reset_n<= tx.reset_n;
        tx_master_cb.enable <= tx.enable;
        tx_master_cb.data   <= tx.data; // Done driving
    endtask: transfer

    task automatic tap (input tx_item tx);
        @(tx_slave_cb);
        tx.reset_n= tx_slave_cb.reset_n;
        tx.enable = tx_slave_cb.enable;
        tx.data   = tx_slave_cb.data;
        tx.outa   = tx_slave_cb.outa;
        // It seems, using clocking block on the RHS does not work out well..
    endtask: tap

    //
    // modports - pass the clocking here - does it work ?
    //
    modport tb(
        clocking tx_master_cb
    );

    modport dut(
        clocking tx_master_cb,
            input data,reset_n,enable,
            output outa
    );

endinterface: reg_if
