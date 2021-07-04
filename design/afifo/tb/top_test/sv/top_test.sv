// You can insert code here by setting file_header_inc in file common.tpl

//=============================================================================
// Copyright (c) Anand Sreekumar
//=============================================================================
// Project  : ../../design/afifo
//
// File Name: top_test.sv
//
// Author   : Name   : Anand Sreekumar
//            Email  : anandsreekv4@gmail.com
//            Year   : 2021
//
// Version:   1.0
//
//=============================================================================
// Description: Test class for top (included in package top_test_pkg)
//=============================================================================

`ifndef TOP_TEST_SV
`define TOP_TEST_SV

// You can insert code here by setting test_inc_before_class in file common.tpl

class top_test extends uvm_test;

  `uvm_component_utils(top_test)

  top_env m_env;

  extern function new(string name, uvm_component parent);

  // You can remove build_phase method by setting test_generate_methods_inside_class = no in file common.tpl

  extern function void build_phase(uvm_phase phase);

  // You can insert code here by setting test_inc_inside_class in file common.tpl

endclass : top_test


function top_test::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new


// You can remove build_phase method by setting test_generate_methods_after_class = no in file common.tpl

function void top_test::build_phase(uvm_phase phase);

  // You can insert code here by setting test_prepend_to_build_phase in file common.tpl

  // You could modify any test-specific configuration object variables here


  top_default_seq::type_id::set_type_override(write_5_read_5_seq::get_type());

  m_env = top_env::type_id::create("m_env", this);

  // You can insert code here by setting test_append_to_build_phase in file common.tpl

endfunction : build_phase


// Start of inlined include file ../../design/afifo/tb/include/top_wX_rXp1_test.sv
//==================================================================
// top_test: top_wX_rXp1_test
//==================================================================
class top_wX_rXp1_test extends top_test;
    `uvm_component_utils(top_wX_rXp1_test)

    extern function new (string name, uvm_component parent);
    extern function void build_phase (uvm_phase phase);

endclass: top_wX_rXp1_test

function top_wX_rXp1_test::new (string name, uvm_component parent);
    super.new(name, parent);
endfunction: new

function void top_wX_rXp1_test::build_phase (uvm_phase phase);
    super.build_phase(phase); // m_env will be created by top_test
    // factory over-ride the default vseq with this test's vseq
    top_default_seq::type_id::set_type_override(top_wX_rXp1_vseq::get_type());
endfunction
//==================================================================
// End of inlined include file

`endif // TOP_TEST_SV

