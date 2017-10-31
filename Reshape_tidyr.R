
# Sample data - Wide format

olddata_wide <- read.table(header = TRUE, text = 
                             ' subject sex control cond1 cond2
                               1 M 7.9 12.3 10.7
                               2 F 6.3 10.6 11.1
                               3 F 9.5 13.1 13.8
                               4 M 11.5 13.4 12.9')
olddata_wide$subject <- as.factor(olddata_wide$subject)

# Sample data - Long format

olddata_long <- read.table(header=TRUE, text='
 subject sex condition measurement
       1   M   control         7.9
       1   M     cond1        12.3
       1   M     cond2        10.7
       2   F   control         6.3
       2   F     cond1        10.6
       2   F     cond2        11.1
       3   F   control         9.5
       3   F     cond1        13.1
       3   F     cond2        13.8
       4   M   control        11.5
       4   M     cond1        13.4
       4   M     cond2        12.9
')
olddata_long$subject <- factor(olddata_long$subject)

# Using tidyr - to reshape data 
# gather()

data_long <- gather(olddata_wide, condition, ceasurement, control: cond2)

# to do it programmtically

keycol <- 'condition'
valuecol <- 'measurement'
sourcecols <- c('control', 'cond1', 'cond2')
data_long <- gather_(olddata_wide, keycol, valuecol, sourcecols)

# rename levels of factor varible
levels(data_long$variable)[levels(data_long$variable) == 'cond1'] <- 'first'
levels(data_long$variable)[levels(data_long$variable)== 'cond2']  <- 'second'

# sort by subject and then condition
data_long <- data_long[order(data_long$subject, data_long$variable), ]

# spread - from long to wide format
data_wide <- spread(olddata_long, condition, measurement)
names(data_wide)[names(data_wide) == 'cond1'] <- 'First'
names(data_wide)[names(data_wide) == 'cond2'] <- 'Second'

# Reorder columns by position
data_wide <- data_wide[, c(1, 2, 5, 3, 4)]

# reshape2 library 
# melt
data_long <- melt(olddata_wide, id.vars=c('subject', 'sex'))
data_long <- melt(olddata_wide, id.vars = c('subject', 'sex'),
                  measure.vars = c("control", 'cond1', 'cond2'),
#                   variable.name = "Condition",
                  value.name = "Measurement")

# dcast

data_wide <- dcast(olddata_long, subject + sex ~ condition, value.var = "measurement" )


# Comparing data frames

dfA <- data.frame( subject = c(1, 2, 3, 4), response = c("x", "x", "x", "x"))
dfB <- data.frame( subject = c(1, 2, 3), response = c("x", "y", "x"))
dfC <- data.frame( subject = c(1, 2, 3), response = c("z", "y", "z"))

# join the dataframes with a column identifying which source each row came from
dfA$Coder <- "A"
dfB$Coder <- "B"
dfC$Coder <- "C"

df <- rbind(dfA, dfB, dfC)
df <- df[, c("Coder", "subject", "response")]

#dupsBetweenGroups
# Find the rows which have duplicates in a different group

dupsRows <- dupsBetweenGroups(df, "Coder")



























