
from pulp import *
import pandas as pd, numpy as np, re, matplotlib.pyplot as plt

ted = pd.read_csv('ted_main.csv', encoding = 'ISO-8859-1')
ted['duration'] = ted['duration']/60
ted = ted.round({'duration':1})

data = ted
sel_col = ['name','event', 'duration', 'views']
data = data[sel_col]
data.reset_index(inplace = True)
# print data.head()

prob = pulp.LpProblem('WatchingTEDTalks', pulp.LpMaximize)

decision_vars = []
for rownum, row in data.iterrows():
    variable =  str('X' + str(row['index']))
    variable = pulp.LpVariable(str(variable), lowBound = 0, upBound = 1, cat = 'Integer')
    decision_vars.append(variable)

# print('Total number of decision variables:'+ str(len(decision_vars)))
# print decision_vars
# print data.head()

total_views = ''
for rownum, row in data.iterrows():
    for i, talk in enumerate(decision_vars):
        if rownum == i:
            formula = row['views']*talk
            total_views += formula
            
prob += total_views

# print "optimize function: "+ str(total_views)
# print total_views

tot_time_available_for_talks = 10 * 60
tot_talks_can_watch = 25

total_time_talks = ''
for rownum, row in data.iterrows():
    for i, talk in enumerate(decision_vars):
        if rownum == i:
            formula = row['duration']*talk
            total_time_talks += formula
                        
prob += (total_time_talks == tot_time_available_for_talks)
 
total_talks = ''
for rownum, row in data.iterrows():
    for i, talk in enumerate(decision_vars):
        if rownum == i:
            formula = talk
            total_talks += formula
             
prob += (total_talks == tot_talks_can_watch)
 
# print(prob)
prob.writeLP('WatchingTEDTalks.lp')
 
optimization_result = prob.solve()
 
assert optimization_result == pulp.LpStatusOptimal
 
print 'Status:', LpStatus[prob.status]
print 'Optimal Solution to the problem: ', value(prob.objective)
# print 'Individual Decision Variables:'
# for v in prob.variables():
#     print v.name, '=', v.varValue
    
var_name = []
var_val = []

for v in prob.variables():
    var_name.append(v.name)
    var_val.append(v.varValue)
     
df = pd.DataFrame({'index':var_name, 'value':var_val})
 
for rownum, row in df.iterrows():
    value = re.findall(r'(\d+)', row['index'])
    df.loc[rownum, 'index'] = int(value[0])
    
df = df.sort_values(by = 'index')
result = pd.merge(data, df, on = 'index')
result = result[result['value'] == 1].sort_values(by = 'views', ascending = False)
result = result[sel_col]

print result.head()
      





