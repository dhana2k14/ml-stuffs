import os
import json

tty = open('/dev/ttyO1', 'r+')
ctr = 1
while 1:
	strJSON = tty.readline();
	if "DEVICE" in strJSON:
		# print(strJSON + '\n');
		code = json.JSONDecoder().decode(strJSON);
	# rCode = json.JSONDecoder().raw_decode(strJSON);
		print(code['DEVICE'][0]);
		SensorCode = code['DEVICE'][0]['D'];
		SensorValue = code['DEVICE'][0]['DA']
		if SensorCode == 30:
			print('Humidity : ' + str(SensorValue) + ' %\n')
		elif SensorCode == 31:
			print('Temperature : ' + str(SensorValue) + '%\n')
		else:
			print('Sensor Code : ' + str(SensorCode) + '\n')
			print('Sensor Value : ' + str(SensorValue) + '\n')
	# print(rCode + '\n');
	sleep(300)
