----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:07:32 05/17/2018 
-- Design Name: 
-- Module Name:    lc - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity lc is
    Port ( OP : in  STD_LOGIC_VECTOR (7 downto 0);
           W : out  STD_LOGIC);
end lc;

architecture Behavioral of lc is

begin

	W<='1' when OP=x"06" or OP=x"01" or OP=x"02" or OP=x"03" or OP=x"07" else
	   '0';

end Behavioral;

