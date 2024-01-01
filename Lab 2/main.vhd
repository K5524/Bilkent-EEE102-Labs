----------------------------------------------------------------------------------
-- EEE102 Lab 2
-- Kaan Ermertcan
-- Create Date: 09/30/2023 12:40:10 PM
-- Module Name: main
----------------------------------------------------------------------------------

-- Definition of the modules that will be used
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Specifying inputs and outputs
entity main is
    Port ( nighttime : in STD_LOGIC;
           winter : in STD_LOGIC;
           windy : in STD_LOGIC;
           window : out STD_LOGIC;
           heating : out STD_LOGIC);
end main;

architecture Behavioral of main is
begin
-- Defining the relation between inputs and outputs.
-- window <= not winter and (not nighttime or (nighttime and not windy));
-- heating <= winter and (nighttime or (not nighttime and windy));
-- window <= (not winter and not windy) or (not nighttime and not winter);
-- heating <= (winter and windy) or (nighttime and winter);
window <= not(winter or (nighttime and windy));
heating <= winter and (nighttime or windy);
end Behavioral;
