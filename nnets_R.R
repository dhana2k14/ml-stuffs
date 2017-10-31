
install.packages('ISLR')
install.packages('caTools')
install.packages('neuralnet')
library(ISLR)
library(caTools)
library(neuralnet)
View(College)

maxs = apply(College[,2:18], 2, max)
mins = apply(College[,2:18], 2, min)

scaled_data <- as.data.frame(scale(College[,2:18], center = mins, scale = maxs - mins))

Private <- as.numeric(College$Private)-1
data <- cbind(Private, scaled_data)

set.seed(101)
split = sample.split(College$Private, SplitRatio = 0.70)

train = subset(data, split == TRUE)
test = subset(data, split == FALSE)

feats <- names(scaled_data)
f <- paste(feats, collapse = ' + ')
f <- paste('Private ~',f)
f <- as.formula(f)

nn <- neuralnet(f, data, hidden = c(10, 10, 10), linear.output = FALSE)
summary(nn)

nn.predicted <- compute(nn, test[,2:18])
print(head(nn.predicted$net.result))

nn.predicted$net.result <- sapply(nn.predicted$net.result, round, digits = 0)
table(test$Private, nn.predicted$net.result)

plot(nn)

# Blood Donation Prediction

path <- 'D:/IoT/Git/predict-blood-donation'
setwd(path)

trans_data <- read.csv('transfusion_data.csv'
                  , header = T
                  , sep = ','
                  , stringsAsFactors = F)

# renaming column names
names(trans_data) <- c('Recency'
                  , 'Frequency'
                  , 'Monetary'
                  , 'Time'
                  , 'Donate')

head(trans_data)

maxs = apply(trans_data[,1:4], 2, max)
mins = apply(trans_data[,1:4], 2, min)

scaled_data <- as.data.frame(scale(trans_data[,1:4], center = mins, scale = maxs - mins))
Donate <- trans_data$Donate
scaled_data_1 <- cbind(scaled_data, Donate)

set.seed(1234)
size = floor(.7 * nrow(scaled_data_1))
ind = sample(seq_len(nrow(scaled_data_1)), size = size)
train_df = scaled_data[ind,]
test_df = scaled_data[-ind,]

preds <- names(scaled_data)
func <- paste(preds, collapse = ' + ')
func <- paste('Donate ~', func)
func <- as.formula(func)

nn.pred <- neuralnet(func, train, hidden = c(5,5,5), linear.output = FALSE)

plot(nn.pred)

nn.preds_pred <- compute(nn.pred, test[,1:4])
print(head(nn.preds_pred$net.result))

nn.preds_pred$net.result <- sapply(nn.preds_pred$net.result, round, digits = 0)
table(test$Donate, nn.preds_pred$net.result)

