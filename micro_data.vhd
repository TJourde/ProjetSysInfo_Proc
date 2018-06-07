----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:30:04 06/01/2018 
-- Design Name: 
-- Module Name:    micro_data - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
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
 use IEEE.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity micro_data is
PORT( RST : in STD_LOGIC;
      clk : in  STD_LOGIC --;
		--input : IN  std_logic_vector(31 downto 0)
		);

end micro_data;

architecture Behavioral of micro_data is


component bram16
  generic (
    init_file : String := "none";
    adr_width : Integer := 11);
  port (
  -- System
  sys_clk : in std_logic;
  sys_rst : in std_logic;
  -- Master
  di : out std_logic_vector(15 downto 0);
  we : in std_logic;
  a : in std_logic_vector(15 downto 0);
  do : in std_logic_vector(15 downto 0));
end component;

component bram32
  generic (
    init_file : String := "instruct.hex";
    adr_width : Integer := 11);
  port (
  -- System
  sys_clk : in std_logic;
  sys_rst : in std_logic;
  -- Master
  di : out std_logic_vector(31 downto 0);
  we : in std_logic;
  a : in std_logic_vector(15 downto 0);
  do : in std_logic_vector(31 downto 0));
end component;


component micro_alu
PORT( RST : in STD_LOGIC;
      clk : in  STD_LOGIC;
		input : IN  std_logic_vector(31 downto 0);
		data_di: IN  std_logic_vector(15 downto 0);
		data_we: OUT std_logic;
		data_a:OUT  std_logic_vector(15 downto 0);
		data_do:OUT  std_logic_vector(15 downto 0)
		);
		end component;
		
		-- input
		signal we : std_logic;
		signal a : std_logic_vector(15 downto 0);
		signal do : std_logic_vector(15 downto 0);
		
		--output
		signal di : std_logic_vector(15 downto 0);
		
				-- input
		signal we32 : std_logic;
		signal a32 : std_logic_vector(15 downto 0):=(others =>'0');--notre compteur d'adresse(ligne) dans le fichier d'instructions
		signal do32 : std_logic_vector(31 downto 0);
		
		--output
		signal di32 : std_logic_vector(31 downto 0);
		
		
begin

	uub:bram16 PORT MAP(
		sys_clk => clk,
		sys_rst => RST,
		-- Master
		di => di,
		we => we,
		a  => a,
		do => do
	
	);
		uub32:bram32	PORT MAP(
		sys_clk => clk,
		sys_rst => RST,
		-- Master
		di => di32,
		we => we32,
		a  => a32,
		do => do32
	
	);
	
	uum:micro_alu PORT MAP(
		RST  => RST,
      clk => clk,
		input  => di32,
		data_di => di,
		data_we => we,
		data_a => a,
		data_do => do
	
	);

process
	begin
	wait until (clk'event)and(clk='1');
	a32<=a32+'1';
end process;


end Behavioral;

