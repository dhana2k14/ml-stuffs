
## Spilt the file into multiple files based on values of a 'DatePart' column
## Reading the telemetry data attached with Trip numbers


path <- "D:\\IoT\\TableauDashboard\\Clustering"
setwd(path)

result <- subset(read.csv('result.csv', sep = ',', header = T, stringsAsFactors = F), assetname == 'Hyundai Creta') 

for (i in 1:length(unique(result$DatePart)))
{
  for (dt in unique(result$DatePart)[i])
  {
    tmp = subset(result, DatePart == dt)
    fn = paste(gsub(' ','',i), sep = '','.csv')
    write.csv(tmp, fn, row.names = FALSE)
  }
  next
}


## K-means Cluster algoirthm 
# 1. Make sure the file path name do not have any white spaces
# 2. Read each csv files of telemetry data given by Date
# 3. The output dataset will be a aggregated file with variables required for clustering technique 

path <- "D:\\IoT\\TableauDashboard\\Clustering\\"
setwd(path)

temp <- data.frame(NULL)
for (i in 1:45)
{
  
  file.path <- gsub(" ","",paste(path, i, ".csv"))
  trip.data <- read.csv(file.path, sep = ",", header = T, stringsAsFactors = FALSE)
  trip.day <- trip.data$DatePart[1]
  avg.speed <- round(mean(trip.data$Speed, na.rm = TRUE),2)
  temp <- rbind(temp, cbind(trip.day, avg.speed))
  
}
temp$avg.speed <- as.numeric(temp$avg.speed)
overall.Speed <- mean(temp$avg.speed, na.rm = TRUE) 

ClustData <- data.frame(NULL)
for (i in 1:45)
{
  file.path <- gsub(" ","",paste(path, i, ".csv"))
  trip.data <- read.csv(file.path, sep = ",", header = T)
  trip_day <- as.character(trip.data$DatePart)[1]
  trip_num <- i
  accl <- trip.data$Speed[-nrow(trip.data)]- trip.data$Speed[-1] 
  avg_speed <- ifelse(is.na(as.numeric(round(mean(trip.data$Speed[trip.data$Speed != 0], na.rm = TRUE,2)))), 0, as.numeric(round(mean(trip.data$Speed[trip.data$Speed != 0], na.rm = TRUE,2))))
  trip_dist <- round(trip.data$Odo_counter[nrow(trip.data)] - trip.data$Odo_counter[1],2)
  trip_time <- round(trip.data$hours_00_counter[nrow(trip.data)] - trip.data$hours_00_counter[1],2)
  dev_speed <- trip.data$Speed[trip.data$Speed != 0] - avg.speed
  num_stops <- nrow(trip.data) - length(dev_speed)
  avg_accl <- round(mean(accl, na.rm = TRUE),2)
  slow <- length(trip.data$Speed[trip.data$Speed < overall.Speed])
  harsh_accl1 <- ifelse(is.na(mean(trip.data$harsh_accl, na.rm = TRUE)), 0, round(mean(trip.data$harsh_accl, na.rm = TRUE),0))
  harsh_brake1 <- ifelse(is.na(mean(trip.data$harsh_brake, na.rm = TRUE)), 0, round(mean(trip.data$harsh_brake, na.rm = TRUE),0))
  colData <- cbind(trip_num,
                   trip_day,
                   trip_dist,
                   trip_time,
                   avg_speed,
                   avg_accl,
                   num_stops,
                   slow,
                   harsh_accl1,
                   harsh_brake1)
  colData <- as.data.frame(colData)
  colData$trip_num <- as.numeric(as.character(paste(colData$trip_num)))
  colData$trip_day <- as.character(paste(colData$trip_day))
  colData$avg_speed <- as.numeric(as.character(paste(colData$avg_speed)))
  colData$avg_accl <- as.numeric(as.character(paste(colData$avg_accl)))
  colData$num_stops <- as.numeric(as.character(paste(colData$num_stops)))
  colData$slow <- as.numeric(as.character(paste(colData$slow)))
  colData$harsh_accl1 <- as.numeric(as.character(paste(colData$harsh_accl1)))
  colData$harsh_brake1 <- as.numeric(as.character(paste(colData$harsh_brake1)))
  ClustData <- rbind(ClustData, colData)
}

## Write the final dataset in an external file to use with Shiny apps
write.csv(ClustData, ".\\DataForCluster_Creta.csv", row.names = FALSE)

## merge files 

polo <- read.csv("DataForCluster_Polo.csv", sep = ',', header = T, stringsAsFactors = F)
creta <- read.csv("DataForCluster_Creta.csv", sep = ',', header = T, stringsAsFactors = F)

polo$assetName <- 'Polo GT'
creta$assetName <- 'Hyundai Creta'
# nissan$assetName <- 'Nissan Sunny'


# Merge with previous trips
ClustData_old <- readRDS('data_old.rds')
ClustData <- rbind(polo, creta, ClustData_old)
saveRDS(ClustData, ".\\data.rds")





















