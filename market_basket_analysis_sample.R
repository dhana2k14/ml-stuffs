
sita_df <- read.transactions('D://output final1.csv'
                             , sep = ','
                             , format = 'basket'
                             , rm.duplicates = TRUE)

# Load the libraries
library(arules)
library(arulesViz)

itemFrequencyPlot(sita_df
                  , topN=20
                  , type="absolute")

# Get the rules
rules <- apriori(sita_df
                 , parameter = list(supp = 0.001, conf = 0.5))

inspect(rules[1:5])

plot(rules[1:50],method="graph",interactive=TRUE,shading=NA)
