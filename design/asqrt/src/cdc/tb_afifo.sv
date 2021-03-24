//-----------------------------------------------------------------------------
// Title         : tb_afifo
// Project       : afifo
//-----------------------------------------------------------------------------
// File          : afifo_tb.sv
// Author        : Anand S/INDIA  <ansn@aremote05>
// Created       : 23.03.2021
// Last modified : 23.03.2021
//-----------------------------------------------------------------------------
// Description :
// This is the TB for the afifo module. There is a fifo model also present which
// is used in the scoreboard here.
//-----------------------------------------------------------------------------
// Copyright (c) 2021 by Anand Sreekumar This model is the confidential and
// proprietary property of Anand Sreekumar and the possession or use of this
// file requires a written license from Anand Sreekumar.
//------------------------------------------------------------------------------
// Modification history :
// 23.03.2021 : created
//-----------------------------------------------------------------------------

module tb_afifo;
   parameter PWDTH = 4;
   parameter DWDTH = 9; // enable + NBITS of Data, i.e NBITS = 8
   
   logic             wclk_i;
   logic             rclk_i;
   logic             wrstn_i;
   logic             rrstn_i;
   logic             winc_i;
   logic             rinc_i;
   logic [DWDTH-1:0] wdata_i;
   logic [DWDTH-1:0] rdata_o;
   logic             fifo_full_o;
   logic             fifo_ovflw_o;
   logic             fifo_undrflw_o;
   
   afifo #(.PWDTH(PWDTH),.DWDTH(DWDTH)) u_afifo(.*);

   initial begin: clk_gen_wclk
      wclk_i <= 0;
      forever #5  wclk_i = ~wclk_i;
   end: clk_gen_wclk
   
   initial begin: clk_gen_rclk   /* rclk=33MHz is 3x slower than wclk=100MHz */
      rclk_i <= 0;
      forever #15 rclk_i = ~rclk_i;
   end: clk_gen_rclk

   initial begin: seq
      fork
         begin: wclk_rst
            wrstn_i = 0;
            repeat(2) @(posedge wclk_i);
            wrstn_i = 1;
         end: wclk_rst

         begin: rclk_rst
            rrstn_i = 0;
            repeat(2) @(posedge rclk_i);
            rrstn_i = 1;
         end: rclk_rst
      join

      repeat (10) @(posedge wclk_i) begin:gen_seq
         waddr_i = $urandom;
         winc_i  = 1;
      end:gen_seq
      
      repeat (10) @(posedge wclk_i) begin:gen_seq_rd
         raddr_i = $urandom;
         rinc_i  = 1;
      end:gen_seq_rd
      
   end:seq
endmodule: tb_afifo

// ^L
// Local Variables:
// Mode: verilog
// indent-tabs-mode:nil
// tab-width:4
// verilog-library-flags:(".")
// End: