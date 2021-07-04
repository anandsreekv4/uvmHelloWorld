dut_top = afifo
project = ../../design/afifo
name    = Anand Sreekumar
email   = anandsreekv4@gmail.com
year    = 2021
copyright = Copyright (c) Anand Sreekumar

dut_source_path = ../../design/afifo/dut

comments_at_include_locations = yes
common_pkg = afifo_pkg.sv
top_default_seq_count = 5

top_seq_inc = top_vseq_lib.sv                                   inline

top_factory_set = top_default_seq write_5_read_5_seq

top_env_append_to_run_phase = test_drain_time.sv                inline

test_inc_after_class = top_wX_rXp1_test.sv                      inline
