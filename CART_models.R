# CART Model

install.packages("caret")
install.packages("e1071")
library(ggvis)
library(rpart)
library(caret)
library(e1071)
library(rattle)
library(ggplot2)

data(iris)
summary(iris)
qqplot(iris$Petal.Length, iris$Sepal.Width, data = iris, colour = iris$Species)

train.flag <- createDataPartition(y = iris$Species, p = 0.5, list = FALSE)
train <- iris[train.flag,]
test <- iris[-train.flag,]

fit <- train(Species ~., method = "rpart", data = train)
fancyRpartPlot(fit$finalModel)

# Model validation

train.cart <- predict(fit, newdata = train)
table(train.cart, train$Species)

test.cart <- predict(fit, newdata = test)
table(test.cart, test$Species)

correct <- test.cart == test$Species
qplot(Petal.Length, Petal.Width, colour = correct, data = test)

# Random Forest model

install.packages("randomForestSRC")
library(randomForest)
library(randomForestSRC)

fit_rf <- train(Species ~., method = "rf", data = train)

pred <- predict(fit_rf, train)
table(pred, train$Species)

pred1 <- predict(fit_rf, test)
table(pred1, test$Species)



















