import dash
from dash.dependencies import Input, Output
import dash_core_components as dcc
import dash_html_components as html
import pandas as pd
from datetime import datetime as dt
import plotly.graph_objs as go

app = dash.Dash()

app.layout = html.Div([
    html.H1('Cold Chain Temperature'),
    dcc.Dropdown(
        id='my-dropdown',
        options=[
            {'label': 'CCU 1', 'value': 'CCU 1'},
            {'label': 'CCU 2', 'value': 'CCU 2'},
            {'label': 'CCU 3', 'value': 'CCU 3'}
        ],
        value='CCU 1'
    ),
    dcc.Graph(
		
		figure = go.Figure(
						data = [
						go.Scatter(x = 'x', y = 'y')],
						layout = go.Layout(showlegend = True)),
		id='my-graph')
])

@app.callback(Output('my-graph', 'figure'), [Input('my-dropdown', 'value')])
def update_graph(selected_dropdown_value):
    
	df = pd.read_csv('./data/log_data.csv', parse_dates = ['DATETIME'])
	df = df[(df['ASSET ID'] == selected_dropdown_value) & (df["DATETIME"].isin(pd.date_range("2017-05-15 12:00:00", "2017-07-20 20:00:00")))]
	return {
        'data': [{
            'x': df.DATETIME,
            'y': df.TEMP_IN
        }]
    }

if __name__ == '__main__':
    app.run_server()
