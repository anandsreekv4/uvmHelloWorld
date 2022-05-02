// --------------------------------------------------------
// VLSI Arch Assignment - 3
// Author: Anand S
// BITSID: 2021HT80003
// --------------------------------------------------------

module reg_file
import cpu_pkg::*;
(
    input   logic       clk, resetn,
    input   logic       enA, enB, enC,
    input   reg_t       addrA, addrB, addrC,
    input   sint32_t    C,           // write data port
    output  sint32_t    A, B         // read data ports
);

    sint32_t rf_array [REG_FILE_DEPTH];

    always_ff @(negedge clk, negedge resetn) begin
        if (!resetn) begin: init
            foreach (rf_array[i]) begin
                rf_array[i]    <= '{default: 0};
            end
            rf_array[1] <= 'h40;
            rf_array[2] <= 'h60;
            rf_array[4] <= 'h02;
            rf_array[5] <= 'h40;
            rf_array[7] <= 'hFFFF856D;
            rf_array[8] <= 'hEEEE3721;
            rf_array[10]<= 'h1FFF756F;
            rf_array[11]<= 'hFFFF765E;
        end: init
        else begin
            if (enC) rf_array[addrC] <= C;
        end
    end

`ifdef RD_STALL_ALLOWED
    always_ff @(posedge clk, negedge resetn) begin
        if (!resetn) begin
            A <= 0;
            B <= 0;
        end else begin
            if (enA) A <= rf_array[addrA];
            if (enB) B <= rf_array[addrB];
        end
    end
`else
    assign A = (enA) ? rf_array[addrA] : 1'b0;
    assign B = (enB) ? rf_array[addrB] : 1'b0;
`endif

endmodule: reg_file
