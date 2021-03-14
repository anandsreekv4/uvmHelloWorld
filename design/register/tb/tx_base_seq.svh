//-----------------------------------------------------------------------------
// Title         : tx_base_seq
// Project       : register
//-----------------------------------------------------------------------------
// File          : tx_base_seq.svh
// Author        : Anand S/INDIA  <ansn@aremote05>
// Created       : 14.03.2021
// Last modified : 14.03.2021
//-----------------------------------------------------------------------------
// Description :
// This is the "base" seq to be inherited by all other active sequences.
//-----------------------------------------------------------------------------
// Copyright (c) 2021 by Anand Sreekumar This model is the confidential and
// proprietary property of Anand Sreekumar and the possession or use of this
// file requires a written license from Anand Sreekumar.
//------------------------------------------------------------------------------
// Modification history :
// 14.03.2021 : created
//-----------------------------------------------------------------------------

virtual class tx_base_seq #(parameter int DELAY=10) extends uvm_sequence #(tx_item#());
    `uvm_object_utils(tx_base_seq#())

    extern function new(string name="tx_seq");
    extern virtual task body();
    extern virtual task do_reset();
endclass: tx_base_seq

function tx_base_seq::new(string name="tx_seq");
    super.new(name);
endfunction: new

task tx_base_seq::body();
    return;
endtask: body

task tx_base_seq::do_reset();
    tx_item rst_tx = tx_item#()::type_id::create(.name("rst_tx"), .contxt(get_full_name()));
    repeat (2) begin: two_cyc_reset
        start_item(rst_tx);
        rst_tx.reset_n = 0;
        rst_tx.enable  = 0;
        rst_tx.data    = 0;
        finish_item(rst_tx);
    end: two_cyc_reset
endtask: do_reset
