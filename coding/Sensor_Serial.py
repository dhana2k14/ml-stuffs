import serial

ser = serial.Serial('/dev/ttyO1', baudrate = 115200, timeout = 1)
print ser.readline()
ser.sleep(300)