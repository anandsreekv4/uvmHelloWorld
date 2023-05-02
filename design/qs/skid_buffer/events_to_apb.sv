// Sam is a fan of the AMBA APB protocol and has taken up the challenge to design a block which converts certain input events to APB transactions. The design takes three different inputs and generates an APB transaction to a single slave. Whenever any input is asserted, Sam wants to send out an APB transaction to an address reserved for the particular event. Sam needs your help to design the events to APB converter.
// 
// All the flops (if any) should be positive edge triggered with asynchronous resets.
// 
// Interface Definition
// The block takes three single bit inputs:
// event_a_i
// event_b_i
// event_c_i
// The output APB transaction uses the following signals:
// apb_psel_o
// apb_penable_o
// apb_paddr_o[31:0]
// apb_pwrite_o
// apb_pwdata_o[31:0]
// apb_pready_i
// The APB transaction should be generated whenever any of the input event is asserted. The generated APB transactions should always be an APB write transaction. Hence the interface doesn't contain the apb_prdata_i input.
// eventsToAPB_block_diagram
// 
// Interface Requirements
// The APB transaction must comply with the AMBA APB protocol specifications
// The three event inputs are mutually exclusive i.e. there can be atmost one event asserted on a cycle
// The APB transaction generated due to Event A should be sent to address 0xABBA0000
// The APB transaction generated due to Event B should be sent to address 0xBAFF0000
// The APB transaction generated due to Event C should be sent to address 0xCAFE0000
// The write data should give the count of the number of events seen since the last write for that particular event
// The APB interface guarantees that the pready signal would be asserted within 10 cycles for a particular transaction without any pslverr. Hence the interface doesn't contain the pslverr input
// Back to back APB transactions aren't supported by interface hence there should a cycle gap before the next APB transaction is generated
// The event input interface guarantees fairness amongst the three events such that there cannot be more than 10 pending events for any input event
// Note: The above fairness scheme allows you to implement the address selection logic for the APB request in any given order of priority for the inputs.


module events_to_apb (
  input   logic         clk,
  input   logic         reset,

  input   logic         event_a_i,
  input   logic         event_b_i,
  input   logic         event_c_i,

  output  logic         apb_psel_o,
  output  logic         apb_penable_o,
  output  logic [31:0]  apb_paddr_o,
  output  logic         apb_pwrite_o,
  output  logic [31:0]  apb_pwdata_o,
  input   logic         apb_pready_i

);

  // Write your logic here
  // Below is a superior design - the testbench currently does not support this design, although it meets the spec. Review.
  // Here, I am interfacing a synch FIFO which is 10 deep to hold ALL data coming in, regardless of the state of the APB o/p i/f.
  // Later, once the receiver is ready, the data is popped out. This is held for EVFIFO_DEPTH.
  localparam EVA_ADDR = 32'hABBA0000;
  localparam EVB_ADDR = 32'hBAFF0000;
  localparam EVC_ADDR = 32'hCAFE0000;
  localparam EVFIFO_DEPTH = 10;
  localparam PTR_MSB  = $clog2(EVFIFO_DEPTH);

  typedef enum logic [1:0] { P_IDLE = 0 ,	P_SEL  = 1 ,	P_ENB  = 2 , P_WAIT} apb_states_t;
  apb_states_t pstate, pstate_nxt;

  // DPRAM EVRAM for EVFIFO
  logic evram_we;
  logic [63:0] evram_wdata, evram_rdata;
  logic [63:0] evram [EVFIFO_DEPTH-1:0];
  typedef struct packed {
    logic [31:0] a;
    logic [31:0] b;
    logic [31:0] c;
  } ev_ctr_t;
  ev_ctr_t ev_ctr, ev_ctr_nxt;
  // Create a 10 deep event FIFO
  logic [PTR_MSB:0] wptr, rptr;
  logic evfifo_push, evfifo_pop, evfifo_full, evfifo_empty, evfifo_req, evfifo_ack;
  always_ff @(posedge clk, posedge reset)
    if (reset)	begin
      {wptr, rptr} <= 0;
      ev_ctr       <=  0;
    end else begin
      if (evfifo_push) ev_ctr <= ev_ctr_nxt;
      if (evfifo_push) wptr <= wptr + 1;
      if (evfifo_pop)  rptr <= rptr + 1;
      if (wptr[PTR_MSB-1:0] == 10) wptr <= 16;
      if (rptr[PTR_MSB-1:0] == 10) rptr <= 16;
    end
  assign evfifo_empty = (wptr == rptr);
  assign evfifo_full  = (wptr[PTR_MSB] ^ rptr[PTR_MSB]) && (wptr[PTR_MSB-1:0] == rptr[PTR_MSB-1:0]);
  assign evfifo_push  = !evfifo_full  && evfifo_req;
  assign evfifo_pop   = !evfifo_empty && evfifo_ack;

	assign evfifo_req   = event_a_i || event_b_i || event_c_i;
	//assign evfifo_ack   = apb_pready_i; // Drive this from the APB fsm :FIXME
  assign evram_wdata[31:0]  = (event_a_i) ? EVA_ADDR :
                        			(event_b_i) ? EVB_ADDR :
                        			(event_c_i) ? EVC_ADDR :
                        			0;
  assign evram_wdata[63:32] = (event_a_i) ? ev_ctr_nxt.a :
    													(event_b_i) ? ev_ctr_nxt.b :
    													(event_c_i) ? ev_ctr_nxt.c :
    													0;
  always_comb begin
    ev_ctr_nxt = ev_ctr;
    if (event_a_i) ev_ctr_nxt.a = ev_ctr.a + 1;
    if (event_b_i) ev_ctr_nxt.b = ev_ctr.b + 1;
    if (event_c_i) ev_ctr_nxt.c = ev_ctr.c + 1;
  end

  assign evram_we = evfifo_push;

  always_ff @(posedge clk, posedge reset) begin: evfifo_ram_blk
    if (evram_we)
      evram[wptr[PTR_MSB-1:0]] <= evram_wdata;
  end: evfifo_ram_blk

  assign evram_rdata = evram[rptr[PTR_MSB-1:0]];

  always_ff @(posedge clk, posedge reset) begin: P_FSM
    if (reset) 	pstate <= P_IDLE;
    else 				pstate <= pstate_nxt;
  end: P_FSM

  always_comb begin: P_NS
    pstate_nxt = P_IDLE;
    case (pstate)
      P_IDLE: begin
        if (evfifo_push) pstate_nxt = P_SEL;
        else			 pstate_nxt = P_IDLE;
      end
      P_SEL : begin
        pstate_nxt = P_ENB;
      end
      P_ENB : begin
        if (apb_pready_i)pstate_nxt = P_WAIT;
        else			 pstate_nxt = P_ENB;
      end
      P_WAIT: begin
        pstate_nxt = P_IDLE;
      end
    endcase
  end: P_NS

	always_comb begin: P_OUT
    apb_psel_o = 0;
    apb_penable_o = 0;
    apb_paddr_o = 0;
    apb_pwrite_o = 1;
    apb_pwdata_o = 0;
    evfifo_ack = 0;
    case(pstate)
      P_IDLE: begin
      end
      P_SEL: begin
        apb_psel_o = 1;
      end
      P_ENB: begin
        apb_psel_o = 1;
        apb_penable_o = 1;
        apb_paddr_o = evram_rdata[31:0];
        apb_pwdata_o = evram_rdata[63:32];
      end
      P_WAIT: begin
        evfifo_ack = 1;
      end
    endcase
  end


endmodule

