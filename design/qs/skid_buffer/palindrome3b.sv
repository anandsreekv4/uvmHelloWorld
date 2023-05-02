// You are tasked to design a circuit which would detect a 3-bit palindrome sequence from incoming stream of bits.
// 
// Palindrome code is a sequence of characters which reads the same backward as forward. For example, the following are palindromes: 101, 010, 111, 000, etc.
// 
// All the flops should be positive edge triggered with asynchronous resets (if any).
// 
// Interface Definition
// x_i : Input stream of bits to the circuit
// 
// palindrome_o : Output to signal that the current bit and the last two bits together form a
//                palindrome
// Interface Requirements
// Output must be given every cycle
// Input will be a stream of bits presented to the circuit on every cycle
// Sample Simulation
// Palindrome
// 
// Explanation
// Cycle T0: Circuit is reset
// Cycle T1: Reset is deasserted with input as 1'b0
// Cycle T2: Input remains at 1'b0 and the stream of input becomes 2'b00
// Cycle T3: Input is 1'b0 and output goes HIGH since stream becomes 3'b000 which is a palindrome
// Cycle T4: Input is 1'b1 and output goes LOW as stream is now 3'b001
// Cycle T5: Input is 1'b0 and output goes HIGH as stream becomes 3'b010 which is a palindrome
// Cycle T6: Input is 1'b1 and output remains HIGH since stream is 3'b101
// Cycle T7: Input is 1'b1 and output goes LOW as stream is 3'b011
// Cycle T8: Input is 1'b1 and output goes HIGH as stream is 3'b111

module palindrome3b (
  input   logic        clk,
  input   logic        reset,

  input   logic        x_i,

  output  logic        palindrome_o
);

  // Write your logic here...
  logic [2:0] num_rev, num_fwd;
  logic [1:0] buffer, buffer_nxt, mask, mask_nxt;
  always_ff @(posedge clk, posedge reset)
    if (reset)		begin
      buffer <= 0;
      mask   <= 0;
    end else begin
  	  buffer <= buffer_nxt;
      mask   <= mask_nxt;
    end
  assign mask_nxt     = {mask[0], 1'b1};
  assign buffer_nxt 	= {buffer[0], x_i};
  assign num_fwd      = {buffer[1:0], x_i};
  assign num_rev  		= {x_i, buffer[0], buffer[1]};

  assign palindrome_o = (num_fwd == num_rev) && ({mask[1:0],1'b1} == 7); // Mask is to start the comparison only after shifting in 1st 3 bits.


endmodule

