
## Tree
# Install and load required libraries
install.packages("tree")
install.packages("ISLR")
library(tree)
library(ISLR)

## Attach the Carseats dataset from ISLR CRAN

attach(Carseats)
data <- Carseats

high <- ifelse(Sales <= 8, "No", "Yes")
data <- data.frame(data, high)

tree <- tree(high ~. - Sales, data)
plot(tree)
text(tree, pretty = 0)

set.seed(2)
train <- data[sample(nrow(data), size = 200),]
test <- data[-train]

tree.train <- tree(high ~. -Sales, data = train)
plot(tree.train)
text(tree.train, pretty =0)

tree.pred <- predict(tree.train, test, type = 'class')
table(train$high, tree.pred)

## Boosting - Regression Problem
install.packages("gbm")
install.packages("MASS")
library(gbm)
library(MASS)

df = Boston
set.seed(1)
train = sample(1:nrow(df), nrow(df)/2)

boost.fit <- gbm(medv~., data = df[train,], distribution = 'gaussian', n.trees = 5000, interaction.depth = 4)
summary(boost.fit)


par(mfrow = c(1,2))
plot(boost.fit, i = 'rm')
plot(boost.fit, i = 'lstat')

