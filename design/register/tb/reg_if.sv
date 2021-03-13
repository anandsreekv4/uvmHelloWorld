/////////////////////////////////////////////////////////////////////////
// Interface: reg_if
// Purpose  : To provide a layer of abstraction bw the TB and DUT 
//            by adding this statically allocated object called intf.
//            Reusability - Key point is, the intf can be connected to a
//            virtual/dynamic object, which is used by the TB(fully dynamic)
/////////////////////////////////////////////////////////////////////////

interface reg_if #(parameter WIDTH = 8) (input logic clk);
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
    default input #1ns output #1ns;
    output data,reset_n,enable;
    input outa;
  endclocking: tx_master_cb

  // 
  // -- methods --
  //
  task automatic transfer (input tx_item tx);
    @(tx_master_cb);
    tx_master_cb.enable <= tx.enable;
    tx_master_cb.data   <= tx.data; // Done driving
  endtask: transfer

  task automatic tap (input tx_item tx);
    tx.enable = tx_master_cb.enable;
    tx.data   = tx_master_cb.data;
    tx.outa   = tx_master_cb.outa;
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
