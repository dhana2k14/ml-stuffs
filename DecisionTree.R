# decison tree (J48) : http://data-mining.business-intelligence.uoc.edu/home/j48-decision-tree
## intall required libraries.

rm(list=ls())

install.packages("RWeka")
install.packages("party")

library(RWeka)
library(party)

str(iris)

# Using the decision tree ID3 in its J48 weka Implementation.

m1 <- J48(Species~., data=iris)
if(require("party",quietly = TRUE))
  plot(m1)

# How Decision Tree works internally.

library(FSelector)
information.gain(Species~.,data=iris)

str(OutL2)


# To access Quandl free datasets via API.
# User: dhana_quandl; pwd: dhana@quandl2015
Qtoken <- "Hx8fC7iHU3MHDSgozR1q"
save(list="Qtoken", file = "Quandl_token")

load("Quandl_token")

# Install & Load library

install.packages("Quandl")
library(Quandl)

## To search for IT companies stocks.

Quandl.search('IT Stocks',  page = 1, source = NULL, silent = FALSE, authcode = Quandl.auth(Qtoken))
