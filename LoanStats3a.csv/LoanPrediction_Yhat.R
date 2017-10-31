## Loan prediction - Yhat blog
library(dplyr)
library(lubridate)

setwd("D:\\R Practice scripts\\LoanStats3a.csv")
df <- read.csv("LoanStats3a.csv", header = T, sep = ",", stringsAsFactors = FALSE, skip = 1)

df[,'desc']<- NULL ## Get rid of the unnecessary column

summary(df)

df[,'mths_since_last_record'] <- NULL

poor_coverage <- sapply(df, function(x) {
  coverage <- 1 - sum(is.na(x)) / length(x)
  coverage < 0.8
})

df<- df[,poor_coverage==FALSE]

df %>% group_by(loan_status) %>% tally()

bad_indicators <- c("Charged Off", "Late (16-30 days)", "Late (31-120 days)")

df$is_bad <- ifelse(df$loan_status %in% bad_indicators, 1, ifelse(df$loan_status == "", NA, 0))

table(df$loan_status)
table(df$is_bad)

df$issue_d <- as.Date(df$issue_d, format = "")
df$year_issued <- year(df$issue_d)
