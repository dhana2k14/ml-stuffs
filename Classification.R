library(sqldf)
library(randomForest)
library(dplyr)

qa.data <- read.csv("C:\\eValuations\\NDMC\\Data Extracts\\Baljit_Qc2PassFail_29Jul.csv", sep =",", header = T, stringsAsFactors = F)
qa.data <- qa.data %>% 
  mutate(Property_Type = substr(Property_Type, 1, 3), UseType = substr(UseType, 1, 3),
         OccupancyType = substr(OccupancyType, 1, 3), StructureType = substr(StructureType, 1, 3),
         OwnerType = substr(OwnerType, 1, 3))

qa.data <- qa.data %>% mutate(Status = ifelse(Status == 'QC2 PASSED', 'Yes', 'No'))
           
qa.data$OwnerName <- as.character(qa.data$OwnerName)
qa.data <- qa.data %>% group_by(PropertyId) %>% mutate(rnum = row_number(PropertyId))

qa.data.class <- qa.data %>% filter(rnum == 1) %>% select(Property_Type, UseType, StructureType, OccupancyType, Status)

# qa.data.class <- qa.data.class %>% select(-PropertyId)

target <- 'Status'

(form <- formula(paste(target, "~ .")))

vars <- setdiff(names(qa.data.class), target)

attach(qa.data.class)
mod <- randomForest(form, qa.data.class[vars])

mod <- rpart(form, qa.data.class[vars])
fancyRpartPlot(mod)

# downSample using random forest.

data <- qc.data %>%
  mutate(PropType = substr(Property_Type, 1, 3),  
         UseType = substr(UseType, 1, 3),
         OccupType = substr(OccupancyType, 1, 3), 
         StrucType = substr(StructureType, 1, 3)) %>%
  filter(PlotAccessibility != "", UnitAccessibility != "", !is.na(OwnerName)) %>%
  group_by(PropertyId, UnitId) %>%
  mutate(rnum = row_number(UnitId)) %>%
  filter(rnum == 1) %>%
  select(Status, PropertyId, BuildingId, FloorId, UnitId, PropType,PlotAccessibility, PlotType, PlotArea, 
         BuildingGroundCoverage, BuildingBuiltUpArea, UnitAccessibility, UseType, OccupType, StrucType, 
         UnitType, OwnerName) 
  

library(randomForest)

ctrl <- trainControl(method = 'cv', 
                     classProbs = TRUE,
                     summaryFunction = twoClassSummary)

fit <- randomForest(Status ~., data = data, ntree = 500, importance = TRUE, metric = "ROC")

# Naivebayes

library(e1071)
nbfit <- naiveBayes(Status ~., data = data)
pred <- predict(nbfit, data[,6:17])
table(data$Status, pred)

# Predict the results for test data.

tstdata <- qa.data %>%
  mutate(PropType = substr(Property_Type, 1, 3),  
         UseType = substr(UseType, 1, 3),
         OccupType = substr(OccupancyType, 1, 3), 
         StrucType = substr(StructureType, 1, 3)) %>%
  filter(PlotAccessibility != "", UnitAccessibility != "", !is.na(OwnerName)) %>%
  group_by(PropertyId, UnitId) %>%
  mutate(rnum = row_number(UnitId)) %>%
  filter(rnum == 1) %>%
  select(Status, PropertyId, BuildingId, FloorId, UnitId, PropType,PlotAccessibility, PlotType, PlotArea, 
         BuildingGroundCoverage, BuildingBuiltUpArea, UnitAccessibility, UseType, OccupType, StrucType, 
         UnitType, OwnerName)

tstPred <- predict(nbfit, tstdata[,2:17])
table(tstdata$Status, tstPred)

tstdata$Pred <- predict(nbfit, tstdata[,2:17])












