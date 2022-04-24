----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/20/2019 07:46:57 PM
-- Design Name: 
-- Module Name: axi_cnt - Behavioral
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

entity axi_cnt is
port (
    clk    : in std_logic;
    resetn : in std_logic;
    
    awvalid : in  std_logic;
    awready : out std_logic;
    awaddr  : in  std_logic_vector(0 downto 0);
    
    wvalid : in  std_logic;
    wready : out std_logic;
    wdata  : in  std_logic_vector(31 downto 0);
    wstrb  : in  std_logic_vector(3 downto 0);
    
    bvalid : out std_logic;
    bready : in  std_logic;
    bresp  : out std_logic_vector(1 downto 0);
    
    arvalid : in std_logic;
    arready : out std_logic;
    araddr  : in std_logic_vector(0 downto 0);
    
    rvalid : out std_logic;
    rready : in  std_logic;
    rdata  : out std_logic_vector(31 downto 0);
    rresp  : out std_logic_vector(1 downto 0);
    
    base_addr   : out std_logic_vector(31 downto 0);
    read_enable : out std_logic
);
end axi_cnt;

architecture Behavioral of axi_cnt is
type axiw_state is (axiw_reset, axiw_addr, axiw_data, axiw_resp);
type axir_state is (axir_reset, axir_addr, axir_data);

signal wstate      : axiw_state := axiw_reset;
signal next_wstate : axiw_state := axiw_reset;

signal rstate      : axir_state := axir_reset;
signal next_rstate : axir_state := axir_reset;

signal wdata_ready : std_logic := '0';
signal wd_hs       : std_logic := '0';

signal reset  : std_logic                     := '1';
signal addr   : std_logic_vector(31 downto 0) := (others => '0');
signal enable : std_logic                     := '0';
begin
reset <= not resetn;

-- write channel ---------------------------------------------------------------
w_state : process (wstate, awvalid, wvalid, bready)
begin
    awready     <= '0';
    wdata_ready <= '0';
    bvalid      <= '0';
    
    case (wstate) is
    when axiw_addr => awready     <= '1'; if (awvalid = '1') then next_wstate <= axiw_data; else next_wstate <= axiw_addr; end if;
    when axiw_data => wdata_ready <= '1'; if (wvalid  = '1') then next_wstate <= axiw_resp; else next_wstate <= axiw_data; end if;
    when axiw_resp => bvalid      <= '1'; if (bready  = '1') then next_wstate <= axiw_addr; else next_wstate <= axiw_resp; end if;
    when others    =>                                             next_wstate <= axiw_addr;
    end case;
end process;

wready <= wdata_ready;
bresp  <= "00";
wd_hs  <= wdata_ready and wvalid;

w_fsm : process (clk)
begin
    if (rising_edge(clk)) then
        if (reset = '1') then wstate <= axiw_reset; else wstate <= next_wstate; end if;
    end if;
end process;

w_data : process (clk)
begin
    if (rising_edge(clk)) then
        if    (reset = '1') then addr <= (others => '0');           enable <= '0';
        elsif (wd_hs = '1') then addr <= wdata(31 downto 2) & "00"; enable <= wdata(0);
        end if;
    end if;
end process;

base_addr   <= addr;
read_enable <= enable;

-- read_channel ----------------------------------------------------------------
r_state : process (rstate, arvalid, rready)
begin
    arready <= '0';
    rvalid  <= '0';

    case (rstate) is
    when axir_addr => arready <= '1'; if (arvalid = '1') then next_rstate <= axir_data; else next_rstate <= axir_addr; end if;
    when axir_data => rvalid  <= '1'; if (rready  = '1') then next_rstate <= axir_addr; else next_rstate <= axir_data; end if;
    when others    =>                                         next_rstate <= axir_addr;
    end case;
end process;

r_fsm : process (clk)
begin
    if (rising_edge(clk)) then
        if (reset = '1') then rstate <= axir_reset; else rstate <= next_rstate; end if;
    end if;
end process;

rdata <= addr(31 downto 1) & enable;
rresp <= "00";

end Behavioral;
