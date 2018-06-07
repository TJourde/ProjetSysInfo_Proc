----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:51:55 05/14/2018 
-- Design Name: 
-- Module Name:    alu - Behavioral 
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity alu is
    Port ( A : in  STD_LOGIC_VECTOR (15 downto 0);  --B (B du pipeline ou du registre)
           B : in  STD_LOGIC_VECTOR (15 downto 0);  --C (A du pipeline)
           OP : in  STD_LOGIC_VECTOR (7 downto 0);
           S : out  STD_LOGIC_VECTOR (15 downto 0);
           Flag : out  STD_LOGIC_VECTOR (3 downto 0)); --ZCNV
end alu;

architecture Behavioral of alu is
signal R:STD_LOGIC_VECTOR (15 downto 0);--:=(others => '0');
signal Radd:STD_LOGIC_VECTOR (16 downto 0);--:=(others => '0');
signal Rmul:STD_LOGIC_VECTOR (31 downto 0);--:=(others => '0');
begin

Rmul<=A*B;
R<=Radd(15 downto 0) when OP=x"01" else
	B-A when OP=x"03" else
	Rmul (15 downto 0) when OP=x"02";
Radd<=("0"&A) + ("0"&B);
Flag(0) <= '1' when A<B and OP=x"03" else '0' ;
Flag(1) <= Radd(15) when OP=x"01" else '0'; 
Flag(2) <= Radd(16) when OP=x"01" else '0';
Flag(3) <= '1' when R=x"0000" else '0';
S<=R; 

end Behavioral;

