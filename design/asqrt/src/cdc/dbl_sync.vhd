-------------------------------------------------------------------------------
-- Title      : dbl_sync
-- Project    : 
-------------------------------------------------------------------------------
-- File       : dbl_sync.vhd
-- Author     : Anand S/INDIA  <ansn@aremote05>
-- Company    : 
-- Created    : 2021-03-21
-- Last update: 2021-03-22
-- Platform   : 
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: basic double synch module to synchronise an input data.
-- Should ONLY be used for GRAY CODED Multi bit data buses. Adjust parameter
-- BITS for desired result. If not GRAY coded, use only for single bit CDC
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
-- entity: dbl_sync
-------------------------------------------------------------------------------

entity dbl_sync is
  
  generic (
    WIDTH : integer := 4);              -- data width

  port (
    clk_i       : in  std_logic;        -- input clk
    rstn_i      : in  std_logic;        -- input rst (active low) - async reset
    data_i      : in  std_logic_vector(WIDTH-1 downto 0);  -- data input - to be synced
    data_sync_o : out std_logic_vector(WIDTH-1 downto 0));  -- data output -after sync
end dbl_sync;

-------------------------------------------------------------------------------
-- architecture: rtl
-------------------------------------------------------------------------------
architecture rtl of dbl_sync is
  
  signal data_sync1, data_sync2 : std_logic_vector(WIDTH-1 downto 0);  -- dbl sync regs
  
  function count_ones (
    vector_i : in std_logic_vector(WIDTH-1 downto 0)
    ) return std_logic_vector is
    variable count : std_logic_vector(WIDTH-1 downto 0) := (others => '0');  -- to count the ones
  begin
    for i in 0 to WIDTH-1 loop
      if vector_i(i) = '1' then
        count := count + 1;
      end if;
    end loop;  -- i
    return count;
  end function;

begin  -- rtl

-- purpose: data_i will be dbl synced here. assumption is data_i is gray coded.
-- type   : sequential
-- inputs : clk_i, rstn_i, data_i
-- outputs: data_sync1, data_sync2
  p_sync : process (clk_i, rstn_i)
  begin  -- process p_sync
    if rstn_i = '0' then                    -- asynchronous reset (active low)
      data_sync1 <= (others => '0');
      data_sync2 <= (others => '0');
    elsif clk_i'event and clk_i = '1' then  -- rising clock edge
      data_sync1 <= data_i;
      data_sync2 <= data_sync1;
    end if;

    assert (count_ones(data_i) <= 1) report "data_i of sync should be one-hot!!" severity error;
  end process p_sync;

  data_sync_o <= data_sync2;

end rtl;
