///////////////////////////////////////////////////////////////////////////////////////////////////
//
//        CLASS: tx_test
//  DESCRIPTION: Handles the different envs, also ensures seq is generated 
//               here. Also has a run_phase, quite different from env in 
//               that sense.
//         BUGS: ---
//       AUTHOR: YOUR NAME (), 
// ORGANIZATION: 
//      VERSION: 1.0
//      CREATED: 05/25/20 00:14:17
//     REVISION: ---
///////////////////////////////////////////////////////////////////////////////////////////////////

class tx_test extends uvm_test;
   `uvm_component_utils(tx_test) 
    function new(string name, uvm_component parent);
        super.new( name,  parent);
    endfunction: new

  // -- properties ---
    tx_env env;

  // -- methods --
    virtual function void build_phase(uvm_phase phase);
    /////////////////////////////////////////////////////////////////////
    //     FUNCTION: build_phase
    //      PURPOSE: Assign interface here, create env
    //   PARAMETERS: ????
    //      RETURNS: ????
    //  DESCRIPTION: ????
    //     COMMENTS: none
    //     SEE ALSO: n/a
    /////////////////////////////////////////////////////////////////////
        env = tx_env::type_id::create("env",this);
        // if ( ! uvm_config_db #(virtual reg_if)::get(
        //         .cntxt     (this),
        //         .inst_name (""),
        //         .field_name("reg_if"),
        //         .value     (env.agt.drv.regif_vi)
        //     )
        // ) begin
        //     `uvm_fatal(get_type_name(), "Didn't get handle to reg_if")
        // end
    endfunction: build_phase

    virtual task run_phase(uvm_phase phase);
    /*---------------------------------------------------------
    Here I will be sending my seq which utilises the seq item
    and send it to the seqr.
    So, first thing is the creation of a seq handle and object.
    ---------------------------------------------------------*/
      tx_seq#() seq;
      seq = tx_seq::type_id::create("seq",this);

      // The connect phase will take care of building the sqr,
      // but we need to make sure we provide the seq the right
      // direction towards the sqr.
      // Also, the run phase should only complete if all the 
      // transactions are completed, meaning, the task of the 
      // seq to provide the pattern with which to emit the 
      // stimulus should be done to exit properly. i.e, we need
      // to raise "objections" :
      phase.raise_objection(this, "Dhee thodangi!");
      seq.start(env.agt.sqr); // shows seq the hierarchy of sqr
      phase.phase_done.set_drain_time(this, 20ns); // Drain time required for scb comparison to finish
      phase.drop_objection(this, "Dha theernu !!");

    endtask: run_phase
    
    virtual function void start_of_simulation_phase (uvm_phase phase);
      uvm_top.print_topology();
    endfunction : start_of_simulation_phase


endclass: tx_test
