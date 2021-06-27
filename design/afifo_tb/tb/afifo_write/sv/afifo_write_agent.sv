// You can insert code here by setting file_header_inc in file common.tpl

//=============================================================================
// Project  : afifo_tb
//
// File Name: afifo_write_agent.sv
//
//
// Version:   1.0
//
// Code created by Easier UVM Code Generator version 2017-01-19 on Sat Jun 26 22:30:53 2021
//=============================================================================
// Description: Agent for afifo_write
//=============================================================================

`ifndef AFIFO_WRITE_AGENT_SV
`define AFIFO_WRITE_AGENT_SV

// You can insert code here by setting agent_inc_before_class in file afifo_wr_if.tpl

class afifo_write_agent extends uvm_agent;

  `uvm_component_utils(afifo_write_agent)

  uvm_analysis_port #(wr_transaction) analysis_port;

  afifo_write_config       m_config;
  afifo_write_sequencer_t  m_sequencer;
  afifo_write_driver       m_driver;
  afifo_write_monitor      m_monitor;

  local int m_is_active = -1;

  extern function new(string name, uvm_component parent);

  // You can remove build/connect_phase and get_is_active by setting agent_generate_methods_inside_class = no in file afifo_wr_if.tpl

  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
  extern function uvm_active_passive_enum get_is_active();

  // You can insert code here by setting agent_inc_inside_class in file afifo_wr_if.tpl

endclass : afifo_write_agent 


function  afifo_write_agent::new(string name, uvm_component parent);
  super.new(name, parent);
  analysis_port = new("analysis_port", this);
endfunction : new


// You can remove build/connect_phase and get_is_active by setting agent_generate_methods_after_class = no in file afifo_wr_if.tpl

function void afifo_write_agent::build_phase(uvm_phase phase);

  // You can insert code here by setting agent_prepend_to_build_phase in file afifo_wr_if.tpl

  if (!uvm_config_db #(afifo_write_config)::get(this, "", "config", m_config))
    `uvm_error(get_type_name(), "afifo_write config not found")

  m_monitor     = afifo_write_monitor    ::type_id::create("m_monitor", this);

  if (get_is_active() == UVM_ACTIVE)
  begin
    m_driver    = afifo_write_driver     ::type_id::create("m_driver", this);
    m_sequencer = afifo_write_sequencer_t::type_id::create("m_sequencer", this);
  end

  // You can insert code here by setting agent_append_to_build_phase in file afifo_wr_if.tpl

endfunction : build_phase


function void afifo_write_agent::connect_phase(uvm_phase phase);
  if (m_config.vif == null)
    `uvm_warning(get_type_name(), "afifo_write virtual interface is not set!")

  m_monitor.vif      = m_config.vif;
  m_monitor.m_config = m_config;
  m_monitor.analysis_port.connect(analysis_port);

  if (get_is_active() == UVM_ACTIVE)
  begin
    m_driver.seq_item_port.connect(m_sequencer.seq_item_export);
    m_driver.vif      = m_config.vif;
    m_driver.m_config = m_config;
  end

  // You can insert code here by setting agent_append_to_connect_phase in file afifo_wr_if.tpl

endfunction : connect_phase


function uvm_active_passive_enum afifo_write_agent::get_is_active();
  if (m_is_active == -1)
  begin
    if (uvm_config_db#(uvm_bitstream_t)::get(this, "", "is_active", m_is_active))
    begin
      if (m_is_active != m_config.is_active)
        `uvm_warning(get_type_name(), "is_active field in config_db conflicts with config object")
    end
    else 
      m_is_active = m_config.is_active;
  end
  return uvm_active_passive_enum'(m_is_active);
endfunction : get_is_active


// You can insert code here by setting agent_inc_after_class in file afifo_wr_if.tpl

`endif // AFIFO_WRITE_AGENT_SV

