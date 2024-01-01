import serial
import mouse
from numpy import interp

ser = serial.Serial('COM4', 1000000, timeout=0)  # Open serial port
s1 = ser.read()                                  # s1 keeps first byte, s keeps second byte
s = ser.read()
iterate = 6                                      # keeps the byte index
rotational_data = [0, 0, 0]                      # keeps the last received angle data
screen_size = [1280, 800]                        # size of the screen space
click_count = 0
no_click_count = 0
while True:
    if ser.inWaiting() > 0:                      # If data is received
        s = ser.read()                           # read a byte
        if iterate == 6:                     # cycle through data index
            iterate = 0
        else:
            iterate += 1
        if s == b'\xcc' or s == b'\xaa':
            iterate = 0
            if s == b'\xcc':
                if click_count == 10:
                    mouse.press()
                    no_click_count = 0
                    click_count = 90
                else:
                    click_count += 1
            else:
                if (click_count >= 90) and (no_click_count >= 10):
                    mouse.release()
                    no_click_count = 0
                    click_count = 0
                else:
                    no_click_count += 1
                if click_count <= 90:
                    click_count = 0
        elif iterate == 2 or iterate == 4 or iterate == 6:        # two bytes are received and converted to int
            rotational_data[int((iterate-1)/2)] = int.from_bytes(s1 + s, "big", signed=True)
        else:
            s1 = s                                              # first byte is kept
        if iterate == 6 and int((rotational_data[0] + rotational_data[1])/2) == rotational_data[2]:
            # print(rotational_data)
            mouse.move(                                         # angle data is mapped to screen and cursor is moved
                screen_size[0] / 2 + interp(rotational_data[1], [-2000, 2000], [screen_size[0] / 2, -screen_size[0] / 2]),
                screen_size[1] / 2 + interp(rotational_data[0], [-2000, 2000], [screen_size[1] / 2, -screen_size[1] / 2]),
                absolute=True, duration=0)
