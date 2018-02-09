import urllib2
import json
import pandas as pd
from pandas.io.json import json_normalize
from bson import json_util

url = 'https://api.edmunds.com/api/vehicle/v2/makes?fmt=json&api_key=bh5n4r5yxvkqycjh4vr4jsg4'
response = urllib2.urlopen(url)
json_data = json.loads(json_util.dumps(response.read()))
json_df = json_normalize(json_data)
df = pd.DataFrame(json_df)

print df.head()