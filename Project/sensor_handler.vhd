library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity sensor_handler is
    Port ( clockin : in STD_LOGIC;                              -- Clock
           sda   : INOUT  STD_LOGIC;                            -- Data pin for I2C
           scl   : INOUT  STD_LOGIC;                            -- Clock pin for I2C
           button: in std_logic;                                -- Button for angle reference reset
           r_av, r_y, r_z: out std_logic_vector(15 downto 0)    -- Referenced angle data for Y and Z axis and their average (degrees*100)
         );
end sensor_handler;

architecture Behavioral of sensor_handler is

Component i2c_master is
  Port(
    clk       : IN     STD_LOGIC;                    --system clock
    reset_n   : IN     STD_LOGIC;                    --active low reset
    ena       : IN     STD_LOGIC;                    --latch in command
    addr      : IN     STD_LOGIC_VECTOR(6 DOWNTO 0); --address of target slave
    rw        : IN     STD_LOGIC;                    --'0' is write, '1' is read
    data_wr   : IN     STD_LOGIC_VECTOR(7 DOWNTO 0); --data to write to slave
    busy      : OUT    STD_LOGIC;                    --indicates transaction in progress
    data_rd   : OUT    STD_LOGIC_VECTOR(7 DOWNTO 0); --data read from slave
    ack_error : BUFFER STD_LOGIC;                    --flag if improper acknowledge from slave
    sda       : INOUT  STD_LOGIC;                    --serial data output of i2c bus
    scl       : INOUT  STD_LOGIC);                   --serial clock output of i2c bus
END component;


signal enable, rw, busy, error: std_logic;                          -- to be connected to i2c_master
signal address: std_logic_vector(6 downto 0) := "1101000";          -- I2C Address of the sensor
signal data_r, data_w: std_logic_vector(7 downto 0);                -- data_r: Data read, data_w: Data to be written
type state_type is(hold, read, setup);                              -- setup: configures the sensor, read: reads the data from the sensor, hold: waits for defined nb of clock cycles
signal state: state_type:= setup;
signal busy_prev: std_logic := '0';                                 -- Busy signal at the previous rising edge
signal data: std_logic_vector(15 downto 0) := (others => '0');      -- For keeping the first byte(s) of data if the data is more than one byte until all bytes are read
signal gyr_x, gyr_y, gyr_z: std_logic_vector(23 downto 0) := (others => '0'); -- Gyroscope data (degrees/s *1000)

begin

IIC: i2c_master Port map (clk => clockin, reset_n => '1', ena => enable, addr => address, rw => rw,     -- Component handling I2C transmission
data_wr => data_w, busy => busy, data_rd => data_r, ack_error => error, sda => sda, scl => scl);

process(clockin, button)

variable dir_x, dir_y, dir_z: integer:= 0;                                  -- Keeps the referanced angle data (degrees*1000)
variable busy_cnt: INTEGER range 0 to 23:= 0;                               -- Keeps the transmission index
variable clock_counter: INTEGER range 0 to 100000000:= 100000000;           -- Keeps the clock count
variable stime: integer range 0 to 654311385:= 0;                           -- Keeps the time of data
variable last_stime: integer range 0 to 654311385:= 0;                      -- Keeps the previous time of data

constant cmd_addr: std_logic_vector(7 downto 0) := "01111110";              -- Address of command register
constant softreset_cmd: std_logic_vector(7 downto 0) := "10110110";         -- Soft Reset Command
constant acc_pwr_normal_cmd: std_logic_vector(7 downto 0) := "00010001";    -- Accelerometer Normal Power Mode Command
constant gyr_pwr_normal_cmd: std_logic_vector(7 downto 0) := "00010101";    -- Gyroscope Normal Power Mode Command
constant mag_pwr_normal_cmd: std_logic_vector(7 downto 0) := "00011001";    -- Magnetometer Normal Power Mode Command
constant gyr_conf: std_logic_vector(7 downto 0) := "00101100";              -- Gyroscope Configuration (odr=1600Hz) 
constant gyr_range: std_logic_vector(7 downto 0) := "00000100";             -- Gyroscope Range = 125dps
constant gyr_multiplier_125dps: integer := 3811; -- *10^-6                  -- Multiplier for gyroscope data for 125 dps range (sensor_data * gyr_multiplier_125dps = dps*10^6)
constant gyr_conf_addr: std_logic_vector(7 downto 0) := "01000010";         -- Address of gyroscope configuration register
constant gyr_range_addr: std_logic_vector(7 downto 0) := "01000011";        -- Address of gyroscope range register
constant gyr_data_addr: std_logic_vector(7 downto 0) := "00001100";         -- Address of gyroscope data register
constant acc_conf_addr: std_logic_vector(7 downto 0) := "01000000";         -- Address of accelerometer configuration register
constant acc_range_addr: std_logic_vector(7 downto 0) := "01000001";        -- Address of accelerometer range register
constant acc_conf: std_logic_vector(7 downto 0) := "00101100";              -- Accelerometer configuration
constant acc_range: std_logic_vector(7 downto 0) := "00000011";             -- Accelerometer Range = 2G

begin
if rising_edge(clockin) then

r_y <= std_logic_vector(to_signed(dir_y/10,16));                            -- Referenced angle data for Y and Z axis and their average (degrees*100)
r_z <= std_logic_vector(to_signed(dir_z/10,16));
r_av <= std_logic_vector(to_signed((dir_y/10 + dir_z/10)/2, 16));

if button = '1' then                                                        -- Reset the reference angle
dir_x := 0;
dir_y := 0;
dir_z := 0;
end if;

case state is
WHEN setup =>
    busy_prev <= busy;                              -- capture the value of the previous i2c busy signal
    IF(busy_prev = '0' AND busy = '1') THEN         -- i2c busy just went high
        busy_cnt := busy_cnt + 1;                   -- counts the times busy has gone from low to high during transaction
    END IF;
    CASE busy_cnt IS                                -- busy_cnt keeps track of which command we are on
    WHEN 0 =>                                       -- no command latched in yet
        enable <= '1';                              -- initiate the transaction
        rw <= '0';                                  -- command is a write
        data_w <= cmd_addr;                         -- command adress to be written
    WHEN 1 =>                                       -- 1st busy high: command 1 latched, okay to issue command 2
        data_w <= softreset_cmd;                    -- Command to perform soft reset of the sensor
    WHEN 2 | 5 | 8 | 11 | 14 | 17 | 20 =>           -- Wait for required delay between commands
        enable <= '0';                              -- End transaction
        IF(busy = '0') THEN                         -- Wait until the acknowledge bit
        if clock_counter = 0 then
        busy_cnt := busy_cnt + 1;                   -- Using the same variable to track the waiting states
        clock_counter := 100000000;                 -- Wait for 1 second
        else
        clock_counter := clock_counter - 1;
        end if;
        end if;
    WHEN 3 =>
        enable <= '1';                              -- initiate the transaction
        data_w <= cmd_addr;                         -- Command register to be written
    WHEN 4 =>                                       
        data_w <= acc_pwr_normal_cmd;               -- Command to set Acc power to normal
    WHEN 6 =>
        enable <= '1';                              -- initiate the transaction
        data_w <= gyr_conf_addr;                    -- gyro configuration register to be written
    WHEN 7 =>                                  
        data_w <= gyr_conf;                         -- Gyroscope configuration is set
    WHEN 9 =>
        enable <= '1';                              -- initiate the transaction
        data_w <= gyr_range_addr;                   -- Gyro range register to be written
    WHEN 10 =>                                  
        data_w <= gyr_range;                        -- Set gyro range
    WHEN 12 =>
        enable <= '1';                              -- initiate the transaction
        data_w <= acc_conf_addr;                    -- Acc configuration register to be written
    WHEN 13 =>                                  
        data_w <= acc_conf;                         -- Accelerometer configuration is set
    WHEN 15 =>
        enable <= '1';                              -- initiate the transaction
        data_w <= acc_range_addr;                   -- Acc range register to be written
    WHEN 16 =>                                  
        data_w <= acc_range;                        -- Accelerometer range is set
    WHEN 18 =>
        enable <= '1';                              -- initiate the transaction
        data_w <= cmd_addr;                         -- command register to be written
    WHEN 19 =>                                      
        data_w <= gyr_pwr_normal_cmd;               -- Set Gyroscope power mode to normal
    WHEN 21 =>
        enable <= '1';                              -- initiate the transaction
        data_w <= cmd_addr;                         -- command register to be written
    WHEN 22 =>                                  
        data_w <= mag_pwr_normal_cmd;               -- Set Magnetometer power mode to normal
    WHEN 23 =>
        enable <= '0';                              -- End transaction
        IF(busy = '0') THEN                         
            busy_cnt := 0;                          -- Reset busy_cnt
            state <= hold;                          -- Go to hold state
        end if;
    WHEN OTHERS => NULL;
    end case;


WHEN read =>
    busy_prev <= busy;                              -- capture the value of the previous i2c busy signal
    IF(busy_prev = '0' AND busy = '1') THEN         -- i2c busy just went high
        busy_cnt := busy_cnt + 1;                   -- counts the times busy has gone from low to high during transaction
    END IF;
    case busy_cnt is
    WHEN 0 =>                                       -- no command latched in yet
        enable <= '1';                              -- initiate the transaction
        rw <= '0';                                  -- command is a write
        data_w <= gyr_data_addr;                    -- Gyroscope data register address to be read
    WHEN 1 =>                                  
        rw <= '1';                                  -- Switch to read
    WHEN 2 | 4 | 6 | 14 =>
        IF(busy = '0') THEN                         -- Wait until the acknowledge bit
        data (7 downto 0) <= data_r;                -- First byte to be kept for one clock cycle
        end if;
    WHEN 3 =>                                       
        IF(busy = '0') THEN                         -- Convert X axis gyro data(full range (+-125 dps) corresponding to 16-bit signed number) to degrees/s *1000
        gyr_x <= std_logic_vector(to_signed((gyr_multiplier_125dps*to_integer(signed(data_r&data(7 downto 0)))/1000), 24));
        end if;
    WHEN 5 =>
        IF(busy = '0') THEN                         -- Convert Y axis gyro data(full range (+-125 dps) corresponding to 16-bit signed number) to degrees/s *1000
        gyr_y <= std_logic_vector(to_signed((gyr_multiplier_125dps*to_integer(signed(data_r&data(7 downto 0)))/1000), 24));
        end if;
    WHEN 7 =>
        IF(busy = '0') THEN                         -- Convert Z axis gyro data(full range (+-125dps) corresponding to 16-bit signed number) to degrees/s *1000
        gyr_z <= std_logic_vector(to_signed((gyr_multiplier_125dps*to_integer(signed(data_r&data(7 downto 0)))/1000), 24));
        end if;
    WHEN 15 =>
        IF(busy = '0') THEN                         -- Keep second byte of sensor time
        data (15 downto 8) <= data_r;
        end if;
    WHEN 16 =>
        enable <= '0';                              -- End transaction
        IF(busy = '0') THEN
        last_stime := stime;                        -- Keep time of the previous data  
        stime:= (39*to_integer(unsigned(data_r&data)));     -- calculate sensor time (us)
        dir_x := dir_x + ((stime-last_stime)*to_integer(signed(gyr_x))/1000000);    -- calculate change in rotation of x axis
        dir_y := dir_y + ((stime-last_stime)*to_integer(signed(gyr_y))/1000000);    -- calculate change in rotation of y axis
        dir_z := dir_z + ((stime-last_stime)*to_integer(signed(gyr_z))/1000000);    -- calculate change in rotation of z axis
        busy_cnt := 0;
        state <= hold;                                                              -- Hold for defined nb of clock cycles
        end if;
    WHEN others => NULL;
    end case;

   
When hold =>                                                -- Do nothing for a specified nb of clock cycles and go to read after that    
    if clock_counter = 0 then
        clock_counter := 100000000;
        state <= read;
        else
        clock_counter := clock_counter - 1000;
        end if; 
end case;

end if;
end process;  

end Behavioral;
