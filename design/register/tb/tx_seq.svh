/////////////////////////////////////////////////////////////////////////////
//
//        CLASS: tx_test
//  DESCRIPTION: The tx_seq is actually a generator ( one of possibly many)
//               It extends from the uvm_sequence class specialised for tx_item
//               Also contains body method which tells how to randomize
//               i.e, any over-rides (in-line) to be done on the tx can be 
//               done here.
//               Basically, a seq is what determines the usage of a tx item.
//               
//         BUGS: ---
//       AUTHOR: YOUR NAME (), 
// ORGANIZATION: 
//      VERSION: 1.0
//      CREATED: 05/25/20 00:14:17
//     REVISION: ---
// 
//    METHODS: inherent :- start(<path to sqr>), body () with optional sender
//                         start_item, finish_item
/////////////////////////////////////////////////////////////////////////////

class tx_seq #(parameter int DELAY=10 ) extends tx_base_seq #(.DELAY(DELAY));
    `uvm_object_utils(tx_seq#()) // Register

    const int WIDTH;

    // -- methods --
    function new ( string name="tx_seq");
        super.new(name);
    endfunction

    // body method
    virtual task body();
    //1. Create tx_item using factory
    //2. Wait drv to req for the next tx_item via sqr
    //3. Assign the tx with values
    //4. Now send the tx_item to drv and wait for drv to complete it
    // General guideline: Use IF instead of ASSERT because, people can
        // disable all assertions together, and will cause this scenario to be 
        // missed.

        // Will create and send tx_items
        tx_item tx;

        // TEMP RESET
        this.do_reset();

        repeat (10) begin: send_10_times
            tx = tx_item::type_id::create(.name("tx"), .contxt(get_full_name())); // Factory create

            start_item(tx);                     // wait for driver to be ready

            if (! tx.randomize () ) begin       // No over-rides for now
                `uvm_fatal("SEQ","Failed to randomise tx"); 
            end
            finish_item(tx); // Done generating this tx
        end
    endtask: body


endclass: tx_seq
