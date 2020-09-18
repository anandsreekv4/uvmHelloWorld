///////////////////////////////////////////////////////////////////////////////////////////////////
//
//        CLASS: tx_monitor
//  DESCRIPTION: Monitors tx to and from DUT. Sends the pin wiggles
//               to scb at agt, by back converting them to tx packets
//         BUGS: ---
//       AUTHOR: YOUR NAME (), 
// ORGANIZATION: 
//      VERSION: 1.0
//      CREATED: 05/25/20 01:46:50
//     REVISION: ---
///////////////////////////////////////////////////////////////////////////////////////////////////
class tx_monitor extends uvm_monitor;
   `uvm_component_utils(tx_monitor) 
   // -- properties --
   virtual reg_if regif_vi;
   /* uvm_analysis_port#(tx_item) itxap; // Why port and no export? */

   // -- methods --
    function new(string name,uvm_component parent);
      super.new(name, parent);
    endfunction: new

    // Building connection of monitor with the interface
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        // void'( 
        //     uvm_resource_db #(virtual reg_if)::read_by_name(
        //         .scope("ifs"), // Would need to add scopes in config_db?
        //         .name ("reg_if"),
        //         .val  (regif_vi)
        //     )
        // );
    endfunction: build_phase

    // We want the monitor to observe the activities 
    // *only* while DUT is out of reset. To mirror this,
    // we add a monitor items conditioning.
    task  run_phase (uvm_phase phase);
        // forever begin
        //     @(posedge regif_vi.reset_n); // wait till reset goes high
        //     fork
        //         monitor_items();         // kicks-off monitoring
        //     join_none

        //     @(negedge regif_vi.reset_n); // wait till reset is asserted
        //     disable fork;                // earlier child-process is killed
        // end
    endtask: run_phase

    virtual task monitor_items();
    // Does nothing for now
    endtask: monitor_items

endclass: tx_monitor
