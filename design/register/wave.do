onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /top/clk
add wave -noupdate /top/ireg_if/clk
add wave -noupdate /top/ireg_if/outa
add wave -noupdate /top/ireg_if/data
add wave -noupdate /top/ireg_if/enable
add wave -noupdate /top/ireg_if/reset_n
add wave -noupdate /top/ireg/clk
add wave -noupdate /top/ireg/reset_n
add wave -noupdate /top/ireg/enable
add wave -noupdate /top/ireg/data
add wave -noupdate /top/ireg/outa
add wave -noupdate -height 32 /uvm_root/uvm_test_top/env/agt/sqr/seq
add wave -noupdate -expand @tx_item__1@1
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {85 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 499
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {110 ns}
