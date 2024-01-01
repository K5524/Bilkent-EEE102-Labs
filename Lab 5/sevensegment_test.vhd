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
use IEEE.NUMERIC_STD.ALL;
use ieee.math_real.all;  

entity sevensegment_test is
end sevensegment_test;

architecture Behavioral of sevensegment_test is
component sevensegment is
Port(      switch_input : in std_logic_vector (11 downto 0);
           sseganode : out STD_LOGIC_VECTOR (3 downto 0);
           ssegcathode : out STD_LOGIC_VECTOR (7 downto 0);
           clockin : in std_logic);
end component;
signal switch_input : std_logic_vector (11 downto 0);
signal sseganode : STD_LOGIC_VECTOR (3 downto 0);
signal ssegcathode : STD_LOGIC_VECTOR (7 downto 0);
signal clockin : std_logic := '0';
begin
uut: sevensegment port map(clockin => clockin, ssegcathode => ssegcathode, sseganode => sseganode, switch_input => switch_input);
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
switch_input <= "000101111011";
wait for 20000000ns;
switch_input <= "011111100111";
wait for 20000000ns;
switch_input <= "010101010101";
wait for 20000000ns;
switch_input <= "101010101010";
wait for 20000000ns;
switch_input <= "111111000011";
wait for 20000000ns;
switch_input <= "011100011010";
wait for 20000000ns;
wait; 
end process;
end Behavioral;
