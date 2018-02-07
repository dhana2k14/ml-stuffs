

library(shiny)

library(shinythemes)

library(DT)

shinyUI(fluidPage(
  
  tags$head(
    tags$style(type="text/css",".dataTables_filter{display: none;}")
  ),
  
  fluidRow(column(3,
                  
                  fluidRow(column(4,
                                  
                                  div(img(src="logo_light_small_transparentbg.png" ,style="float: left;"))),
                           
                           column(8,
                                  
                                  h1("Churn Prediction",
                                     
                                     style = "float: right;
                                     
                                     
                                     
                                     font-family: 'calibri';
                                     
                                     font-size: 140%;
                                     
                                     padding-left: 5%;
                                     
                                     padding-top: 0px;
                                     
                                     padding-right: 0px;
                                     
                                     padding-bottom: 0px;
                                     
                                     color: #666666;"
                                     
                                  )
                                  
                           )
                           
                  ),
                  
                  wellPanel(
                    
                    uiOutput("storelistUI"),
                    
                    uiOutput("itemlistUI"),
                    
                    selectInput("gender",label = "Gender",choices = c("All","Male","Female"),width = '100%'),
                    
                    selectInput("age",label = "Age Group",choices = c("All","Less than 20","21-30","31-40","41-50","More than 50"),selected = "ALL",width = '100%'),
                    
                    selectInput("incomegroup",label = "Income Group",choices = c("All","Less than 20K","21K-30K","31K-40K","41K-50K","51K-60K","More than 60K") ,selected =1 ,width = '100%'),
                    
                    actionButton("plotbutton",label = "Get Data",style="float:center;")
                    
                  )
                  
  ),
  
  column(9,
         
         
         
         
         
         
         fluidRow(
           
  
                         column(8,
                         
                         plotOutput(outputId = "mymap",width = "100%",
                                    
                                    hover = "myplot_hover",
                                    
                                    click = "myplot_click",
                                    
                                    dblclick = dblclickOpts("myplot_double_click"),
                                    
                                    brush = brushOpts(id = "myplot_brush")
                                    
                         ),
                         
                         
                         
                         
                         
                         
                         tags$style("#mydemomap{
                                    
                                    padding-left:0px;
                                    
                                    padding-right:0px")),
                         column(4,br(),
                                br(),
                                br(),
                                dataTableOutput("churnprobdatatable")
                              
#                                 br(),
#                                 br(),
#                                 tags$table(style=" width: 100%;height: 320px; border: 1px solid black; border-radius: 25px",
#                                            
#                                            tags$tr(
#                                              tags$td(style="border: 1px solid black; background-color: #f6f6f6; text-align: center","Churn",br(),"Probability"),
#                                              tags$td(style="border: 1px solid black; background-color: #f6f6f6; text-align: center","Number Of",br()," Customer")
#                                            ),
#                                            tags$tr(
#                                              tags$td(style="border: 1px solid black; background-color: #faf6ca; text-align: center","0.0-0.2"),
#                                              tags$td(style="border: 1px solid black; background-color: #faf6ca; font-size: 100%; text-align: center", textOutput("prob1"))
#                                            ),
#                                            tags$tr(
#                                              tags$td(style="border: 1px solid black; background-color: #FFFFFF; text-align: center","0.2-0.4"),
#                                              tags$td(style="border: 1px solid black; background-color: #FFFFFF; font-size: 100%; text-align: center", textOutput("prob2"))
#                                            ),
#                                            tags$tr(
#                                              tags$td(style="border: 1px solid black; background-color: #faf6ca; text-align: center","0.4-0.6"),
#                                              tags$td(style="border: 1px solid black; background-color: #faf6ca; font-size: 100%; text-align: center", textOutput("prob3"))
#                                            ),
#                                            tags$tr(
#                                              tags$td(style="border: 1px solid black; background-color: #FFFFFF; text-align: center","0.6-0.8"),
#                                              tags$td(style="border: 1px solid black; background-color: #FFFFFF; font-size: 100%; text-align: center", textOutput("prob4"))
#                                            ),
#                                            tags$tr(
#                                              tags$td(style="border: 1px solid black; background-color: #faf6ca; text-align: center","0.8-1.0"),
#                                              tags$td(style="border: 1px solid black; background-color: #faf6ca; font-size: 100%; text-align: center", textOutput("prob5"))
#                                            )
#                                            
#                                            
#                                 )
                                )
                         
                         
                         
                         ),
                  
#                   ,column(6,
#                           
#                           
#                           
#                           plotOutput("jitter",width = "120%")
#                           
#                   )

tags$div(fluidRow(
  column(10,
       br(),
       downloadButton(outputId ="downloadDataAsCsvChurnPrediction",label = " " ),
       tags$style("#downloadDataAsCsvChurnPrediction{float: right; }")
       ),
  column(2,
       br(),
       actionButton(inputId="sendMailChurnPrediction",label = "",icon = icon(name="envelope-o",lib = "font-awesome"),style="float: right"),
       br()
       )
  )
  ),
                  

         dataTableOutput("doubleclickdata_storedata")






         )


         )
  
  

  
  ))





