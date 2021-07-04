class top_default_with_reset_seq extends top_default_seq;
    extern function new(string name = "");
    extern task do_reset(int count=3);
endclass: top_default_with_reset_seq


function top_default_with_reset_seq::new(string name = "");
    super.new(name);
endfunction: new

task top_default_with_reset_seq::do_reset(int count=3);
    string s;
    s = $sformatf( "Sending %0d cycles of reset before starting test", count);
    `uvm_info(get_type_name(), s, UVM_MEDIUM)
    
    fork
        if (m_afifo_write_agent.m_config.is_active == UVM_ACTIVE) begin
            afifo_write_reset_seq seq;
            afifo_write_reset_lift_seq seq_lift;
            repeat (count) begin
                seq = afifo_write_reset_seq::type_id::create("seq");
                seq.set_item_context(this, m_afifo_write_agent.m_sequencer);
                if ( !seq.randomize() )
                    `uvm_error(get_type_name(), "Failed to randomize sequence")
                seq.m_config = m_afifo_write_agent.m_config;
                seq.set_starting_phase( get_starting_phase() );
                seq.start(m_afifo_write_agent.m_sequencer, this);
            end
            // Send one cycle of reset lift-off
            seq_lift = afifo_write_reset_lift_seq::type_id::create("seq_lift");
            seq_lift.set_item_context(this, m_afifo_write_agent.m_sequencer);
            if ( !seq_lift.randomize() )
                `uvm_error(get_type_name(), "Failed to rand reset lift-off seq_lift!")
            seq_lift.m_config = m_afifo_write_agent.m_config;
            seq_lift.set_starting_phase( get_starting_phase() );
            seq_lift.start(m_afifo_write_agent.m_sequencer, this);
        end
        if (m_afifo_read_agent.m_config.is_active == UVM_ACTIVE) begin
            afifo_read_reset_seq seq;
            afifo_read_reset_lift_seq seq_lift;
            repeat (count) begin
                seq = afifo_read_reset_seq::type_id::create("seq");
                seq.set_item_context(this, m_afifo_read_agent.m_sequencer);
                if ( !seq.randomize() )
                    `uvm_error(get_type_name(), "Failed to randomize sequence")
                seq.m_config = m_afifo_read_agent.m_config;
                seq.set_starting_phase( get_starting_phase() );
                seq.start(m_afifo_read_agent.m_sequencer, this);
            end
            // Send one cycle of reset lift-off
            seq_lift = afifo_read_reset_lift_seq::type_id::create("seq_lift");
            seq_lift.set_item_context(this, m_afifo_read_agent.m_sequencer);
            if ( !seq_lift.randomize() )
                `uvm_error(get_type_name(), "Failed to rand reset lift-off seq_lift!")
            seq_lift.m_config = m_afifo_read_agent.m_config;
            seq_lift.set_starting_phase( get_starting_phase() );
            seq_lift.start(m_afifo_read_agent.m_sequencer, this);
        end
    join
    s = $sformatf( "Sending %0d cycles of reset before starting test COMPLETED!", count);
    `uvm_info(get_type_name(), s, UVM_MEDIUM)
endtask: do_reset

class write_5_read_5_seq extends top_default_with_reset_seq;
    `uvm_object_utils(write_5_read_5_seq)

    extern function new(string name="");
    extern virtual task body();
endclass: write_5_read_5_seq

function write_5_read_5_seq::new (string name="");
    super.new(name);
endfunction: new

task write_5_read_5_seq::body();
    this.do_reset(3);
    repeat (m_seq_count) begin
      if (m_afifo_write_agent.m_config.is_active == UVM_ACTIVE)
      begin
        afifo_write_default_seq seq;
        seq = afifo_write_default_seq::type_id::create("seq");
        seq.set_item_context(this, m_afifo_write_agent.m_sequencer);
        if ( !seq.randomize() )
          `uvm_error(get_type_name(), "Failed to randomize sequence")
        seq.m_config = m_afifo_write_agent.m_config;
        seq.set_starting_phase( get_starting_phase() );
        seq.start(m_afifo_write_agent.m_sequencer, this);
      end
    end
    repeat (m_seq_count) begin
      if (m_afifo_read_agent.m_config.is_active == UVM_ACTIVE)
      begin
        afifo_read_default_seq seq;
        seq = afifo_read_default_seq::type_id::create("seq");
        seq.set_item_context(this, m_afifo_read_agent.m_sequencer);
        if ( !seq.randomize() )
          `uvm_error(get_type_name(), "Failed to randomize sequence")
        seq.m_config = m_afifo_read_agent.m_config;
        seq.set_starting_phase( get_starting_phase() );
        seq.start(m_afifo_read_agent.m_sequencer, this);
      end
    end

endtask: body
