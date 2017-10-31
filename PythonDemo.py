import pandas as pd
df = pd.read_csv("http://bit.ly/drinksbycountry")
# average beer_servings by continent
print df.groupby('continent').beer_servings.mean()
# average beer_servings in a given continent
print df[df.continent == 'Africa'].beer_servings.mean()
# maximum value of beer_servings by continent
print df.groupby('continent').beer_servings.max()
# agg() is to combine multiple aggregation functions in one line
print df.groupby('continent').beer_servings.agg(['count','min','mean','max'])
# Visualise the output
print df.groupby('continent').mean().plot(kind = 'bar')


## How do I make my pandas DataFrame smaller and faster?
# what does the type 'category' do? how to properly use it?


