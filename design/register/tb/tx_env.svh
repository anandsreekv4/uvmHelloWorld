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
    tx_agent  agt; // only has 'n' num. of agents
    tx_fc_cov cov;
    tx_scb    scb;
    int WIDTH;
    /* parameter WIDTH=8; */

    // -- methods --
    virtual function void build_phase(uvm_phase phase);
        agt = tx_agent::type_id::create("agt",this);
        cov = tx_fc_cov::type_id::create("cov", this);
        scb = tx_scb::type_id::create("scb", this);
    endfunction: build_phase

    virtual function void connect_phase(uvm_phase phase);
    // Typically this is where other env comps are added:
    //  Eg: subscribers and scoreboards etc.
    //  Not planning to implement them just yet.
    //  Monitor's analysis port connection needs to be done with them.
        super.connect_phase(phase);
        agt.pass_through_txap.connect(cov.analysis_export);
        agt.pass_through_txap.connect(scb.analysis_imp_mon);
        agt.pass_through_txap.connect(scb.analysis_imp_drv);
    endfunction: connect_phase

endclass: tx_env
