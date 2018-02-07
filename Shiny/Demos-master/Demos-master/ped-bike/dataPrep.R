# this R script is used to prepare the data

ped<-read.csv("data/densityPlot/pedLocations.csv")
View(ped)
library(dplyr)
ped<-filter(ped, lon !=0, lat!=0)
saveRDS(ped, "data/densityPlot/ped_locations.rds")


bike<-read.csv("data/densityPlot/Bike_Locations.csv")
View(bike)
head(bike)
bike<-filter(bike, lon !=0, lat!=0)
saveRDS(bike, "data/densityPlot/bike_locations.rds")
