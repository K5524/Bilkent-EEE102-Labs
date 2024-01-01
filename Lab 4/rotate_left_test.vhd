----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/23/2023 12:14:18 PM
-- Design Name: 
-- Module Name: bitwise_and_test - Behavioral
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
use ieee.math_real.all;   
use ieee.numeric_std.all; 


entity rotate_left_test is
end rotate_left_test;

architecture Behavioral of rotate_left_test is
signal a : std_logic_vector(7 downto 0):= "00000000";
signal result : std_logic_vector(7 downto 0):= "00000000";
component rotate_left is
    Port ( a : in STD_LOGIC_VECTOR (7 downto 0);
           result : out STD_LOGIC_VECTOR (7 downto 0));
end component;
begin
uut: rotate_left
port map (a=>a, result=>result);
process 
variable seed1: positive :=28938;  -- seed values for random generator
variable seed2: positive :=22380;    
variable rand1: real;              -- random real-numbers in range 0 to 1             
variable int_rand1: integer;       -- random integers in range 0..255      
variable stim1: std_logic_vector(7 downto 0);  -- random 8-bit stimuli
begin    
for j in 0 to 9 loop
                wait for 100 ns;
                uniform(seed1, seed2, rand1);              -- generate random number
    int_rand1 := integer(trunc(rand1*256.0));              -- rescale to integer between 0-256
    stim1 := std_logic_vector(to_unsigned(int_rand1, stim1'length)); -- convert to std_logic_vector
                a <= stim1; 
            end loop;
wait; 
end process;
end Behavioral;
