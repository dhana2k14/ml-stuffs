library(shiny)
library(DT)
library(dplyr)

shinyApp(
ui = shinyUI(pageWithSidebar (
		headerPanel("Viewing of CAMA Analysis Datasets of Karoo Hoogland Local Municipality"),
		sidebarPanel(
		#selectInput("dataset","Choose a dataset to view:",choices=c("Karoo-Hoogland Sales","Karoo-Hoogland Single-Res","Karoo-Hoogland Vacant land")),
		#selectInput("suburb","Choose a suburb to view:", choices =c('FRASERBURG','WILLISTON','SUTHERLAND')),
		fileInput("file1","Choose a file:",multiple=TRUE)),
		#helpText("Choose a dataset and click on update view "),
		#submitButton("Update View")),
		mainPanel(h4("Observations"),dataTableOutput("view")))),

server = shinyServer(function(input,output) {
#datasetInput1 <- reactive({switch(input$dataset,"Karoo-Hoogland Sales" = read.csv("./Data/KhSales.csv",sep=",",header=TRUE,na.strings="",encoding='utf-8'),
#												"Karoo-Hoogland Single-Res"= read.csv("./Data/khSr.csv",sep=",",header=TRUE,na.strings="",encoding='utf-8'),
#												"Karoo-Hoogland Vacant land"= read.csv("./Data/khVl.csv",sep=",",header=TRUE,na.strings="",encoding='utf-8'))})

#datasetInput2 <- reactive({switch(input$suburb,'FRASERBURG' = subset(datasetInput1(),Suburb=='FRASERBURG'),
#											   'WILLISTON' = subset(datasetInput1(),Suburb=='WILLISTON'),
#											   'SUTHERLAND' = subset(datasetInput1(),Suburb =='SUTHERLAND'))})

					
output$view <- 	DT::renderDataTable({
									inFile <- input$file1
									if(is.null(inFile))
										return(NULL)
									# i = seq(1:nrow(inFile))
									bindData = data.frame()
									for (i in seq(1:nrow(inFile)))
									{
									bindData = bind_rows(read.csv(inFile[i,'datapath'],header=T,sep=","),bindData)
									i = i+1
									}
								    DT::datatable(bindData,
									rownames = FALSE,
									options = list(language = list(info = 'Of _TOTAL_ records _START_ to _END_ are displayed '),
									initComplete = JS("function(settings, json) {","$(this.api().table().header()).css({'background-color': '#000', 'color': '#fff'});","}"),
									dom = 'Rlfrtip',dom = 'C<"clear">lfrtip',
									colReorder = list(realtime = TRUE),
									colVis = list(exclude = c(0,1),activate = 'mouseover')),
									extensions = c('ColReorder','ColVis','Responsive'))					    
									})						
							
					})
)



