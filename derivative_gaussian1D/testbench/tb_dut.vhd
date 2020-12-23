----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/22/2020 03:36:28 PM
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

entity tb_dut is
--  Port ( );
end tb_dut;

architecture behavioral of tb_dut is
component derivative_gaussian1D_wrapper is
port (
    CLK        : in  STD_LOGIC;
    tdata_in   : in  STD_LOGIC_VECTOR ( 15 downto 0 );
    tdata_out  : out STD_LOGIC_VECTOR ( 21 downto 0 );
    tlast_in   : in  STD_LOGIC;
    tlast_out  : out STD_LOGIC_VECTOR ( 0 to 0 );
    tready_in  : out STD_LOGIC_VECTOR ( 0 to 0 );
    tready_out : in  STD_LOGIC;
    tuser_in   : in  STD_LOGIC_VECTOR ( 0 to 0 );
    tuser_out  : out STD_LOGIC_VECTOR ( 0 to 0 );
    tvalid_in  : in  STD_LOGIC;
    tvalid_out : out STD_LOGIC_VECTOR ( 0 to 0 )
);
end component;

signal CLK : STD_LOGIC := '0';

signal tdata_in   : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
signal tlast_in   : STD_LOGIC_VECTOR(0 to 0)      := (others => '0');
signal tready_out : STD_LOGIC                     := '0';
signal tuser_in   : STD_LOGIC_VECTOR(0 to 0)      := (others => '0');
signal tvalid_in  : STD_LOGIC_VECTOR(0 to 0)      := (others => '0');

signal tready_in  : STD_LOGIC_VECTOR(0 to 0);
signal tdata_out  : STD_LOGIC_VECTOR(21 downto 0);
signal tlast_out  : STD_LOGIC_VECTOR(0 to 0);
signal tuser_out  : STD_LOGIC_VECTOR(0 to 0);
signal tvalid_out : STD_LOGIC_VECTOR(0 to 0);

signal hcounter : std_logic_vector(11 downto 0);

type char_file is file of character;
subtype byte is std_logic_vector(7 downto 0);
subtype short is std_logic_vector(15 downto 0);

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

procedure writeshort(variable f : in char_file;
                     variable s : in short)
is
begin
    writebyte(f, s(7 downto 0));
    writebyte(f, s(15 downto 8));
end procedure;

begin

clk_proc : process
begin
    clk <= '0'; wait for 5 ns;
    clk <= '1'; wait for 5 ns;
end process;

load_proc : process (clk)
file f_y : char_file open read_mode is "./median_out.bin";

variable y0 : byte := (others => '0');
variable y1 : byte := (others => '0');

variable first : std_logic := '1';

variable pcounter : unsigned(11 downto 0) := (others => '0');
begin
    if (rising_edge(clk)) then
        if (not endfile(f_y)) then
            readbyte(f_y, y0);
            readbyte(f_y, y1);
            
            hcounter <= std_logic_vector(pcounter);
            pcounter := pcounter + 2;
            
            tdata_in   <= y1 & y0;
            tready_out <= '1';
            tvalid_in  <= "1";
            tuser_in   <= (others => first);
            
            first := '0';
            
            if (endfile(f_y)) then tlast_in <= "1"; else tlast_in <= "0"; end if;
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
file f_out : char_file open write_mode is "./dg_out.bin";

variable s0 : short;
variable s1 : short;

variable d0 : std_logic_vector(10 downto 0);
variable d1 : std_logic_vector(10 downto 0);

variable x0 : std_logic_vector(4 downto 0);
variable x1 : std_logic_vector(4 downto 0);
begin
    if (rising_edge(clk)) then
        if (tvalid_out = "1") then
            d0 := tdata_out(10 downto  0);
            d1 := tdata_out(21 downto 11);
            
            x0 := (others => d0(10));
            x1 := (others => d1(10));
            
            s0 := x0 & d0;
            s1 := x1 & d1;
            
            writeshort(f_out, s0);
            writeshort(f_out, s1);
        end if;
    end if;
end process;

DUT : derivative_gaussian1D_wrapper
port map (
    CLK        => clk,
    tdata_in   => tdata_in,
    tdata_out  => tdata_out,
    tlast_in   => tlast_in(0),
    tlast_out  => tlast_out,
    tready_in  => tready_in,
    tready_out => tready_out,
    tuser_in   => tuser_in,
    tuser_out  => tuser_out,
    tvalid_in  => tvalid_in(0),
    tvalid_out => tvalid_out
);

end behavioral;
