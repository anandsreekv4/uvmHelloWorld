// Learnings: A package cannot contain a code for an interface.
// It should always be outside the pkg. pkg is mostly for class.
package tx_pkg;
  import uvm_pkg::*;        /* DO NOT DELETE */
  `include "uvm_macros.svh" /* DO NOT DELETE */

  typedef class tx_test;
  typedef class tx_config;
  typedef class tx_env_config;
  typedef class tx_env;
  typedef class tx_agt_config;
  typedef class tx_agent;
  typedef class tx_seq;
  typedef class tx_item;
  typedef class tx_driver;
  typedef class tx_monitor;

  `include "tx_test.svh"
  `include "tx_config.svh"
  `include "tx_env_config.svh"
  `include "tx_env.svh"
  `include "tx_agt_config.svh"
  `include "tx_agent.svh"
  `include "tx_seq.svh"
  `include "tx_item.svh"
  `include "tx_driver.svh"
  `include "tx_monitor.svh"

endpackage: tx_pkg