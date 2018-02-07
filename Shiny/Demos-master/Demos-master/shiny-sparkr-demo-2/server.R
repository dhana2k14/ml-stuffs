# First install shiny library
library(shiny)
library(DT)

# Set the system environment variables
Sys.setenv(SPARK_HOME = "C:/Apache/spark-1.4.1")
.libPaths(c(file.path(Sys.getenv("SPARK_HOME"), "R", "lib"), .libPaths()))

#load the Sparkr library
library(SparkR)

# Create a spark context and a SQL context
sc <- sparkR.init(master = "local")
sqlContext <- sparkRSQL.init(sc)

#create a sparkR DataFrame for the "faithful" dataset
DF <- read.df(sqlContext, "~/flights.csv", "com.databricks.csv", header = TRUE)

# Define server logic required to draw a histogram
shinyServer(
  function(input, output) {
    # Filter data based on selections
    output$table <- renderDataTable({
      data <- DF
      if (input$man != "All"){
        data <- data[data$manufacturer == input$man,]
      }
      if (input$cyl != "All"){
        data <- data[data$cyl == input$cyl,]
      }
      if (input$trans != "All"){
        data <- data[data$trans == input$trans,]
      }
      data
    })
  })