library(ggplot2)
library(ggmap)


air <- read.csv("windvector.csv", stringsAsFactors=FALSE)
air$dir <- 2 * pi * air$wd/360  # convert from degrees to radians
map = get_map(location = "Clark County, NV", zoom = 10, maptype = "roadmap")
map = ggmap(map, darken = 0.1)
map 

ggmap(map, darken = 0.6) + 
      geom_point(aes(x=lon, y=lat, colour=o3), 
                 data=air, size=3) + 
      scale_colour_gradient(low = "orangered", high="yellow") + 
      geom_text(data = air, aes(x = lon, y = lat, label = label), 
                size = 3.5, nudge_x = 0.03, nudge_y = -0.02,
                angle=320, fontface=2, colour="yellow3") +
      geom_spoke(data = air, 
                 aes(x = lon, y = lat, angle=dir, radius=ws/100, colour = o3),
                 size = 1.5)
