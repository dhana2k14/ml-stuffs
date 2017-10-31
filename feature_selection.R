
pkgs <- c('Metrics', 'randomForest', 'ggplot2', 'dplyr')

for (pkg in pkgs)
{
  if(!(pkg %in% rownames(installed.packages()))){install.packages(pkg)}
}

library(devtools)

install_github(c("hadley/ggplot2", "jrnold/ggthemes"))

set.seed(101)
data <- read.csv('C:/Users/33093/Downloads/stock_data.csv', stringsAsFactors = T)

dim(data)

data$Y <- as.factor(data$Y)
train <- data[1:2000,]
test <- data[2001:3000,]

library(randomForest)
rf.fit <- randomForest(Y~., data = train)
summary(rf.fit)

rf.pred <- predict(rf.fit, test[,-101])
table(rf.pred)

library(Metrics)
auc(rf.pred, test$Y)

importance(rf.fit,type = 2)
varImpPlot(rf.fit, sort = TRUE)

attach(train)
rf.fit_1 <- randomForest(Y ~ X57 
                         + X30 
                         + X81 
                         + X61 
                         + X4 
                         + X23 
                         + X24 
                         + X19 
                         + X41 
                         + X40 
                         + X66 
                         + X56 
                         + X64
                         + X48
                         + X89
                         + X12
                         + X2
                         + X7
                         + X60
                         + X55
                         + X11
                         , data = train)

rf.fit_1.pred <- predict(rf.fit_1, test[,-101])
table(rf.fit_1.pred)

auc(rf.fit_1.pred, test$Y)
