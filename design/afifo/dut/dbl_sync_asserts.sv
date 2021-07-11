//-----------------------------------------------------------------------------
// Title         : dbl_sync_asserts
// Project       : cdc
//-----------------------------------------------------------------------------
// File          : dbl_sync_asserts.sv
// Author        : Anand S/INDIA  <ansn@aremote05>
// Created       : 28.03.2021
// Last modified : 28.03.2021
//-----------------------------------------------------------------------------
// Description :
// The assertions module for dbl_sync entity. Will be linked to it with
// "bindfiles".
//-----------------------------------------------------------------------------
// Copyright (c) 2021 by Anand Sreekumar This model is the confidential and
// proprietary property of Anand Sreekumar and the possession or use of this
// file requires a written license from Anand Sreekumar.
//------------------------------------------------------------------------------
// Modification history :
// 28.03.2021 : created
//-----------------------------------------------------------------------------

module dbl_sync_asserts #(
   parameter WIDTH = 1			  
) (
   input logic             clk_i,
   input logic             rstn_i,
   input logic [WIDTH-1:0] data_i,
   input logic [WIDTH-1:0] data_sync_o
);

    //------------------------------------------------------------------------
    // Below property is encforcing gray encoding checks - NOT practical on 
    // dbl syncs - Hence not asserting it - But useful for pure gray code based
    // data migration across clock domains (Don't check inside dbl sync though)
    //------------------------------------------------------------------------
    property prop_dbl_sync_di_not_gray_enc;
        @(posedge clk_i) disable iff(!rstn_i || (WIDTH < 1))
        (!$stable(data_i)) |-> $onehot(data_i ^ $past(data_i));
    endproperty: prop_dbl_sync_di_not_gray_enc

    //------------------------------------------------------------------------
    // stability: checks that data_i is stable for two clocks (or 3 edges ??)
    //------------------------------------------------------------------------
    property stability;
        @(posedge clk_i) disable iff(!rstn_i)
            !$stable(data_i) |=> $stable(data_i)[*2];
    endproperty: stability

    //------------------------------------------------------------------------
    // no_glitch: check for a glitch on data_i
    //------------------------------------------------------------------------
    property no_glitch;
        logic [WIDTH-1:0] data;
        @(data_i)
            (1, data = !data_i) |=>
                @(posedge clk_i)
                    (data_i == data);
    endproperty: no_glitch

    //------------------------------------------------------------------------
    // ASSERT PROPERTIES
    //------------------------------------------------------------------------
    assert property (stability);
    assert property (no_glitch);
endmodule: dbl_sync_asserts

// NOTE: for more cdc assertions,
// https://www.techdesignforums.com/practice/technique/multiple-cross-clock-domain-verifcation/
