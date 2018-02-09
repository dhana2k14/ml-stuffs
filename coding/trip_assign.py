
import pandas as pd
import numpy as np
df = pd.read_csv('D:\\IoT\\tele_history_Sep20_Oct13_Updated.csv', nrows = 5000)
df_base = df.loc[df.assetName == 'Polo GT', :].copy()
df_base.reset_index(drop = True, inplace = True)
df_base['date_use'] = pd.to_datetime(df_base.date)
df_base['date_lag'] = df_base.groupby('customData_date')['date_use'].shift(1)
df_base['time_diff'] = abs(df_base.date_lag.dt.minute - df_base.date_use.dt.minute)
df_base['row_num']  = df_base.groupby('customData_date').cumcount().apply(lambda x : x + 1)

for name, group in df_base.groupby(['customData_date']):
    for index, row in df_base.iterrows():
        if df_base.loc[index, 'row_num'] == 1:
            df_base.loc[index, 'trip'] = 1
        else:
            if df_base.loc[index, 'time_diff'] > 20:
                df_base.loc[index, 'trip'] = df_base.loc[index-1, 'trip'] + 1
            else:
                df_base.loc[index,'trip'] = df_base.loc[index-1, 'trip']
                
df_base[['customData_date','date_use','date_lag', 'time_diff', 'row_num', 'trip']].to_csv('D:\\temp.csv', index = False)