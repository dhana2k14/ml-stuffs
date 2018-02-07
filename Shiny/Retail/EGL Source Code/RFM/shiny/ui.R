library(shiny)
library(shinythemes)
library(ggplot2)
library(labeling)
library(DT)

shinyUI(fluidPage(



fluidRow(
  column(3,
         fluidRow(column(4,
                         div(img(src="logo_light_small_transparentbg.png" ,style="float: left;"))),
                  column(8,
                         h6("RFM Analysis",
                            style = "float: right;
                            font-family: 'calibri';
                            font-size: 25px;
                            padding-left: 0px;
                            padding-top: 0px;
                            color: #666666;"
                         )
                  )
         ),
         
         wellPanel(
           
           
           fluidRow(column(6,
                           uiOutput("startDateUI")
                           
           ),
           column(6,
                  uiOutput("endDateUI")
           )
           ),
           
           uiOutput("storeDatasetUI"),
           
           uiOutput("itemcategoryUI"),
           
           numericInput("weightRecencyUI", label = "Recency", value="1",min=0,max=1,step=0.1),
           numericInput("weightFrequencyUI",label = "Frequency", value="1",min=0,max=1,step=0.1),
           numericInput("weightMonetaryUI", label = "Monetary", value="1",min=0,max=1,step=0.1),
           
           
           
           actionButton("calcRfmButton", label = "Calculate RFM")
         )
  ),
  
  
  column(9,
         tabsetPanel(type = "tabs", 
                     tabPanel("Plot", 
                              fluidRow(column(6,
                                              uiOutput("recency"),
                                              tags$style("#recency{
                                                         float: left;
                                                         color: #666666;
                                                         font-size: 15px;
                                                         text-align:left;
                                                         padding-bottom: 10px;
                                                         padding-top: 0px;
                                                         font-family: calibri;
                                                         }"
                                    )
                                              ),
                                    column(6,uiOutput("frequency"),
                                           tags$style("#frequency{
                                                      float: right;
                                                      color: #666666;
                                                      font-size: 15px;
                                                      text-align:left;
                                                      padding-bottom: 10px;
                                                      padding-top: 0px;
                                                      font-family: calibri;
                                                      }")
                                           )
                                    
                                    
                                    
                                           ),
                              tags$div(style="border:1px solid black;border-radius: 10px;", 
                                       fluidRow(column(12,
                                                       
                                                       tags$b(tags$h1(style="float: left", textOutput("countCustomers"))),
                                                       tags$style("#countCustomers{
                                                                  color: #666666;
                                                                  float: left;
                                                                  font-size: 48px;
                                                                  display: inline
                                                                  text-align:left;
                                                                  padding-right: 0px;
                                                                  padding-left: 55px;
                                                                  padding-bottom: 0px;
                                                                  font-style: calibri;
                                                                  }"),
                                                  
                                                       textOutput("cust"),
                                                       tags$style("#cust{font-style: calibri;
                                                                  display: inline
                                                                  text-align:left;
                                                                  float:left;
                                                                  font-size: 18px;
                                                                  padding-bottom: 0px;
                                                                  padding-left: 10px;
                                                                  padding-right: 10px;
                                                                  
                                                                  padding-top: 45px;
                                                                  color: #666666;}"),
                                                       
                                                       
                                                       tags$b(tags$h1(style="float: left ",textOutput("averagePurchase"))),
                                                       
                                                       tags$style("#averagePurchase{
                                                                  color: #666666;
                                                                  font-size: 48px;
                                                                  text-align: right;
                                                                  padding-right: 0px;
                                                                  padding-left:0px;
                                                                  padding-bottom: 0px;
                                                                  font-style: calibri;
                                                                  }"
                                                      )
                                                      
                                                      
                                                      
                                                       ))
                                       #fluidRow(column(4,offset = 4,
                                       #textOutput("relativeRFM_range")
                                       # )
                                       # )
                                                       ),
                              
                              fluidRow(column(12,
                                              tags$div(height = 350,plotOutput("barchart"),style="padding-top: 0px;")
                                              #                                                 tags$style("#barchart{
                                              #                                                            
                                              #                                                            color: #666666;
                                              #                                                            font-size: 48px;
                                              #                                                            text-align: right;
                                              #                                                            padding-right: 55px;
                                              #                                                            padding-bottom: 0px;
                                              #                                                            font-style: calibri;
                                              #                                                            }"
                                              #                                                       )
                                              
                                              
                              )
                              )
                              #                                 fluidRow(column(12,
                              #                                                 textOutput("condvar")))
                                       ), 
                     tabPanel("Data",
                              tags$div(fluidRow(column(3,
                                                       selectInput(inputId ="binSelection",label ="",choices = c("All","0.00-0.20","0.21-0.40","0.41-0.60","0.61-0.80","0.81-1.00"),selected = "All"),
                                                       tags$style("#binSelection{width: 50%}")
                              ),
                              column(7,
                                     br(),
                                     downloadButton(outputId ="downloadDataAsCsvRFM",label = " " ),
                                     tags$style("#downloadDataAsCsvRFM{float: right; }")
                                     
                              ),
                              column(2,
                                     br(),
                                     actionButton(inputId="sendMailRFM",label = "",icon = icon(name="envelope-o",lib = "font-awesome"),style="float: right"),
                                     br()
                              )
                              )
                              ),
                              fluidRow(column(12,
                                              DT::dataTableOutput("RFM_table")
                              )
                              
                              ),
                              fluidRow(column(12,
                                              textOutput("qwerty")
                              )
                              
                              )
                              
                              
                              
                              
                              
                              
                              
                              
                     )
                              )
         
         
                                       )
  
                              )))
