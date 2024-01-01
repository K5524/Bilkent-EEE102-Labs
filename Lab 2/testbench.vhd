----------------------------------------------------------------------------------
-- EEE102 Lab 2
-- Kaan Ermertcan
-- Create Date: 09/30/2023 01:00:42 PM
-- Module Name: testbench - Behavioral
----------------------------------------------------------------------------------

-- Definition of the modules that will be used
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity testbench is
end testbench;

-- Specifying inputs and outputs of the component
architecture Behavioral of testbench is
component main
 PORT(
 nighttime: in STD_LOGIC;
 winter: in STD_LOGIC;
 windy: in STD_LOGIC;
 window: out STD_LOGIC;
 heating: out STD_LOGIC);
end component;

-- Defining signals of the testbench
 signal nighttime: STD_LOGIC;
 signal winter: STD_LOGIC; 
 signal windy: STD_LOGIC; 
 signal window: STD_LOGIC;
 signal heating: STD_LOGIC;
begin

-- Mapping ports of the testbench to ports of main
UUT: main PORT MAP(
nighttime => nighttime,
winter => winter,
windy => windy,
window => window,
heating => heating
);

-- Defining the process of the simulation 
testbench: PROCESS
 begin
 -- 000 
 nighttime<='0';
 winter<='0';
 windy<='0';
 -- 001
 wait for 50 ns;
 nighttime<='0';
 winter<='0';
 windy<='1'; 
 -- 010
 wait for 50 ns;
 nighttime<='0';
 winter<='1';
 windy<='0';
 -- 011
 wait for 50 ns;
 nighttime<='0';
 winter<='1';
 windy<='1';
 -- 100
 wait for 50 ns;
 nighttime<='1';
 winter<='0';
 windy<='0';
 -- 101
 wait for 50 ns;
 nighttime<='1';
 winter<='0';
 windy<='1'; 
 -- 110
 wait for 50 ns;
 nighttime<='1';
 winter<='1';
 windy<='0';
 -- 111
 wait for 50 ns;
 nighttime<='1';
 winter<='1';
 windy<='1';
 wait for 50ns;
end PROCESS;
end Behavioral;
