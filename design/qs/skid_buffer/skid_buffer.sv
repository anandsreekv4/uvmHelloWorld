module skid_buffer (
  input   logic        clk,
  input   logic        reset,

  input   logic        i_valid_i,
  input   logic [7:0]  i_data_i,
  output  logic        i_ready_o,

  input   logic        e_ready_i,
  output  logic        e_valid_o,
  output  logic [7:0]  e_data_o
);

  // Write your logic here...
  typedef enum logic [1:0] {
    NBF=0 /*NON-BUFFERED*/
  ,	BUF=1	/*BUFFERED*/
  , XXX
  } state_e;
  state_e state, state_nxt;
  logic [9:0] buffer;
  
  always_ff @(posedge clk, posedge reset) begin: state_ff
    if (reset)	begin
      state <= NBF;
      buffer <= 10'b10_0000_0000;
    end  	else	begin
      state  <= state_nxt;
      buffer[8:0] <= (state_nxt == BUF && state != BUF && i_valid_i) ? {i_valid_i, i_data_i} : buffer[8:0];
      buffer[9]   <= e_ready_i;
    end
  end: state_ff
  
  always_comb begin: state_trans_comb
    case (state)
      NBF: begin
        if (i_valid_i && e_ready_i==0)		state_nxt = BUF;
        else															state_nxt = NBF;
      end
      BUF: begin
        if (/*i_valid_i &&*/ e_ready_i)		state_nxt = NBF;
        else															state_nxt = BUF;
      end
      default: 														state_nxt = XXX;
    endcase
  end: state_trans_comb
  
  always_comb begin: state_op_comb
    i_ready_o = 1;
    e_valid_o = 0;
    e_data_o  = 0;
    case (state)
      NBF: begin
        i_ready_o = 1; // Immediately provide the ack once out of reset
        e_valid_o = i_valid_i; // Directly send out the valid
        e_data_o  = i_data_i;  // "
      end
      BUF: begin
        i_ready_o = buffer[9];
        e_valid_o = buffer[8];
        e_data_o  = buffer[7:0];
      end
      default: begin
        {i_ready_o , e_valid_o, e_data_o} = 0;
      end
    endcase
  end: state_op_comb
  
  

endmodule
