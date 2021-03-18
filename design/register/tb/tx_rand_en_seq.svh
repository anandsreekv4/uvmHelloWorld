//-----------------------------------------------------------------------------
// Title         : tx_rand_en_seq
// Project       : register
//-----------------------------------------------------------------------------
// File          : tx_rand_en_seq.svh
// Author        : Anand S/INDIA  <ansn@aremote05>
// Created       : 14.03.2021
// Last modified : 14.03.2021
//-----------------------------------------------------------------------------
// Description :
// Here, Identical to "tx_seq", but enable will also be randomised.
//-----------------------------------------------------------------------------
// Copyright (c) 2021 by Anand Sreekumar This model is the confidential and
// proprietary property of Anand Sreekumar and the possession or use of this
// file requires a written license from Anand Sreekumar.
//------------------------------------------------------------------------------
// Modification history :
// 14.03.2021 : created
//-----------------------------------------------------------------------------


class tx_rand_en_seq #(parameter int DELAY=10 ) extends tx_base_seq #(.DELAY(DELAY));
    `uvm_object_utils(tx_rand_en_seq#())

    extern function new(string name="tx_rand_en_seq");
    extern virtual task body();
endclass: tx_rand_en_seq

function tx_rand_en_seq::new(string name="tx_rand_en_seq");
    super.new(name);
endfunction: new

task tx_rand_en_seq::body();
    tx_item tx;
    this.do_reset();

    repeat (11) begin: send_11_times
        tx = tx_item::type_id::create(.name("tx"), .contxt(get_full_name()));

        start_item(tx);
        if (! tx.randomize() with {tx.enable inside {1};})
            `uvm_fatal("SEQ","Failed to randomise tx"); 
        finish_item(tx);
    end: send_11_times
endtask: body
