///////////////////////////////////////////////////////////////////////////////////////////////////
//
//        CLASS: tx_env
//  DESCRIPTION: extends uvm_env
//         BUGS: ---
//       AUTHOR: YOUR NAME (), 
// ORGANIZATION: 
//      VERSION: 1.0
//      CREATED: 05/24/20 23:24:10
//     REVISION: ---
///////////////////////////////////////////////////////////////////////////////////////////////////

class tx_env extends uvm_env;
   `uvm_component_utils(tx_env) 
    function new(string name,uvm_component parent);
      super.new(name, parent);
    endfunction: new

    // -- properties --
    tx_agent agt; // only has 'n' num. of agents

    // -- methods --
    virtual function void build_phase(uvm_phase phase);
      agt = tx_agent::type_id::create("agt",this);
    endfunction: build_phase

    virtual function void connect_phase(uvm_phase phase);
    // Typically this is where other env comps are added:
    //  Eg: subscribers and scoreboards etc.
    //  Not planning to implement them just yet.
    //  Monitor's analysis port connection needs to be done with them.
        super.connect_phase(phase);
    endfunction: connect_phase

endclass: tx_env
