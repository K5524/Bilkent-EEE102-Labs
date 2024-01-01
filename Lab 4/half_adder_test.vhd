----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/21/2023 10:47:58 PM
-- Design Name: 
-- Module Name: half_adder_test - Behavioral
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

entity half_adder_test is
end half_adder_test;

architecture Behavioral of half_adder_test is
signal sum : STD_LOGIC;
signal carry : STD_LOGIC;
signal inputs : std_logic_vector(1 downto 0):= "00";
component half_adder is
    Port ( a : in STD_LOGIC;
           b : in STD_LOGIC;
           carry : out STD_LOGIC;
           sum : out STD_LOGIC);
end component;
begin
uut: half_adder
port map (a=>inputs(0), b=>inputs(1), carry=>carry, sum=>sum);
process begin
    for i in 0 to 3 loop 
        wait for 10 ns;
        inputs <= std_logic_vector(unsigned(inputs) + 1);
    end loop;
    wait;
end process;
end Behavioral;
