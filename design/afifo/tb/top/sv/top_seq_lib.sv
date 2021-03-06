// You can insert code here by setting file_header_inc in file common.tpl

//=============================================================================
// Copyright (c) Anand Sreekumar
//=============================================================================
// Project  : ../../design/afifo
//
// File Name: top_seq_lib.sv
//
// Author   : Name   : Anand Sreekumar
//            Email  : anandsreekv4@gmail.com
//            Year   : 2021
//
// Version:   1.0
//
//=============================================================================
// Description: Sequence for top
//=============================================================================

`ifndef TOP_SEQ_LIB_SV
`define TOP_SEQ_LIB_SV

class top_default_seq extends uvm_sequence #(uvm_sequence_item);

  `uvm_object_utils(top_default_seq)

  top_config         m_config;
          
  afifo_write_agent  m_afifo_write_agent;
  afifo_read_agent   m_afifo_read_agent; 

  // Number of times to repeat child sequences
  int m_seq_count = 5;

  extern function new(string name = "");
  extern task body();
  extern task pre_start();
  extern task post_start();

`ifndef UVM_POST_VERSION_1_1
  // Functions to support UVM 1.2 objection API in UVM 1.1
  extern function uvm_phase get_starting_phase();
  extern function void set_starting_phase(uvm_phase phase);
`endif

endclass : top_default_seq


function top_default_seq::new(string name = "");
  super.new(name);
endfunction : new


task top_default_seq::body();
  `uvm_info(get_type_name(), "Default sequence starting", UVM_HIGH)


  repeat (m_seq_count)
  begin
    fork
      if (m_afifo_write_agent.m_config.is_active == UVM_ACTIVE)
      begin
        afifo_write_default_seq seq;
        seq = afifo_write_default_seq::type_id::create("seq");
        seq.set_item_context(this, m_afifo_write_agent.m_sequencer);
        if ( !seq.randomize() )
          `uvm_error(get_type_name(), "Failed to randomize sequence")
        seq.m_config = m_afifo_write_agent.m_config;
        seq.set_starting_phase( get_starting_phase() );
        seq.start(m_afifo_write_agent.m_sequencer, this);
      end
      if (m_afifo_read_agent.m_config.is_active == UVM_ACTIVE)
      begin
        afifo_read_default_seq seq;
        seq = afifo_read_default_seq::type_id::create("seq");
        seq.set_item_context(this, m_afifo_read_agent.m_sequencer);
        if ( !seq.randomize() )
          `uvm_error(get_type_name(), "Failed to randomize sequence")
        seq.m_config = m_afifo_read_agent.m_config;
        seq.set_starting_phase( get_starting_phase() );
        seq.start(m_afifo_read_agent.m_sequencer, this);
      end
    join
  end

  `uvm_info(get_type_name(), "Default sequence completed", UVM_HIGH)
endtask : body


task top_default_seq::pre_start();
  uvm_phase phase = get_starting_phase();
  if (phase != null)
    phase.raise_objection(this);
endtask: pre_start


task top_default_seq::post_start();
  uvm_phase phase = get_starting_phase();
  if (phase != null) 
    phase.drop_objection(this);
endtask: post_start


`ifndef UVM_POST_VERSION_1_1
function uvm_phase top_default_seq::get_starting_phase();
  return starting_phase;
endfunction: get_starting_phase


function void top_default_seq::set_starting_phase(uvm_phase phase);
  starting_phase = phase;
endfunction: set_starting_phase
`endif


// Start of inlined include file ../../design/afifo/tb/include/top_vseq_lib.sv
//==================================================================
// vsequence: top_default_vseq - Contains basic tasks required
// - do_reset(int count) - 
// - write_atomic - Does a single write
// - read atomic  - Does a single read
//==================================================================
class top_default_vseq extends top_default_seq;
    rand int m_seq_cnt;
    extern function new(string name = "");
    extern task do_reset(int count=3);
    extern task write_atomic();
    extern task read_atomic();
endclass: top_default_vseq


function top_default_vseq::new(string name = "");
    super.new(name);
endfunction: new

task top_default_vseq::do_reset(int count=3);
    string s;
    s = $sformatf( "Sending %0d cycles of reset before starting test", count);
    `uvm_info(get_type_name(), s, UVM_MEDIUM)
    
    fork
        if (m_afifo_write_agent.m_config.is_active == UVM_ACTIVE) begin
            afifo_write_reset_seq seq;
            afifo_write_reset_lift_seq seq_lift;
            repeat (count) begin
                seq = afifo_write_reset_seq::type_id::create("seq");
                seq.set_item_context(this, m_afifo_write_agent.m_sequencer);
                if ( !seq.randomize() )
                    `uvm_error(get_type_name(), "Failed to randomize sequence")
                seq.m_config = m_afifo_write_agent.m_config;
                seq.set_starting_phase( get_starting_phase() );
                seq.start(m_afifo_write_agent.m_sequencer, this);
            end
            // Send one cycle of reset lift-off
            seq_lift = afifo_write_reset_lift_seq::type_id::create("seq_lift");
            seq_lift.set_item_context(this, m_afifo_write_agent.m_sequencer);
            if ( !seq_lift.randomize() )
                `uvm_error(get_type_name(), "Failed to rand reset lift-off seq_lift!")
            seq_lift.m_config = m_afifo_write_agent.m_config;
            seq_lift.set_starting_phase( get_starting_phase() );
            seq_lift.start(m_afifo_write_agent.m_sequencer, this);
        end
        if (m_afifo_read_agent.m_config.is_active == UVM_ACTIVE) begin
            afifo_read_reset_seq seq;
            afifo_read_reset_lift_seq seq_lift;
            repeat (count) begin
                seq = afifo_read_reset_seq::type_id::create("seq");
                seq.set_item_context(this, m_afifo_read_agent.m_sequencer);
                if ( !seq.randomize() )
                    `uvm_error(get_type_name(), "Failed to randomize sequence")
                seq.m_config = m_afifo_read_agent.m_config;
                seq.set_starting_phase( get_starting_phase() );
                seq.start(m_afifo_read_agent.m_sequencer, this);
            end
            // Send one cycle of reset lift-off
            seq_lift = afifo_read_reset_lift_seq::type_id::create("seq_lift");
            seq_lift.set_item_context(this, m_afifo_read_agent.m_sequencer);
            if ( !seq_lift.randomize() )
                `uvm_error(get_type_name(), "Failed to rand reset lift-off seq_lift!")
            seq_lift.m_config = m_afifo_read_agent.m_config;
            seq_lift.set_starting_phase( get_starting_phase() );
            seq_lift.start(m_afifo_read_agent.m_sequencer, this);
        end
    join
    s = $sformatf( "Sending %0d cycles of reset before starting test COMPLETED!", count);
    `uvm_info(get_type_name(), s, UVM_MEDIUM)
endtask: do_reset

task top_default_vseq::write_atomic ();
    afifo_write_default_seq seq;
    `uvm_info(get_type_name(), "Atomic write started", UVM_DEBUG);
    if (m_afifo_write_agent.m_config.is_active != UVM_ACTIVE)
        `uvm_fatal(get_type_name(), "m_afifo_write_agent cannot issue write while config is UVM_PASSIVE")
    seq = afifo_write_default_seq::type_id::create("seq");
    seq.set_item_context(this, m_afifo_write_agent.m_sequencer); // For rand stability
    if ( !seq.randomize() )
        `uvm_error(get_type_name(), "Failed to rand write def seq")
    seq.m_config = m_afifo_write_agent.m_config;
    seq.set_starting_phase( get_starting_phase() ); // To raise objection within this seq
    seq.start(m_afifo_write_agent.m_sequencer, this);
    `uvm_info(get_type_name(), "Atomic write ended  ", UVM_DEBUG);
endtask: write_atomic

task top_default_vseq::read_atomic ();
    afifo_read_default_seq seq;
    `uvm_info(get_type_name(), "Atomic read started", UVM_DEBUG);
    if (m_afifo_read_agent.m_config.is_active != UVM_ACTIVE)
        `uvm_fatal(get_type_name(), "m_afifo_read_agent cannot issue read while config is UVM_PASSIVE")
    seq = afifo_read_default_seq::type_id::create("seq");
    seq.set_item_context(this, m_afifo_read_agent.m_sequencer); // For rand stability
    if ( !seq.randomize() )
        `uvm_error(get_type_name(), "Failed to rand read def seq")
    seq.m_config = m_afifo_read_agent.m_config;
    seq.set_starting_phase( get_starting_phase() ); // To raise objection within this seq
    seq.start(m_afifo_read_agent.m_sequencer, this);
    `uvm_info(get_type_name(), "Atomic read ended  ", UVM_DEBUG);
endtask: read_atomic
//==================================================================

//==================================================================
// vsequence: write_5_read_5 - vitual seq with hardcoded read-write cnt
//==================================================================
class write_5_read_5_seq extends top_default_vseq;
    `uvm_object_utils(write_5_read_5_seq)

    constraint c_m_seq_cnt_0 { m_seq_cnt inside {[5:10]};}
    extern function new(string name="");
    extern virtual task body();
endclass: write_5_read_5_seq

function write_5_read_5_seq::new (string name="");
    super.new(name);
endfunction: new

task write_5_read_5_seq::body();
    this.do_reset(3);
    repeat (m_seq_cnt) begin
        this.write_atomic();
    end
    repeat (m_seq_cnt) begin
        this.read_atomic();
    end

endtask: body
//==================================================================

//==================================================================
// vsequence: write X, read back X+1
//==================================================================
class top_wX_rXp1_vseq extends top_default_vseq;
    `uvm_object_utils(top_wX_rXp1_vseq)

    constraint c_m_seq_cnt_0 { m_seq_cnt inside {[5:10]};}
    extern function new(string name="");
    extern virtual task body();
endclass: top_wX_rXp1_vseq

function top_wX_rXp1_vseq::new (string name = "");
    super.new(name);
endfunction: new

task top_wX_rXp1_vseq::body();
    this.do_reset(3); // Reset for 3 cycles
    repeat (m_seq_cnt)      this.write_atomic();
    repeat (m_seq_cnt + 1)  this.read_atomic();
endtask: body
//==================================================================
// End of inlined include file

`endif // TOP_SEQ_LIB_SV

