
# Install DMwR 

install.packages('DMwR')
library(DMwR)

## A small example with a data set created artificially from the IRIS
## data 
data(iris)
data <- iris[, c(1, 2, 5)]
data$Species <- factor(ifelse(data$Species == "setosa","rare","common")) 
## checking the class distribution of this artificial data set
table(data$Species)

newData <- SMOTE(Species ~ ., data, perc.over = 600, perc.under = 100)
table(newData$Species)


## Checking visually the created data
## Not run: 
par(mfrow = c(1, 2))
plot(data[, 1], data[, 2], pch = 19 + as.integer(data[, 3]),
     main = "Original Data")
plot(newData[, 1], newData[, 2], pch = 19 + as.integer(newData[,3]),
     main = "SMOTE'd Data")


## Now an example where we obtain a model with the "balanced" data
classTree <- SMOTE(Species ~ ., data, perc.over = 600, perc.under=100,
                   learner='rpartXse', se=0.5)
## check the resulting classification tree
classTree
## The tree with the unbalanced data set would be
rpartXse(Species ~ .,data,se=0.5)

# Customer Churn

train_for_smote <- Cust_Model %>% filter(Month %in% c(6, 7))
table(train_for_smote$Churn)

# Variable Trans

train_for_smote$Gen = 1
train_for_smote$Gen[train_for_smote$Gender == 'F' | is.na(train_for_smote$Gender)] = 0

train_for_smote <- train_for_smote %>% mutate(med_age = median(Age, na.rm = TRUE))

train_for_smote$Age <- ifelse(train_for_smote$Age == 0
                    , median(train_for_smote$Age, na.rm = TRUE)
                    , train_for_smote$Age)

train_for_smote$premium_amt <- ifelse(train_for_smote$premium_amt == 0
                            , median(train_for_smote$premium_amt, na.rm = TRUE)
                            , train_for_smote$premium_amt)

train_for_smote$premium_amt <- ifelse(is.na(train_for_smote$premium_amt)
                            , median(train_for_smote$premium_amt, na.rm = TRUE)
                            , train_for_smote$premium_amt)

train_for_smote$Country <- ifelse(train_for_smote$Country == ''
                        , 'BE'
                        , train_for_smote$Country)

train_for_smote$Source <- ifelse(is.na(train_for_smote$Source), 27, train_for_smote$Source)

train_for_smote$Gen <- as.factor(train_for_smote$Gen)
train_for_smote$Country <- as.factor(train_for_smote$Country)
train_for_smote$Marital_Status <- as.factor(train_for_smote$Marital_Status)
train_for_smote$Source <- as.factor(train_for_smote$Source)
train_for_smote$no_all_policies <- as.factor(train_for_smote$no_all_policies)
train_for_smote$Churn <- as.factor(train_for_smote$Churn)

table(train_for_smote$Churn)

train_for_smote <- train_for_smote %>% select(Cust_Rk
                                              , Churn
                                              , Marital_Status
                                              , premium_amt
                                              , no_prods
                                              , Age
                                              , Gen)

set.seed(500)
sMoteTrain <- SMOTE(Churn ~ no_24_policies + Marital_Status + Prod_Group + Age_Group + 
                   Premium_Bin + Gen, train, perc.over = 200, perc.under = 150)
table(sMoteTrain$Churn)






