----------------------------------------------------------------------------------
-- Company: 
-- Engineer: jcds
-- 
-- Create Date: 10/02/2020 06:29:11 PM
-- Design Name: 
-- Module Name: status - behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity status is
port (
    clk   : in std_logic;
    reset : in std_logic;
    
    -- axis bridge
    data_hs : in std_logic;
    sof     : in std_logic;
    eol     : in std_logic;
    
    -- control
    start  : in  std_logic;
    ready  : out std_logic;
    locked : out std_logic;
    width  : out std_logic_vector(11 downto 0);
    height : out std_logic_vector(11 downto 0);
    embed  : out std_logic;
    meta   : out std_logic_vector(31 downto 0)
);
end status;

architecture behavioral of status is
--------------------------------------------------------------------------------
type axis_state is (axis_reset, axis_idle, axis_sof, axis_eol, axis_frame, axis_locked);

signal state      : axis_state := axis_reset;
signal next_state : axis_state := axis_reset;

signal height_ff : unsigned(11 downto 0) := (others => '0');
signal width_ff  : unsigned(11 downto 0) := (others => '0');
signal timer_ff  : unsigned(19 downto 0) := (others => '0');
signal ly_ff     : unsigned(11 downto 0) := (others => '0');

signal sol_ff : std_logic := '0';

signal height_inc : std_logic := '0';
signal width_inc  : std_logic := '0';
signal ly_clr     : std_logic := '0';
signal ly_inc     : std_logic := '0';

signal last : std_logic := '0';
--------------------------------------------------------------------------------
begin
--------------------------------------------------------------------------------
width  <= std_logic_vector(width_ff);
height <= std_logic_vector(height_ff);
embed  <= sol_ff;
meta   <= std_logic_vector(timer_ff & ly_ff);

last <= '1' when ly_ff = (height_ff - 1) else '0';

data_sel : process (state, start, data_hs, sof, eol, last)
begin
    next_state <= state;
    ready      <= '0';
    width_inc  <= '0';
    height_inc <= '0';
    ly_clr     <= '0';
    ly_inc     <= '0';    
    locked     <= '0';

    case (state) is
    when axis_reset  =>                                                                                     next_state <= axis_idle;
    when axis_idle   => ready      <= '1';                                            if (start = '1') then next_state <= axis_sof;    end if;
    when axis_sof    => width_inc  <= sof;                                            if (sof   = '1') then next_state <= axis_eol;    end if;
    when axis_eol    => width_inc  <= data_hs;      height_inc <= eol;                if (eol   = '1') then next_state <= axis_frame;  end if;
    when axis_frame  =>                             height_inc <= eol;                if (sof   = '1') then next_state <= axis_locked; end if;    
    when axis_locked => ly_clr     <= eol and last; ly_inc     <= eol; locked <= '1';
    end case;
end process;

data_fsm : process (clk)
begin
    if (rising_edge(clk)) then
        if (reset = '1') then state <= axis_reset; else state <= next_state; end if;
    end if;
end process;

height_counter : process (clk)
begin
    if (rising_edge(clk)) then
        if    (reset      = '1') then height_ff <= (others => '0');
        elsif (start      = '1') then height_ff <= (others => '0');
        elsif (height_inc = '1') then height_ff <= height_ff + 1;
        end if;
    end if;
end process;

width_counter : process (clk)
begin
    if (rising_edge(clk)) then
        if    (reset     = '1') then width_ff <= (others => '0');
        elsif (start     = '1') then width_ff <= (others => '0');
        elsif (width_inc = '1') then width_ff <= width_ff + 1;
        end if;
    end if;
end process;

timer_counter : process (clk)
begin
    if (rising_edge(clk)) then
        if (reset = '1') then timer_ff <= (others => '0');
        else                  timer_ff <= timer_ff + 1;
        end if;
    end if;
end process;

sol_fsm : process (clk)
begin
    if (rising_edge(clk)) then
        if    (reset   = '1') then sol_ff <= '0';
        elsif (eol     = '1') then sol_ff <= '1';
        elsif (data_hs = '1') then sol_ff <= '0';
        end if;
    end if;
end process;

ly_counter : process (clk)
begin
    if (rising_edge(clk)) then
        if    (reset  = '1') then ly_ff <= (others => '0');
        elsif (ly_clr = '1') then ly_ff <= (others => '0');
        elsif (ly_inc = '1') then ly_ff <= ly_ff + 1;
        end if;
    end if;
end process;
--------------------------------------------------------------------------------
end behavioral;
