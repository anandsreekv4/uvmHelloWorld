package hello_pkg;
  // Basic UVM imports
  `include "uvm_macros.svh"
  import uvm_pkg::*; // Import all base class library from uvm

  // Specific class imports
  typedef class hello_test; // Fwd declaration of hello_test class
  `include "hello_test.svh" // Including class definition file
endpackage: hello_pkg
