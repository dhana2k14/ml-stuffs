# Draw a nicer Classification and regression decision trees with prp

library(rattle)             # Popular decision tree algorithm
library(rpart)              # Fancy tree plot
library(rpart.plot)         # Enhanced tree plot
library(RColorBrewer)       # Color selection for fancy tree plot
library(party)              # Alternative decision tree algorithm
library(partykit)           # Convert rpart object to binary tree
library(caret)              # Just a data source for this script but probably best packages in R

# Get some data
data(segmentationData)
data <- segmentationData[, -c(1, 2)]

# rpart decision tree
form <- as.formula(Class ~ .)
tree.1 <- rpart(form, data = data, control = rpart.control(minsplit = 20, cp =0))
plot(tree.1)
text(tree.1)

# Plot the tree with shorten variable names
prp(tree.1, varlen = 3)

# Interactively prue the tree
new.tree.1 <- prp(tree.1, snip = TRUE)$obj
prp(new.tree.1)

#------------------------
tree.2 <- rpart(form, data)
prp(tree.2)
fancyRpartPlot(tree.2)
