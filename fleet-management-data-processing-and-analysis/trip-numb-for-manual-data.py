import os, sys, pandas as pd, numpy as np
import re

os.chdir("C:\\Users\\33093\\Downloads\\Tele\\Tele2")
path = os.getcwd()
files = os.listdir(path)
files_csv = [f for f in files if f[-3:] == 'csv']

df = pd.DataFrame() 
for f in files_csv:
    data = pd.read_csv(f, sep = ",", parse_dates = True)
    data['asset_name'] = 'Hyundai Creta'
    df = df.append(data)
    
df['date_utc'] = pd.to_datetime(df.Date).dt.tz_localize('UTC').dt.tz_convert('Asia/Kolkata').dt.tz_localize(None)
df.drop(['Date'], axis = 1, inplace = True)
df['date_use'] = df.date_utc.apply(lambda x : x.strftime('%Y-%m-%d'))
df['dup_loc'] = df.groupby(['date_use', 'Lat', 'Lon']).cumcount().apply(lambda x: x + 1)
df_asset = df.loc[(df.asset_name == 'Hyundai Creta') & (df.dup_loc == 1) & (df.engine > 0) & (df.ignition > 0), :].copy()
df_asset = df_asset.reset_index(drop = True)
 
df_asset.to_csv('test1.csv', index = False)
 
# data1 = pd.DataFrame()
# group_by_date = df_asset.groupby('date_use')
#  
# for name, group in group_by_date:
#              
#     df_asset['time_diff'] = (df_asset.date_utc - df_asset.date_utc.shift(1)).apply(lambda x: x/np.timedelta64(1, 'm'))                                       
#     df_asset['row_num']  = df_asset.groupby('date_use').cumcount().apply(lambda x : x + 1)
#     df_asset_date = df_asset.loc[df_asset.date_use == name, :].copy()
#     df_asset_date['totalDist_Date'] = df_asset_date.Odometer.iloc[-1] - df_asset_date.Odometer.iloc[0]
#     df_asset_date['totalHours_Date'] = df_asset_date.hours_00_counter.iloc[-1] - df_asset_date.hours_00_counter.iloc[0]
 
#     for index, row in df_asset_date.iterrows():
#         
#         if df_asset_date.loc[index, 'row_num'] == 1:
#             
#             df_asset_date.loc[index, 'Trip'] = 1                 
#                                                  
#         else:
#             
#             if df_asset_date.loc[index, 'time_diff'] > 15.0:
#                 
#                 df_asset_date.loc[index, 'Trip'] = df_asset_date.loc[index-1, 'Trip'] + 1                                                                        
#                 
#             else:
#                 
#                 df_asset_date.loc[index,'Trip'] = df_asset_date.loc[index-1, 'Trip']   
                                 
#     df2 = pd.DataFrame()                          
#                                         
#     grouped = df_asset_date.groupby(['Trip'])
#                                                                          
#     for name, group in grouped:
#                                              
#             g = pd.DataFrame(group)     
#             g['diffSpeed'] = g.speed - g.speed.shift(1).fillna(np.NaN)                                                                                      
#             g['totalDist_Trip'] = g.Odometer.iloc[-1] - g.Odometer.iloc[0]
#             g['totalHours_Trip'] = g.hours_00_counter.iloc[-1] - g.hours_00_counter.iloc[0]
#                                                        
#             for index, row in g.iterrows():
#                                                              
#                     if g.loc[index, 'diffSpeed'] <= -40:
#                                                                          
#                             g.loc[index, 'harsh_brake'] = 1
#                                                                      
#                     else:
#                             g.loc[index, 'harsh_brake'] = 0                                                                                                                                         
#                                                                  
#                     if g.loc[index, 'diffSpeed'] >= 40:
#                                                                               
#                             g.loc[index, 'harsh_accl'] = 1
#                                                                      
#                     else:                                                                    
#                             g.loc[index, 'harsh_accl'] = 0                                                                 
#                                                                                           
#                     if g.loc[index, 'diffSpeed'] < 0:
#                                                                                     
#                             g.loc[index, 'brakeFlag'] = 1
#                             g.loc[index, 'brakeDist'] = np.round((g.loc[index, 'speed'] * g.loc[index, 'speed'] * 0.0784)/(2 * 9.8 * 0.7), 2)
#                                                                         
#                     elif g.loc[index, 'diffSpeed'] >= 0 or pd.isnull(g.loc[index, 'diffSpeed']):                                                                            
#          
#                             g.loc[index, 'brakeFlag'] = 0
#                             g.loc[index, 'brakeDist'] = 0  
#                                                        
#             g['harshAccl_cnt'] = g.harsh_accl.sum()
#             g['harshBrake_cnt'] = g.harsh_brake.sum()
#             g['avg_speed'] = np.round(g.speed.mean(), 0)
#             g['accl_deaccl'] = g.speed - g.speed.shift(1)
#             g['avg_accl'] = np.round(g.accl_deaccl[g.accl_deaccl > 0].mean(), 0)
#             g['dev_speed'] = g.speed - g.avg_speed
#             g['num_stops'] = len(g) - len(g.avg_speed)
#                                                        
#             df2  = df2.append(g)
                                                                                                                                  
#     data1 = data1.append(df_asset_date)
#     
# data1.to_csv('test1.csv', index = False)
                                                      
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            