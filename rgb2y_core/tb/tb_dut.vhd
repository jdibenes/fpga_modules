----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/06/2020 01:22:18 AM
-- Design Name: 
-- Module Name: tb_dut - behavioral
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
-- tb_pass 11/6/2020
-- tb_pass 11/28/2020
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

entity tb_dut is
--  Port ( );
end tb_dut;

architecture behavioral of tb_dut is
component rgb2y_wrapper is
port (
    CLK        : in  STD_LOGIC;
    tdata_in   : in  STD_LOGIC_VECTOR(47 downto 0);
    tdata_out  : out STD_LOGIC_VECTOR(15 downto 0);
    tlast_in   : in  STD_LOGIC_VECTOR(0 to 0);
    tlast_out  : out STD_LOGIC_VECTOR(0 to 0);
    tready_in  : out STD_LOGIC_VECTOR(0 to 0);
    tready_out : in  STD_LOGIC;
    tuser_in   : in  STD_LOGIC_VECTOR(0 to 0);
    tuser_out  : out STD_LOGIC_VECTOR(0 to 0);
    tvalid_in  : in  STD_LOGIC_VECTOR(0 to 0);
    tvalid_out : out STD_LOGIC_VECTOR(0 to 0)
);
end component;

signal CLK : STD_LOGIC := '0';

signal tdata_in   : STD_LOGIC_VECTOR(47 downto 0) := (others => '0');
signal tlast_in   : STD_LOGIC_VECTOR(0 to 0)      := (others => '0');
signal tready_out : STD_LOGIC                     := '0';
signal tuser_in   : STD_LOGIC_VECTOR(0 to 0)      := (others => '0');
signal tvalid_in  : STD_LOGIC_VECTOR(0 to 0)      := (others => '0');

signal tready_in  : STD_LOGIC_VECTOR(0 to 0);
signal tdata_out  : STD_LOGIC_VECTOR(15 downto 0);
signal tlast_out  : STD_LOGIC_VECTOR(0 to 0);
signal tuser_out  : STD_LOGIC_VECTOR(0 to 0);
signal tvalid_out : STD_LOGIC_VECTOR(0 to 0);

signal hcounter : std_logic_vector(11 downto 0);

type char_file is file of character;
subtype byte is std_logic_vector(7 downto 0);

procedure readbyte(variable f : in  char_file;
                   variable b : out byte)
is
variable c : character;
begin
    read(f, c);
    b := std_logic_vector(to_unsigned(integer(character'pos(c)), b'length));
end procedure;

procedure writebyte(variable f : in char_file;
                    variable b : in byte)
is
variable c : character;
begin
    c := character'val(to_integer(unsigned(b)));
    write(f, c);
end procedure;

procedure readrgb(variable f_r : in  char_file;
                  variable f_g : in  char_file;
                  variable f_b : in  char_file;
                  variable r   : out byte;
                  variable g   : out byte;
                  variable b   : out byte)
is
begin
    readbyte(f_r, r);
    readbyte(f_g, g);
    readbyte(f_b, b);
end procedure;
begin

clk_proc : process
begin
    clk <= '0'; wait for 5 ns;
    clk <= '1'; wait for 5 ns;
end process;

load_proc : process (clk)
file f_r : char_file open read_mode is "./row_r_1060.bin";
file f_g : char_file open read_mode is "./row_g_1060.bin";
file f_b : char_file open read_mode is "./row_b_1060.bin";

variable r0 : byte := (others => '0');
variable g0 : byte := (others => '0');
variable b0 : byte := (others => '0');
variable r1 : byte := (others => '0');
variable g1 : byte := (others => '0');
variable b1 : byte := (others => '0');

variable first : std_logic := '1';

variable pcounter : unsigned(11 downto 0) := (others => '0');
begin
    if (rising_edge(clk)) then
        if (not endfile(f_r)) then
            readrgb(f_r, f_g, f_b, r0, g0, b0);
            readrgb(f_r, f_g, f_b, r1, g1, b1);
            
            hcounter <= std_logic_vector(pcounter);
            pcounter := pcounter + 2;
            
            tdata_in   <= r1 & b1 & g1 & r0 & b0 & g0;
            tready_out <= '1';
            tvalid_in  <= "1";
            tuser_in   <= (others => first);
            
            first := '0';
            
            if (endfile(f_r)) then tlast_in <= "1"; else tlast_in <= "0"; end if;
        else
            tdata_in   <= (others => 'X');
            tready_out <= '0';
            tvalid_in  <= "0";
            tuser_in   <= "0";
            tlast_in   <= "0";
        end if;
    end if;
end process;

store_proc : process (clk)
file f_out : char_file open write_mode is "./rgb2y_out.bin";
variable b0 : byte;
variable b1 : byte;
begin
    if (rising_edge(clk)) then
        if (tvalid_out = "1") then
            b0 := tdata_out( 7 downto 0);
            b1 := tdata_out(15 downto 8);
            writebyte(f_out, b0);
            writebyte(f_out, b1);
        end if;
    end if;
end process;

DUT : rgb2y_wrapper
port map (
    CLK        => clk,
    tdata_in   => tdata_in,
    tdata_out  => tdata_out,
    tlast_in   => tlast_in,
    tlast_out  => tlast_out,
    tready_in  => tready_in,
    tready_out => tready_out,
    tuser_in   => tuser_in,
    tuser_out  => tuser_out,
    tvalid_in  => tvalid_in,
    tvalid_out => tvalid_out
);
end behavioral;
