-------------------------------------------------------------------------------
-- Title      : afifo_wptr_full
-- Project    : 
-------------------------------------------------------------------------------
-- File       : afifo_wptr_full.vhd
-- Author     : Anand S/INDIA  <ansn@aremote05>
-- Company    : 
-- Created    : 2021-03-22
-- Last update: 2021-03-22
-- Platform   : 
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: The write ptr and full issuing logic. This block takes an "winc"
-- signal as a cue to incr the wptr(in binary) and access the fifo ram. The wptr
-- is sent out in GRAY format to avoid CDC issues during synchronisation at rclk
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
-- entity: afifo_wptr_full
-------------------------------------------------------------------------------
entity afifo_wptr_full is
  
  generic (
    PWDTH : integer := 4);  -- ptr width. The depth of FIFO will be 2**PWDTH

  port (
    wclk_i           : in  std_logic;  -- clk. This module works on write clk domain
    wrstn_i          : in  std_logic;  -- rstn, async active low reset. This reset is for the write clk domain
    winc_i           : in  std_logic;  -- wptr increment signal. When this is set, curr ptr is read in at fifomem and ptr is incr'ed
    waddr_o          : out std_logic_vector(PWDTH-1 downto 0);  -- write addr issued to fifomem - should be the binary ver of wptr
    wptr_gray_o      : out std_logic_vector(PWDTH downto 0);  -- Note, PWDTH+1 sized bus brought out since MSB+1 and MSB has special checks for fifo full generation
    rptr_gray_sync_i : in  std_logic_vector(PWDTH downto 0);  -- Same width as wptr_gray, but should be synced before coming in
    fifo_full_o      : out std_logic;   -- single bit fifo full indicator
    fifo_ovflw_o     : out std_logic);  -- single bit interrupt to show another winc came after fifo full

end afifo_wptr_full;

-------------------------------------------------------------------------------
-- architecture: rtl
-------------------------------------------------------------------------------
architecture rtl of afifo_wptr_full is
  signal wptr_bin_s  : std_logic_vector(PWDTH downto 0) := (others => '0');  -- binary format of wptr(reg)
  signal wptr_gray_s : std_logic_vector(PWDTH downto 0) := (others => '0');  -- gray format of wptr(reg)
  signal fifo_full_s : std_logic                        := '0';  -- since fifo_full out cannot be read directly

  function conv2gray (
    num : std_logic_vector(PWDTH downto 0))       -- input number in bin
    return std_logic_vector is
    variable vnum : unsigned(PWDTH downto 0) := (others => '0');  -- type conversion
  begin
    vnum := unsigned(num);
    return std_logic_vector((vnum/2) xor vnum);
    -- because shifted ver of binary ORed with the binary produces GRAY
  end function conv2gray;

  function wptr_rptr_gray_full_chk (
    ptr1 : std_logic_vector(PWDTH downto 0);  -- input 1 - should be gray
    ptr2 : std_logic_vector(PWDTH downto 0))  -- input 2 - should be gray
    return boolean is
  begin
    return (
      -- on a wrp around, LSB PWDTH-2 bits would be same
      (ptr1(PWDTH-2 downto 0) = ptr2(PWDTH-2 downto 0)) and
      -- The MSB wouldn't be same (even for grays)
      (ptr1(PWDTH) /= ptr2(PWDTH)) and
      -- But if MSB isn't same AND MSB-1 is also not same, then it's genuine
      -- wrp around
      (ptr1(PWDTH-1) /= ptr2(PWDTH-1))
      );
  end function wptr_rptr_gray_full_chk;
  
begin  -- rtl

  -- purpose: incr wptr_bin on every clk if winc_i is present and not fifo_full
  -- type   : sequential
  -- inputs : wclk_i, wrstn_i, winc_i
  -- outputs: wptr_bin_s
  p_bin_gry_incr : process (wclk_i, wrstn_i)
  begin  -- process p_bin_incr
    if wrstn_i = '0' then               -- asynchronous reset (active low)
      wptr_bin_s  <= (others => '0');
      wptr_gray_s <= (others => '0');
    elsif wclk_i'event and wclk_i = '1' then   -- rising clock edge
      if ((winc_i = '1') and (fifo_full_s = '0')) then
        wptr_bin_s  <= std_logic_vector(unsigned(wptr_bin_s) + 1);  -- binary converted and stored
        wptr_gray_s <= conv2gray(wptr_bin_s);  -- gray converted and stored
      end if;
    end if;
  end process p_bin_gry_incr;

  -- purpose: to generate the fifo_full logic based on comparison of ptrs
  -- type   : sequential
  -- inputs : wclk_i, wrstn_i, wptr_bin_s, rptr_gray_sync_i
  -- outputs: fifo_full_s
  p_fifo_full : process (wclk_i, wrstn_i)
  begin  -- process p_fifo_full
    if wrstn_i = '0' then               -- asynchronous reset (active low)
      fifo_full_s <= '0';
    elsif wclk_i'event and wclk_i = '1' then  -- rising clock edge
      if (wptr_rptr_gray_full_chk(wptr_gray_s, rptr_gray_sync_i)) then
        fifo_full_s <= '1';             --fifo_full checked
      end if;
    end if;
  end process p_fifo_full;

  fifo_full_o <= fifo_full_s;           -- registered fifo_full status sent
                                        -- out

  fifo_ovflw_o <= fifo_full_s and winc_i;  -- overflows when fifo is full and
                                           -- still read comes in

  waddr_o <= wptr_bin_s(PWDTH-1 downto 0);  -- access the memory location
                                            -- from the binary ptr


end rtl;
