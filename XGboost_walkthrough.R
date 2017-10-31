## install and load xgboost package

install.packages("xgboost")
library(xgboost)
require(xgboost)
data(agaricus.train, package = "xgboost")
data(agaricus.test, package = "xgboost")
train <- agaricus.train
test <- agaricus.test

# Investigate the data 
str(train)

## Input features
# 1. XGboost allows sparse matrix as input
# 2. Target variable: Use integers starting from 0 for classification, 
# or real values for regression
# 3. Objective : For regression: reg:linear
# For classification: binary:logistic
# 4. Number of Iteration: The number of trees added to the model
# The output is the classification error on the training dataset

bst <- xgboost(data = train$data, label = train$label, nround = 2, objective = 'binary:logistic')

# To measure classification error by 'Area under curve (AUC)'
bst <- xgboost(data = train$data, label = train$label, nround = 3, 
               objective = 'binary:logistic', eval_metric = "auc" )

# To predict 
pred <- predict(bst, test$data)
head(pred)

# Cross validation: It is an important method to measure model's predictive power, as well as
# the degree of overfitting.
# To perform cross validation on certain parameters we need to copy them to the xgb.cv function
# and add number of folds


bst.cv <- xgb.cv(data = train$data, label = train$label, nfold = 5, nround = 2, 
                 objective = "binary:logistic", eval_metric = 'auc')

# xgb.cv returns a data.table object containing cross validation results

bst.cv

## Higgs boston competition - XGBOOST
## read the datasets
setwd("D:\\Kaggle\\Higgs Boston")
train <- read.csv("training.csv", sep = ',', stringsAsFactors = FALSE)
test <- read.csv("test.csv", sep = ',', stringsAsFactors = FALSE)

testsize = 550000
train[33] = train[33] == 's'
label = as.numeric(train[[33]])
data = as.matrix(train[2:31])
weight = as.numeric(train[[32]]) * testsize / length(label)
sumwpos = sum(weight * (label == 1))
sumwneg = sum(weight * (label == 0))

# The data contains missing values marked as -999.0. We can construct xgb.DMatrix object 
# containing infomation of weight and missing

xgmat <- xgb.DMatrix(data, label = label, weight = weight, missing = -999.0)

# To save as xbg.DMatrix 
xgb.DMatrix.save(xgmat, 'xgb.DMatrix.data')
t <- xgb.DMatrix("xgb.DMatrix.data")

# set the parameters 
params <- list("objective" = "binary:logistic",
               "scale_pos_weight" = sumwneg / sumwpos,
               "bst.eta" = 0.1,
               "bst.max.depth" = 6,
               "eval_metric" = "auc",
               "eval_metric" = "ams@0.15",
               "silent" = 1,
               "nthread" = 16)
## XGBoost model fit
bst <- xgboost(params = params, data = xgmat, nround = 120)





