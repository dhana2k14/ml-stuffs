
setwd('D:\\IoT')
df <- read.csv('Backup_2.csv', sep = ',', header = T, stringsAsFactors = F)

df$sp <- gregexpr(' ', df$date)[[1]][1]
df$Date <- substr(df$date, 1, gregexpr(' ', df$date)[[1]][1])
df$Time <- substr(df$date, gregexpr(' ', df$date)[[1]][1]+1, length(df$date) - gregexpr(' ', df$date)[[1]][1])

write.csv(df, 'Backup_3.csv', row.names = F)
