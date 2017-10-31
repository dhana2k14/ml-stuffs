
suppressMessages(library(RODBC))
suppressMessages(library(dplyr))
library(dplyr)
cxn <- odbcConnect("Ndmc_Local")
qry <-  'select * from Inderlok_QC1'
data <- sqlQuery(cxn, qry)
close(cxn)

data %>% 
  group_by(Status) %>%
  tally()

levels(data$Status)[levels(data$Status) == 'QC1 FAILED'] <- '1'
levels(data$Status)[levels(data$Status) == 'QC1 PASSED'] <- '0'
levels(data$PlotAccessibility)[levels(data$PlotAccessibility) == 'YES'] <- '1'
levels(data$PlotAccessibility)[levels(data$PlotAccessibility) == 'NO'] <- '0'
levels(data$BuildingAccessibility)[levels(data$BuildingAccessibility) == 'YES'] <- '1'
levels(data$BuildingAccessibility)[levels(data$BuildingAccessibility) == 'NO'] <- '0'
levels(data$UnitAccessibility)[levels(data$UnitAccessibility) == 'YES'] <- '1'
levels(data$UnitAccessibility)[levels(data$UnitAccessibility) == 'NO'] <- '0'
levels(data$PlotType)[levels(data$PlotType) == 'Non-Vacant'] <- '1'
levels(data$PlotType)[levels(data$PlotType) == 'Vacant'] <- '0'


data <- data[, c(2, 4, 5, 6, 7, 9, 11, 14, 20, 35, 41, 42, 43, 44, 79, 80, 81, 82, 1)]

data <- data %>%
  mutate(Property_Type = substr(Property_Type, 1, 3),  
         UseType = substr(UseType, 1, 3),
         OccupancyType = substr(OccupancyType, 1, 3), 
         StructureType = substr(StructureType, 1, 3)) %>%
#   filter(PlotAccessibility != "", UnitAccessibility != "", !is.na(OwnerName)) %>%
  group_by(PropertyId, UnitId) %>%
  mutate(rnum = row_number(UnitId)) %>%
  filter(rnum == 1) 


data %>%
  group_by(UseType) %>%
  tally()

# Change the data types

data$Property_Type <- as.factor(data$Property_Type)
data$UseType <- as.factor(data$UseType)
data$OccupancyType <- as.factor(data$OccupancyType)
data$StructureType <- as.factor(data$StructureType)
data$BldgName <- as.factor(data$BldgName)
data$PropNum <- as.factor(data$PropNum)
data$GenderText <- as.factor(data$GenderText)
data$OwnerN <- as.factor(data$OwnerN)

# random sample followed by downSample

dsname <- 'data'
ds <- get(dsname)
vars <- names(ds)
nobs <- nrow(ds)
length(train <- sample(nobs, .60 * nobs))
length(test <- setdiff(seq_len(nobs), train))
train <- ds[train, vars]
test <- ds[test, vars]

train1 <- downSample(train[1:18], train$Status, list = FALSE)


# Naive Bayes classifier

library(e1071)

bayesFit <- naiveBayes(Class ~., data = train1[, 6:19])
pred <- predict(bayesFit, train1)
table(train1$Class, pred)

train1$pred <- predict(bayesFit, train1)
table(train1$Status, train1$pred)

# Predict the results for test cases and export it.

test$pred <- predict(bayesFit, test)
table(test$Status, test$pred)

write.csv(test, "C:\\BayesPredictionTest.csv", row.names = FALSE, na = " ")
write.csv(train1, "C:\\BayesPredictionTrain.csv", row.names = FALSE, na = " ")

# Predict the results for cases in new ward.

data$pred <- predict(bayesFit, data)
table(data$Status, data$pred)

write.csv(data, "C:\\BayesPredictionKohat.csv", row.names = FALSE, na = " ")






