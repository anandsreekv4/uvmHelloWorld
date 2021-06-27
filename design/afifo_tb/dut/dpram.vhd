-------------------------------------------------------------------------------
-- Title      : dpram
-- Project    : 
-------------------------------------------------------------------------------
-- File       : dpram.vhd
-- Author     : Anand S/INDIA  <ansn@aremote05>
-- Company    : 
-- Created    : 2021-03-21
-- Last update: 2021-03-22
-- Platform   : 
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: Dual-port RAM for the FIFO. Writes synchronous to write clk.
-- Separate read and write addr inputs. Single wdata input and rdata output.
-- Will store the FIFO data - i.e, NBITS of SQRT input with MSB as "start_i"
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
-- entity: dpram
-------------------------------------------------------------------------------

entity dpram is
  
  generic (
    DWDTH : integer := 8;               -- Data width - NBITS downto 0
    PWDTH : integer := 4);              -- ptr width - 2**PWDTH is the total
                                        -- num of entries for the FIFO
  port (
    clk_i   : in  std_logic;            -- input clk
    waddr_i : in  std_logic_vector(PWDTH-1 downto 0);  -- write channel addr input
    wdata_i : in  std_logic_vector(DWDTH-1 downto 0);  -- write channel data input
    wren_i  : in  std_logic;  -- write channel enable - synched with wclk
    raddr_i : in  std_logic_vector(PWDTH-1 downto 0);  -- read channel addr input
    rdata_o : out std_logic_vector(DWDTH-1 downto 0)); -- read channel data out

end dpram;

-------------------------------------------------------------------------------
-- architecture: rtl
-------------------------------------------------------------------------------

architecture rtl of dpram is
  type mem_t is array (0 to (2**PWDTH)-1) of std_logic_vector(DWDTH-1 downto 0);  -- main mem type
  signal mem : mem_t;                   -- actual memory
begin  -- rtl

  -- purpose: write onto memory on edge of clk_i, indexing with waddr
  -- type   : sequential
  -- inputs : clk_i, we
  -- outputs: mem
  p_memwr: process (clk_i)
  begin  -- process p_memwr
    if clk_i'event and clk_i = '1' then  -- rising clock edge
      if wren_i = '1' then
        mem(to_integer(unsigned(waddr_i))) <= wdata_i;
      end if;
    end if;
  end process p_memwr;

  rdata_o <= mem(to_integer(unsigned(raddr_i)));
  
end rtl;
