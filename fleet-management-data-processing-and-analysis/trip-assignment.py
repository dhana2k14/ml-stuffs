
import pandas as pd, numpy as np, os, sys
import datetime, time
from pymongo import MongoClient
from bson import json_util, ObjectId
from pandas.io.json import json_normalize
import json

reload(sys)
sys.setdefaultencoding('utf8')

data = pd.DataFrame()

def trip_numbers(df, asset_names):
     
            df['date_utc'] = pd.to_datetime(df.date).dt.tz_localize('UTC').dt.tz_convert('Asia/Kolkata').dt.tz_localize(None)
            df['date_use'] = df.date_utc.apply(lambda x : x.strftime('%Y-%m-%d'))
            df['dup_loc'] = df.groupby(['date_use','lat', 'lon', 'speed','Odometer', 'engine','ignition']).cumcount().apply(lambda x: x + 1)
             
            df_final = pd.DataFrame()
                
            for asset in asset_names:
                        df_asset = df.loc[(df.assetName == asset) & (df.dup_loc == 1) & (df.speed > 0), :].copy()
                        df_asset = df_asset.reset_index(drop = True)
                        group_by_date = df_asset.groupby('date_use')
                         
                        df_fin = pd.DataFrame()
                         
                        for name in group_by_date:
                             
                                    df_asset['time_diff'] = (df_asset.date_utc - df_asset.date_utc.shift(1)).apply(lambda x: x/np.timedelta64(1, 'm'))                                        
                                    df_asset['row_num']  = df_asset.groupby('date_use').cumcount().apply(lambda x : x + 1)
                                     
 
                                    for index, row in df_asset.iterrows():
                                         
                                                if df_asset.loc[index, 'row_num'] == 1:                                                    
                                                            df_asset.loc[index, 'trip'] = 1
                                                             
                                                else:
                                                            if df_asset.loc[index, 'time_diff'] > 15.0:                                                                
                                                                        df_asset.loc[index, 'trip'] = df_asset.loc[index-1, 'trip'] + 1
                                                                         
                                                            else:
                                                                        df_asset.loc[index,'trip'] = df_asset.loc[index-1, 'trip']   
                                                                         
                        df_final = df_final.append(df_asset)
 
            grouped = df_final.groupby(['assetName', 'date_use', 'trip'])               
            df_fin = pd.DataFrame()
             
            for name, group in grouped:
                 
                        g = pd.DataFrame(group)                        
                        g['diff_speed'] = g.speed - g.speed.shift(1).fillna(np.NaN)                        
                        g['trip_distance'] = g.Odometer.iloc[-1] - g.Odometer.iloc[0]
                    
                        for index, row in g.iterrows():
                             
                                    if g.loc[index, 'diff_speed'] <= -40:                                                                                                            
                                                g.loc[index, 'harsh_braking'] = 1                                            
                     
                                    elif g.loc[index, 'diff_speed'] >= 40:                                                    
                                                g.loc[index, 'harsh_acclerating'] = 1 
                                             
                                    if g.loc[index, 'diff_speed'] < 0:                                        
                                                g.loc[index, 'brake_distance'] = np.round((g.loc[index, 'speed'] * g.loc[index, 'speed'] * 0.0784)/(2 * 9.8 * 0.7), 0)
                                                   
                        df_fin = df_fin.append(g)                                 
              
            df_fin.to_csv('sample_file.csv', index = False)
        
day = (datetime.datetime.utcnow() - datetime.timedelta(1)).day
month = (datetime.datetime.utcnow() - datetime.timedelta(1)).month
year = (datetime.datetime.utcnow()- datetime.timedelta(1)).year
 
dt = str(month) + '/' + str(day) + '/' + str(year)

print dt

client = MongoClient("mongodb://172.25.94.82:27017")
db = client['KeyTelematics']

cursor = db.TelemeteryData_Aug2017.find(
                                              
    {
      
    "telemeteryData.assetName":{'$in':["Polo GT","Hyundai Creta"]},
    "customData.date":{"$eq":dt}
    },
                                               
    {'telemeteryData':1, 'customData':1})

# print pd.DataFrame(list(cursor)).head()

def mongo_to_dataframe(cursor):
    sanitized = json.loads(json_util.dumps(cursor))
    normalized = json_normalize(sanitized)
    df_cursor = pd.DataFrame(normalized)
#     print df_cursor.head()
    
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
#                         , 'event_id'
                        , 'originId'
#                         , 'can_01'
#                         , 'can_5C'
#                         , 'can_1F'
                        , 'zones']
                        , axis = 1)    
         
    trip_numbers(dataX, ['Polo GT', 'Hyundai Creta'])    
    
     
mongo_to_dataframe(cursor)
 
 
 
     

    

