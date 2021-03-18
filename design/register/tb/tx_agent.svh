/////////////////////////////////////////////////////////////////////////////
// Class: tx_agent
// Purpose: To instantiate other components for "tx" interface 
//          One agent per protocol.
// Author: ansn
// Date: 20 May 20
/////////////////////////////////////////////////////////////////////////////

class tx_agent extends uvm_agent; // Notice no specialisation
  `uvm_component_utils(tx_agent)
  function new (string name, uvm_component parent);
    // Construct this class
    super.new(name,parent);
  endfunction

  // -- properties --
  tx_driver drv; // "has-a" relationship with driver, monitor, sequencer
  tx_monitor mon; // Will use it once we have a DUT.
  uvm_sequencer #(tx_item) sqr; // sqr is never extended
  uvm_analysis_port #(tx_item) pass_through_txap; // Instantiating the analysis port!

  // -- methods --

  // Usually we can instantiate a scoreboard, checker etc.
  // along with the other components inside the agent.
  // But since we don't have the monitor yet, no need.
  // Also since building is a null time process, the build_phase
  // is actually a function.
  virtual function void build_phase ( uvm_phase phase);
  // Here we create all the sqr, drv and mon
    sqr = new(.name("sqr"),.parent(this)); // As is the folklore, no factory for sqr
    drv = tx_driver::type_id::create("drv",this);
    mon = tx_monitor::type_id::create("mon",this);
    pass_through_txap = new(.name("pass_through_txap"), .parent(this)); // no need for factory ovrd
  endfunction : build_phase


  // Another major requirement is to connect the drv and sqr 
  // together. So basically, agent, like env needs to build things,
  // but also, needs to connect together the things he built.
  // Why doesn't env have to do it ? because, env has only one 
  // comp, the agt, and each agt ( if multipile ) are independant 
  // of each other.
  virtual function void connect_phase( uvm_phase phase);
    super.connect_phase(phase);
    drv.seq_item_port.connect(sqr.seq_item_export);
    mon.itx_ap.connect(pass_through_txap);
  endfunction: connect_phase

endclass:tx_agent
