// You can insert code here by setting file_header_inc in file common.tpl

//=============================================================================
// Project  : afifo_tb
//
// File Name: afifo_read_coverage.sv
//
//
// Version:   1.0
//
// Code created by Easier UVM Code Generator version 2017-01-19 on Sat Jun 26 22:30:53 2021
//=============================================================================
// Description: Coverage for agent afifo_read
//=============================================================================

`ifndef AFIFO_READ_COVERAGE_SV
`define AFIFO_READ_COVERAGE_SV

// You can insert code here by setting agent_cover_inc_before_class in file afifo_rd_if.tpl

class afifo_read_coverage extends uvm_subscriber #(rd_transaction);

  `uvm_component_utils(afifo_read_coverage)

  afifo_read_config m_config;    
  bit               m_is_covered;
  rd_transaction    m_item;
     
  `include "afifo_read_cover_inc.sv"

  // You can remove new, write, and report_phase by setting agent_cover_generate_methods_inside_class = no in file afifo_rd_if.tpl

  extern function new(string name, uvm_component parent);
  extern function void write(input rd_transaction t);
  extern function void build_phase(uvm_phase phase);
  extern function void report_phase(uvm_phase phase);

  // You can insert code here by setting agent_cover_inc_inside_class in file afifo_rd_if.tpl

endclass : afifo_read_coverage 


// You can remove new, write, and report_phase by setting agent_cover_generate_methods_after_class = no in file afifo_rd_if.tpl

function afifo_read_coverage::new(string name, uvm_component parent);
  super.new(name, parent);
  m_is_covered = 0;
  m_cov = new();
endfunction : new


function void afifo_read_coverage::write(input rd_transaction t);
  if (m_config.coverage_enable)
  begin
    m_item = t;
    m_cov.sample();
    // Check coverage - could use m_cov.option.goal instead of 100 if your simulator supports it
    if (m_cov.get_inst_coverage() >= 100) m_is_covered = 1;
  end
endfunction : write


function void afifo_read_coverage::build_phase(uvm_phase phase);
  if (!uvm_config_db #(afifo_read_config)::get(this, "", "config", m_config))
    `uvm_error(get_type_name(), "afifo_read config not found")
endfunction : build_phase


function void afifo_read_coverage::report_phase(uvm_phase phase);
  if (m_config.coverage_enable)
    `uvm_info(get_type_name(), $sformatf("Coverage score = %3.1f%%", m_cov.get_inst_coverage()), UVM_MEDIUM)
  else
    `uvm_info(get_type_name(), "Coverage disabled for this agent", UVM_MEDIUM)
endfunction : report_phase


// You can insert code here by setting agent_cover_inc_after_class in file afifo_rd_if.tpl

`endif // AFIFO_READ_COVERAGE_SV

