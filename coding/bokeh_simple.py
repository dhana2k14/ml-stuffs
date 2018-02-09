from bokeh.io import output_file, show
from bokeh.plotting import figure
import pandas as pd
from datetime import datetime
from bokeh.models import ColumnDataSource

df = pd.read_csv('C:/Users/33093/Desktop/TelemeteryData_July_August.csv', parse_dates = True)
df['date_use'] = pd.to_datetime(df['date'])
print df['date_use'].dt.hour.head()

# source = ColumnDataSource(df)

# print df.head()

# plot = figure(title = 'speed graph', plot_width = 500, plot_height = 500, x_axis_label = 'Date', y_axis_label = 'Speed')
# plot.circle("date_use","speed", size = 8, fill_color = 'blue', source = source)
# plot.line("date_use", "speed", source = source)

# output_file('speed_chart.html')
# show(plot)


# Parameters to customize the plot 

# plot.title.text_font_size = "25px"
# plot.title.align = "center"
					

