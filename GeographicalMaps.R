
## Plot a Geographicalmap
library(ggplot2)
install.packages("ggmaps")
library(ggmap)
ICCT20 <- c("India", "Australia", "WestIndies", "SriLanka", "SouthAfrica")
Countries <- geocode(ICCT20)
nation.x <- Countries$lon
nation.y <- Countries$lat

# Create a worldmap 

world_map <- borders("world", colour = "grey", fill = "lightblue")

## Add data points to the map

ggplot() + world_map + geom_point(aes(x = nation.x, y = nation.y), data = Countries, color  = "red", size = 3)

world_map = qmap("world", zoom = 2)

# Tabplot to look at a dataset in a single command
install.packages("tabplot")
library(tabplot)

temp <- read.csv("D:\\Json\\JsonData_HexInnov2.csv")
tableplot(temp[,c(1,7,9,10)])

geocode("Erode")
