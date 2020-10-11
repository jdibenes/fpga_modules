----------------------------------------------------------------------------------
-- Company: 
-- Engineer: jcds
-- 
-- Create Date: 09/27/2020 09:43:58 PM
-- Design Name: 
-- Module Name: axis_slave - behavioral
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
-- tb pass OK
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

entity axis_slave is
port (
    clk   : in std_logic;
    reset : in std_logic;
    
    -- stream
    tdata  : in  std_logic_vector(31 downto 0);
    tdest  : in  std_logic;
    tid    : in  std_logic;
    tkeep  : in  std_logic_vector( 3 downto 0);
    tlast  : in  std_logic;
    tstrb  : in  std_logic_vector( 3 downto 0);
    tuser  : in  std_logic;
    tvalid : in  std_logic;
    tready : out std_logic;
    
    -- FIFO write
    wren : out std_logic;
    din  : out std_logic_vector(31 downto 0);
    
    -- control
    start : in std_logic;
    count : in std_logic_vector(15 downto 0);
    
    -- axis state
    idle : out std_logic
);
end axis_slave;

architecture behavioral of axis_slave is
--------------------------------------------------------------------------------
type axis_state is (axis_reset, axis_idle, axis_first, axis_push);

signal state      : axis_state := axis_reset;
signal next_state : axis_state := axis_reset;

signal count_ff : unsigned(15 downto 0) := (others => '0');

signal zerocount : std_logic := '0';
signal eol       : std_logic := '0';
signal decrement : std_logic := '0';
signal last      : std_logic := '0';
--------------------------------------------------------------------------------
begin
--------------------------------------------------------------------------------
-- stream
tready <= '1';

-- FIFO write
din <= tdata;

zerocount <= '1' when count_ff = 0 else '0';
eol       <= tvalid and tlast;
last      <= zerocount and eol;

axis_sel: process (state, start, eol, tvalid, last)
begin
    next_state <= state;
    idle       <= '0';
    wren       <= '0';
    decrement  <= '0';
    
    case (state) is
    when axis_reset =>                                                         next_state <= axis_idle;
    when axis_idle  => idle <= '1';                      if (start = '1') then next_state <= axis_first; end if;
    when axis_first =>                                   if (eol   = '1') then next_state <= axis_push;  end if;
    when axis_push  => wren <= tvalid; decrement <= eol; if (last  = '1') then next_state <= axis_idle;  end if;
    end case;
end process;

axis_fsm : process (clk)
begin
    if (rising_edge(clk)) then
        if (reset = '1') then state <= axis_reset; else state <= next_state; end if;
    end if;
end process;

count_fsm : process (clk)
begin
    if (rising_edge(clk)) then
        if    (reset     = '1') then count_ff <= (others => '0');
        elsif (start     = '1') then count_ff <= unsigned(count);
        elsif (decrement = '1') then count_ff <= count_ff - 1;
        end if;
    end if;
end process;
--------------------------------------------------------------------------------
end behavioral;
