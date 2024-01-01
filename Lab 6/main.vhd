----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/08/2023 06:55:06 PM
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
    Port ( A : in STD_LOGIC_VECTOR (7 downto 0); -- Input A
           B : in STD_LOGIC_VECTOR (7 downto 0); --Input B
           gcd : out STD_LOGIC_VECTOR (7 downto 0); --Result
           clockin : in STD_LOGIC; -- Internal clock
           button : in STD_LOGIC); -- Button to load inputs to registers
end main;

architecture Behavioral of main is
component clock_div is
    Port(clockin : in STD_LOGIC;
         clockout : out STD_LOGIC);
end component;
component subtractor_8bit is
    Port ( a : in STD_LOGIC_VECTOR (7 downto 0);
           b : in STD_LOGIC_VECTOR (7 downto 0);
           sum : out STD_LOGIC_VECTOR (7 downto 0);
           borrow: out STD_LOGIC);
end component;

signal clk: std_logic; -- clock signal after division 
signal Q_A, Q_B, Q_out, D_A, D_B, D_out: std_logic_vector(7 downto 0); -- Signals to be connected to the registers
signal diff: std_logic_vector (7 downto 0); -- Q_A - Q_B 
begin
gcd <= Q_out; -- Output Register connections
subtractor: subtractor_8bit Port map(a => Q_A, b => Q_B, sum => diff, borrow => open); -- 8 bit subtractor
clock_divider: clock_div Port map(clockin => clockin, clockout => clk); -- 100 MHz to 1 KHz clock divider

Process(clk)
begin
    if rising_edge(clk) then -- Creating Registers
        Q_A <= D_A;
        Q_B <= D_B;
        Q_out <= D_out;
    end if; 
end process;

process(clk)
begin      
    D_out <= (others => '0'); -- Out register is defaulted to zeros
    if button = '1' then -- Load inputs to input registers
        D_A <= A;
        D_B <= B;
    else                  -- gcd algorithm
        if Q_A > Q_B then 
            D_A <= diff;
            D_B <= Q_B;
        elsif Q_A < Q_B then
            D_B <= Q_A;
            D_A <= Q_B;
        else 
            D_A <= Q_A;
            D_B <= Q_B;
            D_out <= Q_A;
        end if;
    end if;
end process;
end Behavioral;
