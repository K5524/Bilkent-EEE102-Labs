----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/20/2023 06:11:34 PM
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

entity main is
    Port ( a : in STD_LOGIC_VECTOR (7 downto 0);
           b : in STD_LOGIC_VECTOR (7 downto 0);
           buttons : in STD_LOGIC_VECTOR (4 downto 0);
           result : out STD_LOGIC_VECTOR (7 downto 0);
           overflow : out STD_LOGIC);
end main;

architecture Behavioral of main is
signal a_adder : STD_LOGIC_VECTOR (7 downto 0);
signal b_adder : STD_LOGIC_VECTOR (7 downto 0);
signal result_adder : STD_LOGIC_VECTOR (7 downto 0);
signal result_arithmetic_right : STD_LOGIC_VECTOR (7 downto 0);
signal result_logical_right : STD_LOGIC_VECTOR (7 downto 0);
signal result_logical_left : STD_LOGIC_VECTOR (7 downto 0);
signal result_rotate_right : STD_LOGIC_VECTOR (7 downto 0);
signal result_rotate_left : STD_LOGIC_VECTOR (7 downto 0);
signal result_onescomplement : STD_LOGIC_VECTOR (7 downto 0);
signal result_and : STD_LOGIC_VECTOR (7 downto 0);
signal result_or : STD_LOGIC_VECTOR (7 downto 0);
signal result_xor : STD_LOGIC_VECTOR (7 downto 0);
signal add_sub_sel : STD_LOGIC;
component adder_8bit is
    Port ( a : in STD_LOGIC_VECTOR (7 downto 0);
           b : in STD_LOGIC_VECTOR (7 downto 0);
           add_sub : in STD_LOGIC;
           sum : out STD_LOGIC_VECTOR;
           overflow : out STD_LOGIC);
end component;
component ones_complement is
    Port ( a : in STD_LOGIC_VECTOR (7 downto 0);
           result : out STD_LOGIC_VECTOR (7 downto 0));
end component;
component logical_shift_left is
    Port ( a : in STD_LOGIC_VECTOR (7 downto 0);
           result : out STD_LOGIC_VECTOR (7 downto 0));
end component;
component logical_shift_right is
    Port ( a : in STD_LOGIC_VECTOR (7 downto 0);
           result : out STD_LOGIC_VECTOR (7 downto 0));
end component;
component arithmetic_shift_right is
    Port ( a : in STD_LOGIC_VECTOR (7 downto 0);
           result : out STD_LOGIC_VECTOR (7 downto 0));
end component;
component rotate_left is
    Port ( a : in STD_LOGIC_VECTOR (7 downto 0);
           result : out STD_LOGIC_VECTOR (7 downto 0));
end component;
component rotate_right is
    Port ( a : in STD_LOGIC_VECTOR (7 downto 0);
           result : out STD_LOGIC_VECTOR (7 downto 0));
end component;
component bitwise_and is
    Port ( a : in STD_LOGIC_VECTOR (7 downto 0);
           b : in STD_LOGIC_VECTOR (7 downto 0);
           result : out STD_LOGIC_VECTOR (7 downto 0));
end component;
component bitwise_or is
    Port ( a : in STD_LOGIC_VECTOR (7 downto 0);
           b : in STD_LOGIC_VECTOR (7 downto 0);
           result : out STD_LOGIC_VECTOR (7 downto 0));
end component;
component bitwise_xor is
    Port ( a : in STD_LOGIC_VECTOR (7 downto 0);
           b : in STD_LOGIC_VECTOR (7 downto 0);
           result : out STD_LOGIC_VECTOR (7 downto 0));
end component;
begin
onescomplement: ones_complement port map (a => a,  result => result_onescomplement);
arithmeticshiftr: arithmetic_shift_right port map (a => a,  result => result_arithmetic_right);
logicalshiftr: logical_shift_right port map (a => a,  result => result_logical_right);
logicalshiftl: logical_shift_left port map (a => a,  result => result_logical_left);
rotater: rotate_right port map (a => a,  result => result_rotate_right);
rotatel: rotate_left port map (a => a,  result => result_rotate_left);
bitw_and: bitwise_and port map (a => a, b => b,  result => result_and);
bitw_or: bitwise_or port map (a => a, b => b,  result => result_or);
bitw_xor: bitwise_xor port map (a => a, b => b,  result => result_xor);
addsub: adder_8bit port map (a => a_adder, b => b_adder,  sum => result_adder, add_sub => add_sub_sel, overflow => overflow);

process(buttons) begin
    case buttons is        
        when "01000" => a_adder <= a; b_adder <= b; add_sub_sel <= '0';                  -- Add 
		when "00100" => a_adder <= a; b_adder <= b; add_sub_sel <= '1';                  -- Subtract
		when "00010" => a_adder <= a; b_adder <= "00000001"; add_sub_sel <= '0';         -- Increment
		when "00001" => a_adder <= a; b_adder <= "11111111"; add_sub_sel <= '0';         -- Decrement
		when "10000" => a_adder <= "00000000"; b_adder <= a; add_sub_sel <= '1';         -- Negate
		when others  => a_adder <= "00000000"; b_adder <= "00000000"; add_sub_sel <= '0';
	end case;
end process;

with buttons select
    result <= result_adder              when "01000",   --Add
              result_adder              when "00100",   --Subtract
              result_adder              when "00010",   --Increment
              result_adder              when "00001",   --Decrement
              result_adder              when "10000",   --Negate
              a                         when "00000",   --Pass Through
              result_logical_left       when "10010",   --Logical Left Shift
              result_logical_right      when "00110",   --Logical Right Shift
              result_logical_left       when "10001",   --Arithmetic Left Shift
              result_arithmetic_right   when "00101",   --Arithmetic Right Shift
              result_rotate_left        when "11000",   --Rotate Left Shift
              result_rotate_right       when "01100",   --Rotate Right Shift
              result_onescomplement     when "10100",   --One's Complement
              result_and                when "00011",   --Bitwise AND
              result_or                 when "01010",   --Bitwise OR
              result_xor                when "01001",   --Bitwise XOR
              "00000000"                when others;   
end Behavioral;
