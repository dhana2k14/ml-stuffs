library(shiny)
#library(shinythemes)
library(ggplot2)
library(labeling)
library(DT)

        


shinyUI(fluidPage(
                  shinyjs::useShinyjs(),
                  tags$head(
                      tags$style("label {font-size: 13px; font-weight: normal;  }")
                  ),


                  
                  fluidRow(
                    column(5,
                           fluidRow(
                             column(6,
                             div(style="display: inline",img(src="D:\\LTV\\shiny\\www\\logo_light_small_transparentbg.png"))),
                             column(6,
                             
                                    div(style="display: inline",h1("LTV Analysis",style = "float: right;font-family: 'calibri';font-size: 30px;color: #666666;")))
                                    
                           ),
                           wellPanel(style="padding-left: 5px ",
                                     fluidRow(column(6,
                                                     uiOutput("startDateUI")
                                                     ),
                                              column(6, 
                                                     uiOutput("endDateUI")
                                                     )
                                              ),
                                     
                                     uiOutput("itemcategoryUI")
                                     ,
                           tags$table(style="border-width:1px;border-style:none;font-size: 12px; ;",width="100%",
                                      tags$tr(bgcolor="#E8E8E8",style="border: hidden",
                                              tags$td(style="padding-left: 10px; padding-right: 10px",div("Retention %")),
                                              tags$td(style="padding-left: 10px; padding-right: 10px",div("Average",br(),"Purchase",br(),"Value")),
                                              tags$td(style="padding-left: 10px; padding-right: 10px",div("Average",br(),"No. of" ,br(),"Transactions")),
                                              
                                              tags$td(style="padding-left: 10px; padding-right: 10px",div("Cost %")),
                                              tags$td(style="padding-left: 10px; padding-right: 10px",div("Discount %"))
                                              
                                      ),
                                      tags$tr( 
                                        tags$td(bgcolor="white",colspan="5",div("Period 1 "))
                                        
                                      ),
                                      tags$tr(
                                        tags$td(style="background-color: #E8E8E8",div(textOutput("retentionPercentagePeriod1in"))),
                                        tags$td(style="background-color: #E8E8E8",div(textOutput("averagePurchasePeriod1in"))),
                                        tags$td(style="background-color: #E8E8E8",div(textOutput("transactionsPeriod1in"))),
                                        
                                        tags$td(div(tags$input(Id="costPercentagePeriod1in",type="text", value="10", size="10",maxlength="3", style="text-align:center ;background-color: #f6f6f6; border: 0px solid"))),
                                        tags$td(div(tags$input(Id="discountPercentagePeriod1in",type="text", value="10", size="10",maxlength="3", style="text-align:center ;background-color: #f6f6f6; border: 0px solid"))),
                                        tags$style("#retentionPercentagePeriod1in{text-align: center; color: black}"),
                                        tags$style("#averagePurchasePeriod1in{text-align: center; color: black}"),
                                        tags$style("#transactionsPeriod1in{text-align: center; color: black}")
                                        
                                        
                                        
                                       
                                      ),
                                      tags$tr(
                                        tags$td(bgcolor="white",colspan="5",div("Period 2 "))
                                        
                                      ),
                                      tags$tr(
                                        tags$td(style="background-color: #E8E8E8",div(textOutput("retentionPercentagePeriod2in"))),
                                        tags$td(div(tags$input(Id="averagePurchasePeriod2in",type="text", value="250", size="10", style="text-align:center ;background-color: #f6f6f6; border: 0px solid"))),
                                        tags$td(div(tags$input(Id="transactionsPeriod2in",type="text", value="2", size="10", style="text-align:center ;background-color: #f6f6f6; border: 0px solid"))),
                                        
                                        tags$td(div(tags$input(Id="costPercentagePeriod2in",type="text", value="15", size="10",maxlength="3", style="text-align:center ;background-color: #f6f6f6; border: 0px solid"))),
                                        tags$td(div(tags$input(Id="discountPercentagePeriod2in",type="text", value="10", size="10",maxlength="3", style="text-align:center ;background-color: #f6f6f6; border: 0px solid"))),
                                        tags$style("#retentionPercentagePeriod2in{text-align: center;color: black}")
                                        
                                      ),
                                      tags$tr(
                                        tags$td(bgcolor="white",colspan="5",div("Period 3 "))
                                        
                                      ),
                                      tags$tr(
                                        tags$td(div(tags$input(Id="retentionPercentagePeriod3in",type="text", value="32", size="10",maxlength="3", style="text-align:center ;background-color: #f6f6f6; border: 0px solid"))),
                                        tags$td(div(tags$input(Id="averagePurchasePeriod3in",type="text", value="275", size="10", style="text-align:center ;background-color: #f6f6f6; border: 0px solid"))),
                                        tags$td(div(tags$input(Id="transactionsPeriod3in",type="text", value="3", size="10", style="text-align:center ;background-color: #f6f6f6; border: 0px solid"))),
                                        
                                        tags$td(div(tags$input(Id="costPercentagePeriod3in",type="text", value="20", size="10",maxlength="3", style="text-align:center ;background-color: #f6f6f6; border: 0px solid"))),
                                        tags$td(div(tags$input(Id="discountPercentagePeriod3in",type="text", value="10", size="10",maxlength="3", style="text-align:center ;background-color: #f6f6f6; border: 0px solid")))
                                        
                                        
                                      ),
                                      tags$tr(
                                        tags$td(bgcolor="white",colspan="5",div("Period 4 "))
                                        
                                      ),
                                      tags$tr(
                                        tags$td(div(tags$input(Id="retentionPercentagePeriod4in",type="text", value="95", size="10",maxlength="3", style="text-align:center ;background-color: #f6f6f6; border: 0px solid"))),
                                        tags$td(div(tags$input(Id="averagePurchasePeriod4in",type="text", value="400", size="10", style="text-align:center ;background-color: #f6f6f6; border: 0px solid"))),
                                        tags$td(div(tags$input(Id="transactionsPeriod4in",type="text", value="4", size="10", style="text-align:center ;background-color: #f6f6f6; border: 0px solid"))),
                                        
                                        tags$td(div(tags$input(Id="costPercentagePeriod4in",type="text", value="25", size="10",maxlength="3", style="text-align:center ;background-color: #f6f6f6; border: 0px solid"))),
                                        tags$td(div(tags$input(Id="discountPercentagePeriod4in",type="text", value="10", size="10",maxlength="3", style="text-align:center ;background-color: #f6f6f6; border: 0px solid")))
                                        
                                      ),
                                      tags$tr(
                                        tags$td(bgcolor="white",colspan="5",div("Period 5 "))
                                        
                                      ),
                                      tags$tr(
                                        tags$td(div(tags$input(Id="retentionPercentagePeriod5in",type="text", value="52", size="10",maxlength="3", style="text-align:center ;background-color: #f6f6f6; border: 0px solid"))),
                                        tags$td(div(tags$input(Id="averagePurchasePeriod5in",type="text", value="325", size="10", style="text-align:center ;background-color: #f6f6f6; border: 0px solid"))),
                                        tags$td(div(tags$input(Id="transactionsPeriod5in",type="text", value="5", size="10", style="text-align:center ;background-color: #f6f6f6; border: 0px solid"))),
                                        
                                        tags$td(div(tags$input(Id="costPercentagePeriod5in",type="text", value="30", size="10",maxlength="3", style="text-align:center ;background-color: #f6f6f6; border: 0px solid"))),
                                        tags$td(div(tags$input(Id="discountPercentagePeriod5in",type="text", value="10", size="10",maxlength="3", style="text-align:center ;background-color: #f6f6f6; border: 0px solid")))
                                        
                                      )
                                      
                           ),br(),


                           actionButton("calcltvButton",label = "Calculate LTV",icon = NULL)
                           
                           )
                    ),
                    
                    
                    column(7,
                           tabsetPanel(type = "tabs", 
                                       tabPanel("Plot",
                                                fluidRow(column(6,
                                                
                                                div(style=" padding-left: 0px, padding-right: 0px",plotOutput("ltvVSperiods",height = 300, width = 300 ))),
                                                column(6,
                                                div(style="padding-left: 0px, padding-right: 0px",plotOutput("netrevVSperiods",height = 300 ,width = 300)))),
                                                fluidRow(column(12,
                                                                br(),
                                                                
                                                                div(tags$style(".tblcenterAlign  {float:center;width:100%;
                                                                                     margin-left:auto; 
                                                                                     margin-right:auto;
                                                                                     
                                                                                     }"),
                                                                    tags$style(".trcenter  { 
                                                                                    
                                                                               
                                                                               }"),
                                                                    tags$style(".tdcenter  { text-align: right;
                                                                                padding-right: 10px; 
                                                                               
                                                                               }"),
                                                                    tags$style(".tblheader{ text-align: center
                                                                               
                                                                               
                                                                               }"),
                                                                    
                                                                    
                                                                    
                                                                tags$table(class="tblcenterAlign",border="1",
                                                                  
                                                                  tags$tr(class="trcenter",bgcolor="#E8E8E8",
                                                                    tags$td(class="tblheader","Period"),
                                                                    tags$td(width="18%",style="color: white",class="tblheader",bgcolor="#4169e1","LTV"),
                                                                    tags$td(class="tblheader",bgcolor="#a3ce21","Net Revenue"),
                                                                    tags$td(class="tblheader"," Cumulative ",br(),"NPV"), 
                                                                    tags$td(class="tblheader"," Retained",br(), "Customers ")
                                                                  ),
                                                                  
                                                                  tags$tr(class="trcenter",
                                                                    tags$td(class="tdcenter","Period 1",br(),textOutput("period1DatesUI"), style="text-align: center"),
                                                                    tags$td(class="tdcenter",style="color: #4169e1",textOutput("outLTV1")),
                                                                    tags$td(class="tdcenter",style="color:#659D32",textOutput("outNetRev1")),
                                                                    tags$td(class="tdcenter",textOutput("outCumNPV1")),
                                                                    tags$td(class="tdcenter",textOutput("outRetCust1"))
                                                                  ),
                                                                  tags$tr(class="trcenter",
                                                                    tags$td(class="tdcenter","Period 2",br(),textOutput("period2DatesUI"),style="text-align: center"),
                                                                    tags$td(class="tdcenter",style="color: #4169e1",textOutput("outLTV2")),
                                                                    tags$td(class="tdcenter",style="color: #659D32",textOutput("outNetRev2")),
                                                                    tags$td(class="tdcenter",textOutput("outCumNPV2")),
                                                                    tags$td(class="tdcenter",textOutput("outRetCust2"))
                                                                  ),
                                                                  tags$tr(class="trcenter",
                                                                    tags$td(class="tdcenter","Period 3",br(),textOutput("period3DatesUI"),style="text-align: center"),
                                                                    tags$td(class="tdcenter",style="color: #4169e1",textOutput("outLTV3")),
                                                                    tags$td(class="tdcenter",style="color: #659D32",textOutput("outNetRev3")),
                                                                    tags$td(class="tdcenter",textOutput("outCumNPV3")),
                                                                    tags$td(class="tdcenter",textOutput("outRetCust3"))
                                                                  ),
                                                                  tags$tr(class="trcenter",
                                                                    tags$td(class="tdcenter","Period 4",br(),textOutput("period4DatesUI"),style="text-align: center"),
                                                                    tags$td(class="tdcenter",style="color: #4169e1",textOutput("outLTV4")),
                                                                    tags$td(class="tdcenter",style="color: #659D32",textOutput("outNetRev4")),
                                                                    tags$td(class="tdcenter",textOutput("outCumNPV4")),
                                                                    tags$td(class="tdcenter",textOutput("outRetCust4"))
                                                                  ),
                                                                  tags$tr(class="trcenter",
                                                                    tags$td(class="tdcenter","Period 5",br(),textOutput("period5DatesUI"),style="text-align: center"),
                                                                    tags$td(class="tdcenter",style="color: #4169e1",textOutput("outLTV5")),
                                                                    tags$td(class="tdcenter",style="color: #659D32",textOutput("outNetRev5")),
                                                                    tags$td(class="tdcenter",textOutput("outCumNPV5")),
                                                                    tags$td(class="tdcenter",textOutput("outRetCust5"))
                                                                  )
                                                                  
                                                                ))
                                                                
#                                                                 tableOutput("LTV_data" )
                                                
                                                ))
                                                
                                                ),
                                       tabPanel("Data",
                                                fluidRow(column(10,
                                                                downloadButton(outputId ="downloadDataAsCsv",label = " ",icon(name="excel-o",lib = "font-awesome") )),
                                                         column(2,
                                                                actionButton(inputId="sendMail",label = "",icon = icon(name="envelope-o",lib = "font-awesome"),style="float: right;"),
                                                                tags$style("#downloadDataAsCsv{float: right}") ),
                                                         fluidRow(column(12,DT::dataTableOutput("dataTableLTVUI" ))
                                                                )
                                                               
                                                               
                                                         )
                                                )
                                       )
                           )
)
                 
                  
                 
))
                           
