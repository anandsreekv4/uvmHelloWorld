//-----------------------------------------------------------------------------
// Title         : tx_scb
// Project       : register
//-----------------------------------------------------------------------------
// File          : tx_scb.svh
// Author        : Anand S/INDIA  <ansn@aremote05>
// Created       : 13.03.2021
// Last modified : 13.03.2021
//-----------------------------------------------------------------------------
// Description :
// Scoreboard class with a predictor and comparator. Has two uvm_tlm_fifos,
// So need to separately instantiate "imp"s for each with decl macros (init lines)
//-----------------------------------------------------------------------------
// Copyright (c) 2021 by Anand Sreekumar
//------------------------------------------------------------------------------
// Modification history :
// 13.03.2021 : created
//-----------------------------------------------------------------------------

`uvm_analysis_imp_decl( _drv )
`uvm_analysis_imp_decl( _mon )

class tx_scb #(parameter WIDTH=8) extends uvm_scoreboard;
    `uvm_component_utils(tx_scb)

    // uvm_tlm_analysis_fifos come with their own "imp" - not normal tlm_fifos
    uvm_tlm_fifo #(tx_item) expfifo;
    uvm_tlm_fifo #(tx_item) actfifo;

    uvm_analysis_imp_drv #(tx_item, tx_scb) analysis_imp_drv;
    uvm_analysis_imp_mon #(tx_item, tx_scb) analysis_imp_mon;

    static tx_item last_tx;
    
    int VECT_CNT, PASS_CNT, ERROR_CNT;

    extern function new(string name="tx_scb", uvm_component parent);
    extern virtual function void build_phase(uvm_phase phase);
    extern virtual function void write_drv(tx_item tx);
    extern virtual function void write_mon(tx_item tx);
    extern virtual function void PASS();
    extern virtual function void ERROR();
    extern virtual task run_phase(uvm_phase phase);
    extern virtual function void report_phase(uvm_phase phase);
endclass: tx_scb

function tx_scb::new(string name="tx_scb", uvm_component parent);
    super.new(name, parent);
endfunction: new

function void tx_scb::build_phase(uvm_phase phase);
    super.build_phase(phase);
    expfifo = new( .name("expfifo"), .parent(this));
    actfifo = new( .name("actfifo"), .parent(this));
    analysis_imp_drv = new("analysis_imp_drv", this);
    analysis_imp_mon = new("analysis_imp_mon", this);
endfunction: build_phase

function void tx_scb::write_drv(tx_item tx);
    // To get the item put by monitor in the analysis_imps,
    // create a copy, and write expected value back to the
    // txn copy, and then put it in the "expfifo"
    static  logic [WIDTH-1:0]   last_outa;  // A static variable to keep prev cycle's "outa"
            logic [WIDTH-1:0]   outa;       // Present value of "outa", to be written back (predicted)



    tx_item tx_cp = tx_item#()::type_id::create("tx_cp", this);
    if (last_tx == null) last_tx = tx_item#()::type_id::create("last_tx", this);

    if (!tx_cp.reset_n) begin
        last_tx = tx_cp;           // Now both will reset back
    end else if (tx_cp.enable) begin
        tx_cp.outa = last_tx.data; // Last txn's data should be the outa
    end

    last_tx.copy(tx);             // Stores/Update current txn for next cycle

    // `uvm_info(get_type_name(), {"write_drv() begin:-\n", tx_cp.convert2string}, UVM_MEDIUM)

    // if (~tx_cp.reset_n)         {last_outa, outa} = 0;
    // else if (tx_cp.enable)                   outa = last_outa;

    // last_outa = tx_cp.data;

    // tx_cp.outa = outa;
    // `uvm_info(get_type_name(), {"write_drv() end:-\n", tx_cp.convert2string}, UVM_MEDIUM)

    void'(expfifo.try_put(tx_cp));             // Put it into FIFO now
endfunction: write_drv

function void tx_scb::write_mon(tx_item tx);
    tx_item tx_cp = tx_item#()::type_id::create("tx_cp");
    tx_cp.copy(tx);
    `uvm_info(get_type_name(), {"write_mon() on:-\n", tx_cp.convert2string}, UVM_MEDIUM)
    void'(actfifo.try_put(tx_cp));
endfunction: write_mon

task tx_scb::run_phase(uvm_phase phase);
    // In a forever loop, run and "get" txn from the fifos,
    // compare them, report.
    tx_item exp_tx;
    tx_item act_tx;

    super.run_phase(phase);

    
    forever begin: report
        expfifo.get(exp_tx);
        `uvm_info(get_type_name(),
                  {"Got following txn out of expfifo:-\n", exp_tx.convert2string()},
                                                                            UVM_MEDIUM)
         
        actfifo.get(act_tx);
        `uvm_info(get_type_name(),
                  {"Got following txn out of actfifo:-\n", act_tx.convert2string()},
                                                                            UVM_MEDIUM)
        
        if (exp_tx.compare(act_tx)) begin: do_pass
            `uvm_info("PASS", $sformatf("Actual=%s  |   Expected=%s\n",
                                        act_tx.convert2string(), exp_tx.convert2string()),
                                                                            UVM_MEDIUM)
            PASS();
        end: do_pass
        else begin: do_fail
            `uvm_info("FAIL", $sformatf("Actual=%s  |   Expected=%s\n",
                                        act_tx.convert2string(), exp_tx.convert2string()),
                                                                            UVM_MEDIUM)
            ERROR();
        end: do_fail
    end: report
endtask: run_phase

function void tx_scb::PASS();
    VECT_CNT++;
    PASS_CNT++;
endfunction:PASS

function void tx_scb::ERROR();
    VECT_CNT++;
    ERROR_CNT++;
endfunction: ERROR

function void tx_scb::report_phase(uvm_phase phase);
    super.report_phase(phase);
    if (ERROR_CNT == 0 && VECT_CNT > 0)
        `uvm_info("PASSED",
                  $sformatf("\n\n\n*** TEST PASSED - %0d vectors ran, %0d vectors passed ***\n",
                            VECT_CNT, PASS_CNT),
                                          UVM_LOW)
    else
        `uvm_info("FAILED",
                  $sformatf("\n\n\n*** TEST FAILED - %0d vectors ran, %0d vectors passed, %0d vectors failed ***\n",
                            VECT_CNT, PASS_CNT, ERROR_CNT),
                                                      UVM_LOW)
endfunction: report_phase
