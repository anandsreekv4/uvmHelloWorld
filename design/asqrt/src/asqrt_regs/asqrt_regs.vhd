-------------------------------------------------------------------------------
-- Title      : asqrt_regs
-- Project    : 
-------------------------------------------------------------------------------
-- File       : asqrt_regs.vhd
-- Author     : Anand S/INDIA  <ansn@aremote05>
-- Company    : 
-- Created    : 2021-03-20
-- Last update: 2021-03-20
-- Platform   : 
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: register block for asqrt core. Instantiates an apbSlave block
-- and connects to the MMIO registers.
-------------------------------------------------------------------------------
-- Copyright (c) 2021 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2021-03-20  1.0      ansn	Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


-------------------------------------------------------------------------------
-- entity: asqrt_regs
-------------------------------------------------------------------------------
entity asqrt_regs is
  
  generic (
    NBITS : integer := 16);  -- Number of bits used by the sqrt block

  port (
    clk_i  : in std_logic;              -- apb clock
    rstn_i : in std_logic);             -- apb domain reset (active low)

end asqrt_regs;

-------------------------------------------------------------------------------
-- architecture: RTL
-------------------------------------------------------------------------------

architecture rtl of asqrt_regs is

begin  -- rtl

  

end rtl;
