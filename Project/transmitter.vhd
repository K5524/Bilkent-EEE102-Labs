library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity transmitter is
    Port ( data_z : in STD_LOGIC_VECTOR (15 downto 0);          -- Referenced angle data for Z axis to be transmitted via UART
           data_y : in STD_LOGIC_VECTOR (15 downto 0);          -- Referenced angle data for Y axis to be transmitted via UART
           data_av : in STD_LOGIC_VECTOR (15 downto 0);         -- Average of angles for Z and Y axis for redundancy check
           uart_serial : out STD_LOGIC;                         -- UART serial output
           clock : in STD_LOGIC);                               -- Clock
end transmitter;

architecture Behavioral of transmitter is
type state_type is(hold, transmit);                             -- Hold: Holds for defined nb of clock cycles, Transmit: transmits the data over UART
signal state: state_type:= hold;
signal data_tx: std_logic_vector(7 downto 0);                   -- A byte of data to be transmitted on the next transmission
signal tx_data_latch: std_logic;                                -- For latching a byte of data to UART component and starting transmission
signal tx_active: std_logic;                                    -- Signal of UART components state: 1 -> Transmission in progress 0 -> Waiting for transmission start signal
signal tx_done: std_logic;                                      -- Signal coming from UART component signifying copmletion of transmission: 1 -> Transmission is completed
component uart is 
generic (
    g_CLKS_PER_BIT : integer := 100     -- 100MHz / 1 MHz       -- Clock / UART Baud rate
    );
port (
    Clk       : in  std_logic;                                  -- Clock
    TX_DV     : in  std_logic;                                  -- For latching a byte of data to UART component and starting transmission
    TX_Byte   : in  std_logic_vector(7 downto 0);               -- A byte of data to be transmitted on the next transmission
    TX_Active : out std_logic;                                  -- Signal of UART components state: 1 -> Transmission in progress 0 -> Waiting for transmission start signal
    TX_Serial : out std_logic;                                  -- UART serial output
    TX_Done   : out std_logic                                   -- Signal coming from UART component signifying copmletion of transmission: 1 -> Transmission is completed
    );
end component;
begin
uart_transmitter: uart Port Map(Clk => clock, TX_DV => tx_data_latch, TX_Byte => data_tx, TX_Active => tx_active, TX_Serial => uart_serial,TX_Done => tx_done); -- Component for handling uart transmission of a byte of data

process(clock)
variable tx_cnt: INTEGER range 0 to 5:= 0;                  -- Keeping the index of transmitted data
variable clock_counter: INTEGER range 0 to 100:= 100;       -- Keeping the clock count for hold state
begin
if rising_edge(clock) then
if state = transmit then
    if tx_cnt = 0 then                                      -- Select which data to be transmitted according to tx_cnt 
        data_tx <= data_y(15 downto 8);                     -- Transmit MSB of Y axis data
    elsif tx_cnt = 1 then
        data_tx <= data_y(7 downto 0);                      -- Transmit LSB of Y axis data
    elsif tx_cnt = 2 then 
        data_tx <= data_z(15 downto 8);                     -- Transmit MSB of Z axis data
    elsif tx_cnt = 3 then
        data_tx <= data_z(7 downto 0);                      -- Transmit LSB of Z axis data
    elsif tx_cnt = 4 then 
        data_tx <= data_av(15 downto 8);                    -- Transmit MSB of data average
    elsif tx_cnt = 5 then
        data_tx <= data_av(7 downto 0);                     -- Transmit LSB of data average
    end if;
    
    if tx_active = '0' and tx_done = '0' then               -- start transmission
        tx_data_latch <= '1';   
    elsif tx_active = '1' and tx_done = '0' then            -- transmission in progress
        tx_data_latch <= '0';
    elsif tx_active = '0' and tx_done = '1' then            -- Transmission completed
        if tx_cnt = 5 then
            tx_data_latch <= '0';
            data_tx <= (others => '0');                     -- end transmission
            tx_data_latch <= '0';
            tx_cnt:= 0;
            state <= hold;                                  -- Hold
        else
            tx_cnt := tx_cnt + 1;                            -- Continue with the next transmission
        end if;
    else
        tx_data_latch <= '0';
    end if;
    
elsif state = hold then                                      -- Hold for 100 clock cycles
    if clock_counter = 0 then
        clock_counter := 100;
        state <= transmit;                                    -- Transmit again
    else
        clock_counter := clock_counter - 1;
    end if; 
end if;
end if;
end process;
end Behavioral;
