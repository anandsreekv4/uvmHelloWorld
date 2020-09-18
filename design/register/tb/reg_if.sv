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

  // clocking
  clocking tx_cb @(posedge clk);
    default input #1ns output #1ns;
    output data,reset_n,enable;
    input outa;
  endclocking: tx_cb

  // -- methods --
  task automatic transfer (input tx_item tx);
    @(posedge clk);
    enable <= tx.enable;
    data   <= tx.data; // Done driving
  endtask: transfer

  task automatic tap (inout tx_item tx);
    @(posedge clk);
    tx.outa <= outa;
  endtask: tap

  //
  // modports - pass the clocking here - does it work ?
  //
  modport tb(
    clocking tx_cb
  );

  modport dut(
    clocking tx_cb,
    input data,reset_n,enable,
    output outa
  );

endinterface: reg_if
