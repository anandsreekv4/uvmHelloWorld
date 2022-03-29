// Code your design here
module hi;
  wire hi_w = 0;
  
  //always_comb
  //  assert(hi_w == 0) else $error("FATAL");
  
  typedef struct packed {
    logic [7:0] t0;
    logic [7:0] t1;
  } bundle_semathread_t;
  typedef struct packed {
    bundle_semathread_t mcu;
    bundle_semathread_t wl; 
  } bundle_semaip_t;
  
  bundle_semaip_t semareq_bus;
  
  logic [1:0] [1:0] [7:0] semareq_parr;
  localparam SEMA_WIDTH = 8;
  localparam NUM_THREADS= 2;
  localparam NUM_ON_CHIP_IP= 2;
  typedef logic [SEMA_WIDTH-1:0]  sema_t;
  typedef sema_t [NUM_THREADS-1:0] semathread_t;
  typedef semathread_t [NUM_ON_CHIP_IP-1:0] semathreadip_t;
  semathreadip_t semareq_parr_td;

  
  
  initial begin
    semareq_bus = 'hAAAA_AAAA;
    semareq_parr= 'h2B2A_1B1A;
    semareq_parr_td= 'h2B2A_1B1A;
    $display ("semareq_bus=%p and logic4=%b and semareq_parr=%h",semareq_bus, logic4, semareq_parr[0]);
    #10;
    semareq_bus.wl = '0;
    $display ("semareq_bus=%p and logic4=%b and semareq_parr=%h",semareq_bus, logic4, semareq_parr);
    #10;
  end
  
  logic clk, resetn, wren, regis;
  
  initial begin
    clk = 0;
    forever    clk = #5 ~clk;
  end
  
  initial begin
    $display("Apply reset");
    resetn = 0; wren=0;#10;
    
    resetn = 1;
    #10 wren = 1;
    #200; $finish;
    
  end
  
  logic [3:0] logic4;
  logic hi = 1;logic lo = 0;
  assign logic4 = {2{hi,lo}};
  always_ff @(posedge clk, negedge resetn)
    if (!resetn) begin
      regis <= 0;
    end else begin
      regis <= 0;
      if (wren) begin
        regis <= 1;
      end
    end
  
  initial begin
  $dumpfile("dump.vcd");
  $dumpvars(1);
	end
endmodule
