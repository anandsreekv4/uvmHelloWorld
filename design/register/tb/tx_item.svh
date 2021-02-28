/////////////////////////////////////////////////////////////////////////
//
//        CLASS: tx_item
//  DESCRIPTION: sequence item which contains a basic
//               data types.
//               - stores stimulus,outputs, and predicted results
//               - recommended practis: create tx_in and tx_out,which
//                 extends from a common tx. Helps to sort better.
//               Must have tx methods:
//               - compare (deep)
//               - copy (deep)
//               - create (and return handle)
//               - clone (create and copy)
//               - convert2string (prettyprint a tx obj)
//               - print (disply tx's props.)
//               - record (stores the tx for further analysis)
//               - pack (the props. into a packed array in bytes/ints etc.)
//         BUGS: ---
//       AUTHOR: ansn 
// ORGANIZATION: IFX
//      VERSION: 1.0
//      CREATED: 05/24/20 22:35:28
//     REVISION: ---
/////////////////////////////////////////////////////////////////////////

class tx_item #(parameter WIDTH = 8) extends uvm_sequence_item;

  // Register this seq class into factory
  `uvm_object_utils(tx_item#())

  // -- Properties -- better to declare them rand  for control
  rand byte unsigned             str_byte[]; // a dynamic array
  rand bit unsigned  [WIDTH-1:0] data;
  rand bit		         enable;     // handshake sig. - no rand.
  bit		                 reset_n;
  string	                 str;
  bit unsigned       [WIDTH-1:0] outa;     // DUT Output - no rand.

  // -- constraints on properties --
  constraint str_c { // len of str should be 4

    // Another thing I tried is to constrain str to have the value,
    // but str should also be a 'rand' property. Since it is not,
    // the randomiser will fail to rand it, which was the actual
    // problem in the first place. So, the best thing here would 
    // be to call get_str once tx packet is properly randomised.
    /* str == get_str(this.str_byte); */
  }
  
  constraint str_byte_len_c {
    str_byte.size() == 4;
  }

  constraint ascii_map_str_byte_c {
    // Restricts between ascii values so no issues in
    // string conversions
    foreach(str_byte[i]) str_byte[i] inside {[65:90]};
  }

  constraint enable_c {
      // enable should always be 1 while randomising (by default)
      enable == 1; 
  }

  // -- Methods --
  // Now define constructor 
  function new (string name="tx_item");
    super.new(name);
  endfunction

  function string get_str(ref byte unsigned str_byte[]);
    string str;
    // Appending to get 4 character strings
    foreach ( str_byte[i] ) begin
      str = { str, string'(str_byte[i]) };
    end

    `uvm_info("GSTR",$sformatf("Has str_byte=%0h, str=%s",str_byte,str),UVM_HIGH)
    return str;
  endfunction : get_str

  function void post_randomize();
      this.str = get_str(this.str_byte);
      `uvm_info (
        "PRAND",
        $sformatf(
        "Randomized tx_item.str field based on str_byte and get_str
         \nstr => %s",
         this.str
        ),
        UVM_HIGH
      )
  endfunction: post_randomize

  // -- do_* methods --
  virtual function void do_copy (input uvm_object rhs); // Follow OOP rules
    tx_item tx_rhs; // actual type
    if (!$cast(tx_rhs,rhs)) 
      `uvm_fatal(get_type_name(),"rhs to tx_rhs dwncast failed") //1.Check

    super.do_copy(rhs); //2. Parent's props copy

    this.data = tx_rhs.data; //3. Copy this guy's fields
    this.enable = tx_rhs.enable;
    this.str_byte = tx_rhs.str_byte;

    //3b. Here you can provide any objects contained within tx.
    //class pld...
    //pld pld_h; is a property of this class...
    //if ( (pld_h != null) && tx_rhs.pld_h!= null)
      //pld_h.do_copy(tx_rhs.pld_h) // Because he himself should have it
  endfunction: do_copy

  virtual function bit do_compare (uvm_object rhs,uvm_comparer comparer);
    tx_item tx_rhs;
    if(!$cast(tx_rhs,rhs)) 
      `uvm_fatal(get_type_name(),"rhs to tx_rhs dwncast failed") //1.Check

      return ( 
      (this.data     === tx_rhs.data)       &&
      (this.enable   === tx_rhs.enable)     &&
      (this.str_byte === tx_rhs.str_byte) ); 
      // Should also add the call to pld_h.do_copy
  endfunction:do_compare

  virtual function string convert2string();
  ///////////////////////////////////////////////////////////////////////
  //     FUNCTION: convert2string
  //      PURPOSE: my own printing format + do_print called by sprint
  //   PARAMETERS: ????
  //      RETURNS: ????
  //  DESCRIPTION: ????
  //     COMMENTS: none
  //     SEE ALSO: n/a
  ///////////////////////////////////////////////////////////////////////
    string s = super.convert2string();

    $sformat(s, "%s\n ----- tx_item values ----- ",s);
    $sformat(s, "%s\n Data     : 0x%0h", s,this.data);
    $sformat(s, "%s\n enable   : 0x%0h", s,this.enable);
    $sformat(s, "%s\n outa     : 0x%0h", s,this.outa);
    $sformat(s, "%s\n str_byte : %0h", s,this.str_byte);
    $sformat(s, "%s\n -------------------------- ",s);
    $sformat(s, "%s\n %s",s,this.sprint(uvm_default_table_printer));
    $sformat(s, "%s\n -------------------------- ",s);
    return s;
    // $sformat(s,
    // "%s\n Payload : %s",
    // ( pld_h ==null ) ? "null": pld_h.do_compare();
    // );
    //
    // Make sure to always call convert2string inside a `uvm_info
  endfunction: convert2string
    
    // For serial protocols, like pcie and spi, could use pack/unpack
    // to convert the serial data into packed arrays, this allows for 
    // them to be recoreded inside some files, which can then be used 
    // by some other file to read and check the validity of the tx.
    // Hence, they are very rarely required, so just having empty 
    // virtual functions is enough for this tx.

    virtual function void do_print(uvm_printer printer);
        super.do_print(printer);
        printer.print_int("reset_n",reset_n,.size(1));
        printer.print_int("enable",enable,.size(1));
        printer.print_int("data",data,.size(WIDTH));
        printer.print_int("outa",outa,.size(WIDTH));
        printer.print_string("str",str);
        /* printer.print_int("str_byte",str_byte,.size(str_byte.size())); */
    endfunction: do_print

    virtual function void do_pack(uvm_packer packer);
      return;
    endfunction: do_pack
    
    virtual function void do_unpack(uvm_packer packer);
      return;
    endfunction: do_unpack
    
    virtual function void do_record(uvm_recorder recorder);
      return;
    endfunction: do_record
   
    ////////////////////////////////////////
    // do_reset - deprecated: use UVM phase
    ////////////////////////////////////////
    virtual task do_reset();
	this.reset_n = 1'b0;
	this.enable  = 1'b0;
	this.data    = 1'b0;
	#50; // TODO: Remove this guy - find better way to add reset
	this.reset_n = 1'b1; // release
    endtask: do_reset

    // Commenting out below - uvm_printer_table requires info either by
    // macros, or by pack and unpack methods. Haven't implemented pack
    // and neither have I done fully committed to `uvm_field_macros_* 
    // So skipping this for now. Use:
    // https://verificationacademy.com/verification-methodology-reference/uvm/docs_1.2/html/files/base/uvm_object-svh.html
    // to find our more (search for 'If your object')
    /* `uvm_object_utils_begin(tx_item#()) */
    /*     `uvm_field_darray_int(str_byte, UVM_DEFAULT) */
    /* `uvm_object_utils_end */

endclass : tx_item
