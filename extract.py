
from pymongo import MongoClient
import pandas as pd
client = MongoClient("mongodb://172.25.146.4:27017")
db= client['KeyTelematics']
cursor = db.TelemeteryData_June2016.find(
			{"telemeteryData.assetName":{'$in':["Polo GT","Hyundai Creta","Hexaware Nissan Sunny"]}},
			{"customData.time":1, "telemeteryData.telemetry.battery_voltage":1}).sort({"_id":-1}).limit(500)


from bson import json_util, ObjectId
from pandas.io.json import json_normalize
import json

data= pd.DataFrame()

def mongo_to_dataframe(cursor):
    sanitized = json.loads(json_util.dumps(cursor))
    normalized = json_normalize(sanitized)
    df = pd.DataFrame(normalized)
    df.columns = df.columns.str.replace('TelemeteryData.','')
    df.rename(columns = {'assetName':'assetName'}, inplace = True)
    df.columns = df.columns.str.replace('telemetry.','')
    dataX = data.append(df)
    dataX.head()
 
mongo_to_dataframe(cursor)
