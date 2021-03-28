-------------------------------------------------------------------------------
-- Title      : afifo
-- Project    : 
-------------------------------------------------------------------------------
-- File       : afifo.vhd
-- Author     : Anand S/INDIA  <ansn@aremote05>
-- Company    : 
-- Created    : 2021-03-23
-- Last update: 2021-03-25
-- Platform   : 
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: async fifo. Supports transmission of data through two async clk
-- domains. The fifo takes two inputs wren and rden as control, based on which
-- data is written into the dpram inside the fifo. The ptr monitoring is done
-- by two separate blocks in each clk domain.
-------------------------------------------------------------------------------
-- Copyright (c) 2021 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2021-03-23  1.0      ansn    Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

-------------------------------------------------------------------------------
-- entity: afifo
-------------------------------------------------------------------------------

entity afifo is
  
  generic (
    PWDTH : integer := 4;  -- Pointer width. The fifomem is configured to be 2**PWDTH deep
    DWDTH : integer := 8);  -- Data width of the fifo. Transport this many bits per clk cycle

  port (
    wclk_i , rclk_i  : in  std_logic;   -- clks
    wrstn_i, rrstn_i : in  std_logic;  -- resets. All resets are active low and asynch
    winc_i , rinc_i  : in  std_logic;   -- read and write commands to fifo
    wdata_i          : in  std_logic_vector(DWDTH-1 downto 0);  -- Data to be written into
                                       -- fifomem. To be writeen from rd clk domain
    rdata_o          : out std_logic_vector(DWDTH-1 downto 0);  -- To be read
                                        -- from read clk domain 
    fifo_full_o      : out std_logic;   -- fifo full interrupt
    fifo_ovflw_o     : out std_logic;   -- fifo overflow interrupt - indicates
                                       -- a write command issued even after full
    fifo_empty_o     : out std_logic;   -- fifo empty interrupt
    fifo_undrflw_o   : out std_logic);  -- fifo underflow interrupt - indicates
                                       -- a read command issued even after empty
end afifo;

library cdc;
use cdc.cdc_pkg.all;

-------------------------------------------------------------------------------
-- architecture: rtl
-------------------------------------------------------------------------------
architecture rtl of afifo is
  signal waddr, raddr              : std_logic_vector(PWDTH-1 downto 0);  -- addr interconnect wires
  signal wren, fifo_full           : std_logic;  -- coming from wptr_full blk
  signal wptr_gray_sync, wptr_gray : std_logic_vector(PWDTH downto 0);
  signal rptr_gray_sync, rptr_gray : std_logic_vector(PWDTH downto 0);
begin  -- rtl

  i_fifomem : dpram
    generic map (
      DWDTH => DWDTH,
      PWDTH => PWDTH)
    port map (
      clk_i   => wclk_i,
      waddr_i => waddr,
      wdata_i => wdata_i,
      wren_i  => wren,
      raddr_i => raddr,
      rdata_o => rdata_o);

  i_afifo_rptr_empty : afifo_rptr_empty
    generic map (
      PWDTH => PWDTH)
    port map (
      rclk_i           => rclk_i,
      rrstn_i          => rrstn_i,
      rinc_i           => rinc_i,
      raddr_o          => raddr,
      rptr_gray_o      => rptr_gray,
      wptr_gray_sync_i => wptr_gray_sync,
      fifo_empty_o     => fifo_empty_o,
      fifo_undrflw_o   => fifo_undrflw_o);

  i_afifo_wptr_full : afifo_wptr_full
    generic map (
      PWDTH => PWDTH)
    port map (
      wclk_i           => wclk_i,
      wrstn_i          => wrstn_i,
      winc_i           => winc_i,
      waddr_o          => waddr,
      wptr_gray_o      => wptr_gray,
      rptr_gray_sync_i => rptr_gray_sync,
      fifo_full_o      => fifo_full,
      fifo_ovflw_o     => fifo_ovflw_o);

  i_rptr_sync_to_wclk : dbl_sync
    generic map (
      WIDTH => PWDTH+1)
    port map (
      clk_i       => wclk_i,
      rstn_i      => wrstn_i,
      data_i      => rptr_gray,
      data_sync_o => rptr_gray_sync);

  i_wptr_sync_to_rclk : dbl_sync
    generic map (
      WIDTH => PWDTH+1)
    port map (
      clk_i       => rclk_i,
      rstn_i      => rrstn_i,
      data_i      => wptr_gray,
      data_sync_o => wptr_gray_sync);

  wren        <= winc_i and (not fifo_full);
  fifo_full_o <= fifo_full;
  
end rtl;
