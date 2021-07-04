phase.raise_objection(this, "Raising objection from top_env::run_phase!");
`ifndef UVM_POST_VERSION_1_1
    uvm_test_done.set_drain_time(this, 1000);
`else
    uvm_objection obj = phase.get_objection();
    obj.set_drain_time(this, 1000);
`endif
phase.drop_objection(this, "Dropping objection from top_env::run_phase!");
