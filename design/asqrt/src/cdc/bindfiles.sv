//-----------------------------------------------------------------------------
// Title         : bindfiles
// Project       : cdc
//-----------------------------------------------------------------------------
// File          : bindfiles.sv
// Author        : Anand S/INDIA  <ansn@aremote05>
// Created       : 28.03.2021
// Last modified : 28.03.2021
//-----------------------------------------------------------------------------
// Description :
// bindfiles module to include binding of assertions to the various DUTs
//-----------------------------------------------------------------------------
// Copyright (c) 2021 by Anand Sreekumar This model is the confidential and
// proprietary property of Anand Sreekumar and the possession or use of this
// file requires a written license from Anand Sreekumar.
//------------------------------------------------------------------------------
// Modification history :
// 28.03.2021 : created
//-----------------------------------------------------------------------------

`ifndef ASSRT_FILES_INCLUDED
    `define DBL_SYNC_ASSRT_INCLUDED
    `include "dbl_sync_asserts.sv"
`endif //!ASSRT_FILES_INCLUDED

module bindfiles;
   
   bind dbl_sync dbl_sync_asserts #(.WIDTH(WIDTH)) p1 (.*);
   
endmodule: bindfiles
