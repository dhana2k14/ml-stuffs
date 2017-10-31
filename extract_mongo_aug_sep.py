from pymongo import MongoClient
import pandas as pd
client_1 = MongoClient("mongodb://172.25.164.232:27017")
db_1 = client_1['KeyTelematics']
cursor_1 = db_1.TelemeteryData_June2016.find({"assetName":{'$in':["Polo GT","Hyundai Creta"]}})

from bson import json_util, ObjectId
from pandas.io.json import json_normalize
import json

data_1 = pd.DataFrame()

def mongo_to_dataframe(cursor_1):
	sanitized_1 = json.loads(json_util.dumps(cursor_1))
    normalized_1 = json_normalize(sanitized_1)
    df_1 = pd.DataFrame(normalized_1)
    dataX = data_1.append(df_1)
	dataX = dataX.drop(['_id.$oid','linked','ownerId','routes','event_id','originId'], axis = 1, inplace = True)
	print dataX.columns   
 
mongo_to_dataframe(cursor_1)

