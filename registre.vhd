----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:23:41 05/14/2018 
-- Design Name: 
-- Module Name:    registre - Behavioral 
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
use ieee.STD_LOGIC_ARITH.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity registre is
    Port ( RST : in STD_LOGIC;
			  RAadr : in STD_LOGIC_VECTOR(3 downto 0);
			  RBadr : in STD_LOGIC_VECTOR(3 downto 0);
			  QA : out STD_LOGIC_VECTOR(15 downto 0);
			  QB : out STD_LOGIC_VECTOR(15 downto 0);
			  --@W, W et DATA.
			  RWadr : in STD_LOGIC_VECTOR(3 downto 0);
			  W : in STD_LOGIC;
			  DATA : in STD_LOGIC_VECTOR(15 downto 0);
           clk : in  STD_LOGIC);
end registre;

architecture Behavioral of registre is
type type_name is array (0 to 15) of STD_LOGIC_VECTOR (15 downto 0);
signal registers:type_name ;

--conv_integer
begin
	process
	begin
	wait until (clk'event)and(clk='1');
	if RST='0' then
   registers <= (others => (others => '0'));
    else
		if W='1' then
		 registers(conv_integer(unsigned(RWadr))) <= DATA;
		end if;

    end if;	 
	end process;
	

	 		QA <= DATA when RWadr = RAadr else registers(conv_integer(unsigned(RAadr))); 

			QB <= DATA when RWadr = RBadr else registers(conv_integer(unsigned(RBadr)));


end Behavioral;

