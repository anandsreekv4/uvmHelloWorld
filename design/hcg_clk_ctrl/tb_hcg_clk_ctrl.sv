`include "hcg_clk_ctrl.sv"

module tb_hcg_clk_ctrl();
    parameter PERIOD = 10;
    string mode = "STOP2RUN2WAIT";

    //...................
    // internal declarations
    //...................
    logic     clk_i;          // FSM clock
    logic     rstn_i;         // FSM reset - active low
    
    logic     CACTIVE_i;      // CACTIVE out from peri. needs sync
    logic     CSYSACK_i;      // CSYSACK out from peri. needs sync
    logic     domain_ready_i; // Subsystem ready input. needs sync

    logic     CSYSREQ_o;      // Final CSYSREQ towards peri.
    logic     hcg_clk_en_o;   // Final HCG clock enable


    //...................
    // DUT
    //...................
    hcg_clk_ctrl u_DUT (.*);

    //...................
    // Clock gen
    //...................
    initial begin: CLK
        clk_i <= 0;
        forever #(PERIOD/2) clk_i = ~clk_i;
    end: CLK

    //...................
    // Sequence
    //...................
    initial begin: SEQ
        $value$plusargs ("mode=%s", mode);
        $display("*** Picking mode = %s ***", mode);

        CACTIVE_i = 0;
        CSYSACK_i = 0;
        domain_ready_i = 0;

        rstn_i = 0; // Assert reset
        #20;
        rstn_i = 1; // Release reset
        case (mode)
            "STOP2RUN": begin
                CACTIVE_i = #30 1;
                domain_ready_i = #10 1;
            end
            "STOP2RUN2WAIT": begin
                #30;
                CACTIVE_i = 1;
                #10;
                domain_ready_i = 1;

                #30;
                CACTIVE_i = 0;
                #10;
                CSYSACK_i = 1;
                domain_ready_i = 0;
            end
            "STOP2RUN2WAIT2STOP": begin
                #30;
                CACTIVE_i = 1;
                #10;
                domain_ready_i = 1;

                #30;
                CACTIVE_i = 0;
                #10;
                CSYSACK_i = 1;
                domain_ready_i = 0;

                #13;
                CSYSACK_i = 0;
            end
            default: $fatal("Invalid sequence selected with plusargs");
        endcase

        #100 $finish;
    end
endmodule: tb_hcg_clk_ctrl
