package afifo_tb_pkg;
    `ifdef DWDTH
        parameter DWDTH = `DWDTH;
    `else
        parameter DWDTH = 8;
    `endif

    `ifdef PWDTH
        parameter PWDTH = `PWDTH;
    `else
        parameter PWDTH = 4;
    `endif
endpackage: afifo_tb_pkg
