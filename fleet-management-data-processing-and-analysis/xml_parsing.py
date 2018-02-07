import pandas as pd
import numpy as np
import sys
import os
import datetime, time, json
import xml.etree.ElementTree as ET
from pymongo import MongoClient
from bson import json_util
from pandas.io.json import json_normalize
from bson import json_util, ObjectId

client = MongoClient("mongodb://172.25.94.82:27017")
db = client['KeyTelematics']
 
tree = ET.parse('..\common\\fleet-management\\asset.xml')
data = pd.DataFrame()
 
lst = [t.strftime('%#m/%#d/%Y') for t in pd.date_range('11/01/2017', '11/05/2017')]
print (lst)

columns = [
            'accuracy',
            'Address',
            'airflow',
            'altitude',
            'AssetName',
            'Battery_voltage',
            'brakeDist',
            'brakeFlag',
            'date',
            'DatePart',
            'diffSpeed',
            'engine',
            'Engine_Temp',
            'Fuel_Used',
            'harsh_accl',
            'harsh_brake',
            'harsh_corner',
            'heading',
            'hours00counter',
            'idlecounter',
            'ignition',
            'lat',
            'lon',
            'Odo_counter',
            'overspeed',
            'Power_voltage',
            'rpm',
            'Speed',
            'Time',
            'totalDist_Date',
            'totalDist_Trip',
            'Trip',
]

for asset in tree.findall('Asset'):
            name = asset.get('Name')         
            cursor = db.TelemeteryData_Aug2017.find(                                             
            {             
            "telemeteryData.assetName":{'$in':[name]},
            "customData.date":  {'$in':lst}
            },                                                     
            {'telemeteryData':1, 'customData':1})          
 
            print (cursor.count())
            print (name)
             
            if cursor.count() > 0:
                  
                        df_json = list(cursor)
                        df_cursor = json_normalize(df_json)
                        df_cursor.columns = df_cursor.columns.str.replace('location.','')
                        df_cursor.columns = df_cursor.columns.str.replace('telemeteryData.','')
                        df_cursor.columns = df_cursor.columns.str.replace('telemetry.','')
                        df_cursor['date_utc'] = pd.to_datetime(df_cursor.date).dt.tz_localize('UTC').dt.tz_convert('Asia/Kolkata').dt.tz_localize(None)
                        df_cursor.drop(['date'], axis = 1, inplace = True)
                        df_cursor['date_use'] = df_cursor.date_utc.apply(lambda x : x.strftime('%Y-%m-%d'))                        
                        df_cursor['dup_loc'] = df_cursor.groupby(['date_use', 'lat', 'lon']).cumcount().apply(lambda x: x + 1)          
                        df_asset = df_cursor.loc[(df_cursor.assetName == name) & (df_cursor.dup_loc == 1) & (df_cursor.engine > 0) & (df_cursor.ignition > 0), :].copy()
                        df_asset = df_asset.reset_index(drop = True)
                          
                        data1 = pd.DataFrame()
                        group_by_date = df_asset.groupby('date_use')
  
                        for name, group in group_by_date:
                                       
                                    df_asset['time_diff'] = (df_asset.date_utc - df_asset.date_utc.shift(1)).apply(lambda x: x/np.timedelta64(1, 'm'))                                       
                                    df_asset['row_num']  = df_asset.groupby('date_use').cumcount().apply(lambda x : x + 1)
                                    df_asset_date = df_asset.loc[df_asset.date_use == name, :].copy()
                                    df_asset_date['totalDist_Date'] = df_asset_date.Odometer.iloc[-1] - df_asset_date.Odometer.iloc[0]
                                    df_asset_date['totalHours_Date'] = df_asset_date.hours_00_counter.iloc[-1] - df_asset_date.hours_00_counter.iloc[0]
  
                                    for index, row in df_asset_date.iterrows():                                        
                                                            
                                                if df_asset_date.loc[index, 'row_num'] == 1:
                                                              
                                                            df_asset_date.loc[index, 'Trip'] = 1                 
                                                    
                                                else:
                                                            if df_asset_date.loc[index, 'time_diff'] > 15.0:
                                                                           
                                                                        df_asset_date.loc[index, 'Trip'] = df_asset_date.loc[index-1, 'Trip'] + 1                                                                        
                                                            else:
                                                                        df_asset_date.loc[index,'Trip'] = df_asset_date.loc[index-1, 'Trip']   
                                    
                                    df2 = pd.DataFrame()                          
                                           
                                    grouped = df_asset_date.groupby(['Trip'])
                                                                            
                                    for name, group in grouped:
                                                
                                                    g = pd.DataFrame(group)     
                                                    g['diffSpeed'] = g.speed - g.speed.shift(1).fillna(np.NaN)                                                                                      
                                                    g['totalDist_Trip'] = g.Odometer.iloc[-1] - g.Odometer.iloc[0]
#                                                     g['totalHours_Trip'] = g.hours_00_counter.iloc[-1] - g.hours_00_counter.iloc[0]
                                                          
                                                    for index, row in g.iterrows():
                                                                
                                                                if g.loc[index, 'diffSpeed'] <= -40:
                                                                            
                                                                            g.loc[index, 'harsh_brake'] = 1
                                                                        
                                                                else:
                                                                            g.loc[index, 'harsh_brake'] = 0                                                                                                                                         
                                                                    
                                                                if g.loc[index, 'diffSpeed'] >= 40:
                                                                                 
                                                                            g.loc[index, 'harsh_accl'] = 1
                                                                        
                                                                else:                                                                    
                                                                            g.loc[index, 'harsh_accl'] = 0                                                                 
                                                                                             
                                                                if g.loc[index, 'diffSpeed'] < 0:
                                                                                       
                                                                            g.loc[index, 'brakeFlag'] = 1
                                                                            g.loc[index, 'brakeDist'] = np.round((g.loc[index, 'speed'] * g.loc[index, 'speed'] * 0.0784)/(2 * 9.8 * 0.7), 2)
                                                                           
                                                                elif g.loc[index, 'diffSpeed'] >= 0 or pd.isnull(g.loc[index, 'diffSpeed']):                                                                            
            
                                                                            g.loc[index, 'brakeFlag'] = 0
                                                                            g.loc[index, 'brakeDist'] = 0  
                                                          
                                                    g['harshAccl_cnt'] = g.harsh_accl.sum()
                                                    g['harshBrake_cnt'] = g.harsh_brake.sum()
                                                    g['avg_speed'] = np.round(g.speed.mean(), 0)
                                                    g['accl_deaccl'] = g.speed - g.speed.shift(1)
                                                    g['avg_accl'] = np.round(g.accl_deaccl[g.accl_deaccl > 0].mean(), 0)
                                                    g['dev_speed'] = g.speed - g.avg_speed
                                                    g['num_stops'] = len(g) - len(g.avg_speed)
                                                          
                                                    df2  = df2.append(g)
                                                                                                                                     
                                    data1 = data1.append(df2)
                                           
                        data = data.append(data1)
                        data.drop(['harsh_accl', 'harsh_brake'], axis = 1, inplace = True)
   
if len(data) > 0:
                      
            data['Time'] = data['date_utc'].astype(str).str.split(' ').str[1]      
            data.rename(index = str
                        , columns = {  "assetName":"AssetName"
                                     , "address":"Address"
                                     , "battery_voltage":"Battery_voltage"
                                     , "date_utc":"date"
                                     , "date_use":"DatePart"
                                     , "Engine Temp":"Engine_Temp"
                                     , "Fuel Used":"Fuel_Used"
                                     , "harshAccl_cnt":"harsh_accl"
                                     , "harshBrake_cnt":"harsh_brake"
                                     , "hours_00_counter":"hours00counter"
                                     , "idle_counter":"idlecounter"
                                     , "Odometer":"Odo_counter"
                                     , "power_voltage":"Power_voltage"
                                     , "RPM":"rpm"
                                     , "speed":"Speed"}
                        , inplace = True)
          
            data_tableau = data[columns]                      
            data_tableau = data_tableau.sort_index(axis = 1).copy()
            data_tableau.to_csv('sample_file.csv', index = False)
          
            data['dups'] = data.groupby(['AssetName','DatePart', 'Trip']).cumcount().apply(lambda x: x + 1)
            data = data.loc[(data.dups == 1), :].copy()             
            data.rename(index = str 
                        , columns = {  "AssetName":"assetName"
                                     , "DatePart":"trip_day"
                                     , "totalDist_Trip":"trip_dist"
                                     , "totalHours_Trip":"trip_time"
                                     , 'Trip':'trip_num'
                                     , "harsh_accl":"harsh_accl1"
                                     , "harsh_brake":"harsh_brake1"}
                        , inplace = True)
                
            data[[  'trip_num'
                  , 'trip_day'
                  , 'trip_dist'
                  , 'avg_speed'
                  , 'avg_accl'
                  , 'num_stops'
                  , 'harsh_accl1'
                  , 'harsh_brake1'
                  , 'assetName']].to_csv('file-for-app.csv', index = False)
                            
elif len(data) == 0:
              
            print ("There were no records exist")
#  
# # db_1.telemetry_tableau.insert(data.to_dict('records'), check_keys = False)    