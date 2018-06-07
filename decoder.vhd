----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:01:22 05/17/2018 
-- Design Name: 
-- Module Name:    decoder - Behavioral 
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

entity decoder is
    Port ( ins_di : in  STD_LOGIC_VECTOR (31 downto 0);
           A : out  STD_LOGIC_VECTOR (15 downto 0);
           B : out  STD_LOGIC_VECTOR (15 downto 0);
           OP : out  STD_LOGIC_VECTOR (7 downto 0);
			  C : out STD_LOGIC_VECTOR (15 downto 0));
end decoder;

architecture Behavioral of decoder is

signal MOP:STD_LOGIC_VECTOR (7 downto 0);

begin
MOP<=ins_di(31 downto 24);
OP<=MOP;

-- ADD MOP="01"
-- MIL MOP="02"
-- SOU MOP="03"
-- AFC MOP="06"
-- LOAD MOP="07"
-- STORE MOP="08"
-- EQU MOP="09"
-- INF MOP="0A"
-- INFE MOP="0B"
-- SUP MOP="0C"
-- SUPE MOP="0D"
-- JMP MOP="0E"
-- JMPC MOP="0F"

A(15 downto 8) <= ins_di(23 downto 16);
A(7 downto 0)  <= ins_di(15 downto 8)when MOP=x"08" or MOP=x"0E" or MOP=x"0F" else
					   x"00";
		
B(15 downto 8) <= ins_di(7 downto 0)when MOP=x"08" or MOP=x"0F" else
						x"00" when MOP=x"0E" else
					   ins_di(15 downto 8);
						
B(7 downto 0)  <= ins_di(7 downto 0) when MOP=x"06" or MOP=x"07" or MOP=x"0F" else
					   x"00";

-- en fait on n'utilise jamais avec ce paramètre
C (15 downto 8) <= ins_di(23 downto 16) when MOP=x"01" or MOP=x"02" or MOP=x"03" else(others => '0');
C (7 downto 0) <= (others => '0');
end Behavioral;

