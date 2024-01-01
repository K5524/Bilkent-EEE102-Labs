----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/26/2023 05:38:43 PM
-- Design Name: 
-- Module Name: clock - Behavioral
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

entity clock_div is
    Port ( clockin : in STD_LOGIC;
           clockout : out STD_LOGIC);
end clock_div;

architecture Behavioral of clock_div is
begin
clock_division: process(clockin)
variable counter : integer range 0 to 500 := 500;
variable clock : std_logic := '0';
begin
    if rising_edge(clockin) then
    counter := counter-1;
        if counter = 0 then
        clock := not clock;
        counter := 500;
        end if;
    end if;
    clockout <= clock;
end process;
end Behavioral;
