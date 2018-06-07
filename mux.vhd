----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:35:13 06/01/2018 
-- Design Name: 
-- Module Name:    mux - Behavioral 
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

entity mux is
    Port ( OP : in  STD_LOGIC_VECTOR (7 downto 0);
           B_in : in  STD_LOGIC_VECTOR (15 downto 0);
           newB : in  STD_LOGIC_VECTOR (15 downto 0);
           B_out : out  STD_LOGIC_VECTOR (15 downto 0));
end mux;

architecture Behavioral of mux is

begin

B_out<=newB when OP=x"01" or OP=x"02" or OP=x"03" or OP=x"08" else B_in;


end Behavioral;

