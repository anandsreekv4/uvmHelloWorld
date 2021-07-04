class afifo_write_reset_seq extends afifo_write_default_seq;
    `uvm_object_utils(afifo_write_reset_seq)

    extern function new(string name="");
    extern task body();
endclass: afifo_write_reset_seq

function afifo_write_reset_seq::new (string name="");
    super.new(name);
endfunction: new

task afifo_write_reset_seq::body();
    `uvm_info(get_type_name(), "Reset sequence starting", UVM_MEDIUM)

    req = wr_transaction::type_id::create("req");
    start_item(req);
    req.wrstn = 0; // Just send an empty default trn
    req.winc  = 0; // Just send an empty default trn
    finish_item(req);
    `uvm_info(get_type_name(), "Reset sequence done", UVM_MEDIUM)
endtask: body

class afifo_write_reset_lift_seq extends afifo_write_default_seq;
    `uvm_object_utils(afifo_write_reset_lift_seq)

    extern function new (string name="");
    extern task body();
endclass: afifo_write_reset_lift_seq

function afifo_write_reset_lift_seq::new (string name="");
    super.new(name);
endfunction: new

task afifo_write_reset_lift_seq::body();
    `uvm_info(get_type_name(), "Reset lift-off starting", UVM_MEDIUM)

    req = wr_transaction::type_id::create("req");
    start_item(req);
    req.wrstn = 1;
    req.winc  = 0; // For lift-off, don't try to write immediately
    finish_item(req);

    `uvm_info(get_type_name(), "Reset lift-off done!", UVM_MEDIUM)
endtask: body
