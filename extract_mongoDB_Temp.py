
from pymongo import MongoClient
import pandas as pd
client_1 = MongoClient("mongodb://172.25.164.232:27017")
db_1 = client_1['KeyTelematics']
cursor_1 = db_1.TelemeteryData_June2016.find({"telemeteryData.assetName":{'$in':["Polo GT","Hyundai Creta"]}}, {"telemeteryData":1, "customData":1})


from bson import json_util, ObjectId
from pandas.io.json import json_normalize
import json

data_1 = pd.DataFrame()

def mongo_to_dataframe(cursor_1):
    sanitized_1 = json.loads(json_util.dumps(cursor_1))
    normalized_1 = json_normalize(sanitized_1)
    df_1 = pd.DataFrame(normalized_1)
    df_1.columns = df_1.columns.str.replace('telemeteryData.','')
    df_1.rename(columns = {'assetName':'assetName'}, inplace = True)
    df_1.columns = df_1.columns.str.replace('location.','')
    df_1.columns = df_1.columns.str.replace('telemetry.','')
    dataX = data_1.append(df_1)
    dataX.to_csv('D:\\IoT\\tele_history.csv', index = False)
 
mongo_to_dataframe(cursor_1)