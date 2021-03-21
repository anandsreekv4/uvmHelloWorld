-------------------------------------------------------------------------------
-- Title      : ptr_dbl_sync
-- Project    : 
-------------------------------------------------------------------------------
-- File       : ptr_dbl_sync.vhd
-- Author     : Anand S/INDIA  <ansn@aremote05>
-- Company    : 
-- Created    : 2021-03-21
-- Last update: 2021-03-21
-- Platform   : 
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: basic double synch module to synchronise an input pointer.
-- Should ONLY be used for GRAY CODED Multi bit data buses. Adjust parameter
-- BITS for desired result.
-------------------------------------------------------------------------------
-- Copyright (c) 2021 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2021-03-21  1.0      ansn    Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

-------------------------------------------------------------------------------
-- entity: ptr_dbl_sync
-------------------------------------------------------------------------------

entity ptr_dbl_sync is
  
  generic (
    PWDTH : integer := 4);              -- ptr width

  port (
    clk_i      : in  std_logic;         -- input clk
    rstn_i     : in  std_logic;         -- input rst (active low) - async reset
    ptr_i      : in  std_logic_vector(PWDTH-1 downto 0);  -- ptr input - to be synced
    ptr_sync_o : out std_logic_vector(PWDTH-1 downto 0));  -- ptr output -after sync
end ptr_dbl_sync;

-------------------------------------------------------------------------------
-- architecture: rtl
-------------------------------------------------------------------------------
architecture rtl of ptr_dbl_sync is
  
  signal ptr_sync1, ptr_sync2 : std_logic_vector(PWDTH-1 downto 0);  -- dbl sync regs
  
  function count_ones (
    vector_i : in std_logic_vector(PWDTH-1 downto 0)
    ) return std_logic_vector is
    variable count : std_logic_vector(PWDTH-1 downto 0) := (others => '0');  -- to count the ones
  begin
    for i in 0 to PWDTH-1 loop
      if vector_i(i) = '1' then
        count := count + 1;
      end if;
    end loop;  -- i
    return count;
  end function;

begin  -- rtl

-- purpose: ptr_i will be dbl synced here. assumption is ptr_i is gray coded.
-- type   : sequential
-- inputs : clk_i, rstn_i, ptr_i
-- outputs: ptr_sync1, ptr_sync2
  p_sync : process (clk_i, rstn_i)
  begin  -- process p_sync
    if rstn_i = '0' then                    -- asynchronous reset (active low)
      ptr_sync1 <= (others => '0');
      ptr_sync2 <= (others => '0');
    elsif clk_i'event and clk_i = '1' then  -- rising clock edge
      ptr_sync1 <= ptr_i;
      ptr_sync2 <= ptr_sync1;
    end if;

    assert (count_ones(ptr_i) <= 1) report "ptr_i of sync should be one-hot!!" severity error;
  end process p_sync;

  ptr_sync_o <= ptr_sync2;

end rtl;
