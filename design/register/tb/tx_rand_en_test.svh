///////////////////////////////////////////////////////////////////////////////////////////////////
//
//        CLASS: tx_rand_en_test
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

class tx_rand_en_test extends tx_test;
    `uvm_component_utils(tx_rand_en_test)

    function new(string name, uvm_component parent);
        super.new( name,  parent);
    endfunction: new

    extern virtual task run_phase(uvm_phase phase);
endclass: tx_rand_en_test

task tx_rand_en_test::run_phase(uvm_phase phase);
    tx_rand_en_seq#() seq;
    seq = tx_rand_en_seq#()::type_id::create("seq", this);

    phase.raise_objection(this, "Dhee thodangi!");
    seq.start(env.agt.sqr); // shows seq the hierarchy of sqr
    phase.drop_objection(this, "Dha theernu !!");
endtask: run_phase
