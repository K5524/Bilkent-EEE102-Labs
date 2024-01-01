----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/20/2023 06:32:47 PM
-- Design Name: 
-- Module Name: full_adder_test - Behavioral
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

entity full_adder_test is
end full_adder_test;

architecture Behavioral of full_adder_test is
signal sum : STD_LOGIC;
signal carryout : STD_LOGIC;
signal inputs : std_logic_vector(2 downto 0):= "000";
component full_adder is
    Port ( a : in STD_LOGIC;
           b : in STD_LOGIC;
           carryin : in STD_LOGIC;
           sum : out STD_LOGIC;
           carryout : out STD_LOGIC);
end component;
begin
uut: full_adder
port map (a=>inputs(0), b=>inputs(1), carryin=>inputs(2), carryout=>carryout, sum=>sum);
process begin
    for i in 0 to 7 loop 
        wait for 10 ns;
        inputs <= std_logic_vector(unsigned(inputs) + 1);
    end loop;
    wait;
end process;
end Behavioral;
