# this shiny app is for a pedestrian & bike safety application
# it is based on my masters thesis

# start by loading the shiny package and the leaflet package

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


# define a user interface for the application
shinyUI(navbarPage('Pedestrian and Bike Safety in Tennessee',
        
        # First tab -----------------------------------------------------
        
        tabPanel('Hot Spot Identification',
                 
                 includeCSS("style.css"),
                 
                 
        fluidPage(
                
                # add a side bar-----
                sidebarLayout(
                        sidebarPanel(
                                
                                # add some help text
                                h3("Get Started"),
                                
                                p("You can use this application to identify pedestrians and
                                         bicycle hotspots in Tennessee. In addition, you can also
                                         predict the number of crashes based on a set on inputPanel
                                         input variables"),
                                
                                # add a selection box for selecting a county
                                h3("Hot Spot Locations"),
                                p("Select a county in the selection box below to zoom into a particular
                                  location to view the hotspots in the Map"),
                                selectInput("county", 
                                            label = "Select a County",
                                            choices = list("ALL","Davidson", "Knox",
                                                           "Hamilton", "Shelby"),
                                            selected = "ALL")
                                
                                ),
                        
                        
                        # show a plot of the generated distribution
                        mainPanel(
                                h3("A Map showing Hot Spot Locations in Tennessee"),
                                showOutput("map", "leaflet")
                        )
                
                )
        )
        ),
        
        # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        # the Second tab 
        # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        
        tabPanel('Crash Prediction',
                 
                 includeCSS("style.css"),
                 
                 
                 fluidPage(
                         
                         # add a side bar-----
                         sidebarLayout(
                                 sidebarPanel(
                                         
                                         # add some help text
                                         h3("Get Started"),
                                         
                                         p("You can use this application to identify pedestrians and
                                           bicycle hotspots in Tennessee. In addition, you can also
                                           predict the number of crashes based on a set on inputPanel
                                           input variables")
                                        
                                         ),
                                 
                                 
                                 # show a plot of the generated distribution
                                 mainPanel(
                                         
                                         # add a selection box for selecting a county
                                         h3("Pedestrian Crash Prediction Based on Economic Factors"),
                                         p("Select a set of input variables below to predict the number of fatal
                                           crashes in Tennessee"),
                                         
                                         fluidRow(
                                                 column(3,
                                                        
                                                        numericInput("trafficVolume", 
                                                                     label = "Traffic Volume (vehicles/day):", 
                                                                     value = 1)
                                                        )
                                         ),
                                         
                                         
                                         
                                         fluidRow(
                                                 column(3,
                                                        
                                                        sliderInput("householdIncome1", 
                                                                    label = "Households with Income from $25000-$49999 (%):",
                                                                    min = 0, max = 100, value = 0)
                                                 ),
                                                 
                                                 column(3,
                                                        
                                                        sliderInput("householdIncome2", 
                                                                    label = "Households with Income from $50000-$74999 (%):",
                                                                    min = 0, max = 100, value = 0)
                                                 ),
                                                 
                                                 column(3,
                                                        
                                                        sliderInput("householdIncome3", 
                                                                    label = "Households with Income from $75000-$99999 (%):",
                                                                    min = 0, max = 100, value = 0)
                                                 )
                                         ),
                                         
                                         
                                         fluidRow(
                                                 column(3,
                                                        
                                                        sliderInput("householdVehicle1", 
                                                                    label = "Households with no vehicles (%):",
                                                                    min = 0, max = 100, value = 0)
                                                 ),
                                                 
                                                 column(3,
                                                        
                                                        sliderInput("householdVehicle2", 
                                                                    label = "Households with 2 vehicles (%):",
                                                                    min = 0, max = 100, value = 0)
                                                 ),
                                                 
                                                 column(3,
                                                        
                                                        sliderInput("householdVehicle3", 
                                                                    label = "Households with > 2 vehicles (%):",
                                                                    min = 0, max = 100, value = 0)
                                                 )
                                         ),
                                         
                                        
                                         sliderInput("employmentRate", 
                                                     label = "Employment rate (%):",
                                                     min = 0, max = 100, value = 0),
                                         
                                         sliderInput("householdFoodStamps", 
                                                     label = "Households living on Food Stamps (%):",
                                                     min = 0, max = 100, value = 0),
                                         
                                         actionButton("predictCrashes", 
                                                      label="Predict Crashes"),
                                         br(),
                                         br(),
                                         
                                         verbatimTextOutput("prediction"),
                                         
                                         
                                         h3("The Estimated Model"),
                                         p("The table below shows the estimated model for predicting the 
                                           number of fatal pedestrian crashes based on the the above set of 
                                           economic predictors"),
                                         
                                         verbatimTextOutput("summary")
                                 )
                                 
                                         )
        )
                 ),
        
        
        
        
        # The third tab -----------------------------------
        
        tabPanel('About',
                 
                 includeCSS("style.css"),
                 
                 fluidPage(
                         
                         # create a side bar
                         sidebarLayout(
                                 sidebarPanel(
                                         h2("The Project Team"),
                                         h3("Daniel Emaasit"),
                                         img(src="dan.png", height=112, width=112),
                                         br(),
                                         br(),
                                         p("Daniel is a", a("PhD student", href="http://danielemaasit.com"), "of Transportation 
                                  Engineering at UNLV. His research interest is data mining of 
                                  “Big” Transportation data to extract new insights, patterns & 
                                  knowledge that can be used to improve road safety, traffic operations 
                                  and planning.")
                                         
                                 ),
                                 
                                 
                                 # show a plot of the generated distribution
                                 mainPanel(
                                         h2("Introduction"),
                                         p("Bicyclists and pedestrians are a class of vulnerable road users 
                                  that are often overrepresented in fatal or incapacitating injury crash 
                                  statistics. While passenger car fatalities have shown sharp declines in 
                                  the last decade, pedestrian and bike fatalities have remained relatively 
                                  constant. "),
                                         
                                         p("Although Department of Transportation (DOT) agencies have extensive road safety audit programs that utilize criteria based on the ratio of crashes to average daily traffic, DOT programs do not target locations with a high number of bike/pedestrian crashes since bicycle and pedestrian counts are not recorded.  Agencies face the current challenge of allocating funds and resources equitably among urban and rural areas when designing and planning communities to maximize bicycle and pedestrian safety, thereby safeguarding the lives of the valuable citizenry. "),
                                         
                                         
                                         h2("Objective"),
                                         p("The objective of this project is to develop a software tool",
                                           strong("(both desktop & web tool)"),"that can be utilized to identify 
                                  locations that are prone to high bicycle and pedestrian crashes 
                                  also known as", span("“hot spots.”",style="color:red"),  "In addition, the tool can be used to 
                                  predict an approximation of crashes in a given location based on 
                                  certain conditions like roadway, socio-economic status, demographic
                                  factors, etc.."),
                                         
                                         # display the density plot plot here
                                         h2("Value"),
                                         p("In the top 10 U.S. cities with populations over 200,000, an average of 9% of the
                                           population walk to work and an average of 6% of the population bicycle to work [2].
                                           As cities continue to grow larger and travel congestion increases, segments of
                                           the populace are selecting non-motorized transportation over motorized 
                                           transportation. However, in doing so, this percentage of the tax paying 
                                           population becomes exposed to an elevated risk of fatal or incapacitating 
                                           injury from automobiles. Using this software, state and local agencies can 
                                           take steps to facilitate safer pedestrian and bicycle travel by identifying 
                                           hot spot areas where crashes are more likely to occur. Once these locations 
                                           have been determined, targeted initiatives and strategies can be implemented 
                                           to increase the safety of pedestrian and bicycle commuters. Accommodations 
                                           for non-motorized travel vary across communities, but may include sidewalk 
                                           modifications, bridges, pedestrian-oriented commercial centers, and/or bicycle
                                           lanes."),
                                         
                                         p("Communities that utilize this software during planning activities will benefit 
                                           from safer roadways with decreased bicycle and pedestrian accidents and achieve 
                                           greater utility for tax-payers in the area. ")
                                         
                                         
                                         
                                         
                                 )
                                 
                         )
                 )
        )
)
)