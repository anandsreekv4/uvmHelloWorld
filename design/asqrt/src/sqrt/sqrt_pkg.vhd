-------------------------------------------------------------------------------
-- Title      : sqrt_pkg
-- Project    : 
-------------------------------------------------------------------------------
-- File       : sqrt_pkg.vhd
-- Author     : Anand S/INDIA  <ansn@aremote05>
-- Company    : 
-- Created    : 2021-03-21
-- Last update: 2021-03-21
-- Platform   : 
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: pakcage for sqrt comps. sqrt design will be compiled in this
-- dir, along with the packages.
-------------------------------------------------------------------------------
-- Copyright (c) 2021 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2021-03-21  1.0      ansn	Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package sqrt_pkg is

  component sqrt
    generic (
      NBITS     : integer;
      PRECISION : integer);
    port (
      clk_i    : in  std_logic;
      rstn_i   : in  std_logic;
      N        : in  std_logic_vector(NBITS-1 downto 0);
      start_i  : in  std_logic;
      busy     : out std_logic;
      valid_o  : out std_logic;
      result_o : out std_logic_vector(NBITS-1 downto 0));
  end component;

end sqrt_pkg;
