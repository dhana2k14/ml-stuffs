
'''
loading necessary packages
'''

import pandas as pd, numpy as np, os, sys
import datetime, time
from pymongo import MongoClient
from bson import json_util, ObjectId
from pandas.io.json import json_normalize
import json


'''
Connection string to connect to mongo DB instance running in the cloud envir.
'''

client = MongoClient("mongodb://172.25.164.232:27017")
db = client['KeyTelematics']

'''
standard mongo DB query method goes here
'''

cursor = db.TelemeteryData_June2016.find(
                                             
    {
     
     "telemeteryData.assetName":{'$in':["Polo GT","Hyundai Creta"]},
     "customData.date":{"$gte":"10/24/2016", "$lte":"10/25/2016"}
    },
                                              
    {'telemeteryData':1, 'customData':1})

'''
funtion to convert the list of BSON documents into data frame using Pandas
'''

def mongo_to_dataframe(cursor):
    sanitized = json.loads(json_util.dumps(cursor))
    normalized = json_normalize(sanitized)
    df_cursor = pd.DataFrame(normalized)
    df_cursor.columns = df_cursor.columns.str.replace('location.','')
    df_cursor.columns = df_cursor.columns.str.replace('telemeteryData.','')
    df_cursor.columns = df_cursor.columns.str.replace('telemetry.','')
    dataX = data.append(df_cursor)    
    dataX['customData_time'] = dataX['date'].str.split(' ').str[1]
    dataX['customData_date'] = dataX['date'].str.split(' ').str[0]
    dataX = dataX.drop(['_id.$oid'
                        , 'linked'
                        , 'ownerId'
                        , 'routes'
                        , 'event_id'
                        , 'originId'
                        , 'can_01'
                        , 'can_5C'
                        , 'can_1F'
                        , 'zones']
                        , axis = 1)
						
	'''
	
	print the top 6 records of a dataframe 
	
	'''		
						
	print dataX.head()
 
mongo_to_dataframe(cursor)
