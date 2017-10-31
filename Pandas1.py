import pandas as pd
# drinks = pd.read_csv("http://bit.ly/drinksbycountry", index_col = 'country')
# print drinks.ix['Albania':'Andorra',0:2]

movies = pd.read_csv("http://bit.ly/imdbratings")
# print movies[(movies.genre == 'Crime') | (movies.duration >= 200)].head()
print movies[movies.genre.isin(['Crime','Action','Drama'])].head()


## working with date and time in Pandas

import pandas as pd
ufo = pd.read_csv('http://bit.ly/uforeports')

# string slice

ufo.Time.str.slice(-5, -3).astype(int).head()

## method to convert the time column into datetime

ufo['Time'] = pd.to_datetime(ufo.Time)

## useful in-built functions -- search .dt in Pandas API reference
ufo.Time.dt.dayofyear 
ufo.Time.dt.weekday_name

# trick 1:

ts = pd.to_datetime('1/1/1999')
ufo.loc[ufo.Time >= ts, :].head()

# trick 2:

(ufo.Time.max() - ufo.Time.min()).days

# plot 
%matplotlib inline

ufo['Year'] = ufo.Time.dt.year
ufo.Year.value_counts.sort_index().plot()

## How to avoid SettingWithCopyWarning in Pandas

movies = pd.read_csv('http://bit.ly/imdbrating')
movies.head()

## To get count of missing values of a column or a Pandas series

movies.content_rating.isnull().sum()


# How do I change display options in Pandas




