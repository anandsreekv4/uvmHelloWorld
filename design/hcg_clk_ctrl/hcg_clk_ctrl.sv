//............................................................................. 
// MODULE:   hcg_clk_ctrl
// PURPOSE:  FSM to control clock gating based on ARM AXI LPI signals
//............................................................................. 

package hcg_clk_ctrl_pkg;
    typedef enum logic [1:0] {STOPPED,
                              RUN,
                              WAIT_ACK,
                              XX='x} state_e;
endpackage: hcg_clk_ctrl_pkg

module hcg_clk_ctrl (
    input  logic     clk_i,          // FSM clock
    input  logic     rstn_i,         // FSM reset - active low
    
    input  logic     CACTIVE_i,      // CACTIVE out from peri. needs sync
    input  logic     CSYSACK_i,      // CSYSACK out from peri. needs sync
    input  logic     domain_ready_i, // Subsystem ready input. needs sync

    output logic     CSYSREQ_o,      // Final CSYSREQ towards peri.
    output logic     hcg_clk_en_o    // Final HCG clock enable
);

    import hcg_clk_ctrl_pkg::*;

    //...............................
    // Internal declarations
    //...............................
    logic       CACTIVE_sync_s;
    logic       CSYSACK_sync_s;
    logic       domain_ready_sync_s;
    state_e     state;
    state_e     next;

    //...............................
    // Input synchronisation
    //...............................
    hcg_sync_block  #(.WIDTH(3)) u_hcg_sync_block (
        .clk_i, 
        .rstn_i,
        .d_async_i({CACTIVE_i,
                    CSYSACK_i,
                    domain_ready_i}),
        .q_sync_o({CACTIVE_sync_s,
                   CSYSACK_sync_s,
                   domain_ready_sync_s})
    );

    //...............................
    // FSM
    //...............................
    always_ff @(posedge clk_i or negedge rstn_i)
        if (!rstn_i)    state <= STOPPED;
        else            state <= next;

    always_comb begin: FSM_NS_comb
        next = XX; // For easier debug

        unique case (state)
            STOPPED: if (CACTIVE_sync_s && domain_ready_sync_s)                 next = RUN;
                     else                                                       next = STOPPED;
            RUN: if (CSYSACK_sync_s && !CACTIVE_sync_s && !domain_ready_sync_s) next = WAIT_ACK;
                 else                                                           next = RUN;
            WAIT_ACK: if (!CSYSACK_sync_s)                                      next = STOPPED;
                      else                                                      next = WAIT_ACK;
            default:                                                            next = XX;
        endcase
    end: FSM_NS_comb

    always_ff @(posedge clk_i or negedge rstn_i) begin: FSM_op
        if (!rstn_i) begin: rst
            CSYSREQ_o    <= '0;
            hcg_clk_en_o <= '0;
        end: rst
        else begin: drv_op
            CSYSREQ_o    <= '0;
            hcg_clk_en_o <= '0;

            unique case (next)
                STOPPED: begin
                    CSYSREQ_o    <= '0;
                    hcg_clk_en_o <= '0;
                end
                RUN: begin
                    CSYSREQ_o    <= 1;
                    hcg_clk_en_o <= 1;
                end
                WAIT_ACK: begin
                    CSYSREQ_o    <= 0;
                    hcg_clk_en_o <= 1;
                end
                default: begin
                    CSYSREQ_o    <= 'x;
                    hcg_clk_en_o <= 'x;
                end
            endcase
        end: drv_op
    end: FSM_op

    property stopped2run_check;
        @(posedge clk_i) disable iff(rstn_i == 0)
        (CACTIVE_sync_s==1 && domain_ready_sync_s==1 |=> 
         state==RUN && CSYSREQ_o==1 && hcg_clk_en_o==0);
    endproperty: stopped2run_check
    prop_stopped2run_check: assert property (stopped2run_check);

    property reset_check;
        @(posedge clk_i) 
            (!rstn_i    |->
                (state==STOPPED) && CSYSREQ_o==0 && hcg_clk_en_o==0);
    endproperty: reset_check
    prop_reset_check: assert property (reset_check);

endmodule: hcg_clk_ctrl

module hcg_sync_block #(
    parameter WIDTH = 3
) (
    input               clk_i,
    input               rstn_i,

    input   [WIDTH-1:0] d_async_i,
    output  [WIDTH-1:0] q_sync_o
);

//.................................................................
// NOTE: Do NOT use this module to dbl sync buses.  Only meant for
// synchronising multiple single bit signals.
//.................................................................

    genvar i;
    generate
        for (i=0; i < WIDTH; i++) begin: SYNC_INPUT
            css600_cdc_capt_sync #(.DELAY_ONLY(1)) u_dbl_sync (.clk       (clk_i), 
                                                               .reset_n   (rstn_i),
                                                               .d_async_i (d_async_i[i]),
                                                               .q_sync_o  (q_sync_o[i]));
        end: SYNC_INPUT
    endgenerate
endmodule: hcg_sync_block

module css600_cdc_capt_sync
  #(parameter FF_SYNC_DEPTH = 2,
    parameter DELAY_ONLY = 0)
  (
  clk,
  reset_n,
  d_async_i,
  q_sync_o
  );

localparam SYNC_DEPTH = (FF_SYNC_DEPTH == 3) ? 3 : 2;

input        clk;
input        reset_n;
input        d_async_i;

output wire  q_sync_o;


  reg       d_sync1;
  reg       d_sync2;

generate
  if (SYNC_DEPTH == 3) begin: sync_depth_3
    reg       d_sync3;
    always @(posedge clk or negedge reset_n) begin
      if (!reset_n)
        begin
          d_sync1 <= 1'b0;
          d_sync2 <= 1'b0;
          d_sync3 <= 1'b0;
        end
      else
        begin
          d_sync1 <= d_async_i;
          d_sync2 <= d_sync1;
          d_sync3 <= d_sync2;
        end
    end

    assign q_sync_o = d_sync3;
  end
  else begin: sync_depth_2
    if (DELAY_ONLY == 1) begin: delay_only_depth_2
    always @(posedge clk or negedge reset_n) begin
      if (!reset_n)
      begin
        d_sync1 <= 1'b0;
        d_sync2 <= 1'b0;
      end
      else
        begin
          d_sync1 <= d_async_i;
          d_sync2 <= d_sync1;
        end
    end

    assign q_sync_o = d_sync2;
    end 
    else begin: hnd_dbl_sync
      dbl_sync_arstn u_dbl_sync ( .clk(clk), .DI(d_async_i), .DO(q_sync_o), .Rstn(reset_n) );
    end
  end

endgenerate


endmodule // css600_cdc_capt_sync


// vim:set ts=4:sw=4:noet:
