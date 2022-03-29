// --------------------------------------------------------
// VLSI Arch Assignment - 2
// Author: Anand S
// BITSID: 2021HT80003
// --------------------------------------------------------
`include "flist.v"
module top ();
    localparam DATA_WDTH = 32;
    logic [DATA_WDTH-1:0] A;
    logic [DATA_WDTH-1:0] B;
    logic [3:0]           ALUC;
    logic [DATA_WDTH-1:0] OUT, OUT_exp=0;
    logic                 CARRY;
    string                op = "invalid";
    logic                 check_now;
    int                   pass, fail;

    // -----------------------
    // DUT
    // -----------------------
    `define INST
    alu #(
        `include "alu_params.v"
    ) u_alu (.*);

    initial begin: SEQ
        $display ("[SEQ]: Driving directed sequences ***********");
        drive_alu_directed();
        #100;

        $display ("[SEQ]: Driving random sequences ***********");
        drive_alu_random(10);
        #100;
        report();
        #10 $finish;
    end: SEQ

    task automatic drive_alu (input logic [3:0] tALUC,
                    input logic [DATA_WDTH-1:0] tA, tB);
        ALUC = tALUC;
        A = tA;
        B = tB;
        casez (ALUC)
            4'b?000: begin
                op = "add";
                OUT_exp = A + B;
            end
            4'b?100: begin
                op = "sub";
                OUT_exp = A - B;
            end
            4'b?010: begin
                op = "xor";
                OUT_exp = A ^ B;
            end
            4'b?001: begin
                op = "and";
                OUT_exp = A & B;
            end
            4'b?101: begin
                op = "or ";
                OUT_exp = A | B;
            end
            4'b?110: begin
                op = "lui";
                OUT_exp = {B[15:0],16'b0};
            end
            4'b0011: begin
                op = "sll";
                OUT_exp = B << A;
            end
            4'b0111: begin
                op = "srl";
                OUT_exp = B >> A;
            end
            4'b1111: begin
                op = "sra";
                OUT_exp = $signed(B) >>> A;
            end
            default: begin
                op = "invalid";
                OUT_exp = $signed(B) >>> A;
                $fatal("Invalid operation selected");
            end
        endcase
        #5 check_now = 1;#1 check_now = 0;
    endtask: drive_alu

    task drive_alu_directed ();
        //         4'bALUC,         A,          B
        drive_alu (0      ,         0,          0); #10;
        drive_alu (0      ,         3,          8); #10;// add             
        drive_alu (4'b1000,        11,          8); #10;// add with msb set
        drive_alu (4'b0100,        11,          8); #10;// sub             
        drive_alu (4'b1100,        11,          8); #10;// sub with msb set
        drive_alu (4'b0010,        11,          8); #10;// xor             
        drive_alu (4'b1010,        11,          8); #10;// xor with msb set
        drive_alu (4'b0001,        11,          8); #10;// and             
        drive_alu (4'b1001,        11,          8); #10;// and with msb set
        drive_alu (4'b0101,        11,          8); #10;// or              
        drive_alu (4'b1101,        11,          8); #10;// or with msb set 
        drive_alu (4'b0110,        11,          8); #10;// lui             
        drive_alu (4'b1110,        11,          8); #10;// lui with msb set
        drive_alu (4'b0011,        11,          8); #10;// sll             
        drive_alu (4'b0111,        11,          8); #10;// srl             
        drive_alu (4'b1111,        11,          8); #10;// sra             
        drive_alu (4'b1111,        11,         -8); #10;// sra             
        drive_alu (4'b1111,        11,         -8);     // sra             
    endtask: drive_alu_directed

    task drive_alu_random(input int iter);
        logic [3:0] ALUC_t;
        logic [DATA_WDTH-1:0] A_t;
        logic [DATA_WDTH-1:0] B_t;
        repeat(iter) begin: rand_seq
            std::randomize(ALUC_t) with {
                ALUC_t != 4'b1011; // This is invalid
            };
            std::randomize(A_t) with {
                A_t < 32;
                A_t > 0;
            };
            std::randomize(B_t); #10;
            drive_alu (ALUC_t, A_t, B_t);
        end: rand_seq
        repeat(iter) begin: rand_seq_shift
            std::randomize(ALUC_t) with {
                ALUC_t      != 4'b1011; // This is invalid - but design imp. sra
                ALUC_t[1:0] == 2'b11;   // Target shifts
            };
            std::randomize(A_t) with {
                A_t < 32;
                A_t > 0;
            };
            std::randomize(B_t); #10;
            drive_alu (ALUC_t, A_t, B_t);
        end: rand_seq_shift
    endtask: drive_alu_random

    task report();
        $display("[ALUSIM]: %0d vectors run, %0d pass, %0d fail", 
                fail+pass, pass, fail);
        if (fail!=0)
            $error("[ALUSIM]: TEST FAILED with %0d errors",fail);
        else
            $display("[ALUSIM]: TEST PASSED with %0d vectors",fail+pass);
    endtask: report

    always_comb begin: check
        if (check_now) 
            RESULT_ASSERT: assert (OUT === OUT_exp)  begin
                $display("PASS :***** time:%t|A:0x%h|B:0x%h|ALUC:0x%h(%s)|OUT:0x%h|OUT_exp:0x%h",
                        $time, A, B, ALUC, op, OUT, OUT_exp);
                pass++;
            end else  begin
                $display("FAIL :***** time:%t|A:0x%h|B:0x%h|ALUC:0x%h(%s)|OUT:0x%h|OUT_exp:0x%h",
                        $time, A, B, ALUC, op, OUT, OUT_exp);
                $display("[RESULT_ASSERT]: Expected OUT = 0x%0h, actual OUT = 0x%0h", OUT_exp, OUT);
                fail++;
            end
    end: check

endmodule: top
