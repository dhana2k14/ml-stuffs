# this R script is used to develop crash density plots using kernel density method
# the purpose is to identify locations with high crashes


# install the required packages
library(rjson)
library(leaflet)
library(rCharts)
library(rMaps)


# start by creating a map of the location
L2<-Leaflet$new()

# set the view to Tennessee
L2$setView(c(35.7882005,-86.3301614), 7)

# create tile Layer
L2$tileLayer(provider="MapQuestOpen.OSM")

# read the data into R
ped_crash_locations<-readRDS("data/densityPlot/ped_locations.rds")
bike_crash_locations<-readRDS("data/densityPlot/bike_locations.rds")

# create a JSONArray file for bike and ped locations
ped_data<-ped_crash_locations[c("lat","lon")]

bike_data<-bike_crash_locations[c("lat","lon")]

ped_data_Json<-toJSONArray2(ped_data, json = F, names = F)

cat(rjson::toJSON(ped_data_Json))

bike_data_Json<-toJSONArray2(bike_data, json = F, names = F)

cat(rjson::toJSON(bike_data_Json))

# now add heatmaps for bike and ped crashes
# Add leaflet-heat plugin. Thanks to Vladimir Agafonkin
L2$addAssets(jshead = c(
        "http://leaflet.github.io/Leaflet.heat/dist/leaflet-heat.js"
))

# Add javascript to modify underlying chart
L2$setTemplate(afterScript = sprintf("
<script>
  var addressPoints = %s
  var heat = L.heatLayer(addressPoints).addTo(map)           
</script>
", rjson::toJSON(ped_data_Json)
))

print(L2)
