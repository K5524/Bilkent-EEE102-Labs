----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/19/2023 10:09:19 AM
-- Design Name: 
-- Module Name: full_adder - Behavioral
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

entity full_adder is
    Port ( a : in STD_LOGIC;
           b : in STD_LOGIC;
           carryin : in STD_LOGIC;
           sum : out STD_LOGIC;
           carryout : out STD_LOGIC);
end full_adder;

architecture Behavioral of full_adder is
signal half_sum : std_logic;
signal half_carry : std_logic;
component half_adder is
    Port ( a : in STD_LOGIC;
           b : in STD_LOGIC;
           carry : out STD_LOGIC;
           sum : out STD_LOGIC);
end component;
begin
halfadder: half_adder port map (a => a, b => b, carry => half_carry, sum => half_sum);
sum <= half_sum xor carryin;
carryout <= (half_sum and carryin) or half_carry;
end Behavioral;
