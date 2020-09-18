///////////////////////////////////////////////////////////////////////////////////////////////////
//
//        CLASS: tx_env_config
//  DESCRIPTION: config for env only.
//         BUGS: ---
//       AUTHOR: YOUR NAME (), 
// ORGANIZATION: 
//      VERSION: 1.0
//      CREATED: 05/25/20 15:58:17
//     REVISION: ---
///////////////////////////////////////////////////////////////////////////////////////////////////

class tx_env_config extends uvm_object; // NOTE: configs are not comps as such
   `uvm_object_utils(tx_env_config)     // Registered in factory
    function new(string name="tx_env_config");
      super.new(name);
    endfunction: new

    // Now think of all the things required inside this config obj..
    // Since it is for an env, and env has the scb,checker etc.
    // as well the agt, we can use it to have configurable instantiation
    // of scbs etc. as well as the number of agents to be instantiated.
    // It should also not that there can be separate config objs for 
    // each element.

    rand bit scb_present;
    rand int n_tx_agents;
    rand tx_config tx_cfg;

endclass: tx_env_config
