#!/bin/sh
IUS_HOME=/tools/apps/cadence/INCISIVE15.20.042
irun -vtimescale 1ns/1ps -uvmhome ${IUS_HOME}/tools/methodology/UVM/CDNS-1.2 \
+UVM_TESTNAME=top_test  \
+incdir+../tb/include \
+incdir+../tb/afifo_write/sv \
+incdir+../tb/afifo_read/sv \
+incdir+../tb/top/sv \
+incdir+../tb/top_test/sv \
+incdir+../tb/top_tb/sv \
-F ../dut/files.f \
../tb/afifo_write/sv/afifo_write_pkg.sv \
../tb/afifo_write/sv/afifo_write_if.sv \
../tb/afifo_read/sv/afifo_read_pkg.sv \
../tb/afifo_read/sv/afifo_read_if.sv \
../tb/top/sv/top_pkg.sv \
../tb/top_test/sv/top_test_pkg.sv \
../tb/top_tb/sv/top_th.sv \
../tb/top_tb/sv/top_tb.sv \
$* 
