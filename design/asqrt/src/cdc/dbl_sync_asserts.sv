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
   input             clk_i,
   input             rstn_i,
   input [WIDTH-1:0] data_i,
   input [WIDTH-1:0] data_sync_o
);

   ERR_DBL_SYNC_DI_NOT_GRAY_ENC: assert property (
					       @(posedge clk_i) disable iff(!rstn_i || (WIDTH < 1))
					       (!$stable(data_i)) |-> $onehot(data_i ^ $past(data_i)) && (WIDTH > 1));
       					      
endmodule: dbl_sync_asserts