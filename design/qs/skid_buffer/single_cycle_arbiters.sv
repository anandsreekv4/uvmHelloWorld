// You are leading a complex SoC which interacts with a lot of peripherals. As a result there is a need for an arbitration scheme to be used across the SoC. You decide to design a parameterized fixed priority arbitration scheme which grants a winner every cycle.
// 
// Design the parameterized single cycle arbiter module with fixed priority arbitration scheme. All the flops (if any) should be positive edge triggered with asynchronous resets.
// 
// Interface Definition
// req_i : Input request vector to the arbiter
// gnt_o : One-hot encoded signal for the winning request port
// Interface Requirements
// Arbiter should grant a single winner (if any) every cycle
// The arbiter should use a fixed priority arbitration scheme
// Port[0] has the highest priority and priority decreases with incrementing port numbers
// Sample Simulation
// Arbiter
// 
// Explanation
// Cycle T1 : Reset is asserted
// Cycle T2 : Reset is de-asserted
// Cycle T3 : req_i is 0x0 - No incoming requests. gnt_o is also 0x0
// Cycle T4 : req_i is 0x3 - Requests at Port[0] and [1]. gnt_o is 0x1 as port[0] gets priority
// Cycle T5 : req_i is 0x6 - Requests at port[1] and [2]. gnt_o is 0x2 as port[1] gets priority
// Cycle T6 : req_i is 0xC - Requests at port[2] and [3]. gnt_o is 0x4 as port[2] wins
// Cycle T7 : req_i is 0x9 - Requests at port[0] and [3]. gnt_o is 0x1 as port[0] wins
// Cycle T8 : req_i is 0xE - Requests at port[1], [2] and [3]. gnt_o is 0x2 as port[0] wins
// Cycle T9 : req_i is 0xF - Requests at all the ports. gnt_o is 0x1 as port[0] wins


module single_cycle_arbiter #(
  parameter N = 32
) (
  input   logic          clk,
  input   logic          reset,
  input   logic [N-1:0]  req_i,
  output  logic [N-1:0]  gnt_o
);

  // Write your logic here...
  logic [N-1:0] mask, gnt_nxt;
  always_comb begin
    mask    = 0;
    for (int i=N-1; i>=0; i--) begin: gen_gnt
      if (req_i[i] == 1) begin
        mask    = 0;
        mask[i] = 1;
      end
    end
    gnt_o = req_i & mask;
  end

  /* Waveforms match when gnt_o is flopped, also easier on timing.
  	 But although waveform matches, the mismatch bit is asserted in TB. FIXME: website bug?
  always_ff @(posedge clk, posedge reset)
    if (reset)	gnt_o <= 0;
  	else 			 	gnt_o <= gnt_nxt;
  */

endmodule


