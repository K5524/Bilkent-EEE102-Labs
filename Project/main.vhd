----------------------------------------------------------------------------------
--EEE102 Project
--Kaan Ermertcan
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity main is
    Port ( clockin : in STD_LOGIC;                              -- 100 MHz Clock of Basys3
           sda   : INOUT  STD_LOGIC;                            -- Data pin for I2C 
           scl   : INOUT  STD_LOGIC;                            -- Clock pin for I2C 
           sseganode : out STD_LOGIC_VECTOR (3 downto 0);       -- Anodes of Seven Segment Display
           ssegcathode : out STD_LOGIC_VECTOR (7 downto 0);     -- Cathodes of Seven Segment Display
           switch: in std_logic;                                -- Sliding Switch on Basys 3
           uart_tx: out std_logic;                              -- Uart Tx pin going to FT2232HQ
           button: in std_logic);                               -- Center button for reference reset 
end main;


architecture Behavioral of main is

component sevensegment is
    Port ( switch_input : in std_logic_vector (11 downto 0);    -- Data to be displayed
           sseganode : out STD_LOGIC_VECTOR (3 downto 0);       -- Anodes of Seven Segment Display
           ssegcathode : out STD_LOGIC_VECTOR (7 downto 0);     -- Cathodes of Seven Segment Display
           clockin : in std_logic);                             -- Clock
end component;

component transmitter is
    Port ( data_z : in STD_LOGIC_VECTOR (15 downto 0);          -- Referenced angle data for Z axis to be transmitted via UART
           data_y : in STD_LOGIC_VECTOR (15 downto 0);          -- Referenced angle data for Y axis to be transmitted via UART
           data_av : in STD_LOGIC_VECTOR (15 downto 0);         -- Average of angles for Z and Y axis for redundancy check
           uart_serial : out STD_LOGIC;                         -- UART serial output
           clock : in STD_LOGIC);                               -- Clock
end component;

component sensor_handler is
    Port ( clockin : in STD_LOGIC;                              -- Clock
           sda   : INOUT  STD_LOGIC;                            -- Data pin for I2C 
           scl   : INOUT  STD_LOGIC;                            -- Clock pin for I2C 
           button: in std_logic;                                -- Input for reference Reset
           r_av, r_y, r_z: out std_logic_vector(15 downto 0));  -- Referenced angle data for Y and Z axis and their average (degrees*100)
end component;


signal to_ss: std_logic_vector(11 downto 0);                    -- Data signal going to seven segment display
signal r_av, r_y, r_z: std_logic_vector(15 downto 0):= (others => '0'); -- Referenced angle data for Y and Z axis and their average (degrees*100)


begin

seven_segment: sevensegment Port Map(clockin => clockin, sseganode => sseganode, ssegcathode => ssegcathode, switch_input => to_ss); -- Component handling Seven segment display
data_transmitter: transmitter Port map(clock => clockin, data_y => r_y, data_z => r_z, data_av => r_av, uart_serial => uart_tx);     -- Component handling transmission of angle data over UART 
sensor: sensor_handler Port map(clockin => clockin, sda => sda, scl => scl, button => button, r_av => r_av, r_y => r_y, r_z => r_z); -- Component handling communication with the sensor and processing of sensor data

with switch select
to_ss <= std_logic_vector(to_unsigned(abs(to_integer(signed(r_y))/10),12)) when '1',        -- to see angle data for Y axis on seven segment (degrees*10)
         std_logic_vector(to_unsigned(abs(to_integer(signed(r_z))/10),12)) when '0',        -- to see angle data for Z axis on seven segment (degrees*10)
         (others => '0')                                                   when others;

end Behavioral;
