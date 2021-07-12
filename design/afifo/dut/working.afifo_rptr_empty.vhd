-------------------------------------------------------------------------------
-- Title      : afifo_rptr_empty
-- Project    : 
-------------------------------------------------------------------------------
-- File       : afifo_rptr_empty.vhd
-- Author     : Anand S/INDIA  <ansn@aremote05>
-- Company    : 
-- Created    : 2021-03-22
-- Last update: 2021-03-28
-- Platform   : 
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: The read ptr and epty issuing logic. This block takes an "rinc"
-- signal as a cue to incr the rptr(in binary) and access the fifo ram. The rptr
-- is sent out in GRAY format to avoid CDC issues during synchronisation at wclk
-------------------------------------------------------------------------------
-- Copyright (c) 2021 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2021-03-22  1.0      ansn    Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-------------------------------------------------------------------------------
-- entity: afifo_rptr_empty
-------------------------------------------------------------------------------

entity afifo_rptr_empty is
  
  generic (
    PWDTH : integer := 4);  -- ptr width. The depth of FIFO will be 2**PWDTH

  port (
    rclk_i           : in  std_logic;  -- clk. This module works on read clk domain
    rrstn_i          : in  std_logic;  -- read clk domain's async active low reset
    rinc_i           : in  std_logic;  -- read increment signal. Will trigger an access to fifo ram and incr the ptr
    raddr_o          : out std_logic_vector(PWDTH-1 downto 0);  -- read addr issued to fifomem - should be the binary ver of rptr
    rptr_gray_o      : out std_logic_vector(PWDTH downto 0);  -- PWDTH+1 bus where MSB and MSB-1 is used at the wclk domain to get fifo full logic
    wptr_gray_sync_i : in  std_logic_vector(PWDTH downto 0);  -- wclk domain's wptr. Will be used here to generate the "empty" logic.
    fifo_empty_o     : out std_logic;   -- single bit fifo empty indicator
    fifo_undrflw_o   : out std_logic);  -- Interrupt when a read happens after a fifo empty signal is asserted

end afifo_rptr_empty;

-------------------------------------------------------------------------------
-- architecture: rtl
-------------------------------------------------------------------------------

architecture rtl of afifo_rptr_empty is
  signal rptr_bin_s, rptr_bin_next_s        : unsigned(PWDTH downto 0);  -- binary format of wptr(reg)
  signal rptr_gray_s,rptr_gray_next_s       : unsigned(PWDTH downto 0);  -- gray format of wptr(reg)
  signal fifo_empty_s, fifo_empty_next_s    : std_logic;  -- since fifo_empty out cannot be read directly
  signal wptr_gray_sync_s                   : unsigned(PWDTH downto 0);

  function conv2gray (
    num : unsigned(PWDTH downto 0))  -- input number in bin
    return unsigned is
  begin
    return (num/2 xor num);
    -- because shifted ver of binary ORed with the binary produces GRAY
  end function conv2gray;

begin  -- rtl

  p_bin_gry_incr : process (rclk_i, rrstn_i)
  begin  -- process p_bin_gry_incr
    if rrstn_i = '0' then               -- asynchronous reset (active low)
      rptr_bin_s  <= (others => '0');
      rptr_gray_s <= (others => '0');
    elsif rclk_i'event and rclk_i = '1' then   -- rising clock edge
      rptr_bin_s  <= rptr_bin_next_s;  -- binary converted and stored
      rptr_gray_s <= rptr_gray_next_s; -- converted and stored
    end if;
  end process p_bin_gry_incr;

  p_rptr_bin_next: process (rptr_bin_s, rinc_i, fifo_empty_s)
  begin
    if (rinc_i = '1' and fifo_empty_s = '0') then
      rptr_bin_next_s <= to_unsigned(to_integer(rptr_bin_s) + 1, PWDTH+1);
    else
      rptr_bin_next_s <= rptr_bin_s;
    end if;
  end process p_rptr_bin_next;

  rptr_gray_next_s<= conv2gray(rptr_bin_next_s);

  p_fifo_empty : process (rclk_i, rrstn_i)
  begin  -- process p_fifo_empty
    if rrstn_i = '0' then               -- asynchronous reset (active low)
      fifo_empty_s <= '1';              -- empty should be HIONRST
    elsif rclk_i'event and rclk_i = '1' then  -- rising clock edge
      fifo_empty_s <= fifo_empty_next_s;
    end if;
  end process p_fifo_empty;

  -----------------------------------------------------------------------
  -- Empty generation - when the 'next' rd ptr and synced wr ptr are same
  -----------------------------------------------------------------------
  fifo_empty_next_s  <= '1' when rptr_gray_next_s = unsigned(wptr_gray_sync_i)
                            else '0';


  fifo_empty_o   <= fifo_empty_s;
  fifo_undrflw_o <= fifo_empty_s and rinc_i;  -- overflows when accessed while empty

  -- Memory read-address pointer. Only MSB-1 bits addressable in memory
  raddr_o        <= std_logic_vector(rptr_bin_s(PWDTH-1 downto 0));  
  rptr_gray_o    <= std_logic_vector(rptr_gray_s);

end rtl;
