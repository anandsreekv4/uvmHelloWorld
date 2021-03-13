//                              -*- Mode: Verilog -*-
// Filename        : tx_fc_cov.svh
// Description     :
//-----------------------------------------------------------------------------
// Title         : tx_fc_cov
// Project       : register
//-----------------------------------------------------------------------------
// File          : tx_cov.svh
// Author        : Anand S/INDIA  <ansn@aremote05>
// Created       : 13.03.2021
// Last modified : 13.03.2021
//-----------------------------------------------------------------------------
// Description :
//               This block is meant to add functional coverage of "tx_item"
//-----------------------------------------------------------------------------
// Copyright (c) 2021 by IFX This model is the confidential and
// proprietary property of IFX and the possession or use of this
// file requires a written license from IFX.
//------------------------------------------------------------------------------
// Modification history :
// 13.03.2021 : created
//-----------------------------------------------------------------------------

class tx_fc_cov extends uvm_subscriber #(tx_item);
    `uvm_component_utils(tx_fc_cov)

    tx_item tx;

    function new(string name="tx_fc_cov", uvm_component parent);
        super.new(name, parent);
        this.tx_cg = new();
    endfunction: new

    covergroup tx_cg;
        data_cp:    coverpoint  tx.data {
            option.auto_bin_max=2;
        }
        enable_cp:  coverpoint  tx.enable;
        outa_cp:    coverpoint  tx.outa {
            bins bottom = {[    0:8'h10]};
            bins top    = {[8'h11:8'hFF]};
        }
        cross   data_cp, enable_cp, outa_cp;
    endgroup: tx_cg

    extern virtual function void build_phase(uvm_phase phase);
    extern virtual function void write(tx_item t);

endclass: tx_fc_cov

function void tx_fc_cov::build_phase(uvm_phase phase);
    super.build_phase(phase);
    // tx_cg = new(); --> LRM 19.4: embedded covergroups can only be present
    // inside "new" of the class.
endfunction: build_phase

function void tx_fc_cov::write(tx_item t);
    string s = "";
    this.tx = t;

    s = $sformatf(s, "\n Below txn will be used for coverage:-");
    s = $sformatf(s, this.tx.convert2string());
    // Print out got values
    `uvm_info(get_type_name(), s, UVM_MEDIUM)

    tx_cg.sample();
endfunction: write
