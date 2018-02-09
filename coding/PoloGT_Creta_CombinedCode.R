install.packages("readr")
install.packages("knitr")
install.packages("MASS")
install.packages("dplyr")
install.packages("ggplot2")
install.packages("plotly")
install.packages("lubridate")

library(readr)
library(knitr)
library(MASS)
library(dplyr)
library(ggplot2)
library(plotly)
library(lubridate)





path <- "D:\\31157\\1\\BACKup\\IOT\\data\\Raw_Data\\TelemeteryData_July_August"
setwd(path)


cat("Hyundai Creta")


liveAtrack <- read.csv("TelemeteryData_July_August.csv", header = T, sep = ",", stringsAsFactors = FALSE)

liveAtrack <- subset(liveAtrack, assetname == 'Hyundai Creta')

#liveAtrack$date_time <- paste(liveAtrack$date, liveAtrack$time, sep = " ")

#liveAtrack$date <- as.POSIXct(liveAtrack$Date, format = "%m/%d/%Y %H:%M") 

liveAtrack$DatePart <- substr(liveAtrack$date, 1, 9)

# colnames(liveAtrack)[which(colnames(liveAtrack) %in% c( "lat","lon","heading","altitude",
#                                                         "accuracy","ignition","batteryvoltage",
#                                                         "powervoltage","odometer","hours00counter",
#                                                         "idlecounter","airflow","fuelused",
#                                                         "engineload","rpm","enginetemp") )] <- 
#                                                     c("Lat","Lon","Heading","Altitude","Accuracy",
#                                                       "ignition","battery_voltage","power_voltage",
#                                                       "odometer","Hours_00_counter","Idle_counter",
#                                                       "AirFlow","Fuel.Used","EngineLoad","RPM",
#                                                       "Engine.Temp")
#names(liveAtrack)
liveAtrack<- liveAtrack %>%
  dplyr::select(assetname,date, DatePart,time, lat, lon, speed, heading, altitude, accuracy, 
                address, ignition,batteryvoltage, powervoltage, odometer, hours00counter, 
                idlecounter,airflow, engine,fuelused, rpm, enginetemp,overspeed)


#colnames(liveAtrack)
#write.csv(liveAtrack,"D::\\IOT\\R_Data_\\AfterSelect.csv" , row.names= FALSE)

#liveAtrack$date <- substr(liveAtrack$date, 1, 9)

# liveAtrack <- subset(read.csv("streaming Data_Hyundai creta.csv", header = T, sep = ",", stringsAsFactors = FALSE))
# ,
# date == c( "04-05-2016","04-06-2016","04-07-2016","04-08-2016"))
# View(liveAtrack)




# # ## Applicable only for Honda City
#liveAtrack <- subset(liveAtrack, DatePart <= "2016-03-10")  

newdata <- liveAtrack


# View(liveAtrack)
# liveAtrack$Date <- sort(liveAtrack$Date)
newdata <- newdata %>%dplyr::arrange(date)
# View(newdata)

newdata1 <- newdata %>%
  filter(ignition == 1)
#write.csv(newdata1,"D:\\IoT\\data\\Test\\test.csv" , row.names= FALSE)
# View(newdata1)


## remove duplicated records by date


newdata1 <- newdata1 %>%
  group_by(date, lat, lon) %>%
  mutate(rn = row_number(date)) %>% 
  filter(rn == 1)

cat ("Order data by date and time")


newdata1$x <- as.POSIXct(newdata1$date,format = "%m/%d/%Y %H:%M")

# srtdata <- arrange(newdata1 ,x)
srtdata <- newdata1 
# View(srtdata)
cat ("Creating flag variables for classifying trips")
srtdata$First <- !duplicated(srtdata$DatePart)

srtdata$Last <- !duplicated(srtdata$DatePart,fromLast=TRUE)

# set up previous record time lag for a lag diff of 1

srtdata$prev_time <- lag(srtdata$x)

# Iterate through data to calculate time difference
#write.csv(srtdata,"D:\\IOT\\data\\AfterBinding\\Creta_Data_27_6_2016.csv" , row.names= FALSE)
#View(srtdata)

srtdata$Time_diff <- NA

 # View(srtdata)
# write.csv(srtdata,"D:\\IoT\\honda city\\triperror file .csv" , row.names= FALSE)
# Iterate through data to classify trips per day

srtdata$Trip <- NA
for(i in seq(1:nrow(srtdata))) 
{
  
  if (srtdata$First[i] == 1L)
  {
    srtdata$Trip[i] <- 1 
  } 
  
  else 
  {
    if (srtdata$Time_diff[i] > 20) 
    {
      
      srtdata$Trip[i] <- srtdata$Trip[i-1] + 1
    } 
    else
    {
      srtdata$Trip[i] <- srtdata$Trip[i-1]
    }
  }
}

# 
# # Cross check:
# To view/check maximum number of trips driven per day - Trip can't be zero, NA or blank
# 
# srtdata %>% 
# group_by(DatePart) %>% 
# summarise(t = max(Trip)) %>% 
#   View()
#   


## Variables for Tableau

## To create a NULL data frame
# result <- data.frame(NULL) 

harshAccl <- srtdata %>%
  group_by(DatePart, Trip) %>%
  mutate(diffspeed = lag(speed) - speed) %>%
  dplyr::select(Trip, speed, diffspeed) %>% 
  filter(diffspeed >= 40) %>% 
  summarise(harsh_accl = n()) 

harshBrake <- srtdata %>%
  group_by(DatePart, Trip) %>%
  mutate(diffspeed = lag(speed) - speed) %>%
  filter(diffspeed <= -40) %>%
  summarise(harsh_brake = n())

trip.data <- srtdata %>%
  dplyr::select(-First, -Last, -rn, -x, -prev_time, -Time_diff) %>%
  left_join(harshAccl, by = c('DatePart','Trip')) %>%
  left_join(harshBrake, by = c('DatePart','Trip'))

trip.data <- trip.data %>%
  group_by(DatePart, Trip) %>%
  mutate(diffspeed = lag(speed) - speed) %>%
  mutate(brakeFlag = ifelse(ifelse(is.na(diffspeed), 0, diffspeed) < 0, 1, 0)) %>%
  mutate(brakeDist = ifelse(ifelse(is.na(diffspeed), 0, diffspeed) < 0, round((speed*speed)/72,2), 0),
         totalDist_Trip = round(abs(last(odometer) - first(odometer)),0))
# travelTime = last(ms(timeHrs)) - ms(first(timeHrs)),

# totalFuelConsp_Trip = round(abs(last(Fuel.Used) - first(Fuel.Used)),0),
# mpl = round(totalDist_Trip / totalFuelConsp_Trip, 0)) 
trip.data <- trip.data %>%
  group_by(DatePart) %>%
  mutate(totalDist_Date = round(abs(last(odometer) - first(odometer)),0))

# totalFuelConsp_Date = round(abs(last(Fuel.Used) - first(Fuel.Used)),0))
# write.csv(liveAtrack,"D:\\IoT\\honda city\\processed data of hyundai creta.csv")

# This is the final dataset for Tableau implementation
result_Creta <- trip.data
# result <- rbind(result,trip.data) 
#View(result)


result_Creta <- result_Creta %>% rename(assetName = assetname,
                            Speed = speed,
                            Time = time,
                            Address = address,
                            Battery_voltage = batteryvoltage,
                            Power_voltage = powervoltage,
                            Odo_counter = odometer,
                            FuelUsed = fuelused,
                            Engine_Temp = enginetemp)

write.csv(result_Creta,"D:\\31157\\1\\BACKup\\IOT\\data\\BeforeBinding\\Creta_Data_19_08_2016.csv" , row.names= FALSE)



############################################################################################


cat("For Polo GT")

liveAtrack <- read.csv("TelemeteryData_July_August.csv", header = T, sep = ",", stringsAsFactors = FALSE)

liveAtrack_P <- subset(liveAtrack, assetname == 'Polo GT')

#liveAtrack_P$date_time <- paste(liveAtrack_P$date, liveAtrack_P$time, sep = " ")

#liveAtrack_P$date <- as.POSIXct(liveAtrack_P$date_time, format = "%m/%d/%Y %H:%M") 

liveAtrack_P$DatePart <- substr(liveAtrack_P$date, 1, 9)

liveAtrack_P<- liveAtrack_P%>%
  dplyr::select(assetname,date, DatePart,time, lat, lon, speed, heading, altitude, accuracy, 
                address, ignition,batteryvoltage, powervoltage, odometer, hours00counter, 
                idlecounter,airflow, engine,fuelused,rpm, enginetemp,overspeed)


#colnames(liveAtrack)
#write.csv(liveAtrack,"D::\\IOT\\R_Data_\\AfterSelect.csv" , row.names= FALSE)

#liveAtrack$date <- substr(liveAtrack$date, 1, 9)

# liveAtrack <- subset(read.csv("streaming Data_Hyundai creta.csv", header = T, sep = ",", stringsAsFactors = FALSE))
# ,
# date == c( "04-05-2016","04-06-2016","04-07-2016","04-08-2016"))
# View(liveAtrack)




# # ## Applicable only for Honda City
#liveAtrack <- subset(liveAtrack, DatePart <= "2016-03-10")  

newdata <- liveAtrack_P
# View(liveAtrack)
# liveAtrack$Date <- sort(liveAtrack$Date)
newdata <- newdata %>%
  arrange(date)
# View(newdata)

newdata1 <- newdata %>%
  filter(ignition == 1)

# View(newdata1)


## remove duplicated records by date

newdata1 <- newdata1 %>%
  group_by(date, lat, lon) %>%
  mutate(rn = row_number(date)) %>% 
  filter(rn == 1)

cat ("Order data by date and time")


newdata1$x <- as.POSIXct(newdata1$date,format = "%m/%d/%Y %H:%M")

# srtdata <- arrange(newdata1 ,x)

srtdata <- newdata1 
# View(srtdata)
cat ("Creating flag variables for classifying trips")
srtdata$First <- !duplicated(srtdata$DatePart)

srtdata$Last <- !duplicated(srtdata$DatePart,fromLast=TRUE)

# set up previous record time lag for a lag diff of 1

srtdata$prev_time <- lag(srtdata$x)

# Iterate through data to calculate time difference
#\AfterBinding
srtdata$Time_diff <- NA
for(i in 1:nrow(srtdata)) {
  
  if (srtdata$First[i] == 1L)
  {
    srtdata$Time_diff[i] <- 0 
  } else 
    
  {
    srtdata$Time_diff[i] = difftime(srtdata$x[i], srtdata$prev_time[i], units = 'mins')
  }
  
}
# View(srtdata)
# write.csv(srtdata,"D:\\IoT\\honda city\\triperror file .csv" , row.names= FALSE)
# Iterate through data to classify trips per day

srtdata$Trip <- NA
for(i in seq(1:nrow(srtdata))) 
{
  
  if (srtdata$First[i] == 1L)
  {
    srtdata$Trip[i] <- 1 
  } 
  
  else 
  {
    if (srtdata$Time_diff[i] > 20) 
    {
      
      srtdata$Trip[i] <- srtdata$Trip[i-1] + 1
    } 
    else
    {
      srtdata$Trip[i] <- srtdata$Trip[i-1]
    }
  }
}

# 
# # Cross check:
# To view/check maximum number of trips driven per day - Trip can't be zero, NA or blank
# 
# srtdata %>% 
# group_by(DatePart) %>% 
# summarise(t = max(Trip)) %>% 
#   View()
#   


## Variables for Tableau

## To create a NULL data frame
# result <- data.frame(NULL) 

harshAccl <- srtdata %>%
  group_by(DatePart, Trip) %>%
  mutate(diffspeed = lag(speed) - speed) %>%
  dplyr::select(Trip, speed, diffspeed) %>% 
  filter(diffspeed >= 40) %>% 
  summarise(harsh_accl = n()) 

harshBrake <- srtdata %>%
  group_by(DatePart, Trip) %>%
  mutate(diffspeed = lag(speed) - speed) %>%
  filter(diffspeed <= -40) %>%
  summarise(harsh_brake = n())

trip.data <- srtdata %>%
  dplyr::select(-First, -Last, -rn, -x, -prev_time, -Time_diff) %>%
  left_join(harshAccl, by = c('DatePart','Trip')) %>%
  left_join(harshBrake, by = c('DatePart','Trip'))

trip.data <- trip.data %>%
#  group_by(DatePart, Trip) %>%
  mutate(diffspeed = lag(speed) - speed) %>%
  mutate(brakeFlag = ifelse(ifelse(is.na(diffspeed), 0, diffspeed) < 0, 1, 0)) %>%
  mutate(brakeDist = ifelse(ifelse(is.na(diffspeed), 0, diffspeed) < 0, round((speed*speed)/72,2), 0),
         totalDist_Trip = round(abs(last(odometer) - first(odometer)),0))
# travelTime = last(ms(timeHrs)) - ms(first(timeHrs)),

# totalFuelConsp_Trip = round(abs(last(Fuel.Used) - first(Fuel.Used)),0),
# mpl = round(totalDist_Trip / totalFuelConsp_Trip, 0)) 
trip.data <- trip.data %>%
  group_by(DatePart) %>%
  mutate(totalDist_Date = round(abs(last(odometer) - first(odometer)),0))

# totalFuelConsp_Date = round(abs(last(Fuel.Used) - first(Fuel.Used)),0))
# write.csv(liveAtrack,"D:\\IoT\\honda city\\processed data of hyundai creta.csv")

# This is the final dataset for Tableau implementation
result_Polo <- trip.data
# result <- rbind(result,trip.data) 
#View(result)

result_Polo <- result_Polo %>% rename(assetName = assetname,
                            Speed = speed,
                            Time = time,
                            Address = address,
                            Battery_voltage = batteryvoltage,
                            Power_voltage = powervoltage,
                            Odo_counter = odometer,
                            FuelUsed = fuelused,
                            Engine_Temp = enginetemp)

#View(result_Polo)
write.csv(result_Polo,"D:\\31157\\1\\BACKup\\IOT\\data\\BeforeBinding\\Polo_GT_19_08_2016.csv" , row.names= FALSE)



############################################################################################


cat("Hexaware Nissan Sunny")

liveAtrack <- read.csv("telemetryHistory20May_28june.csv", header = T, sep = ",", stringsAsFactors = FALSE)

liveAtrack_N <- subset(liveAtrack, assetname == 'Hexaware Nissan Sunny')

liveAtrack_N$date_time <- paste(liveAtrack_N$date, liveAtrack_N$time, sep = " ")

liveAtrack_N$date <- as.POSIXct(liveAtrack_N$date_time, format = "%m/%d/%Y %H:%M") 

liveAtrack_N$DatePart <- substr(liveAtrack_N$date, 1, 10)

liveAtrack_N<- liveAtrack_N %>%
  dplyr::select(assetname,date, DatePart,time, lat, lon, speed, heading, altitude, accuracy, 
                address, ignition,batteryvoltage, powervoltage, odometer, hours00counter, 
                idlecounter,airflow, engine,fuelused, engineload,rpm, enginetemp,overspeed)

#colnames(liveAtrack)
#write.csv(liveAtrack,"D::\\IOT\\R_Data_\\AfterSelect.csv" , row.names= FALSE)

#liveAtrack$date <- substr(liveAtrack$date, 1, 9)

# liveAtrack <- subset(read.csv("streaming Data_Hyundai creta.csv", header = T, sep = ",", stringsAsFactors = FALSE))
# ,
# date == c( "04-05-2016","04-06-2016","04-07-2016","04-08-2016"))
# View(liveAtrack)




# # ## Applicable only for Honda City
#liveAtrack <- subset(liveAtrack, DatePart <= "2016-03-10")  

newdata <- liveAtrack_N
# View(liveAtrack)
# liveAtrack$Date <- sort(liveAtrack$Date)
newdata <- newdata %>%
  arrange(date)
# View(newdata)

newdata1 <- newdata %>%
  filter(ignition == 1)

# View(newdata1)


## remove duplicated records by date

newdata1 <- newdata1 %>%
  group_by(date, lat, lon) %>%
  mutate(rn = row_number(date)) %>% 
  filter(rn == 1)

cat ("Order data by date and time")


newdata1$x <- as.POSIXct(newdata1$date,format = "%Y-%m-%d %H:%M:%S")

# srtdata <- arrange(newdata1 ,x)

srtdata <- newdata1 
# View(srtdata)
cat ("Creating flag variables for classifying trips")
srtdata$First <- !duplicated(srtdata$DatePart)

srtdata$Last <- !duplicated(srtdata$DatePart,fromLast=TRUE)

# set up previous record time lag for a lag diff of 1

srtdata$prev_time <- lag(srtdata$x)

# Iterate through data to calculate time difference
#\AfterBinding
srtdata$Time_diff <- NA
for(i in 1:nrow(srtdata)) {
  
  if (srtdata$First[i] == 1L)
  {
    srtdata$Time_diff[i] <- 0 
  } else 
    
  {
    srtdata$Time_diff[i] = difftime(srtdata$x[i], srtdata$prev_time[i], units = 'mins')
  }
  
}
# View(srtdata)
# write.csv(srtdata,"D:\\IoT\\honda city\\triperror file .csv" , row.names= FALSE)
# Iterate through data to classify trips per day

srtdata$Trip <- NA
for(i in seq(1:nrow(srtdata))) 
{
  
  if (srtdata$First[i] == 1L)
  {
    srtdata$Trip[i] <- 1 
  } 
  
  else 
  {
    if (srtdata$Time_diff[i] > 20) 
    {
      
      srtdata$Trip[i] <- srtdata$Trip[i-1] + 1
    } 
    else
    {
      srtdata$Trip[i] <- srtdata$Trip[i-1]
    }
  }
}

# 
# # Cross check:
# To view/check maximum number of trips driven per day - Trip can't be zero, NA or blank
# 
# srtdata %>% 
# group_by(DatePart) %>% 
# summarise(t = max(Trip)) %>% 
#   View()
#   


## Variables for Tableau

## To create a NULL data frame
# result <- data.frame(NULL) 

harshAccl <- srtdata %>%
  group_by(DatePart, Trip) %>%
  mutate(diffspeed = lag(speed) - speed) %>%
  dplyr::select(Trip, speed, diffspeed) %>% 
  filter(diffspeed >= 40) %>% 
  summarise(harsh_accl = n()) 

harshBrake <- srtdata %>%
  group_by(DatePart, Trip) %>%
  mutate(diffspeed = lag(speed) - speed) %>%
  filter(diffspeed <= -40) %>%
  summarise(harsh_brake = n())

trip.data <- srtdata %>%
  dplyr::select(-First, -Last, -rn, -x, -prev_time, -Time_diff) %>%
  left_join(harshAccl, by = c('DatePart','Trip')) %>%
  left_join(harshBrake, by = c('DatePart','Trip'))


trip.data <- trip.data %>%
  group_by(DatePart, Trip) %>%
  mutate(diffspeed = lag(speed) - speed) %>%
  mutate(brakeFlag = ifelse(ifelse(is.na(diffspeed), 0, diffspeed) < 0, 1, 0)) %>%
  mutate(brakeDist = ifelse(ifelse(is.na(diffspeed), 0, diffspeed) < 0, round((speed*speed)/72,2), 0),
         totalDist_Trip = round(abs(last(odometer) - first(odometer)),0))
# travelTime = last(ms(timeHrs)) - ms(first(timeHrs)),

# totalFuelConsp_Trip = round(abs(last(Fuel.Used) - first(Fuel.Used)),0),
# mpl = round(totalDist_Trip / totalFuelConsp_Trip, 0)) 
trip.data <- trip.data %>%
  group_by(DatePart) %>%
  mutate(totalDist_Date = round(abs(last(odometer) - first(odometer)),0))

# totalFuelConsp_Date = round(abs(last(Fuel.Used) - first(Fuel.Used)),0))
# write.csv(liveAtrack,"D:\\IoT\\honda city\\processed data of hyundai creta.csv")

# This is the final dataset for Tableau implementation
result_Nissan<- trip.data
# result <- rbind(result,trip.data) 
#View(result)

#colnames(result)[which(colnames(result) %in% c( "assetname","speed","time" ,"address","batteryvoltage","powervoltage","odometer","fuelused","enginetemp") )]<- c("Asset Name","Speed","Time","Address","Battery_voltage","Power_voltage","Odo_counter","FuelUsed","Engine_Temp")

result_Nissan <- result_Nissan %>% rename(AssetName = assetname,
                            Speed = speed,
                            Time = time,
                            Address = address,
                            Battery_voltage = batteryvoltage,
                            Power_voltage = powervoltage,
                            Odo_counter = odometer,
                            FuelUsed = fuelused,
                            Engine_Temp = enginetemp)







write.csv(result_Nissan,"D:\\IOT\\data\\BeforeBinding\\Sunny_Data_30_6_2016.csv" , row.names= FALSE)



#**********************************************************************************************************



###  BINDING  PART
Polo_GT_Data<- read.csv("D:\\31157\\1\\BACKup\\IOT\\data\\BeforeBinding\\Polo_GT_19_08_2016.csv", header = T, sep = ",", stringsAsFactors = FALSE)
Creta_Data<- read.csv("D:\\31157\\1\\BACKup\\IOT\\data\\BeforeBinding\\Creta_Data_19_08_2016.csv", header = T, sep = ",", stringsAsFactors = FALSE)
Nissan_Sunny<- read.csv("D:\\IOT\\data\\BeforeBinding\\Sunny_Data_30_6_2016.csv", header = T, sep = ",", stringsAsFactors = FALSE)

Result_final<- rbind(Polo_GT_Data,Creta_Data)

write.csv(Result_final,"D:\\31157\\1\\BACKup\\IOT\\data\\AfterBinding\\Consolidated_19_8_2016.csv" , row.names= FALSE)
