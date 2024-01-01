----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/27/2023 06:01:31 PM
-- Design Name: 
-- Module Name: sevensegment_test - Behavioral
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


entity gcd_test is
end gcd_test;

architecture Behavioral of gcd_test is
component main is
    Port ( A : in STD_LOGIC_VECTOR (7 downto 0);
           B : in STD_LOGIC_VECTOR (7 downto 0);
           gcd : out STD_LOGIC_VECTOR (7 downto 0);
           clockin : in STD_LOGIC;
           button : in STD_LOGIC);
end component;

signal A : std_logic_vector (7 downto 0);
signal B : std_logic_vector (7 downto 0);
signal gcd: STD_LOGIC_VECTOR (7 downto 0);
signal button : std_logic := '0';
signal clockin : std_logic := '0';
begin
uut: main port map(clockin => clockin, A => A, B => B, gcd => gcd, button => button);
process
constant clock_period : time := 10ns;
begin
clockin <= '0';
wait for clock_period/2;
clockin <= '1';
wait for clock_period/2;
end process;

process
begin
A <= "01011101";
B <= "01111101";
wait for 20020ns;
button <= '1';
wait for 20000ns;
button <= '0';
wait for 400us;
A <= "10001100";
B <= "00001100";
wait for 20020ns;
button <= '1';
wait for 20000ns;
button <= '0';
wait for 400us;
A <= "01001110";
B <= "10110110";
wait for 20020ns;
button <= '1';
wait for 20000ns;
button <= '0';
wait for 400us;
wait; 
end process;
end Behavioral;
