/////////////////////////////////////////////////////////////////////////
//
//       MODULE: registers
//  DESCRIPTION: A simple register slice
//   IO SIGNALS: data[WIDTH-1:0], outa[WIDTH-1:0]
//       AUTHOR: ANSN, 
// ORGANIZATION: CYPRESS
//      VERSION: 1.0
//      CREATED: 09/06/20 22:45:45
//     REVISION: 1.0
/////////////////////////////////////////////////////////////////////////

module register (/*AUTOARG*/
   // Outputs
   outa,
   // Inputs
   clk, reset_n, enable, data
   );

parameter WIDTH = 8;

input		   clk;
input		   reset_n;
input		   enable;
input  [WIDTH-1:0] data;
output [WIDTH-1:0] outa;

/*AUTOREG*/
// Beginning of automatic regs (for this module's undeclared outputs)
reg [WIDTH-1:0]		outa;
// End of automatics

/*AUTOWIRE*/

// sends out data at the very next clock cycle
always_ff @(posedge clk or negedge reset_n) begin: flop
    if(!reset_n) begin
	/*AUTORESET*/
	// Beginning of autoreset for uninitialized flops
	outa <= {WIDTH{1'b0}};
	// End of automatics
    end else if (enable) begin
	outa <= data;
    end else begin
	outa <= outa;
    end
end

// synopsys translate off
initial begin
    $monitor ("\n[inline_monitor] @%0t:reset_n=>0x%0h enable=>0x%0h data=>0x%0h outa=>0x%0h", $time, reset_n, enable, data, outa);
end
// synopsys translate on
    
endmodule: register
