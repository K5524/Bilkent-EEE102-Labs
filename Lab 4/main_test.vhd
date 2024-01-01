----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/23/2023 01:44:50 PM
-- Design Name: 
-- Module Name: main_test - Behavioral
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


entity main_test is
end main_test;

architecture Behavioral of main_test is
signal a : STD_LOGIC_VECTOR (7 downto 0) := "10101010";
signal b : STD_LOGIC_VECTOR (7 downto 0) := "00110100";
signal buttons : STD_LOGIC_VECTOR (4 downto 0) := "00000";
signal result : STD_LOGIC_VECTOR (7 downto 0);
signal overflow : STD_LOGIC;

component main is
    Port ( a : in STD_LOGIC_VECTOR (7 downto 0);
           b : in STD_LOGIC_VECTOR (7 downto 0);
           buttons : in STD_LOGIC_VECTOR (4 downto 0);
           result : out STD_LOGIC_VECTOR (7 downto 0);
           overflow : out STD_LOGIC);
end component;
begin
uut: main
port map (a=>a, b=>b, buttons=>buttons, result=>result, overflow=>overflow);
process begin
    for i in 0 to 31 loop 
        wait for 10 ns;
        buttons <= std_logic_vector(unsigned(buttons) + 1);
    end loop;
    wait;
end process;
end Behavioral;
