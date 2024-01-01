----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/26/2023 05:38:43 PM
-- Design Name: 
-- Module Name: sevensegment - Behavioral
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

entity sevensegment is
    Port ( switch_input : in std_logic_vector (11 downto 0);
           sseganode : out STD_LOGIC_VECTOR (3 downto 0);
           ssegcathode : out STD_LOGIC_VECTOR (7 downto 0);
           clockin : in std_logic);
end sevensegment;

architecture Behavioral of sevensegment is
signal clock : std_logic := '0';
signal sseg : STD_LOGIC_VECTOR (15 downto 0);
component clock_div is 
    Port (clockin : in std_logic;
        clockout : out STD_LOGIC);
end component;
component converter is
Port (input : in STD_LOGIC_VECTOR (11 downto 0);
      output: out STD_LOGIC_VECTOR (15 downto 0));
end component;
begin
bintodec_converter: converter port map (input => switch_input, output => sseg);
clock_divider: clock_div port map (clockout => clock, clockin => clockin);
process(clock)
variable digit : std_logic_vector (3 downto 0) := "0000" ; -- digit to be displayed 
variable digcount : integer range 0 to 3 := 0; -- to keep track of the anode that is asserted low
begin
if rising_edge(clock) then
case digcount is -- switches anodes and corresponding digit
when 0 => digit := sseg(3 downto 0); sseganode <= "1110";
when 1 => digit := sseg(7 downto 4); sseganode <= "1101";
when 2 => digit := sseg(11 downto 8); sseganode <= "1011";
when others => digit := sseg(15 downto 12); sseganode <= "0111";
end case;
case digit is -- switches cathodes according to the digit
when "0000" => ssegcathode <= "11000000";
when "0001" => ssegcathode <= "11111001";
when "0010" => ssegcathode <= "10100100";
when "0011" => ssegcathode <= "10110000";
when "0100" => ssegcathode <= "10011001";
when "0101" => ssegcathode <= "10010010";
when "0110" => ssegcathode <= "10000010";
when "0111" => ssegcathode <= "11111000";
when "1000" => ssegcathode <= "10000000";
when "1001" => ssegcathode <= "10010000";
when others => ssegcathode <= "11111111";
end case;
if digcount = 3 then
digcount := 0;
else
digcount := digcount + 1;
end if; 
end if;
end process;
end Behavioral;
