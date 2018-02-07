# First install shiny library
library(shiny)

# Set the system environment variables
Sys.setenv(SPARK_HOME = "C:\\spark-1.6.1-bin-hadoop2.4")
.libPaths(c(file.path(Sys.getenv("SPARK_HOME"), "R", "lib"), .libPaths()))

#load the Sparkr library
library(SparkR)

# Create a spark context and a SQL context
sc <- sparkR.init(master = "local")
sqlContext <- sparkRSQL.init(sc)

#create a sparkR DataFrame for the "iris" dataset
iris_DF <- createDataFrame(sqlContext, iris)
cache(iris_DF)



# Define server logic required to predict the sepal length
shinyServer(function(input, output) {

  # Statistical machine learning
  model_fit <- glm(Sepal_Length ~ Species + Petal_Width + Petal_Length, data = iris_DF, family = "gaussian")
  
  output$summary_model <- renderPrint({summary(model_fit)})
  
  output$predict_new_value <- renderText({
    
    input$predictSepalLength
    
    isolate({
      Species <- as.character(input$species) 
      Petal_Width <- as.double(input$petalWidth)
      Petal_Length <- as.double(input$petalLength)
      
      
      
      new_data_frame <- data.frame(Species = Species, 
                                 Petal_Width = Petal_Width,
                                 Petal_Length = Petal_Length)
      
      newDataFrame <- createDataFrame(sqlContext, new_data_frame)
      
      predicted_value <- predict(model_fit, newData = newDataFrame)
      
      unlist(head(select(predicted_value, "prediction")))
    })
  })
  
  
})