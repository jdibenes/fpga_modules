----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/20/2019 08:52:54 PM
-- Design Name: 
-- Module Name: top - Behavioral
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

entity top is
port (
clk    : in std_logic;
resetn : in std_logic;

axilite_awvalid : in  std_logic;
axilite_awready : out std_logic;
axilite_awaddr  : in  std_logic_vector(0 downto 0);

axilite_wvalid : in  std_logic;
axilite_wready : out std_logic;
axilite_wdata  : in  std_logic_vector(31 downto 0);
axilite_wstrb  : in  std_logic_vector(3 downto 0);

axilite_bvalid : out std_logic;
axilite_bready : in  std_logic;
axilite_bresp  : out std_logic_vector(1 downto 0);

axilite_arvalid : in std_logic;
axilite_arready : out std_logic;
axilite_araddr  : in std_logic_vector(0 downto 0);

axilite_rvalid : out std_logic;
axilite_rready : in  std_logic;
axilite_rdata  : out std_logic_vector(31 downto 0);
axilite_rresp  : out std_logic_vector(1 downto 0);

aximm_araddr   : out std_logic_vector(31 downto 0);
aximm_arlen    : out std_logic_vector( 7 downto 0);
aximm_arsize   : out std_logic_vector( 2 downto 0);
aximm_arburst  : out std_logic_vector( 1 downto 0);
aximm_arlock   : out std_logic_vector( 1 downto 0);
aximm_arcache  : out std_logic_vector( 3 downto 0);
aximm_arprot   : out std_logic_vector( 2 downto 0);
aximm_arqos    : out std_logic_vector( 3 downto 0);
aximm_arregion : out std_logic_vector( 3 downto 0);
aximm_arvalid  : out std_logic;
aximm_arready  : in  std_logic;

aximm_rdata  : in  std_logic_vector(127 downto 0);
aximm_rresp  : in  std_logic_vector(  1 downto 0);
aximm_rlast  : in  std_logic;
aximm_rvalid : in  std_logic;
aximm_rready : out std_logic;

vga_r : out std_logic_vector(3 downto 0);
vga_g : out std_logic_vector(3 downto 0);
vga_b : out std_logic_vector(3 downto 0);
vga_h : out std_logic;
vga_v : out std_logic
);
end top;

architecture Behavioral of top is
signal base_addr : std_logic_vector(31 downto 0);
signal addr_valid : std_logic;
signal start : std_logic;
signal continue : std_logic;
signal data : std_logic_vector(31 downto 0);
begin

axilite_interface : entity work.axi_cnt
port map (
clk    => clk,
resetn => resetn,

awvalid => axilite_awvalid,
awready => axilite_awready,
awaddr  => axilite_awaddr,

wvalid => axilite_wvalid,
wready => axilite_wready,
wdata  => axilite_wdata,
wstrb  => axilite_wstrb,

bvalid => axilite_bvalid,
bready => axilite_bready,
bresp  => axilite_bresp,

arvalid => axilite_arvalid,
arready => axilite_arready,
araddr  => axilite_araddr,

rvalid => axilite_rvalid,
rready => axilite_rready,
rdata  => axilite_rdata,
rresp  => axilite_rresp,

base_addr   => base_addr,
read_enable => addr_valid
);

aximm_interface : entity work.axi_mm
port map(
clk    => clk,
resetn => resetn,

araddr   => aximm_araddr,
arlen    => aximm_arlen,
arsize   => aximm_arsize,
arburst  => aximm_arburst,
arlock   => aximm_arlock,
arcache  => aximm_arcache,
arprot   => aximm_arprot,
arqos    => aximm_arqos,
arregion => aximm_arregion,
arvalid  => aximm_arvalid,
arready  => aximm_arready,

rdata  => aximm_rdata,
rresp  => aximm_rresp,
rlast  => aximm_rlast,
rvalid => aximm_rvalid,
rready => aximm_rready,

base_addr => base_addr,
start     => start,
continue  => continue,
data_out  => data
);

vga_controller : entity work.vga300M
port map (
clk    => clk,
resetn => resetn,

data     => data,
enable   => addr_valid,
start    => start,
continue => continue,

vga_r => vga_r,
vga_g => vga_g,
vga_b => vga_b,
vga_h => vga_h,
vga_v => vga_v
);
end Behavioral;
