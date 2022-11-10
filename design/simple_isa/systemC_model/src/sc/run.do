# vim: set ft=tcl
#Copyright 1991-2019 Mentor Graphics Corporation
#
# All Rights Reserved.
#
# THIS WORK CONTAINS TRADE SECRET AND PROPRIETARY INFORMATION
# WHICH IS THE PROPERTY OF MENTOR GRAPHICS CORPORATION
# OR ITS LICENSORS AND IS SUBJECT TO LICENSE TERMS.

# Use this run.do file to run this example.
# Either bring up ModelSim and type the following at the "ModelSim>" prompt:
#     do run.do
# or, to run from a shell, type the following at the shell prompt:
#     vsim -do run.do -c
# (omit the "-c" to see the GUI while running from the shell)

onbreak {resume}

# create library
if [file exists work] {
    vdel -all
}
vlib work

# compile all Verilog source files
vlog -sv ../sv/flist.v -define SC

# compile sc files
sccom -g simple_phase_ctr.cpp
# create simple_cpu.h
scgenmod -bool simple_cpu > simple_cpu.h
sccom -g simple_tb.cpp
sccom -link

# open debugging windows
quietly view *

# start and run simulation
vsim -vopt work.simple_tb -voptargs="+acc" -vv

# Add waves
do wave.do
# add wave -r /simple_tb/u_simple_cpu/*
# add wave -r /simple_tb/u_phase/*

# Run command
run 500000 ns
