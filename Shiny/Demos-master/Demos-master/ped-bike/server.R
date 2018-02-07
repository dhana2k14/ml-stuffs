# this shiny app is for a pedestrian & bike safety application
# it is based on my masters thesis

# start by loading the required packages
# install the required packages

library(shiny)
library(rjson)
library(RJSONIO)
library(leaflet)
library(rCharts)
library(rMaps)
library(RColorBrewer)
library(scales)
library(lattice)
library(dplyr)
library(brew)


# read the R script that creates the density plots
source("densityPlot.R")

# read the R script that develops the regression model
#source("regModel.R")

# define the server logic required to draw the crash density plots
shinyServer(
        function(input, output){
                
                # read the data into R
                ped_data<-readRDS("data/countModel/ped_data.rds")
                
                # prepare the pedestrian data set for modeling
                ped_data$fatal<-as.integer(ped_data$fatal)
                ped_data$incap<-as.integer(ped_data$incap)
                ped_data$nonincap<-as.integer(ped_data$nonincap)
                ped_data$pdo<-as.integer(ped_data$pdo)
                ped_data$totalcrashes<-as.integer(ped_data$totalcrashes)
                ped_data$injurycrashesonly<-as.integer(ped_data$injurycrashesonly)
                ped_data$county1<-as.factor(ped_data$county1)
                #ped_data$drctoneway1<-as.factor(ped_data$drctoneway1)
                ped_data$terrain1<-as.factor(ped_data$terrain1)
                ped_data$landuse1<-as.factor(ped_data$landuse1)
                ped_data$speedlmt<-as.integer(ped_data$speedlmt)
                ped_data$speedlmt1<-as.factor(ped_data$speedlmt1)
                ped_data$speedlmtschool1<-as.factor(ped_data$speedlmtschool1)
                ped_data$lanes<-as.integer(ped_data$lanes)
                ped_data$thrulanes<-as.integer(ped_data$thrulanes)
                ped_data$totpopamericanindian<-as.numeric(ped_data$totpopamericanindian)
                
                
                # estimate a negative Binomial model for PEDESTRIAN crashes
                # first case, we use Economic factors
                library(MASS)
                ped_fatalCrashes_model_econ<-glm.nb(fatal~0+avgaadt+percenthh25000_to_49999+
                                                            percenthh50000_to_74999+percenthh75000_to_99999+
                                                            percent_no_vehicle+percenthu_2_vehicles+
                                                            percenthh_3_or_more_vehicles+percentpop_in_labor_force+
                                                            percenthh_with_food_stamp,
                                                    data=ped_data)
                
                # create an output of the model
                library(stargazer)
                output$summary<-renderPrint({stargazer(ped_fatalCrashes_model_econ, type="text")})
                
                
                ## Extract user inputs from ui.R and preidict the crashes using the
                ## regression model generated above
                output$prediction <- renderText({ 
                        input$predictCrashes
                        isolate({
                                trafficVolume <- as.numeric(input$trafficVolume); 
                                householdIncome1 <- as.integer(input$householdIncome1)
                                householdIncome2 <- as.integer(input$householdIncome2)
                                householdIncome3 <- as.integer(input$householdIncome3)
                                householdVehicle1 <- as.integer(input$householdVehicle1)
                                householdVehicle2 <- as.integer(input$householdVehicle2)
                                householdVehicle3 <- as.integer(input$householdVehicle3)
                                employmentRate <- as.integer(input$employmentRate)
                                householdFoodStamps <- as.integer(input$householdFoodStamps)
                                
                                
                                newData <- data.frame(avgaadt = trafficVolume, 
                                                      percenthh25000_to_49999 = householdIncome1,
                                                      percenthh50000_to_74999 = householdIncome2,
                                                      percenthh75000_to_99999 = householdIncome3,
                                                      percent_no_vehicle = householdVehicle1,
                                                      percenthu_2_vehicles = householdVehicle2,
                                                      percenthh_3_or_more_vehicles = householdVehicle3,
                                                      percentpop_in_labor_force = employmentRate,
                                                      percenthh_with_food_stamp= householdFoodStamps)
                                
                                predict(ped_fatalCrashes_model_econ, newData)
                        })
                })
                
                output$map<-renderMap({
                        # this R script is used to develop crash density plots 
                        # the purpose is to identify locations with high crashes
                        
                        
                        # install the required packages
                        library(rjson)
                        library(leaflet)
                        library(rCharts)
                        library(rMaps)
                        
                        
                        # start by creating a map of the location
                        map<-Leaflet$new()
                        
                        # set the view to Tennessee
                        map$setView(c(36.16,-86.77), 12)
                        
                        # create tile Layer
                        map$tileLayer(provider="MapQuestOpen.OSM")
                        map$tileLayer(provider="OpenStreetMap.Mapnik")
                        
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
                        map$addAssets(jshead = c(
                                "http://leaflet.github.io/Leaflet.heat/dist/leaflet-heat.js"
                        ))
                        
                        # Add javascript to modify underlying chart
                        map$setTemplate(afterScript = sprintf("
                                                             <script>
                                                             var addressPoints = %s
                                                             var heat = L.heatLayer(addressPoints).addTo(map)           
                                                             </script>
                                                             ", rjson::toJSON(ped_data_Json)
                        ))
                        map$enablePopover(TRUE)
                        map
                })
                        
        
        }
)
