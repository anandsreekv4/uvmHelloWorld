class hello_test extends uvm_test;
  `uvm_component_utils(hello_test)

// Methods
  function new (string name,uvm_component parent);
    // Constructs hello_test class
    super.new(name,parent);
  endfunction 

  function void print_hw ();
    // Prints the hello world program
    `uvm_info("HW", "HELLO WORLD !", UVM_NONE)
  endfunction : print_hw

  virtual task run_phase (uvm_phase phase);
    this.print_hw();
  endtask : run_phase
  
  virtual function void start_of_simulation_phase (uvm_phase phase);
    uvm_top.print_topology();
  endfunction : start_of_simulation_phase

endclass: hello_test
