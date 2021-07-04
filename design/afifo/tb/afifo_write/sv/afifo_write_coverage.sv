// You can insert code here by setting file_header_inc in file common.tpl

//=============================================================================
// Copyright (c) Anand Sreekumar
//=============================================================================
// Project  : ../../design/afifo
//
// File Name: afifo_write_coverage.sv
//
// Author   : Name   : Anand Sreekumar
//            Email  : anandsreekv4@gmail.com
//            Year   : 2021
//
// Version:   1.0
//
//=============================================================================
// Description: Coverage for agent afifo_write
//=============================================================================

`ifndef AFIFO_WRITE_COVERAGE_SV
`define AFIFO_WRITE_COVERAGE_SV

// You can insert code here by setting agent_cover_inc_before_class in file afifo_wr_if.tpl

class afifo_write_coverage extends uvm_subscriber #(wr_transaction);

  `uvm_component_utils(afifo_write_coverage)

  afifo_write_config m_config;    
  bit                m_is_covered;
  wr_transaction     m_item;
     
  // Start of inlined include file ../../design/afifo/tb/include/afifo_write_cover_inc.sv
  covergroup m_cov;
      option.per_instance = 1;
  
      cp_wdata: coverpoint m_item.wdata {
          bins zero = {0};
          bins one  = {1};
          bins first_half = { [1            : (2**(DWDTH-1) - 1)] };
          bins sec_half   = { [2**(DWDTH-1) : (2**(DWDTH)   - 1)] };
      }
  
      cp_wrstn: coverpoint m_item.wrstn {
          bins reset_tx     = {0};
          bins non_reset_tx = {1};
      }
  endgroup: m_cov
  // End of inlined include file

  // You can remove new, write, and report_phase by setting agent_cover_generate_methods_inside_class = no in file afifo_wr_if.tpl

  extern function new(string name, uvm_component parent);
  extern function void write(input wr_transaction t);
  extern function void build_phase(uvm_phase phase);
  extern function void report_phase(uvm_phase phase);

  // You can insert code here by setting agent_cover_inc_inside_class in file afifo_wr_if.tpl

endclass : afifo_write_coverage 


// You can remove new, write, and report_phase by setting agent_cover_generate_methods_after_class = no in file afifo_wr_if.tpl

function afifo_write_coverage::new(string name, uvm_component parent);
  super.new(name, parent);
  m_is_covered = 0;
  m_cov = new();
endfunction : new


function void afifo_write_coverage::write(input wr_transaction t);
  if (m_config.coverage_enable)
  begin
    m_item = t;
    m_cov.sample();
    // Check coverage - could use m_cov.option.goal instead of 100 if your simulator supports it
    if (m_cov.get_inst_coverage() >= 100) m_is_covered = 1;
  end
endfunction : write


function void afifo_write_coverage::build_phase(uvm_phase phase);
  if (!uvm_config_db #(afifo_write_config)::get(this, "", "config", m_config))
    `uvm_error(get_type_name(), "afifo_write config not found")
endfunction : build_phase


function void afifo_write_coverage::report_phase(uvm_phase phase);
  if (m_config.coverage_enable)
    `uvm_info(get_type_name(), $sformatf("Coverage score = %3.1f%%", m_cov.get_inst_coverage()), UVM_MEDIUM)
  else
    `uvm_info(get_type_name(), "Coverage disabled for this agent", UVM_MEDIUM)
endfunction : report_phase


// You can insert code here by setting agent_cover_inc_after_class in file afifo_wr_if.tpl

`endif // AFIFO_WRITE_COVERAGE_SV

