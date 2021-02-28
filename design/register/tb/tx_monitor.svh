////////////////////////////////////////////////////////////////////////////////////
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
////////////////////////////////////////////////////////////////////////////////////
class tx_monitor extends uvm_monitor;
   `uvm_component_utils(tx_monitor) 
   // -- properties --
   uvm_analysis_port#(tx_item) itx_ap; // Why port and no export?
   virtual reg_if regif_vi;

   // -- methods --
    function new(string name,uvm_component parent);
      super.new(name, parent);
    endfunction: new

    // Building connection of monitor with the interface
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        // Get virtual interface handle from config DB
        if (! uvm_config_db 
            #(virtual reg_if) // declare type here
            :: get (
                .cntxt(this),
                .inst_name("*"),
                .field_name("reg_if"),
                .value(regif_vi)
            )) begin: get_vif
            `uvm_fatal (get_type_name(), "DUT interface not found !!!")
        end

        // Create the analysis port - does not reg. via factory(?!)
        itx_ap = new("itx_ap", this);
    endfunction: build_phase

    // We want the monitor to observe the activities 
    // *only* while DUT is out of reset. To mirror this,
    // we add a monitor items conditioning.
    task  run_phase (uvm_phase phase);
        // create a new tx item
        tx_item tx = tx_item#()::type_id::create(.name("tx"), .contxt(get_full_name()));

        forever begin
            @(posedge regif_vi.reset_n); // wait till reset goes high
            fork
                monitor_items(tx);         // kicks-off monitoring
            join_none

            @(negedge regif_vi.reset_n); // wait till reset is asserted
            disable fork;                // earlier child-process is killed
        end
    endtask: run_phase

    virtual task monitor_items(tx_item tx);
        string s;

        forever begin: mon_items
            // Check at every clock posedge
            @regif_vi.tx_master_cb;

            // Calls the "tap" function of the interface
            regif_vi.tap(tx);

            s = "";
            s = $sformatf(s, "\nTAPPED values from Monitor:-");
            s = $sformatf(s, tx.convert2string());

            // Print out got values
            `uvm_info(get_type_name(),s, UVM_MEDIUM)

            // Finally, write to analysis port
            itx_ap.write(tx);
        end: mon_items
    endtask: monitor_items

endclass: tx_monitor
