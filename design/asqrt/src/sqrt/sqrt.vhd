-------------------------------------------------------------------------------
-- Title      : sqrt
-- Project    : asqrt
-------------------------------------------------------------------------------
-- File       : sqrt.vhd
-- Author     : Anand S/INDIA  <ansn@aremote05>
-- Company    : Anand Sreekumar
-- Created    : 2021-03-20
-- Last update: 2021-03-21
-- Platform   : 
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: Basic sqrt block. Provide input number along with "start".
--              Will provide a "valid" in NBITS+2 clock cycles
-------------------------------------------------------------------------------
-- Copyright (c) 2021 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2021-03-20  1.0      ansn    Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;               -- needed for shifts

-------------------------------------------------------------------------------
-- entity: sqrt
-------------------------------------------------------------------------------
entity sqrt is

  generic (
    NBITS     : integer := 8;           -- Number of bits for the input number
    PRECISION : integer := 0);  -- Number of floating point places for which sqrt can be done

  port (
    clk_i    : in  std_logic;           -- FSM clock
    rstn_i   : in  std_logic;           -- FSM async resetn (active low)
    N        : in  std_logic_vector(NBITS-1 downto 0);   -- Input number
    start_i  : in  std_logic;           -- Start indicator for the sqrt
    busy     : out std_logic;           -- Indicates whether sqrt is busy
    valid_o  : out std_logic;           -- Indicates that result is valid
    result_o : out std_logic_vector(NBITS-1 downto 0));  -- Final result
end sqrt;

architecture rtl of sqrt is
  subtype nbits_t is unsigned(NBITS+NBITS-1 downto 0);
  type    fsm_t is (INIT, CALCY, CALC, SEND);
  signal  X             : nbits_t;  -- Init value of "N", will be shifted left
  signal  P             : nbits_t;  -- sigma of all indiv. bits. Updated per cycle
  signal  Y             : nbits_t;  -- Intermediate res after each "calc" cycle
  signal  result_s      : nbits_t;  -- temp result, requires shifting back for result
  signal  calc_done     : std_logic;    -- temp sig for valid_o
  signal  send_done     : std_logic;    -- Let FSM know sending is done
  signal  state, nextst : fsm_t;        -- state machine states
  signal  m             : integer range -2 to NBITS-1;
begin  --   rtl

  -- purpose: Main state machine transition block
  -- type   : sequential
  -- inputs : clk_i, rstn_i, state
  -- outputs: result_o
  p_FSM : process (clk_i, rstn_i)
  begin  -- process p_FSM
    if rstn_i = '0' then                    -- asynchronous reset (active low)
      state <= INIT;
    elsif clk_i'event and clk_i = '1' then  -- rising clock
      state <= nextst;
    end if;
  end process p_FSM;

  -- purpose: Next state combo logic
  -- type   : combinational
  -- inputs : all
  -- outputs: nextst
  FSM_NS_comb : process (state, start_i, calc_done, send_done)
  begin  -- process FSM_NS_comb
    case state is
      when INIT =>
        if start_i = '1' then
          nextst <= CALCY;
        else
          nextst <= INIT;
        end if;
      when CALCY =>
        nextst <= CALC;                 -- delay for obtaining Y properly
      when CALC =>
        if calc_done = '1' then
          nextst <= SEND;
        else
          nextst <= CALCY;              -- go back and calcY if not sending
        end if;
      when SEND =>
        if send_done = '1' then
          nextst <= INIT;
        else
          nextst <= SEND;
        end if;
      when others =>
        nextst <= INIT;
    end case;
  end process FSM_NS_comb;

  -- purpose: output assignment based on curr state
  -- type   : sequential
  -- inputs : clk_i, rstn_i, nextst
  -- outputs: result_s, X, Y, P
  FSM_op : process (clk_i, rstn_i)
  begin  -- process FSM_op
    if rstn_i = '0' then                -- asynchronous reset (active low)
      X         <= (others => '0');
      P         <= (others => '0');
      Y         <= (others => '0');
      result_s  <= (others => '0');
      m         <= 0;
      valid_o   <= '0';
      send_done <= '0';
      calc_done <= '0';
      result_o  <= (others => '0');
      busy      <= '0';
    elsif clk_i'event and clk_i = '1' then          -- rising clock edge
      case nextst is
        when INIT =>
          -- should populate X as precision shifted of N
          X(NBITS-1 downto 0) <= shift_left(unsigned(N), PRECISION);
          P                   <= (others => '0');
          Y                   <= (others => '0');
          result_s            <= (others => '0');
          calc_done           <= '0';
          send_done           <= '0';
          m                   <= NBITS-1;
          valid_o             <= '0';
        when CALCY =>
          busy <= '1';
          report "when m=" & integer'image(m) & ", Y=" & integer'image(to_integer(Y)) & " X=" & integer'image(to_integer(X));
          Y    <= shift_left(P, m+1) + 2 ** (m+m);  --shift_left(unsigned('1'), m+m);
        when CALC =>
          if (m >= 0) and (m < NBITS) then
            if (Y <= X) then            -- Y lt or eq X, res(m) is '1'
              assert (Y /= 0) report "Y <= X not met but still in branch!" severity warning;
              result_s(m) <= '1';       -- update X and P for the next cyc
              X           <= X - Y;
              P           <= P + 2 ** m;            -- P + shift_left('1', m);
            else
              result_s(m) <= '0';       -- nothing else to update
            end if;
            m <= m - 1;
            if (m = 0) then
              calc_done <= '1';         -- calc done when m becomes 0
            end if;
          end if;
        when SEND =>
          result_o  <= std_logic_vector(shift_right(result_s, PRECISION) (result_o'high downto 0));
          valid_o   <= '1';
          send_done <= '1';
          busy      <= '0';
        when others =>                  -- drive everything 'X' !
          result_o  <= (others => 'X');
          valid_o   <= 'X';
          send_done <= 'X';
          busy      <= 'X';
      end case;
    end if;
  end process FSM_op;
end rtl;

-- 
-- Emacs mode setup lines below; DO NOT DELETE!
-- This file uses tabs for indentation. The Emacs mode commands below allow Emacs to play nice with this file
-- Local Variables:
-- Mode: vhdl
-- indent-tabs-mode: nil
-- tab-width: 4
-- End:
