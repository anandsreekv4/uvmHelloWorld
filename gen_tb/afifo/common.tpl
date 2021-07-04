dut_top = afifo
project = ../../design/afifo
name    = Anand Sreekumar
email   = anandsreekv4@gmail.com
year    = 2021
copyright = Copyright (c) Anand Sreekumar

comments_at_include_locations = yes
common_pkg = afifo_pkg.sv
top_default_seq_count = 5

top_seq_inc = top_default_with_reset_seq.sv

top_factory_set = top_default_seq write_5_read_5_seq

test_prepend_to_build_phase = test_drain_time.sv
