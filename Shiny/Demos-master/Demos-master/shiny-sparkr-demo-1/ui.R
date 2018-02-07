library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Shiny and SparkR!"),
  
  # Sidebar with a slider input for the number of bins
  sidebarLayout(
    sidebarPanel(
      
      # add some help text
      h3("Get Started"),
      
      p("This is a simple application that demonstrates how to use Apache SparkR to power
        a shiny application")
      
      ),
    
    mainPanel(
      
      # add a selection box for selecting a county
      h3("Prediction of Sepal Length of Flowers"),
      p("Select a set of input variables below to predict the sepal lenght of flowers"),
      
      fluidRow(
        column(3,
               
               selectInput("Species", 
                           label = "Select the Species",
                           choices = list("versicolor", "virginica"),
                           selected = "versicolor")
        ),
        
        column(3,
               
               numericInput("petalWidth", 
                           label = "Petal Width (mm):",
                           min = 0.01, max = 3, value = 0.1)
        ),
        
        column(3,
               
               sliderInput("petalLength", 
                           label = "Petal Length (mm):",
                           min = 0.1, max = 7.0, value = 0.1)
        )
      ),
      
      actionButton("predictSepalLength", 
                   label="Predict Sepal Length"),
      br(),
      br(),
      
      verbatimTextOutput("predict_new_value"),
      
      
      h3("The Estimated Model"),
      p("The table below shows the estimated model for predicting the Sepal Length"),
      
      verbatimTextOutput("summary_model")
    
  )
  )))