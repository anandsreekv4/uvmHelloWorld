-------------------------------------------------------------------------------
-- Title      : cdc_pkg
-- Project    : 
-------------------------------------------------------------------------------
-- File       : cdc_pkg.vhd
-- Author     : Anand S/INDIA  <ansn@aremote05>
-- Company    : 
-- Created    : 2021-03-21
-- Last update: 2021-03-22
-- Platform   : 
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: main package for the cdc set of RTL. Will contain all the basic
-- entities required to implement CDC generically.
-------------------------------------------------------------------------------
-- Copyright (c) 2021 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2021-03-21  1.0      ansn    Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-------------------------------------------------------------------------------
-- package: cdc_pkg
-------------------------------------------------------------------------------
package cdc_pkg is
  component dbl_sync
    generic (
      WIDTH : integer);
    port (
      clk_i       : in  std_logic;
      rstn_i      : in  std_logic;
      data_i      : in  std_logic_vector(WIDTH-1 downto 0);
      data_sync_o : out std_logic_vector(WIDTH-1 downto 0));
  end component;
  
  component dpram
    generic (
      DWDTH : integer;
      PWDTH : integer);
    port (
      clk_i   : in  std_logic;
      waddr_i : in  std_logic_vector(PWDTH-1 downto 0);
      wdata_i : in  std_logic_vector(DWDTH-1 downto 0);
      wren_i  : in  std_logic;
      raddr_i : in  std_logic_vector(PWDTH-1 downto 0);
      rdata_o : out std_logic_vector(DWDTH-1 downto 0));
  end component;
  
  component afifo_wptr_full
    generic (
      PWDTH : integer);
    port (
      wclk_i           : in  std_logic;
      wrstn_i          : in  std_logic;
      winc_i           : in  std_logic;
      waddr_o          : out std_logic_vector(PWDTH-1 downto 0);
      wptr_gray_o      : out std_logic_vector(PWDTH downto 0);
      rptr_gray_sync_i : in  std_logic_vector(PWDTH downto 0);
      fifo_full_o      : out std_logic;
      fifo_ovflw_o     : out std_logic);
  end component;
  
end cdc_pkg;

