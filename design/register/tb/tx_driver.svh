/* tx_driver: 
 * Need to specialise this class for tx_item 
 * because it is specifically designed to drive
 * only a single type of item 
 */

 
class tx_driver extends uvm_driver #(tx_item);
  `uvm_component_utils(tx_driver)

  // -- properties --
  virtual reg_if regif_vi;

  // -- methods --
  function new (string name,uvm_component parent);
    super.new(name,parent);
  endfunction

  function void build_phase (uvm_phase phase);
    super.build_phase(phase);
    if (!  uvm_config_db 
        #(virtual reg_if)
        ::get(
            .cntxt      ( this     ) ,
            .inst_name  ( "*"      ) ,
            .field_name ( "reg_if" ) ,
            .value      ( regif_vi )
        )) begin: get_vif
        `uvm_fatal (get_type_name(), "Didn't get handle to reg_if");
    end
  endfunction: build_phase

  // run-phase : need to fetch a few items from sqr
  virtual task run_phase (uvm_phase phase);
  ///////////////////////////////////////////////////////////////////////
  //     FUNCTION: run_phase
  //      PURPOSE: need to fetch a few items from sqr
  //   PARAMETERS: phase
  //      RETURNS: n/a
  //  DESCRIPTION: ????
  //     COMMENTS: none
  //     SEE ALSO: n/a
  ///////////////////////////////////////////////////////////////////////

    tx_item tx;

    forever begin                      // Send the packet
      seq_item_port.get_next_item(tx); // Now tx holds an obj
      show_item(tx);                   // Goes to show_item task
      regif_vi.transfer(tx);
      seq_item_port.item_done();       // Reply back to sqr port
    end

  endtask: run_phase


  task show_item (tx_item tx);
    // At the driver phase the packet is already randomised.
    // We just need to make sure all the properties of tx pkt
    // has values. For this, the below code is most appropriately
    // put at the sequence level, where it actually gets randomised.
    /* tx.str = tx.get_str(tx.str_byte); */ //--> OR DEFINE POST_RAND!
    string s;
    `uvm_info("DRV_SHW_ITM",
      $sformatf(
      "Got the following things:\n
        reset_n  = 0x%0h \n
        enable   = 0x%0h \n
        data     = 0x%0h \n
        str_byte = %0d \n
        str      = %s \n",
        tx.reset_n,
        tx.enable,
        tx.data,
        tx.str_byte,
        tx.str
      ),
      UVM_DEBUG
    )

    `uvm_info (
        get_type_name(),
        tx.convert2string(),
        UVM_MEDIUM
    )

  endtask: show_item

  virtual task pre_reset_phase (uvm_phase phase);
    phase.raise_objection(this, "[pre_reset] Raising objection !");

    regif_vi.reset_n = 1'b1;    // De-assert reset initially

    phase.drop_objection(this, "[pre_reset] Dropping objection");
  endtask: pre_reset_phase

  virtual task reset_phase(uvm_phase phase);
    phase.raise_objection(this,"[reset_phase] Raising objection");

    regif_vi.reset_n = 1'b0;    // asserting reset 
    repeat (2) @(regif_vi.tx_master_cb);
    regif_vi.reset_n = 1'b1;    // de-asserting reset 

    phase.drop_objection(this,"[reset_phase] Dropping objection");
  endtask: reset_phase


endclass: tx_driver
