----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/21/2023 10:58:22 PM
-- Design Name: 
-- Module Name: ones_complement - Behavioral
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


entity ones_complement is
    Port ( a : in STD_LOGIC_VECTOR (7 downto 0);
           result : out STD_LOGIC_VECTOR (7 downto 0));
end ones_complement;

architecture Behavioral of ones_complement is

begin
inverters: for i in 0 to 7 generate
result(i) <= not a(i);
end generate;
end Behavioral;
