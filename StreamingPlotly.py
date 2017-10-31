import plotly
import numpy as np
import plotly.plotly as py
import plotly.tools as tls
import plotly.graph_objs as go

plotly.tools.set_credentials_file(username = 'dhana', api_key = 'h5qictce9t', stream_ids = ('wzwtxkdhnp','9ovqspax14'))
stream_ids = plotly.tools.get_credentials_file()['stream_ids']


stream_id = stream_ids[0]

stream_1 = go.Stream(token = stream_id, maxpoints = 80)

trace1 = go.Scatter(x = [], y = [], stream = stream_1)
data = go.Data([trace1])

layout = go.Layout(title='Time Series')
fig = go.Figure(data=data, layout=layout)
py.plot(fig, filename='python-streaming')

s = py.Stream(stream_id)
s.open()

import datetime
import time

i = 0
k = 5

time.sleep(5)

while True:
		x = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S.%f')
		y = (np.cos(k*i/50.)*np.cos(i/50.)+np.random.randn(1))[0]
		
		s.write(dict(x=x, y=y))
		
		time.sleep(1)
s.close()
		 



