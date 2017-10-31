library(shiny)
library(shinydashboard)

ui <- dashboardPage(
			dashboardHeader(title = "A Basic Dashboard", dropdownMenuOutput("messageMenu")),
			dashboardSidebar(
			sidebarSearchForm(textId = 'searchText',buttonId = 'searchButton',  label = 'Search...'),
			#sidebarMenu(
							#menuItemOutput('menuitem1'),
							#menuItemOutput('menuitem2'),
						#)
			sidebarMenu(
						menuItem("Dashboard",tabName="dashboard",icon=icon("dashboard")),
						menuItem("Widgets",tabName = "widgets", icon=icon("th"), badgeLabel = 'new', badgeColor = 'green'),
						menuItem('Contact me',icon = icon("file-code-o"), href = "https://za.linkedin.com/in/dpalaniappan")
						)
			),
			dashboardBody(
							tabItems(
										tabItem(tabName = "dashboard",
										fluidRow(
										box(title = 'Histogram', status='primary',background='aqua',solidHeader = TRUE, collapsible = TRUE, plotOutput("plot1",height=250)),
										box(title = "Inputs",solidHeader = TRUE, background='black',collapsible = TRUE,sliderInput("slider","Slider Input:",1,100,50) , textInput('text','Text Input:')
												))),
										tabItem(tabName = "widgets",h2("widgets tab content"))
												)
									)
						)
					
	

server <- function(input,output)
{
#output$menuitem1 <- renderMenu ({
#							menuItem("Menu Item 1",icon=icon('calender'))
#							   })
#output$menuitem2 <- renderMenu ({menuItem("Menu Item 2",icon = icon('calender'))		
#							   })
set.seed(122)
histdata <- rnorm(500)
output$plot1 <- renderPlot({
					data <- histdata[seq_len(input$slider)]
					hist(data)
				})
output$messageMenu <- renderMenu ({
						messageData <- read.csv("./data/messageData.csv",sep=",", header=T,stringsAsFactors=F,encoding='utf=8',na.strings='')
						msgs <- apply(messageData,1, function(row) {
						messageItem(from =row[['from']],message = row[['message']])
						})
						dropdownMenu(type = "messages",.list =msgs)
})

#dropdownMenu(type = "tasks",badgeStatus = 'success',
##taskItem(value = 90, color = 'green', 'Documentation'),
#taskItem(value= 10, color = 'blue', 'Project Dashboard'),
#taskItem(value = 50, color ='aqua', 'Server Deployment')
#)
#})
}

shinyApp(ui,server)