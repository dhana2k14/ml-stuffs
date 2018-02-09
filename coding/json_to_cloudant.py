import requests

usr_name= 'dhanasekaranp'
usr_pwd = '7e1dc72ad13251f0cdb2b95e86dcc800b6d72e48'
usr_db = 'sample_db'

json = open('D:\\Json\\SampleJSON\\Telematics.json','r')

response = requests.post("https://"+usr_name+".cloudant.com/"+usr_db,
data = json,
auth = (usr_name, usr_pwd),
headers = {'Content-type':'application/json'})

if response.status_code == 200:
		print "OK:\n" + response.json()
else:
		print "ERROR:\n" + response.text