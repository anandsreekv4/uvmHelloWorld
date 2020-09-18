///////////////////////////////////////////////////////////////////////////////////////////////////
//
//        CLASS: tx_agt_config
//  DESCRIPTION: agent configurations
//         BUGS: ---
//       AUTHOR: YOUR NAME (), 
// ORGANIZATION: 
//      VERSION: 1.0
//      CREATED: 09/12/20 23:55:08
//     REVISION: ---
///////////////////////////////////////////////////////////////////////////////////////////////////
class tx_agt_config extends uvm_object;
    `uvm_object_utils(tx_agt_config)

    ///////////////////////////////////////////////////////////////////////////////////////////////////
    //  Constructor: new
    function new(string name="tx_agt_config");
	super.new(name);
    endfunction

    ///////////////////////////////////////////////////////////////////////////////////////////////////
    //         TASK: convert2string
    //      PURPOSE: <CURSOR>
    //   PARAMETERS: ????
    //      RETURNS: ????
    //  DESCRIPTION: ????
    //     COMMENTS: none
    //     SEE ALSO: n/a
    virtual function string convert2string();
	string s;
	$sformat(s, "I'm a tx_agt_config");
	return s;
    endfunction: convert2string

endclass : tx_agt_config
