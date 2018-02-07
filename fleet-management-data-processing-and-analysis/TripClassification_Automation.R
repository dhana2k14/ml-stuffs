
## To assign trip numbers to telemetry data and create additional fields for dashboards 
# Install and load required libraries

pkgs <- c('dplyr', 'lubridate')

for (pkg in pkgs)
{
  if(!(pkg %in% rownames(installed.packages()))) { install.packages(pkg) } 
}

library(dplyr)
library(lubridate)

path <- "D:\\IoT"

setwd(path)

# Input file name

poloTele <- subset(read.csv("TelemeteryData_July_August.csv"
                              , header = T
                              , sep = ","
                              , stringsAsFactors = FALSE)
                              , assetName == "Polo GT")


poloTele <- poloTele %>%
  select(assetName
         , date
         , Time
         , lat
         , lon
         , speed
         , address
         , heading
         , altitude
         , ignition
         , accuracy
         , battery_voltage
         , power_voltage
         , Odometer
         , hours_00_counter
         , idle_counter
         , airflow
         , engine
         , Fuel.Used
         , RPM
         , Engine.Temp)

poloTele$Date <- as.POSIXct(paste(poloTele$date
                                    , ":00", sep = "")
                                    , format = "%m/%d/%Y %H:%M:%S", tz = 'UTC')

poloTele$Date_tz <- with_tz(poloTele$Date, tz = 'Asia/Calcutta')

poloTele$DatePart <- substr(poloTele$Date_tz, 1, 10)

poloTele$Time <- substr(poloTele$Date_tz, 12, 20)

## Apply the following filter only for the asset 'Hyundai Creta'
# liveAtrack <- subset(liveAtrack, DatePart <= "2016-03-10")  

newdata <- poloTele %>%
  arrange(Date_tz)

## remove duplicated records by date, latitude and longitude

newdata <- newdata %>%
  dplyr::group_by(DatePart
           , lat
           , lon
           , speed
           , Odometer) %>%
  dplyr::mutate(rn = row_number(DatePart)) %>% 
  filter(rn == 1, speed != 0)

cat ("Order data by date and time")

newdata$x <- as.POSIXct(newdata$Date_tz
                        ,format = "%Y-%m-%d %H:%M:%S")

srtdata <- newdata

cat ("Creating flag variables for classifying trips")

srtdata$First <- !duplicated(srtdata$DatePart)

srtdata$Last <- !duplicated(srtdata$DatePart
                            ,fromLast=TRUE)

# set up previous record time lag for a lag diff of 1

srtdata$prev_time <- lag(srtdata$x)

# Iterate through data to calculate time difference

srtdata$Time_diff <- ''

for(i in 1:nrow(srtdata)) 
  {
     if (srtdata$First[i] == 1L)
       {
         srtdata$Time_diff[i] <- 0 
       } 
     else 
       {
          srtdata$Time_diff[i] = difftime(srtdata$x[i]
                                  , srtdata$prev_time[i]
                                  , units = 'mins')
       }
  
  }

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


# Note: Trip can't be zero, NA or blank

srtdata %>% 
  group_by(DatePart) %>% 
  summarise(t = max(Trip)) %>% 
  View()

## Creating addtional Variables for Tableau dashboard
## Create Harsh Acceleration attribute

harshAccl <- srtdata %>%
  group_by(DatePart, Trip) %>%
  mutate(diffSpeed = lag(speed) - speed) %>%
  filter(diffSpeed >= 40) %>%
  summarise(harsh_accl = n())

## Create Harsh brake attibute

harshBrake <- srtdata %>%
  group_by(DatePart, Trip) %>%
  mutate(diffSpeed = lag(speed) - speed) %>%
  filter(diffSpeed <= -40) %>%
  summarise(harsh_brake = n())

## Combine Harsh Acceleration and Harsh Brake to the main dataset

trip.data <- srtdata %>%
  select(-First
         , -Last
         , -rn
         , -x
         , -prev_time
         , -Time_diff) %>%
  left_join(harshAccl
            , by = c('DatePart','Trip')) %>%
  left_join(harshBrake, by = c('DatePart','Trip'))

trip.data <- trip.data %>%
  group_by(DatePart, Trip) %>%
  mutate(diffSpeed = lag(speed) - speed) %>%
  mutate(brakeFlag = ifelse(ifelse(is.na(diffSpeed), 0, diffSpeed) < 0, 1, 0)) %>%
  mutate(brakeDist = ifelse(ifelse(is.na(diffSpeed), 0, diffSpeed) < 0, round((speed*speed)/(2 * 9.8 * 0.7),2), 0),
         totalDist_Trip = round(abs(last(Odometer) - first(Odometer)),0))


trip.data <- trip.data %>%
  group_by(DatePart) %>%
  mutate(totalDist_Date = round(abs(last(Odometer) - first(Odometer)),0))


# Obtain a final dataset to be given for Tableau visualization

poloGT <- trip.data %>% 
  rename(assetname = assetName
         , Speed = speed
         , Time = Time
         , Address = address
         , Battery_voltage = battery_voltage
         , Power_voltage = power_voltage
         , Odo_counter = Odometer
         , FuelUsed = Fuel.Used
         , Engine_Temp = Engine.Temp)


#-------------------------------------------------------------------------------------------#
  
# AssetName - Hyundai Creta
  
cretaTele <- subset(read.csv("TelemeteryData_July_August.csv"
                            , header = T
                            , sep = ","
                            , stringsAsFactors = FALSE)
                   , assetName == "Hyundai Creta")


cretaTele <- cretaTele %>%
  select(assetName
         , date
         , Time
         , lat
         , lon
         , speed
         , address
         , heading
         , altitude
         , ignition
         , accuracy
         , battery_voltage
         , power_voltage
         , Odometer
         , hours_00_counter
         , idle_counter
         , airflow
         , engine
         , Fuel.Used
         , RPM
         , Engine.Temp)

cretaTele$Date <- as.POSIXct(paste(cretaTele$date
                                  , ":00", sep = "")
                            , format = "%m/%d/%Y %H:%M:%S", tz = 'UTC')

cretaTele$Date_tz <- with_tz(cretaTele$Date, tz = 'Asia/Calcutta')

cretaTele$DatePart <- substr(cretaTele$Date_tz, 1, 10)

cretaTele$Time <- substr(cretaTele$Date_tz, 12, 20)

## Apply the following filter only for the asset 'Hyundai Creta'
# liveAtrack <- subset(liveAtrack, DatePart <= "2016-03-10")  

newdata <- cretaTele %>%
  arrange(Date_tz)

## remove duplicated records by date, latitude and longitude

newdata <- newdata %>%
  dplyr::group_by(DatePart
                  , lat
                  , lon
                  , speed
                  , Odometer) %>%
  dplyr::mutate(rn = row_number(DatePart)) %>% 
  filter(rn == 1, speed != 0)

cat ("Order data by date and time")

newdata$x <- as.POSIXct(newdata$Date_tz
                        ,format = "%Y-%m-%d %H:%M:%S")

srtdata <- newdata

cat ("Creating flag variables for classifying trips")

srtdata$First <- !duplicated(srtdata$DatePart)

srtdata$Last <- !duplicated(srtdata$DatePart
                            ,fromLast=TRUE)

# set up previous record time lag for a lag diff of 1

srtdata$prev_time <- lag(srtdata$x)

# Iterate through data to calculate time difference

srtdata$Time_diff <- ''

for(i in 1:nrow(srtdata)) 
{
  if (srtdata$First[i] == 1L)
  {
    srtdata$Time_diff[i] <- 0 
  } 
  else 
  {
    srtdata$Time_diff[i] = difftime(srtdata$x[i]
                                    , srtdata$prev_time[i]
                                    , units = 'mins')
  }
  
}

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


# Note: Trip can't be zero, NA or blank

srtdata %>% 
  group_by(DatePart) %>% 
  summarise(t = max(Trip)) %>% 
  View()

## Creating addtional Variables for Tableau dashboard
## Create Harsh Acceleration attribute

harshAccl <- srtdata %>%
  group_by(DatePart, Trip) %>%
  mutate(diffSpeed = lag(speed) - speed) %>%
  filter(diffSpeed >= 40) %>%
  summarise(harsh_accl = n())

## Create Harsh brake attibute

harshBrake <- srtdata %>%
  group_by(DatePart, Trip) %>%
  mutate(diffSpeed = lag(speed) - speed) %>%
  filter(diffSpeed <= -40) %>%
  summarise(harsh_brake = n())

## Combine Harsh Acceleration and Harsh Brake to the main dataset

trip.data <- srtdata %>%
  select(-First
         , -Last
         , -rn
         , -x
         , -prev_time
         , -Time_diff) %>%
  left_join(harshAccl
            , by = c('DatePart','Trip')) %>%
  left_join(harshBrake, by = c('DatePart','Trip'))

trip.data <- trip.data %>%
  group_by(DatePart, Trip) %>%
  mutate(diffSpeed = lag(speed) - speed) %>%
  mutate(brakeFlag = ifelse(ifelse(is.na(diffSpeed), 0, diffSpeed) < 0, 1, 0)) %>%
  mutate(brakeDist = ifelse(ifelse(is.na(diffSpeed), 0, diffSpeed) < 0, round((speed*speed)/(2 * 9.8 * 0.7),2), 0),
         totalDist_Trip = round(abs(last(Odometer) - first(Odometer)),0))

trip.data <- trip.data %>%
  group_by(DatePart) %>%
  mutate(totalDist_Date = round(abs(last(Odometer) - first(Odometer)),0))

# Obtain a final dataset to be given for Tableau visualization

hyundaiCreta <- trip.data %>% 
  rename(assetname = assetName
         , Speed = speed
         , Time = Time
         , Address = address
         , Battery_voltage = battery_voltage
         , Power_voltage = power_voltage
         , Odo_counter = Odometer
         , FuelUsed = Fuel.Used
         , Engine_Temp = Engine.Temp)


# Combine assets and save the combined file in a flat file format.

write.csv(rbind(poloGT, hyundaiCreta), "telemeteryData_viz.csv", row.names = FALSE)




