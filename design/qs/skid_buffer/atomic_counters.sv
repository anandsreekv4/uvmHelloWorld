// Link ==========================================================================
//    https://quicksilicon.in/course/rtl-design/module/atomic-counters
// Interface Definition ==========================================================
// trig_i    : Trigger input to increment the counter
// req_i     : A read request to the counter
// atomic_i  : Marks whether the current request is the first part of the two 32-bit accesses to read
//             the 64-bit counter. Use this input to save the current value of the upper 32-bit of
//             the counter in-order to ensure single-copy atomic operation
// ack_o     : Acknowledge output from the counter
// count_o   : 32-bit counter value given as output to the controller
// 
// Interface Requirements ========================================================
// The counter value is read by a 32-bit wide bus but the output should be single-copy atomic. The interface is a simple request and acknowledge interface with the following strict requirements:
// 
// Request can be a pulse or can get back to back multiple requests
// The acknowledge output must be given one cycle after the request is asserted
// The controller will always send two requests in order to read the full 64-bit counter
// The first request will always have the atomic_i input asserted
// The second request will not have the atomic_i input asserted
// 
// 
// Explanation ===================================================================
// Cycle T1 : Reset is asserted
// Cycle T2 : Reset is de-asserted
// Cycle T3 : trig_i is 1'b1 and should increment the internal counter
// Cycle T4 : req_i is 1'b1 and atomic_i is 1'b1. Marks the first part of two accesses
// Cycle T5 : req_i is 1'b1 and atomic_i is 1'b0. Second part of the request. ack_o is 1'b1 and count_o is 0x1 as only one trigger request was seen
// Cycle T6 : req_i is 1'b0. ack_o is 1'b1 with count_o as 0x0 (since the upper 32-bit of the counter are still 0x0. 64-bit counter value: 0x00000000_00000001
// Cycle T7 : req_i is 1'b0. ack_o is 1'b0
// Cycle T8 : Assume simulation is carried for few cycles with trig_i asserted
// Cycle T9 : req_i is 1'b1 with atomic_i being 1'b1
// Cycle T10 : req_i is 1'b1 with atomic_i being 1'b0 ack_o is 1'b1 with count_o as 0xFF.
// Cycle T11 : req_i is 1'b0. ack_o is 1'b0 ack_o is 1'b1 with count_o as 0x2. 64-bit counter value: 0x00000002_000000FF
// 
module atomic_counters (
  input                   clk,
  input                   reset,
  input                   trig_i,
  input                   req_i,
  input                   atomic_i,
  output logic            ack_o,
  output logic[31:0]      count_o
);

  // --------------------------------------------------------
  // DO NOT CHANGE ANYTHING HERE
  // --------------------------------------------------------
  logic [63:0] count_q;
  logic [63:0] count;

  always_ff @(posedge clk or posedge reset)
    if (reset)
      count_q[63:0] <= 64'h0;
    else
      count_q[63:0] <= count;
  // --------------------------------------------------------

  // Write your logic here...
  // 1. ack_o is simply delayed req_i
  // 2. When ack_o is asserted, drive the correct count_o
  // 3. When atomic_i is asserted, sample the count_q into count_atm => count_atm gets the value in the next cyc
  // 		Requirement: atomic_i is always there for the 1st req
  // Case: req without any atomic ?
  
  // 4. Counter always get's updated based on a trigger
  logic [1:0] ack;
  assign count = (trig_i) ? count_q + 1 :
    												count_q;
  
  logic [63:32] count_atm;
  assign count_o = (ack[1]) ? count_atm[63:32] : // count_atm stores the atomic value - use it on the 2nd valid cycle
    													(ack[0]) ? count_q[31:0] : // count_q (realtime value) to be used if it's first ack
    												 					   0;     // Otherwise always 0 -- Is this right?
    
  
  always_ff @(posedge clk or posedge reset)
    if (reset) begin
      count_atm <= 0;
      ack 		<= 0;
      ack_o 	<= 0;
    end else begin
      count_atm <= (atomic_i) ? count_q[63:32] : count_atm;
      ack 	    <= {{ack[0] && req_i && !atomic_i}, {req_i && atomic_i}};
      ack_o		<= req_i;                        // handshake is very simple - always ack back 1 cyc later
    end
  
      

endmodule


