----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/19/2019 07:11:29 PM
-- Design Name: 
-- Module Name: vga300M - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity vga300M is
port (
    clk    : in std_logic;
    resetn : in std_logic;
    
    data     : in  std_logic_vector(31 downto 0);
    enable   : in  std_logic;
    start    : out std_logic;
    continue : out std_logic;
    
    vga_r : out std_logic_vector(3 downto 0);
    vga_g : out std_logic_vector(3 downto 0);
    vga_b : out std_logic_vector(3 downto 0);
    vga_h : out std_logic;
    vga_v : out std_logic
);
end vga300M;

architecture Behavioral of vga300M is
signal reset : std_logic := '1';

signal hcount : unsigned(13 downto 0) := (others => '0');
signal vcount : unsigned(22 downto 0) := (others => '0');
signal pcount : unsigned( 3 downto 0) := (others => '0');

signal hdata         : std_logic := '0';
signal vdata         : std_logic := '0';
signal output_enable : std_logic := '0';

signal r : std_logic_vector(3 downto 0) := (others => '0');
signal g : std_logic_vector(3 downto 0) := (others => '0');
signal b : std_logic_vector(3 downto 0) := (others => '0');

signal frame_start : std_logic := '0';
signal valid       : std_logic := '0';
signal prefetch    : std_logic := '0';

begin
reset <= not resetn;

hsync_counter : process (clk)
begin
    if (rising_edge(clk)) then
        if    (reset = '1')              then hcount <= to_unsigned(0, hcount'length);
        elsif (hcount < (12*   800 - 1)) then hcount <= hcount + 1;
        else                                  hcount <= to_unsigned(0, hcount'length);
        end if;
    end if;
end process;

vsync_counter : process (clk)
begin
    if (rising_edge(clk)) then
        if    (reset = '1')              then vcount <= to_unsigned(0, vcount'length);
        elsif (vcount < (12*416800 - 1)) then vcount <= vcount + 1;
        else                                  vcount <= to_unsigned(0, vcount'length);
        end if;
    end if;
end process;

hdata <= '0' when hcount < (12*   48) else '1' when hcount < (12*(   48 +    640)) else '0';
vdata <= '0' when vcount < (12*23200) else '1' when vcount < (12*(23200 + 384000)) else '0';

output_enable <= hdata and vdata and valid;

vga_h <= '1' when hcount < (12*(   800 -   96)) else '0';
vga_v <= '1' when vcount < (12*(416800 - 1600)) else '0';

vga_r <= r when output_enable = '1' else (others => '0');
vga_g <= g when output_enable = '1' else (others => '0');
vga_b <= b when output_enable = '1' else (others => '0');

frame_start <= '1' when vcount = 0 else '0';
start       <= '1' when vcount = 1 and valid = '1' else '0';

valid_ff : process (clk)
begin
    if (rising_edge(clk)) then
        if (frame_start = '1') then valid <= enable; end if;
    end if;
end process;

pixel_counter : process (clk)
begin
    if (rising_edge(clk)) then
        if    (reset = '1')       then pcount <= to_unsigned(0, pcount'length);
        elsif (pcount < (12 - 1)) then pcount <= pcount + 1;
        else                           pcount <= to_unsigned(0, pcount'length);
        end if;
    end if;
end process;

prefetch <= '0' when hcount < (12*(48 - 1)) else '1' when hcount < (12*(48 + 640 - 1)) else '0';
continue <= '1' when valid = '1' and prefetch = '1' and pcount = 0 and vdata = '1' else '0';

component_ff : process (clk)
begin
    if (rising_edge(clk)) then
        if (pcount = (12 - 1)) then
            r <= data( 7 downto  4);
            g <= data(15 downto 12);
            b <= data(23 downto 20);
        end if;
    end if;
end process;

end Behavioral;
