----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/20/2023 04:06:18 PM
-- Design Name: 
-- Module Name: adder_8bit - Behavioral
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

entity adder_8bit is
    Port ( a : in STD_LOGIC_VECTOR (7 downto 0);
           b : in STD_LOGIC_VECTOR (7 downto 0);
           sum : out STD_LOGIC_VECTOR (7 downto 0);
           add_sub : in STD_LOGIC;
           overflow : out STD_LOGIC);
end adder_8bit;

architecture Behavioral of adder_8bit is
component full_adder is
    Port ( a : in STD_LOGIC;
           b : in STD_LOGIC;
           carryin : in STD_LOGIC;
           sum : out STD_LOGIC;
           carryout : out STD_LOGIC);
end component;

component ones_complement is
    Port ( a : in std_logic_vector (7 downto 0);
           result : out std_logic_vector (7 downto 0));
end component;
signal b_in : std_logic_vector (7 downto 0);
signal b_comp : std_logic_vector (7 downto 0); 
signal carry : std_logic_vector (8 downto 0);
begin
with add_sub select
    b_in <= b_comp when '1',
            b when others;
carry(0) <= add_sub;
full_adders: for i in 0 to 7 generate
adders: full_adder port map (a => a(i), b => b_in(i), carryin => carry(i), sum => sum(i), carryout => carry(i+1));
end generate;
b_complement: ones_complement port map (a => b,  result => b_comp);
overflow <= carry(8) xor carry(7);
end Behavioral;
