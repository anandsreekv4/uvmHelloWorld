// You can insert code here by setting file_header_inc in file common.tpl

//=============================================================================
// Project  : afifo_tb
//
// File Name: top_th.sv
//
//
// Version:   1.0
//
//=============================================================================
// Description: Test Harness
//=============================================================================

module top_th;

  timeunit      1ns;
  timeprecision 1ps;

  import afifo_tb_pkg::*;

  // You can remove clock and reset below by setting th_generate_clock_and_reset = no in file common.tpl

  // Example clock and reset declarations
  logic clock = 0;
  logic reset;

  // Example clock generator process
  always #10 clock = ~clock;

  // Example reset generator process
  initial
  begin
    reset = 0;         // Active low reset in this example
    #75 reset = 1;
  end

  assign afifo_write_if_0.wclk_i = clock;
  assign afifo_read_if_0.rclk_i  = clock;

  // You can insert code here by setting th_inc_inside_module in file common.tpl

  // Pin-level interfaces connected to DUT
  // You can remove interface instances by setting generate_interface_instance = no in the interface template file

  afifo_write_if  afifo_write_if_0 ();
  afifo_read_if   afifo_read_if_0 (); 

  afifo #(
    .PWDTH(4),
    .DWDTH(8)
  )
  uut (
    .wclk_i        (afifo_write_if_0.wclk_i),
    .wrstn_i       (afifo_write_if_0.wrstn_i),
    .winc_i        (afifo_write_if_0.winc_i),
    .wdata_i       (afifo_write_if_0.wdata_i),
    .fifo_full_o   (afifo_write_if_0.fifo_full_o),
    .fifo_ovflw_o  (afifo_write_if_0.fifo_ovflw_o),
    .rclk_i        (afifo_read_if_0.rclk_i),
    .rrstn_i       (afifo_read_if_0.rrstn_i),
    .rinc_i        (afifo_read_if_0.rinc_i),
    .rdata_o       (afifo_read_if_0.rdata_o),
    .fifo_empty_o  (afifo_read_if_0.fifo_empty_o),
    .fifo_undrflw_o(afifo_read_if_0.fifo_undrflw_o)
  );

endmodule

