----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/26/2023 05:38:43 PM
-- Design Name: 
-- Module Name: main - Behavioral
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

entity converter is
    Port (input : in STD_LOGIC_VECTOR (11 downto 0);
          output: out STD_LOGIC_VECTOR (15 downto 0));
end converter;

architecture Behavioral of converter is
begin
converter: process(input)
variable decimal : integer range 0 to 4095 := 0;
variable to_ss : unsigned (15 downto 0);
begin
decimal := to_integer(signed(input));
to_ss := (others => '0');
to_ss(3 downto 0) := to_unsigned(decimal mod 10, 4);                                -- Isolating least significant digit
if decimal > 9 then
to_ss(7 downto 4) := to_unsigned(((decimal - (decimal mod 10))/10) mod 10, 4);      -- Isolating second least significant digit
end if;
if decimal > 99 then
to_ss(11 downto 8) := to_unsigned(((decimal - (decimal mod 100))/100) mod 10, 4);   -- Isolating second most significant digit
end if;
if decimal > 999 then
to_ss(15 downto 12) := to_unsigned(((decimal - (decimal mod 1000))/1000) mod 10, 4);-- Isolating most significant digit
end if;
output <= std_logic_vector(to_ss);
end process;
end Behavioral;
