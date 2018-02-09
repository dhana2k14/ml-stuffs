from pymongo import MongoClient
import pandas as pd
client = MongoClient("mongodb://172.25.164.232:27017")
db = client['KeyTelematics']
cursor = db.TelemeteryData_June2016.find({"telemeteryData.assetName":{'$in':['Asset1']}}, {"TelemeteryData":1})


from bson import json_util, ObjectId
from pandas.io.json import json_normalize
import json

dataF = pd.DataFrame()
def mongo_to_dataframe(cursor):
    sanitized = json.loads(json_util.dumps(cursor))
    normalized = json_normalize(sanitized)
    df = pd.DataFrame(normalized)
    data = dataF.append(df)
    data.to_csv("C:\\asset.csv", index = False)

mongo_to_dataframe(cursor)
